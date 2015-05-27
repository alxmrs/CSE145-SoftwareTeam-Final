%%%%%% CHB-MIT Master Script %%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   SET FLAGS

flag_logFeatures     = 1;
flag_parseTrainData  = 0;
flag_parseTestData   = 0;
flag_extractTrFt     = 0;
flag_extractTeFt     = 0;

%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   SET PARAMETERS

LDA = 0;
SVM = 1;
MLE = 2;

classificationMode = SVM;

trainingSegments = [1  5];
testSegments     = [6 10];
patientNum       = 12;
channel          = 'FT10T8';

num_ft2rmv = 5;

fprintf('\n');

if classificationMode == MLE
    fprintf('Classification mode - MLE\n');
elseif classificationMode == SVM
    fprintf('Classification mode - SVM\n');
else
    fprintf('Classification mode - LDA\n');
end

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   READ SEIZURE DATA

seizStr_1to9   = 'Data/CHBMIT/chb0pnum/seizures.csv';
seizStr_10to99 = 'Data/CHBMIT/chbpnum/seizures.csv';

if patientNum < 10
    seizures = csvread(strrep(seizStr_1to9,'pnum',num2str(patientNum)));
else
    seizures = csvread(strrep(seizStr_10to99,'pnum',num2str(patientNum)));
end

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   PARSE TRAINING DATA

if flag_parseTrainData
    fprintf('\n');
    fprintf('Parsing CHB-MIT training data...\n');
    CHBMIT_traindata = CHBMIT_parse(patientNum, trainingSegments);
    CHBMIT_traindata = CHBMIT_channel(CHBMIT_traindata, channel);
    CHBMIT_traindata = CHBMIT_preprocess(CHBMIT_traindata);
end

%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   EXTRACT TRAINING FEATURES

numSegments  = size(CHBMIT_traindata,1);
samplingFreq = 256;

windowSize_sec = 1;
windowSize     = samplingFreq*windowSize_sec;

if flag_extractTrFt

    fv_train = [];
    lv_train = [];

    fprintf('\n');
    fprintf('Extracting training set features...\n');
    fprintf('\n');

    for seg = 1:(trainingSegments(2)-trainingSegments(1)+1)

        fprintf('  Segment %d... 0%%                            100%%\n', ...
                seg+(trainingSegments(1)-1));
        fprintf('               |                              |\n');
        thisSegment       = CHBMIT_traindata(seg).record;
        seizIndex         = find(seizures(:,1)==seg);
        numSeizures       = size(seizIndex,1);
        segmentLength     = size(thisSegment,2);
        segmentLength_sec = segmentLength/samplingFreq;
        seizurePresent    = 0;

        if numSeizures >= 1
            seizurePresent = 1;
            for i = (1:numSeizures)
                seizureStarts(i)   = seizures(seizIndex(i),2);
                seizureEnds(i)     = seizures(seizIndex(i),3);
            end
        end

        fprintf('               ');

        count = 0;
        for pos = (1:windowSize:segmentLength)
            time_sec       = 1+((pos-1)/samplingFreq);
            thisSubSegment = thisSegment(:,pos:pos+(windowSize-1));

            if count >= 0
                fprintf('%%');
                count = -segmentLength/32;
            else
                count = count + windowSize;
            end

            fv_train = [fv_train;
                        Classifier_getFeatures(thisSubSegment, ...
                                                    flag_logFeatures)];
            if seizurePresent
                seizureStart = 0;
                seizureEnd   = 0;
                for i = (1:numSeizures)
                    if (time_sec >= seizureStarts(i)) && ...
                            (time_sec <= seizureEnds(i))
                        seizureStart = seizureStarts(i);
                        seizureEnd   = seizureEnds(i);
                    end
                end
            end


            if seizurePresent && ((time_sec >= seizureStart) &&   ...
                                  (time_sec <= seizureEnd))
                lv_train = [lv_train; 1];
            else
                lv_train = [lv_train; 0];
            end

        end
        fprintf('\n\n');
    end

    fprintf('\n');
    fprintf('Done.\n');

    fprintf('\n');
    fprintf('Reducing feature space of training set by %d...\n', num_ft2rmv);

    fv_N_train = fv_train(find(lv_train == 0),:);
    fv_S_train = fv_train(find(lv_train == 1),:);

    size_S = size(fv_S_train,1);
    size_N = size(fv_N_train,1);

    
    fv_N_train = fv_N_train(randperm(size_N),:);
    fv_N_train = fv_N_train(1:size_S,:);

    flist = Classifier_findWorstFeatures(fv_N_train, fv_S_train, ...
                                         num_ft2rmv, classificationMode);
                                     
    
    fv_train = [fv_N_train; fv_S_train];
    fv_train = Classifier_removeFeatures(fv_train, flist);

    
    lv_train = [zeros(size_S,1); ones(size_S,1)];


    fprintf('Done.\n');
