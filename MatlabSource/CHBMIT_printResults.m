function [  ] = CHBMIT_printResults( params, data, labels, lv_test )

assert(nargin == 4);

numModules     = params.numModules;
samplingFreq   = params.samplingFreq;
windowSize     = params.windowSize_sec*samplingFreq;
testSegments   = params.testSegments;
seizures       = params.seizures;
secsPerLabel   = (params.windowSize_sec)/(params.numModules);

fprintf('\n');
fprintf('Results...\n');
fprintf('\n');



numSegs = testSegments(2)-testSegments(1)+1;

offset = 1;

for seg = (1:numSegs)
    
    count(seg).tot.S  = 0;
    count(seg).tot.N  = 0;

    count(seg).good.S = 0;
    count(seg).good.N = 0;
    
    fprintf('Segment %d\n', seg+(testSegments(1)-1));
    fprintf('\n');
    
    seizureIndex = find(seizures(:,1)==(seg+testSegments(1)-1));
    numSeizures  = size(seizureIndex,1);
    
    segmentLength     = size(data(seg).record,2);
    segmentLength_sec = segmentLength/samplingFreq;
    
    numLabelsInSeg = numModules*segmentLength/windowSize;
    
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
        
        count(seg).tot.S = count(seg).tot.S + theseLabels(l);
        count(seg).tot.N = count(seg).tot.N + ~theseLabels(l);
        
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
                        count(seg).good.S = count(seg).good.S+1;
                    end
                    
                    break;
                    
                elseif ~theseLabels(l)
                    count(seg).good.N = count(seg).good.N+1;
                end
                
            end
            
        elseif ~theseLabels(l)
            count(seg).good.N = count(seg).good.N+1;
        end
           
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    offset = offset + numLabelsInSeg;
    
    fprintf('   %d/%d -> %.1f%% of SEIZURE labels are correct.\n', ...
    	count(seg).good.S, count(seg).tot.S,                        ...
    	(100*count(seg).good.S)/count(seg).tot.S);
        

    fprintf('\n');
    fprintf('   %d/%d -> %.1f%% of NON-SEIZURE labels are correct.\n', ...
        count(seg).good.N, count(seg).tot.N,                           ...
     	(100*count(seg).good.N)/count(seg).tot.N);
    
    fprintf('\n');
    fprintf('   %d/%d -> %.1f%% of ALL labels are correct.\n', ...
        count(seg).good.N+count(seg).good.S,               ...
        count(seg).tot.N+count(seg).tot.S,                 ...
     	(100*(count(seg).good.N+count(seg).good.S))/       ...
        (count(seg).tot.N+count(seg).tot.S));
    
    fprintf('\n');
    fprintf('\n');
end


    
fprintf('\n');
fprintf('Process Complete.\n');
fprintf('\n');

end

