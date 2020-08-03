function [] = Classifier_featurePlot(fv, lv, channel)
%function [] = Classifier_featurePlot(fv, lv)
%
%   fv is a feature vector
%     - row per segment


%%%%%%%%%%
%
% Separate features by class

N_index = find(lv == 0);
S_index = find(lv == 1);

fv_var = fv(:,1:5);
fv_en  = fv(:,6:10);
fv_max = fv(:,11:15);
fv_min = fv(:,16:20);

fv_var_N = (fv_var(N_index, :));
fv_en_N  = (fv_en(N_index, :));
fv_max_N = (fv_max(N_index, :));
fv_min_N = (fv_min(N_index, :));

fv_var_S = (fv_var(S_index, :));
fv_en_S  = (fv_en(S_index, :));
fv_max_S = (fv_max(S_index, :));
fv_min_S = (fv_min(S_index, :));


%%%%%%%%%%
%
% Plot features


subplot(2,3,1);
Classifier_subplot(fv_var_N, fv_en_N, fv_var_S, fv_en_S, channel);
xlabel('Variance');
ylabel('Energy');

a = subplot(2,3,2);
Classifier_subplot(fv_var_N, fv_max_N, fv_var_S, fv_max_S, channel);
xlabel('Variance');
ylabel('PSD of max band');

subplot(2,3,3);
Classifier_subplot(fv_var_N, fv_min_N, fv_var_S, fv_min_S, channel);
xlabel('Variance');
ylabel('PSD of min band');

subplot(2,3,4);
Classifier_subplot(fv_en_N, fv_max_N, fv_en_S, fv_max_S, channel);
xlabel('Energy');
ylabel('PSD of max band');

subplot(2,3,5);
Classifier_subplot(fv_en_N, fv_min_N, fv_en_S, fv_min_S, channel);
xlabel('Energy');
ylabel('PSD of min band');

subplot(2,3,6);
Classifier_subplot(fv_max_N, fv_min_N, fv_max_S, fv_min_S, channel);
xlabel('PSD of max band');
ylabel('PSD of min band');


title(a,channel);

end

