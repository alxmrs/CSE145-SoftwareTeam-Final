%%%%%% CHB-MIT Ensemble RAND PERM%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   SET FLAGS

flag_log             = 1;
flag_parseTrainData  = 1;
flag_parseTestData   = 1;
flag_extractTrainFt  = 1;
flag_extractTestFt   = 1;
flag_printResults    = 1;

%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   SET PARAMETERS

SVM = 1;

classMode = SVM;

fprintf('\n');
fprintf('Classification mode - SVM Ensemble\n');

trainSegments = [1  5];
testSegments  = [6 10];
patientNum    = 12;
channel       = 'FT10T8';

num_ft2rmv = 5;

numSVMS = 10;

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
    CHBMIT_traindata = CHBMIT_parse(patientNum, trainSegments);
    CHBMIT_traindata = CHBMIT_channel(CHBMIT_traindata, channel);
    CHBMIT_traindata = CHBMIT_preprocess(CHBMIT_traindata);
end

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   EXTRACT TRAINING FEATURES
                    
if flag_extractTrainFt

    [fv_train lv_train] =            ...
    	CHBMIT_ensemble_RandPerm_fv( ...
        CHBMIT_traindata, trainSegments, seizures, numSVMs, flag_log, 1);
   
    fprintf('\n');
    fprintf('Reducing feature space of training set by %d...\n', ...
        num_ft2rmv);
    
    for svm = (1:numSVMs)
        
        indices(svm).N = find(lv_train(svm).lv == 0);
        indices(svm).S = find(lv_train(svm).lv == 1);
        
        fv_train_N(svm).fv = fv_train(svm).fv(indices(svm).N, :);
        fv_train_S(svm).fv = fv_train(svm).fv(indices(svm).S, :);
        
        sizes(svm).S = size(indices(svm).S, 1)
        sizes(svm).N = size(indices(svm).N, 1)
        
        rp(svm).N = randperm(sizes(svm).N);
        
        fv_train_N(svm).fv = fv_train_N(svm).fv(rp(svm).N,:)
        fv_train_N(svm).fv = fv_train_N(svm).fv(1:sizes(svm).S,:);
        
        fv_train(svm).fv = [fv_train_N(svm).fv; fv_train_S(svm).fv];
        lv_train(svm).lv = [zeros(sizes(svm).S,1); ones(sizes(svm).S,1)];
        
        flist(svm,:) = ...
            Classifier_findWorstFeatures(...
            fv_train_N(svm).fv, fv_train_S(svm).fv, num_ft2rmv, classMode);
        
        fv_train(svm).fv = ...
            Classifier_removeFeatures(fv_train(svm).fv, flist(svm,:));
        
    end
    
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

%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   EXTRACT TEST FEATURES


if flag_extractTestFt

    [fv_test lv_test] =              ...
    	CHBMIT_ensemble_RandPerm_fv( ...
        CHBMIT_testdata, testSegments, seizures, numSVMs, flag_log, 0);
    
    fprintf('\n');
    fprintf('Reducing feature space of training set by %d...\n', ...
        num_ft2rmv);
    
    for svm = (1:numSVMs)
       
        fv_test(svm).fv = ...
            Classifier_removeFeatures(fv_test(svm).fv, flist(svm,:));
        
    end
    
    fprintf('Done.\n');
    
end

%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   CLASSIFY

 
fprintf('\n');
fprintf('Training SVM Classifier...\n');

for svm = (1:numSVMs)
	SVMModel(svm).obj = fitcsvm(fv_train(svm).fv, lv_train(svm).lv);
end

fprintf('Done.\n');

fprintf('\n');
fprintf('Classifying test data...\n');

for svm = (1:numSVMs)
    labels_raw(svm,:) = predict(SVMModel(svm).obj, fv_test);
end

for l = (1:size(labels_raw,2))
    labels(l) = mode(labels_raw(:,l));
end

fprintf('Done.\n');
    

%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   PRINT RESULTS

if flag_printResults
    CHBMIT_printResults(testSegments, seizures, CHBMIT_testdata, labels);
end

