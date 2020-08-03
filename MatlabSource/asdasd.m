f1 = 1
f2 = 3

scatter(fv_train_N(1).fv(:,f1), fv_train_N(1).fv(:,f2), '+g');
hold on
scatter(fv_train_S(1).fv(:,f1), fv_train_S(1).fv(:,f2), 'or');
hold off

title('SVM Example Plot');
xlabel('Variance of the EEG signal in 0 to 4Hz range.');
ylabel('Variance of the EEG signal in 8 to 16Hz range.');