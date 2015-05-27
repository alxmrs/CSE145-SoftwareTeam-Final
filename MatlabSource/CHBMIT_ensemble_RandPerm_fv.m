function [fv, lv] = ...
    CHBMIT_ensemble_RandPerm_fv(params, input, flag_log, train)
%[fv, lv] = CHBMIT_ensemble_RandPerm_fv(params, input, flag_log, train)

assert(nargin == 4);

samplingFreq    = params.samplingFreq;
windowSize_sec  = params.windowSize_sec;
windowSlide_sec = params.windowSlide_sec;
numSVMs         = params.numSVMs;
seizures        = params.seizures;

if train
    
    fprintf('\n');
    fprintf('Extracting training set features...\n');
    fprintf('\n');
    
else
    
    fprintf('\n');
    fprintf('Extracting test set features...\n');
    fprintf('\n');
    
end


windowSize  = samplingFreq*windowSize_sec;
windowSlide = samplingFreq*windowSlide_sec;

subWindowSize_sec = windowSize_sec/numSVMs;
subWindowSize     = samplingFreq*subWindowSize_sec;

numSegments  = size(input,1);
numFeatures  = ...
    size(Classifier_getFeatures(input(1).record(:,1:windowSize)), 2);


if train

    segments = params.trainSegments;
    
    for svm = (1:numSVMs)
        fv(svm).fv = [];
        lv(svm).lv = [];
    end
    
else
    
    segments = params.testSegments;
    
    fv = [];
    lv = [];
    
end

for seg = (1:numSegments)
    
    fprintf('Segment %d... 0%%                            100%%\n', ...
        seg+(segments(1)-1));
    
    fprintf('             |                              |\n');
    
    seg_numSamples = size(input(seg).record,2);
    seg_numSeconds = floor(seg_numSamples/samplingFreq);
    seg_numSamples = seg_numSeconds*samplingFreq;
    
    thisSegment = input(seg).record(:,1:seg_numSamples);
    
    if train
    
        numSubSegments = seg_numSeconds/windowSlide_sec;
        numSubSegments = numSubSegments-(windowSize_sec/windowSlide_sec)+1;
    
    else
       
        numSubSegments = numSVMs*seg_numSeconds/windowSize_sec;
        
    end
        
    seizIndex   = find(seizures(:,1) == seg);
    numSeizures = size(seizIndex, 1);
    
    seizurePresent = 0;
    if numSeizures >= 1
        seizurePresent = 1;
        for i = (1:numSeizures)
            seizureStarts(i) = seizures(seizIndex(i),2);
            seizureEnds(i)   = seizures(seizIndex(i),3);
        end
    end
    
    fprintf('             ');
    
    count = 0;
    
    for subseg = (1:numSubSegments)
        
        if count >= 0
            fprintf('%%');
            count = -seg_numSamples/32;
        else
            if train
                count = count + windowSlide;
            else
                count = count + windowSize/numSVMs;
            end
        end
        
        if train
        
            offset = 1+(subseg-1)*(windowSlide);
            thisSubSegment = thisSegment(:,offset:offset+windowSize-1);
        
            rp = randperm(numSVMs);

            for svm = (1:numSVMs)

                rpVect = 1+(rp(svm)-1)*subWindowSize:rp(svm)*subWindowSize;
                thisSubSegment_rp = thisSubSegment(:,rpVect);

                fv(svm).fv = [fv(svm).fv;                         ...
                    Classifier_getFeatures(thisSubSegment_rp, ...
                    flag_log)];

            end
            
        
        else
            
            offset = 1+(subseg-1)*(windowSize/numSVMs);
            thisSubSegment = ...
                thisSegment(:,offset:offset+windowSize/numSVMs-1);
            
            fv = [fv; Classifier_getFeatures(thisSubSegment, flag_log)];
            
        end
        
        for svm = (1:numSVMs)
            
            if train
                time_sec = ...
                    1+(subseg-1)*windowSlide_sec + ...
                    (rp(svm)-1)*subWindowSize_sec + subWindowSize_sec/2;
            else
                time_sec = ...
                    1+(subseg-1)*windowSize/numSVMs+windowSize/(numSVMs*2);
            end
        
            if seizurePresent
                seizureStart = 0;
                seizureEnd   = 0;
                for seiz = (1:numSeizures)
                    if (time_sec >= seizureStarts(seiz)) && ...
                            (time_sec <= seizureEnds(seiz))
                        seizureStart = seizureStarts(seiz);
                        seizureEnd   = seizureEnds(seiz);
                    end
                end
            end

            if train
                
                if seizurePresent && ((time_sec >= seizureStart) &&   ...
                        (time_sec <= seizureEnd))
                    lv(svm).lv = [lv(svm).lv; 1];
                else
                    lv(svm).lv = [lv(svm).lv; 0];
                end
                
            else
                
                if seizurePresent && ((time_sec >= seizureStart) &&   ...
                        (time_sec <= seizureEnd))
                    lv = [lv; 1];
                else
                    lv = [lv; 0];
                end
            end
            
        end
    end
    
    fprintf('\n\n');
    
end

fprintf('Done.\n');


end

