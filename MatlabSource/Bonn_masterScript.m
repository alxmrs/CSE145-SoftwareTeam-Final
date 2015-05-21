% BONN MASTER SCRIPT


MLE_flag = 1;
log_flag = 1;

fprintf('\n');

if MLE_flag
    fprintf('Classification mode - MLE\n');
else
    fprintf('Classification mode - SVM\n');
end

[Bonn_N Bonn_S] = Bonn_parse();
Bonn_data = [Bonn_N; Bonn_S];
Bonn_data = Bonn_preprocess(Bonn_data);

numN_total = 100;
numS_total = 100;

numN_train = 50;
numS_train = 50;

numN_test = numN_total-numN_train;
numS_test = numS_total-numS_train;

lv_N = [zeros(numN_total,1)];
lv_S = [ones(numS_total,1)];

for i = (1:numN_total)
    fv_N(i,:) = Classifier_getFeatures([Bonn_data(i).record],log_flag); 
end

for i = (1:numS_total)
    fv_S(i,:) = Classifier_getFeatures([Bonn_data(i+numN_total).record],...
                                       log_flag); 
end

%Number of features to remove
num_ft2rmv = 5;
fv_N_train = fv_N(1:numN_train,:);
fv_S_train = fv_S(1:numS_train,:);

fv_N_test = fv_N(numN_train+1:numN_total,:);
fv_S_test = fv_S(numS_train+1:numS_total,:);

flist = Classifier_findWorstFeatures(fv_N_train, ...
                                     fv_S_train, num_ft2rmv, MLE_flag);

fv_train = [fv_N_train; fv_S_train];
lv_train = [lv_N(1:numN_train,:); lv_S(1:numS_train,:)];
fv_test  = [fv_N_test; fv_S_test];
lv_test  = [lv_N(numN_train+1:numN_total,:); ...
            lv_S(numS_train+1:numS_total,:)];
                                 
fv_train = Classifier_removeFeatures(fv_train, flist);

fv_test  = Classifier_removeFeatures(fv_test,  flist); 
                                              

if MLE_flag
       
    fprintf('\n');
    fprintf('Training Classifier...\n');                  
    MLE_params = Classifier_trainMLE(fv_train, lv_train);
    fprintf('Done.\n');

    fprintf('\n');
    fprintf('Classifying test data...\n');
    labels = Classifier_predictMLE(MLE_params, fv_test);
    fprintf('Done.\n'); 
    
else
    fprintf('\n');
    fprintf('Training Classifier...\n');                  
    SVM_params = fitcsvm(fv_train, lv_train);
    fprintf('Done.\n');

    fprintf('\n');
    fprintf('Classifying test data...\n');
    labels = predict(SVM_params, fv_test);
    fprintf('Done.\n'); 
end

N_labels_test = labels(1:numN_test);
S_labels_test = labels(1+numN_test:numN_test+numS_test);

fprintf('\n');
fprintf('Non-Seizure labels (should be 0):\n');
for i = (1:numN_test)
    fprintf('    %d - (TestN #%d)\n', N_labels_test(i), i);
end

fprintf('\n');
fprintf('Seizure labels (should be 1):\n');
for i = (1:numS_test)
    fprintf('    %d - (TestS #%d)\n', S_labels_test(i), i);
end

correct_N = sum(N_labels_test == 0);
correct_S = sum(S_labels_test == 1);

fprintf('\n');
fprintf('%d/%d = %.1f%% Non-seizures correctly classified.\n', ...
        correct_N,numN_test,100*correct_N/numN_test);

fprintf('%d/%d = %.1f%% Seizures correctly classified.\n', ...
        correct_S,numS_test,100*correct_S/numS_test);

fprintf('\n');
fprintf('Process Complete.\n');
fprintf('\n');