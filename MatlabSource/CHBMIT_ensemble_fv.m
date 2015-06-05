function [fv_raw, lv_raw] = ...
    CHBMIT_ensemble_fv(params, input, train)
%[fv, lv] = CHBMIT_ensemble_RandPerm_fv(params, input, flag_log, train)

assert(nargin == 3);

flag_log        = params.flags.log;
samplingFreq    = params.samplingFreq;
windowSize_sec  = params.windowSize_sec;
windowSlide_sec = params.windowSlide_sec;
numModules      = params.numModules;
seizures        = params.seizures;
RP              = params.flags.randperm;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
if train == 0
    
    fprintf('\n');
    fprintf('Extracting test set features...\n');
    fprintf('\n');
    
    segments = params.testSegments;
    
elseif params.flags.hierarchy
    
    if train == 1

        fprintf('\n');
        fprintf('Extracting training set A features...\n');
        fprintf('\n');

        segments = params.trainSegments_A;
        
    elseif train == 2
        
        fprintf('\n');
        fprintf('Extracting training set B features...\n');
        fprintf('\n');

        segments = params.trainSegments_B;
        
    end
    
elseif train == 1
    
    fprintf('\n');
    fprintf('Extracting training set features...\n');
    fprintf('\n');
    
    segments = params.trainSegments;
    
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
        
    seizIndex   = find(seizures(:,1) == segments(seg));
    numSeizures = length(seizIndex);
    
    if numSeizures
        
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
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        
            
        time_sec = 1+(subseg-1)*windowSlide_sec + windowSize_sec/2;

        thisLabel = 0;
        
        for seiz = (1:numSeizures)
           	if (time_sec >= seizureStarts(seiz)) && ...
                	(time_sec <= seizureEnds(seiz))
            	thisLabel = 1;
        	end
        end
        
        lv_raw = [lv_raw; thisLabel];
        fv_raw = [fv_raw; Classifier_getFeatures(thisSubSegment, flag_log)];
        
    end
    
    fprintf('\n\n');
    
end

end
