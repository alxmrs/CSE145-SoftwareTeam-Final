function [  ] = CHBMIT_printResults( testSegments, seizures, data, labels )

samplingFreq = 256;

fprintf('\n');
fprintf('Results...\n');
fprintf('\n');

goodCount = 0;
totCount  = 0;

numSegs = testSegments(2)-testSegments(1)+1;

for seg = (1:numSegs)
    
    fprintf('Segment %d\n', seg+(testSegments(1)-1));
    fprintf('\n');
    
    seizIndex         = find(seizures(:,1)==(seg+testSegments(1)-1));
    numSeizures       = size(seizIndex,1);
    
    segmentLength = size(data(seg).record,2);
    
    segmentLength_sec = segmentLength/samplingFreq;
    seizurePresent    = 0;
    
    if numSeizures >= 1
        seizurePresent = 1;
        fprintf('  Seizure at...\n');
        for i = (1:numSeizures)
            seizureStart   = seizures(seizIndex(i),2);
            seizureEnd     = seizures(seizIndex(i),3);
            fprintf('    [should be %d to %d seconds]\n', ...
                seizureStart, seizureEnd);
        end
    else
        fprintf('  Seizure at... [should be none]\n');
    end
    
    fprintf('\n');
    
    seizIndices = find(labels(:,seg) == 1);
    numSeiz     = size(seizIndices,1);
    totCount    = totCount + numSeiz;

    lastSeiz   = -1000;
    lastConsec = 0;
    
    for seiz = (1:numSeiz)
        
        thisSeiz = seizIndices(seiz);
        
        if (thisSeiz*secsPerFeat >= seizureStart) && ...
           (thisSeiz*secsPerFeat <= seizureEnd)
            goodCount = goodCount + 1;
        end
        
        if seiz ~= numSeiz
            nextSeiz = seizIndices(seiz+1);
        end
        
        if thisSeiz-1 == lastSeiz
            lastConsec = 1;
        else
            if lastConsec
                topSeiz = lastSeiz;
                %fprintf('    %d to %d seconds\n', ...
                 %       bottomSeiz*secsPerFeat, topSeiz*secsPerFeat);
            end
            
            if thisSeiz+1 ~= nextSeiz
                %fprintf('    %d\n', secsPerFeat*thisSeiz);
            end
            bottomSeiz = thisSeiz;
            lastConsec = 0;
        end
        
        lastSeiz = thisSeiz;
    end
    
    fprintf('\n');
end

fprintf('\n');
fprintf('%.1f%% of seizure labels are TRUE  positives.\n', ...
        (100*goodCount)/totCount);
fprintf('%.1f%% of seizure labels are FALSE positives.\n', ...
        (100*(totCount-goodCount))/totCount);

fprintf('\n');
fprintf('Process Complete.\n');
fprintf('\n');

end

