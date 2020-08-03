function [labels] = Classifier_predictMLE(MLE_params, fv_test)
%function labels = Classifier_predictML(MLE_params, fv_test)

mean_N = repmat(MLE_params.N.mean,size(fv_test,1),1);
mean_S = repmat(MLE_params.S.mean,size(fv_test,1),1);
cov_N  = MLE_params.N.cov;
cov_S  = MLE_params.S.cov;

prob_inN = mvnpdf(abs(fv_test-mean_N), zeros(1,size(mean_N,2)), cov_N);
prob_inS = mvnpdf(abs(fv_test-mean_S), zeros(1,size(mean_S,2)), cov_S);
           
labels = (prob_inS >= prob_inN);
           
end

