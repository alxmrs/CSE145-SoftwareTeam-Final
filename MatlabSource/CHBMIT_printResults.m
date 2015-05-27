function [  ] = CHBMIT_printResults( params, data, labels, lv_test )

assert(nargin == 4);

numSVMs        = params.numSVMs;
samplingFreq   = params.samplingFreq;
windowSize     = params.windowSize_sec*samplingFreq;
testSegments   = params.testSegments;
seizures       = params.seizures;
secsPerLabel   = (params.windowSize_sec)/(params.numSVMs);

fprintf('\n');
fprintf('Results...\n');
fprintf('\n');

count.tot.S  = 0;
count.tot.N  = 0;

count.good.S = 0;
count.good.N = 0;

numSegs = testSegments(2)-testSegments(1)+1;

offset = 1;

for seg = (1:numSegs)
    
    fprintf('Segment %d\n', seg+(testSegments(1)-1));
    fprintf('\n');
    
    seizureIndex = find(seizures(:,1)==(seg+testSegments(1)-1));
    numSeizures  = size(seizureIndex,1);
    
    segmentLength     = size(data(seg).record,2);
    segmentLength_sec = segmentLength/samplingFreq;
    
    numLabelsInSeg = numSVMs*segmentLength/windowSize;
    
    if numSeizures >= 1
        
        seizurePresent = 1;
        fprintf('  Seizure detected at...\n');
        
        for i = (1:numSeizures)
            
            seizureStart = seizures(seizureIndex(i),2);
            seizureEnd   = seizures(seizureIndex(i),3);
            fprintf('    [should be %d to %d seconds]\n', ...
                seizureStart, seizureEnd);
            
        end
        
    else
        
        seizurePresent = 0;
        fprintf('  Seizure detected at...\n')
        fprintf('    [should be none]\n')
        
    end
    
    fprintf('\n');
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    theseLabels = labels(offset:offset+numLabelsInSeg-1);
    
    for l = (1:numLabelsInSeg)
        
        count.tot.S = count.tot.S + theseLabels(l);
        count.tot.N = count.tot.N + ~theseLabels(l);
        
        time_sec = 1+(l-1)*secsPerLabel + secsPerLabel/2;
        
        if seizurePresent
            
            seizureStart = ...
                seizures(find(seizures(:,1)==(seg+testSegments(1)-1)), 2);
            
            seizureEnd   = ...
                seizures(find(seizures(:,1)==(seg+testSegments(1)-1)), 3);
            
            for seiz = (1:numSeizures)
                
                if (time_sec >= seizureStart(seiz)) && ...
                        (time_sec <= seizureEnd(seiz))
                    
                    if theseLabels(l)
                        count.good.S = count.good.S+1;
                    end
                    
                    break;
                    
                elseif ~theseLabels(l)
                    count.good.N = count.good.N+1;
                end
                
            end
            
        end
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    offset = offset + numLabelsInSeg;
    
end

fprintf('\n');
fprintf('%.1f%% of seizure labels are correct.\n', ...
        (100*count.good.S)/count.tot.S);
fprintf('%.1f%% of seizure labels are incorrect.\n', ...
        (100*(count.tot.S-count.good.S))/count.tot.S);
    
fprintf('\n');
fprintf('%.1f%% of non-seizure labels are correct.\n', ...
        (100*count.good.N)/count.tot.N);
fprintf('%.1f%% of non-seizure labels are incorrect.\n', ...
        (100*(count.tot.N-count.good.N))/count.tot.N);
    
fprintf('\n');
fprintf('Process Complete.\n');
fprintf('\n');

end

