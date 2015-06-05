%%%%%% CHB-MIT Ensemble %%%%%%

%
%   This file is the master script for the bagged SVM/LDA classifier with
%   randomly permuted training data
%

clearvars labels_raw labels

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   SET FLAGS

flags.log             = 1;
flags.augmentResults  = 1;
flags.randperm        = 0;
flags.hierarchy       = 0;
flags.unanimous       = 0;

%   CONTROL FLOW
flags.parseData       = 0;
flags.preprocessData  = 0;

flags.extractTrainFt  = 1;
flags.distributeFt    = 1;

flags.reduceTrainFS   = 1;

flags.extractTestFt   = 1;

flags.trainClassifier = 1;
flags.runClassifier   = 1;

flags.printResults    = 1;
flags.sendData        = 0;

%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   SET PARAMETERS

SVM = 1;

params.numModules      = 9;    % The number of SVMs/LDAs
params.classMode       = SVM;

params.numFt2Rmv       = 20;    % Number of features to remove from space

params.FLAddChance_N   = 0.8;
params.FLAddChance_S   = 0.2;

params.windowSlide_sec = 4;
params.windowSize_sec  = 4;

params.patientNum      = 1;
params.minutesToSend   = 20;

params.channel         = 'FT10T8';  % EEG channel from CHBMIT
params.samplingFreq    = 256;

params.flags           = flags;

params.allSegments     = [1 2 3 4 5 6 7];
params.trainSegments   = [1 2 3 4];
params.testSegments    = [5 6 7];

if params.flags.hierarchy
    
    params.trainSegments_A = params.trainSegments(1:2); 
    params.trainSegments_B = params.trainSegments(3:4);
    
end

fprintf('\n');
if params.flags.randperm 
    fprintf('Classification mode: %d-SVM Ensemble', params.numModules);
    fprintf(' using randomly permuted windows\n');
else
    fprintf('Classification mode: %d-SVM Ensemble', params.numModules);
    fprintf(' using bagging\n');
end

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
%   PARSE DATA

if params.flags.parseData
    
    fprintf('\n');
    fprintf('Parsing CHB-MIT data...\n');
    
    %   See CHBMIT_parse file for description/run help CHBMIT_parse)
    CHBMIT_data_raw = ...
        CHBMIT_parse(params.patientNum, params.allSegments);
    
    %   See CHBMIT_channel file for description/run help CHBMIT_channel)
    CHBMIT_data_raw = CHBMIT_channel(CHBMIT_data_raw, params.channel);
    
end

if params.flags.preprocessData
    %   See CHBMIT_preprocess file for description/run help CHBMIT_parse
    CHBMIT_data_preprocessed = ...
        CHBMIT_preprocess(CHBMIT_data_raw, params);
    
end

if params.flags.hierarchy
    CHBMIT_traindata_A = ...
        CHBMIT_data_preprocessed(params.trainSegments_A, :);
    
    CHBMIT_traindata_B = ...
        CHBMIT_data_preprocessed(params.trainSegments_B, :);
else
    CHBMIT_traindata = CHBMIT_data_preprocessed(params.trainSegments, :);
end

CHBMIT_testdata  = CHBMIT_data_preprocessed(params.testSegments, :);

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   EXTRACT TRAINING FEATURES
                    
if params.flags.extractTrainFt
    
    if params.flags.hierarchy
        
        [fv_rawA lv_rawA] =         ...
    	CHBMIT_ensemble_fv(             ...
        params, CHBMIT_traindata_A, 1);
    
        [fv_trainB_raw lv_trainB] =         ...
    	CHBMIT_ensemble_fv(             ...
        params, CHBMIT_traindata_B, 2);
    
    else
        
        [fv_raw lv_raw] =               ...
            CHBMIT_ensemble_fv(             ...
            params, CHBMIT_traindata, 1);

    end
    
end

if params.flags.distributeFt
    
    if params.flags.hierarchy
        
        [fv_trainA lv_trainA] = ...
            CHBMIT_ensemble_fv_distribute(fv_rawA, lv_rawA, params);
        
    else
        
        [fv_train lv_train] = ...
            CHBMIT_ensemble_fv_distribute(fv_raw, lv_raw, params);
        
    end
    
end

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   REDUCE TRAINING FEATURE SPACE

