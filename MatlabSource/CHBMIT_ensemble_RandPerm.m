%%%%%% CHB-MIT Ensemble RAND PERM %%%%%%

%
%   This file is the master script for the bagged SVM/LDA classifier with
%   randomly permuted training data
%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   SET FLAGS

%   If set, applies a logarithm to the feature vector
flags.log             = 1;
flags.equalVectors    = 0;
flags.augmentResults  = 1;

%   CONTROL FLOW
%
%   The following flags are fairly self explanatory
%   Set completed stages of a given training set/test set instantiation
%       to 0 to prevent re-computation. Parsing files and extracting features
%       take a particularly long time.

flags.parseData       = 0;

flags.extractTrainFt  = 1;
flags.reduceTrainFS   = 1;

flags.extractTestFt   = 1;

flags.trainClassifier = 1;
flags.runClassifier   = 1;

flags.printResults    = 1;

%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   SET PARAMETERS

LDA = 0;
SVM = 1;

params.numModules      = 32;    % The number of SVMs/LDAs
params.windowSlide_sec = 2;     % Number of seconds in a slide
params.windowSize_sec  = params.numModules*params.windowSlide_sec;
params.samplingFreq    = 256;
params.classMode       = SVM;
params.numFt2Rmv       = 8;     % Number of features to remove from space
params.channel         = 'FT10T8';  % EEG channel from CHBMIT
params.allSegments     = [1 2 3 4 5 6 7];
params.trainSegments   = [1 2 3 4 5]; % Bottom segment to top
params.testSegments    = [6 7];
params.patientNum      = 1;

fprintf('\n');
if params.classMode == LDA
    fprintf('Classification mode: %d-LDA Ensemble\n', params.numModules);
elseif params.classMode == SVM
    fprintf('Classification mode: %d-SVM Ensemble\n', params.numModules);
end

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   READ SEIZURE DATA

%   Read the seizure matrix:
%       col 1: segment number of segment with seizure present
%       col 2: start time of seizure in seconds
%       col 3: end time of seizure in seconds
%
%	 NB (Very important):
%     	Some CHBMIT example files are not consecutive in numbering
%       You will need to re-number them
%       I recommend using patient one (chb01) with the following numbering:
%
%     chb01:
%     3  	-> 1
%     4  	-> 2
%     15 	-> 3
%     16	-> 4
%     18	-> 5
%     21	-> 6
%     26	-> 7
%
%       These are the segments with seizures in them. The corresponding
%       .csv file is...
%
%     1, 2996, 3036
%     2, 1467, 1494
%     3, 1732, 1772
%     4, 1015, 1066
%     5, 1720, 1810
%     6, 327, 420
%     7, 1862, 1963
%
%       You will of course need to rename the files as to correspond with
%       the above mapping!

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

if flags.parseData
    
    fprintf('\n');
    fprintf('Parsing CHB-MIT data...\n');
    
    %   See CHBMIT_parse file for description/run help CHBMIT_parse)
    CHBMIT_data = ...
        CHBMIT_parse(params.patientNum, params.allSegments);
    
    %   See CHBMIT_channel file for description/run help CHBMIT_channel)
    CHBMIT_data = CHBMIT_channel(CHBMIT_data, params.channel);
    
    %   See CHBMIT_preprocess file for description/run help CHBMIT_parse
    CHBMIT_data = ...
        CHBMIT_preprocess(CHBMIT_data, params);
    
end

CHBMIT_traindata = CHBMIT_data(params.trainSegments, :);
CHBMIT_testdata  = CHBMIT_data(params.testSegments,  :);

trainSegments = params.trainSegments
testSegments  = params.testSegments

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   EXTRACT TRAINING FEATURES
                    
