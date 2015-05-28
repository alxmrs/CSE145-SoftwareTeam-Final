function [fv, lv] = ...
    CHBMIT_ensemble_RandPerm_fv(params, input, flag_log, train)
%[fv, lv] = CHBMIT_ensemble_RandPerm_fv(params, input, flag_log, train)

assert(nargin == 4);

samplingFreq    = params.samplingFreq;
windowSize_sec  = params.windowSize_sec;
windowSlide_sec = params.windowSlide_sec;
numModules      = params.numModules;
seizures        = params.seizures;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if train
    
    fprintf('\n');
    fprintf('Extracting training set features...\n');
    fprintf('\n');
    
else
    
    fprintf('\n');
    fprintf('Extracting test set features...\n');
    fprintf('\n');
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

windowSize  = samplingFreq*windowSize_sec;
windowSlide = samplingFreq*windowSlide_sec;

numSegments  = size(input,1);
numFeatures  = ...
    size(Classifier_getFeatures(input(1).record(:,1:windowSize)), 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if train

    segments = params.trainSegments;
    
    for m = (1:numModules)
        fv(m).fv = [];
        lv(m).lv = [];
    end
    
else
    
    segments = params.testSegments;
    
    fv = [];
    lv = [];
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for seg = (1:numSegments)
    
    fprintf('Segment %d... 0%%                            100%%\n', ...
        seg+(segments(1)-1));
    
    fprintf('             |                              |\n');
    
    seg_numSamples = size(input(seg).record,2);
    seg_numSeconds = floor(seg_numSamples/samplingFreq);
    seg_numSamples = seg_numSeconds*samplingFreq;
    
    thisSegment = input(seg).record(:,1:seg_numSamples);
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if train
    
        numSubSegments = seg_numSeconds/windowSlide_sec;
        numSubSegments = numSubSegments-(windowSize_sec/windowSlide_sec)+1;
    
    else
       
        numSubSegments = numModules*seg_numSeconds/windowSize_sec;
        
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    seizIndex   = find(seizures(:,1) == seg);
    numSeizures = size(seizIndex, 1);
    
    seizurePresent = 0;
    if numSeizures >= 1
        seizurePresent = 1;
        for seiz = (1:numSeizures)
            seizureStarts(seiz) = seizures(seizIndex(seiz),2);
            seizureEnds(seiz)   = seizures(seizIndex(seiz),3);
        end
    end
    
    fprintf('             ');
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    count = 0;
    
    for subseg = (1:numSubSegments)
        
        if count >= 0
            fprintf('%%');
            count = -seg_numSamples/32;
        else
            if train
                count = count + windowSlide;
            else
                count = count + windowSize/numModules;
            end
        end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        
        if train
        
            offset = 1+(subseg-1)*(windowSlide);
            thisSubSegment = thisSegment(:,offset:offset+windowSize-1);
        
            rp = randperm(numModules);

            for m = (1:numModules)

                rpVect = 1+(rp(m)-1)*windowSlide:rp(m)*windowSlide;
                thisSubSegment_rp = thisSubSegment(:,rpVect);

                fv(m).fv = [fv(m).fv;                         ...
                    Classifier_getFeatures(thisSubSegment_rp, ...
                    flag_log)];

            end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
            
        else
            
            offset = 1+(subseg-1)*(windowSize/numModules);
            thisSubSegment = ...
                thisSegment(:,offset:offset+windowSize/numModules-1);
            
            fv = [fv; Classifier_getFeatures(thisSubSegment, flag_log)];
            
        end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        
        for m = (1:numModules)
            
            if train
                time_sec = ...
                    1+(subseg-1)*windowSlide_sec + ...
                    (rp(m)-1)*windowSlide_sec + windowSlide_sec/2;
            else
                time_sec =                               ...
                    1+(subseg-1)*windowSize/numModules + ...
                    windowSize/(numModules*2);
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
                    lv(m).lv = [lv(m).lv; 1];
                else
                    lv(m).lv = [lv(m).lv; 0];
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

