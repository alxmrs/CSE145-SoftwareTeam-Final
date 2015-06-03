function [fv, lv] = ...
    CHBMIT_ensemble_fv(params, input, flag_log, train)
%[fv, lv] = CHBMIT_ensemble_RandPerm_fv(params, input, flag_log, train)

assert(nargin == 4);

samplingFreq    = params.samplingFreq;
windowSize_sec  = params.windowSize_sec;
windowSlide_sec = params.windowSlide_sec;
numModules      = params.numModules;
seizures        = params.seizures;
RP              = params.randperm;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if train
    
    fprintf('\n');
    fprintf('Extracting training set features...\n');
    fprintf('\n');
    
    segments = params.trainSegments;
    
else
    
    fprintf('\n');
    fprintf('Extracting test set features...\n');
    fprintf('\n');
    
    segments = params.testSegments;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

windowSize  = samplingFreq*windowSize_sec;
windowSlide = samplingFreq*windowSlide_sec;

numSegments  = size(input,1);
numFeatures  = ...
    size(Classifier_getFeatures(input(1).record(:,1:windowSize)), 2);

fv_raw = [];
lv_raw = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for seg = (1:numSegments)
    
    fprintf('Segment %d... 0%%                           100%%\n', ...
        segments(seg));
    
    fprintf('             |                             |\n');
    
    seg_numSamples = size(input(seg).record,2);
    seg_numSeconds = floor(seg_numSamples/samplingFreq);
    seg_numSamples = seg_numSeconds*samplingFreq;
    
    thisSegment = input(seg).record(:,1:seg_numSamples);
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    numSubSegments = ...
        seg_numSamples/windowSlide - windowSize/windowSlide + 1;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    seizIndex   = find(seizures(:,1) == seg);
    numSeizures = length(seizIndex);
    
    seizurePresent = 0;
    if numSeizures >= 1
        seizurePresent = 1;
        seizureStarts((1:numSeizures)) = ...
            seizures(seizIndex((1:numSeizures)),2);
        seizureEnds((1:numSeizures)) = ...
            seizures(seizIndex((1:numSeizures)),3);
    end
    
    fprintf('             ');
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    count = 0;
    
    for subseg = (1:numSubSegments)
        
        if count >= 0
            fprintf('%%');
            count = -seg_numSamples/32;
        else
          	count = count + windowSlide;
        end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
          
      	offset = 1+(subseg-1)*windowSlide;
      	thisSubSegment = ...
           	thisSegment(:,offset:offset+windowSize-1);
            
     	fv_raw = ...
            [fv_raw; Classifier_getFeatures(thisSubSegment, flag_log)];
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        
            
        time_sec = 1+(subseg-1)*windowSlide_sec + windowSize_sec/2;

        thisLabel = 0;
        if seizurePresent
            for seiz = (1:numSeizures)
                if (time_sec >= seizureStarts(seiz)) && ...
                        (time_sec <= seizureEnds(seiz))
                    thisLabel = 1;
                end
            end
        end
     	lv_raw = [lv_raw; thisLabel];
        
    end
    
    fprintf('\n\n');
    
end

if train

    if RP
        
        numLabels = length(lv_raw);
        
        fprintf('Assigning random permutations of window to SVMs...\n');
        fprintf('\n');
        
        for l = (1:numLabels-numModules+1)
           
            thisRP = randperm(numModules);
            thisFV = fv_raw(l:l+numModules-1,:);
            thisLV = lv_raw(l:l+numModules-1,1);
            
            for m = (1:numModules)
               
                lv(m).lv(l,1) = thisLV(thisRP(m),1);
                fv(m).fv(l,:) = thisFV(thisRP(m),:);
                
            end
            
        end
        
        fprintf(' Done\n');
        
    else
    
        numLabels = length(lv_raw);

        fprintf('Randomly sampling F-L vector pairs by module...\n');
        fprintf('\n');

        for m = (1:numModules)

            fprintf('    Module %d...', m);

            fv(m).fv = [];
            lv(m).lv = [];

            for l = (1:numLabels)

                thisRand      = randi(numLabels); 
                lv(m).lv(l,1) = lv_raw(thisRand,1);
                fv(m).fv(l,:) = fv_raw(thisRand,:);

            end

            fprintf(' Done\n');

        end
        
    end
    
else
    
    fv = fv_raw;
    lv = lv_raw;
    
end

fprintf('\n');
fprintf('Done.\n');

end