if flags.extractTrainFt

    %  See CHBMIT_ensemble_RandPerm_fv file for description
    %      .../run help CHBMIT_ensemble_RandPerm_fv
    
    %  This function basically returns a feature vector and label vector
    %      for the training set
    %
    %  The structs are accessed as:
    %      fv_train(moduleNumber).fv => FEATURE_VECTOR
    %      lv_train(moduleNumber).lv => LABEL_VECTOR
    %
    %  Due to the way in which the Modules receive randomly permuted
    %      data for a given window, the label vectors may not necessarily
    %      be the same.
    %
    %  For example: [0 0 0 0 1 1 1 1 1 1]
    %                  |             | <- Window_Size = 8, iteration 2
    %
    %  Let's say that the permutation is [4 2 5 3 6 7 8 1]
    %      ...and that we have 8 modules
    %      ...and we are at the second iteration (one window_slide passed)
    %
    %      lv_train(1).lv(2) = 1
    %      lv_train(2).lv(2) = 0
    %      lv_train(3).lv(2) = 1
    %      lv_train(4).lv(2) = 0
    %      lv_train(5).lv(2) = 1
    %      lv_train(6).lv(2) = 1
    %      lv_train(7).lv(2) = 1
    %      lv_train(8).lv(2) = 0
     
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
    
    %   Each modules may have a different list of features to remove
    %       ...That being said, the lists will mostly be similar
    %       ...The inclusion of a list for each module is to remove bias
    
    flist = zeros(params.numModules, params.numFt2Rmv);
    
    %   For each module...
    for m = (1:params.numModules)
        
        %   Find indices in label vector of (non-)seizure features (0,1
        %   resp.)
        indices(m).N = find(lv_train(m).lv == 0);
        indices(m).S = find(lv_train(m).lv == 1);
        
        %   Extract the feature vectors into seperate matrices
        fv_train_N(m).fv = fv_train(m).fv(indices(m).N, :);
        fv_train_S(m).fv = fv_train(m).fv(indices(m).S, :);
        
        %   Store number of features within (non-)seizure sets
        sizes(m).S = size(indices(m).S, 1);
        sizes(m).N = size(indices(m).N, 1);
        
        %   Create a random permuation for each module
        %
        %   Why?
        %       Their are generally more non-seizure (N) feature vectors
        %           than seizure (S) feature vectors.
        %       We want to make the feature vectors the same size so that
        %           each module gets the same info about N as S
        %       To reduce the number of N feature vectors we randomly
        %           select |S| feature vectors. 
        %       I randomly select by randomly permuting and then taking the
        %           first |S| vectors of the permuted N data
        
        if flags.equalVectors
        
            rp(m).N          = randperm(sizes(m).N);
            fv_train_N(m).fv = fv_train_N(m).fv(rp(m).N,:);
            fv_train_N(m).fv = fv_train_N(m).fv(1:sizes(m).S,:);
        
        %   Overwrite fv_train(m).fv such that it now stores |S| N and S
        %       vectors and do the same for lv

            lv_train(m).lv = [zeros(sizes(m).S,1); ones(sizes(m).S,1)];
            
        else
           
            lv_train(m).lv = [zeros(sizes(m).N,1); ones(sizes(m).S,1)];
            
        end
            
        fv_train(m).fv = [fv_train_N(m).fv; fv_train_S(m).fv];
        
        %   See Classifier_findWorstFeatures for descrtion
        %   Finds worst features by plotting feature points on a 1D plane
        %       and finding features that produce the worst seperation
        %   The method of determining seperation depends on the
        %       classification mode
        %
        %   If SVM: Use simple decision boundary and find num of outliers
        %   If LDA: Create Gaussian distributions. Find probabilities of
        %       points falling within each dist.
        
        flist(m,:) = ...
            Classifier_findWorstFeatures(           ...
            fv_train_N(m).fv, fv_train_S(m).fv, ...
            params.numFt2Rmv, params.classMode);
        
        %   Remove the features
        
        fv_train(m).fv = ...
            Classifier_removeFeatures(fv_train(m).fv, flist(m,:));
        
    end
    
    fprintf('Done.\n');

end

%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ~

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   EXTRACT TEST FEATURES


if flags.extractTestFt

    %As explained in 'if flags.extractTestFt ... end'
    
    [fv_test_raw lv_test] =              ...
    	CHBMIT_ensemble_RandPerm_fv(params, CHBMIT_testdata, flags.log, 0);
    
    fprintf('\n');
    fprintf('Reducing feature space of test set by %d...\n', ...
        params.numFt2Rmv);
    
    for m = (1:params.numModules)
       
        fv_test(m).fv = ...
            Classifier_removeFeatures(fv_test_raw, flist(m,:));
        
%         if min(size(find(var(fv_test(m).fv) == 0))) > 0
%             m
%             find(var(fv_test(m).fv) == 0)
%         end
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

if params.classMode == SVM

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TRAIN

    if flags.trainClassifier
        
        fprintf('\n');
        fprintf('Training SVM Classifier...\n');

        % Create an SVM for each of the feature/label vector pairs
        
        parfor m = (1:params.numModules)
            SVMModel(m).obj = fitcsvm(fv_train(m).fv, lv_train(m).lv);
        end

        fprintf('Done.\n');
        
    end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CLASSIFY

    if flags.runClassifier 

        fprintf('\n');
        fprintf('Classifying test data...\n');
        
        %Extract labels from the independant classifications

        for m = (1:params.numModules)
            labels_raw(m,:) = predict(SVMModel(m).obj, fv_test(m).fv)';
        end

        %Set master label as majority vote of independant labels
        
        for l = (1:size(labels_raw,2))
            labels(l) = mode(labels_raw(:,l));
        end
        
    end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
elseif params.classMode == LDA
    
    if flags.trainClassifier

        fprintf('\n');
        fprintf('Training LDA Classifier...\n');

        parfor m = (1:params.numModules)
            LDAModel(m).obj = fitcdiscr(fv_train(m).fv, lv_train(m).lv);
        end

        fprintf('Done.\n');

    end
    
    if flags.runClassifier
        
        fprintf('\n');
        fprintf('Classifying test data...\n');

        for m = (1:params.numModules) 
            labels_raw(m,:) = predict(LDAModel(m).obj, fv_test(m).fv);
        end

        for l = (1:size(labels_raw,2))
            labels(l) = mode(labels_raw(:,l));
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
%   PRINT RESULTS

if flags.printResults
    results =           ...
        CHBMIT_results( ...
        params, CHBMIT_testdata, labels, lv_test, flags.augmentResults);
end