end

%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   PARSE TEST DATA

if flag_parseTestData
    fprintf('\n');
    fprintf('Parsing CHB-MIT test data...\n');
    CHBMIT_testdata = CHBMIT_parse(patientNum, testSegments);
    CHBMIT_testdata = CHBMIT_channel(CHBMIT_testdata, channel);
    CHBMIT_testdata = CHBMIT_preprocess(CHBMIT_testdata);
end

if flag_extractTeFt

    fv_test      = [];

    fprintf('\n');
    fprintf('Extracting test set features...\n');
    fprintf('\n');

    for seg = 1:(testSegments(2)-testSegments(1)+1)

        fprintf('  Segment %d... 0%%                            100%%\n', ...
                seg+(testSegments(1)-1));

        fprintf('               |                              |\n');
        thisSegment       = CHBMIT_testdata(seg).record;
        segmentLength     = size(thisSegment,2);
        segmentLength_sec = segmentLength/samplingFreq;

        fprintf('               ');

        count = 0;
        for pos = (1:windowSize:segmentLength)
            time_sec       = 1+((pos-1)/samplingFreq);
            thisSubSegment = thisSegment(:,pos:pos+(windowSize-1));

            if count >= 0
                fprintf('%%');
                count = -segmentLength/32;
            else
                count = count + windowSize;
            end

            fv_test = [fv_test;
                       Classifier_getFeatures(thisSubSegment, ...
                                              flag_logFeatures)];
        end

        fprintf('\n\n');
    end

    fprintf('\n');
    fprintf('Reducing feature space of test set by %d...\n', num_ft2rmv);


    fv_test = Classifier_removeFeatures(fv_test, flist);

    fprintf('Done.\n');

end

%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   CLASSIFY

if classificationMode == MLE
       
    fprintf('\n');
    fprintf('Training MLE Classifier...\n');                  
    MLE_params = Classifier_trainMLE(fv_train, lv_train);
    fprintf('Done.\n');

    fprintf('\n');
    fprintf('Classifying test data...\n');
    labels = Classifier_predictMLE(MLE_params,fv_test);
    fprintf('Done.\n'); 
    
elseif classificationMode == SVM
    
    fprintf('\n');
    fprintf('Training SVM Classifier...\n');                  
    SVM_params = fitcsvm(fv_train, lv_train);
    fprintf('Done.\n');

    fprintf('\n');
    fprintf('Classifying test data...\n');
    labels = predict(SVM_params, fv_test);
    fprintf('Done.\n');
    
else
    
    fprintf('\n');
    fprintf('Training LDA Classifier...\n'); 
    fprintf('Done.\n');

    fprintf('\n');
    fprintf('Classifying test data...\n');
    
    fprintf('Done.\n');
    
end

%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   PRINT RESULTS

numSegs     = testSegments(2)-testSegments(1)+1;
sampsPerSeg = size(fv_test,1)/numSegs;
labels      = reshape(labels, [sampsPerSeg numSegs]);
secsPerFeat = windowSize_sec;

fprintf('\n');
fprintf('Results...\n');
fprintf('\n');

goodCount = 0;
totCount  = 0;

for seg = (1:numSegs)
    
    fprintf('Segment %d\n', seg+(testSegments(1)-1));
    fprintf('\n');
    
    seizIndex         = find(seizures(:,1)==(seg+testSegments(1)-1));
    numSeizures       = size(seizIndex,1);
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