if params.flags.reduceTrainFS
   
    fprintf('\n');
    fprintf('Reducing feature space of training set by %d...\n', ...
        params.numFt2Rmv);
    
    fprintf('\n');
    
    flist = zeros(params.numModules, params.numFt2Rmv);
    
    for m = (1:params.numModules)
        
        fprintf('    Module %d...', m);
        
        if params.flags.hierarchy
            
            flist(m,:) = ...
                Classifier_findWorstFeatures(           ...
                fv_trainA(m).fv, lv_trainA(m).lv, ...
                params.numFt2Rmv, params.classMode);

            fv_trainA(m).fv = ...
                Classifier_removeFeatures(fv_trainA(m).fv, flist(m,:));
            
            fv_trainB(m).fv = ...
                Classifier_removeFeatures(fv_trainB_raw, flist(m,:));
            
        else
        
            flist(m,:) =                        ...
                Classifier_findWorstFeatures(   ...
                fv_train(m).fv, lv_train(m).lv, ...
                params.numFt2Rmv, params.classMode);

            fv_train(m).fv = ...
                Classifier_removeFeatures(fv_train(m).fv, flist(m,:));
        
        end
        
        fprintf(' Done.\n', m);
        
    end
    
    fprintf('\n');
    fprintf('Done.\n');

end

%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   EXTRACT TEST FEATURES

if params.flags.extractTestFt
    
    [fv_test_raw lv_test] =              ...
    	CHBMIT_ensemble_fv(params, CHBMIT_testdata, 0);
    
    fprintf('\n');
    fprintf('Reducing feature space of test set by %d...\n', ...
        params.numFt2Rmv);
    
    for m = (1:params.numModules)
       
        fv_test(m).fv = ...
            Classifier_removeFeatures(fv_test_raw, flist(m,:));
        
    end
    
    fprintf('Done.\n');
    
end

%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   TRAIN

labels_raw = [];
labelsB    = [];

if params.flags.trainClassifier
    
    fprintf('\n');
    fprintf('Training SVM Classifier...\n');
    
    % Create an SVM for each of the feature/label vector pairs
    
    if params.flags.hierarchy
        
        parfor m = (1:params.numModules)
            
            SVMModel_layer1(m).obj = ...
                fitcsvm(fv_trainA(m).fv, lv_trainA(m).lv);
            
        end
        
        for m = (1:params.numModules)
            
            labelsB(:,m)    = ...
                predict(SVMModel_layer1(m).obj, fv_trainB(m).fv);
        
        end  
        
        SVMModel_master = fitcsvm(labelsB, lv_trainB);
        
    else
        
        parfor m = (1:params.numModules)
            SVMModel(m).obj = ...
                fitcsvm(fv_train(m).fv, lv_train(m).lv);
        end
        
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

if params.flags.runClassifier
    
    fprintf('\n');
    fprintf('Classifying test data...\n');
    
    %Extract labels from the independant classifications
    
    if params.flags.hierarchy
        
        for m = (1:params.numModules)
            labels_raw(:,m) = ...
                predict(SVMModel_layer1(m).obj, fv_test(m).fv);
        end
        
        labels = predict(SVMModel_master, labels_raw);
        
    else
    
        for m = (1:params.numModules)
            labels_raw(:,m) = predict(SVMModel(m).obj, fv_test(m).fv);
        end

        %Set master label as majority vote of independant labels

        if params.numModules > 1
            for l = 1:size(labels_raw,1)
                
                if flags.unanimous
                    
                else
                    labels(l) = mode(labels_raw(l,:));
                end
            end
        else
            labels = labels_raw;
        end
        
    end
    
end

%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   PRINT RESULTS

if params.flags.printResults
    results =                   ...
        CHBMIT_ensembleResults( ...
        params, CHBMIT_data_preprocessed, ...
        labels, lv_test);
end

%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   SEND DATA

if params.flags.sendData
    
    secondsToSend = 60*params.minutesToSend;
    
    for seiz = 1:size(results,1)
        
        segNum         = results(seiz,1);
        startTime_seiz = results(seiz,2);
        endTime_seiz   = results(seiz,3);
        startTime_send = startTime_seiz - secondsToSend;
        
        seizureData = ...
            CHBMIT_data_raw(segNum).record(:,startTime_seiz:endTime_seiz);
        
        if startTime_send <= 0
            
            preseizureData = ...
                CHBMIT_data_raw(segNum-1).record(:,end+startTime_send:end);
            
            preseizureData = [preseizureData ...
                CHBMIT_data_raw(segNum).record(:,1:startTime_seiz-1)];
            
        else
        
            preseizureData = ...
                CHBMIT_data_raw(segNum).record(:, ...
                startTime_send:startTime_seiz-1);
            
        end
        
        metaData.patientNum = params.patientNum;
        metaData.channel    = params.channel;
        
        CHBMIT_sendData([preseizureData, seizureData], metaData);
        
    end
    
end





clearvars -except            ...
    CHBMIT_data_preprocessed ...
    CHBMIT_data_raw          ...
    CHBMIT_testdata          ...
    CHBMIT_traindata         ...
    fv_raw lv_raw            ...
    labels labels_raw
    
            
