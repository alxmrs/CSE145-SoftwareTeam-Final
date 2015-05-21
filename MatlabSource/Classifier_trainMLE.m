function [ MLE_params ] = Classifier_trainMLE(fv_train, lv_train)
%function [ MLE_params ] = Classifier_trainMLE(fv_train, lv_train)

fv_N = fv_train(find(lv_train == 0),:);
fv_S = fv_train(find(lv_train == 1),:);
    
mean_N = mean(fv_N);
mean_S = mean(fv_S);

cov_N = cov(fv_N);
cov_S = cov(fv_S);

MLE_params.N.mean = mean_N;
MLE_params.N.cov  = cov_N;
MLE_params.S.mean = mean_S;
MLE_params.S.cov  = cov_S;

end

