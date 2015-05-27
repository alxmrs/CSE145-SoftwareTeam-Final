%%%%%% CHB-MIT Ensemble RAND PERM %%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   SET FLAGS

flags.log             = 1;

flags.parseTrainData  = 0;
flags.extractTrainFt  = 1;
flags.reduceTrainFS   = 1;

flags.parseTestData   = 0;
flags.extractTestFt   = 1;

flags.runClassifier   = 1;

flags.printResults    = 1;

%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   SET PARAMETERS

SVM = 1;

fprintf('\n');
fprintf('Classification mode - SVM Ensemble\n');

params.numSVMs         = 10;
params.samplingFreq    = 256;
params.windowSize_sec  = 10;
params.windowSlide_sec = 1;
params.classMode       = SVM;
params.numFt2Rmv       = 5;
params.channel         = 'FT10T8';
params.trainSegments   = [1 5];
params.testSegments    = [6 10];
params.patientNum      = 12;

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   READ SEIZURE DATA

seizStr_1to9   = 'Data/CHBMIT/chb0pnum/seizures.csv';
seizStr_10to99 = 'Data/CHBMIT/chbpnum/seizures.csv';

if params.patientNum < 10
    seizures = ...
        csvread(strrep(seizStr_1to9,'pnum',num2str(params.patientNum)));
else
    seizures = ...
        csvread(strrep(seizStr_10to99,'pnum',num2str(params.patientNum)));
end

params.seizures = seizures;

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   PARSE TRAINING DATA

if flags.parseTrainData
    
    fprintf('\n');
    fprintf('Parsing CHB-MIT training data...\n');
    CHBMIT_traindata = ...
        CHBMIT_parse(params.patientNum, params.trainSegments);
    
    CHBMIT_traindata = CHBMIT_channel(CHBMIT_traindata, params.channel);
    CHBMIT_traindata = ...
        CHBMIT_preprocess(CHBMIT_traindata, params, 1);
    
end

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   EXTRACT TRAINING FEATURES
                    
if flags.extractTrainFt

    [fv_train lv_train] =            ...
    	CHBMIT_ensemble_RandPerm_fv( ...
        params, CHBMIT_traindata, flags.log, 1);
end

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   REDUCE TRAINING FEATURE SPACE

if flags.reduceTrainFS
   
    fprintf('\n');
    fprintf('Reducing feature space of training set by %d...\n', ...
        params.numFt2Rmv);
    
    flist = zeros(params.numSVMs, params.numFt2Rmv);
    
    for svm = (1:params.numSVMs)
        
        indices(svm).N = find(lv_train(svm).lv == 0);
        indices(svm).S = find(lv_train(svm).lv == 1);
        
        fv_train_N(svm).fv = fv_train(svm).fv(indices(svm).N, :);
        fv_train_S(svm).fv = fv_train(svm).fv(indices(svm).S, :);
        
        sizes(svm).S = size(indices(svm).S, 1);
        sizes(svm).N = size(indices(svm).N, 1);
        
        rp(svm).N = randperm(sizes(svm).N);
        
        fv_train_N(svm).fv = fv_train_N(svm).fv(rp(svm).N,:);
        fv_train_N(svm).fv = fv_train_N(svm).fv(1:sizes(svm).S,:);
        
        fv_train(svm).fv = [fv_train_N(svm).fv; fv_train_S(svm).fv];
        lv_train(svm).lv = [zeros(sizes(svm).S,1); ones(sizes(svm).S,1)];
        
        flist(svm,:) = ...
            Classifier_findWorstFeatures(           ...
            fv_train_N(svm).fv, fv_train_S(svm).fv, ...
            params.numFt2Rmv, params.classMode);
        
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

if flags.parseTestData
    
    fprintf('\n');
    fprintf('Parsing CHB-MIT test data...\n');
    CHBMIT_testdata = CHBMIT_parse(params.patientNum, params.testSegments);
    CHBMIT_testdata = CHBMIT_channel(CHBMIT_testdata, params.channel);
    CHBMIT_testdata = ...
        CHBMIT_preprocess(CHBMIT_testdata, params, 0);
    
end

%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   EXTRACT TEST FEATURES


if flags.extractTestFt

    [fv_test_raw lv_test] =              ...
    	CHBMIT_ensemble_RandPerm_fv(params, CHBMIT_testdata, flags.log, 0);
    
    fprintf('\n');
    fprintf('Reducing feature space of test set by %d...\n', ...
        params.numFt2Rmv);
    
    for svm = (1:params.numSVMs)
       
        fv_test(svm).fv = ...
            Classifier_removeFeatures(fv_test_raw, flist(svm,:));
        
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

if flags.runClassifier 
 
    fprintf('\n');
    fprintf('Training SVM Classifier...\n');

    for svm = (1:params.numSVMs)
        SVMModel(svm).obj = fitcsvm(fv_train(svm).fv, lv_train(svm).lv);
    end

    fprintf('Done.\n');

    fprintf('\n');
    fprintf('Classifying test data...\n');

    for svm = (1:params.numSVMs)
        labels_raw(svm,:) = predict(SVMModel(svm).obj, fv_test(svm).fv);
    end

    for l = (1:size(labels_raw,2))
        labels(l) = mode(labels_raw(:,l));
    end

    fprintf('Done.\n');
    
end

%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   PRINT RESULTS

if flags.printResults
    CHBMIT_printResults(params, CHBMIT_testdata, labels, lv_test);
end

