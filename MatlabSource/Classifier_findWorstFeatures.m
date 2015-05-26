function flist = Classifier_findWorstFeatures(fv_N, fv_S, num_ft2rmv, ... 
                                              classificationMode)
%flist = Classifier_findWorstFeatures(fv_N, fv_S, num_ft2rmv, MLE_flag)
%
%   if ML is set to 1, use ML, else lin

assert(nargin >= 3);

SVM = 1;
LDA = 0;
MLE = 2;

flist        = [];
num_features = size(fv_N,2);

if ((nargin == 3) || (classificationMode == SVM))

    for i = 1:num_features

        fvals_N = fv_N(:,i);
        fvals_S = fv_S(:,i);

        max_N = max(fvals_N);
        max_S = max(fvals_S);
        min_N = min(fvals_N);
        min_S = min(fvals_N);

        badCount(i) = (sum(fvals_N < max_S) - sum(fvals_N < min_S)) + ...
                      (sum(fvals_S < max_N) - sum(fvals_S < min_N));

    end

    
elseif ((nargin == 4) && classificationMode == MLE)

    for i = 1:num_features
        
        fvals_N = fv_N(:,i);
        fvals_S = fv_S(:,i);
        
        mean_N = mean(fvals_N);
        mean_S = mean(fvals_S);
        
        sd_N = sqrt(var(fvals_N));
        sd_S = sqrt(var(fvals_S));
        
        prob_NinN = normcdf(abs(fvals_N-mean_N), 0, sd_N);
                
        prob_NinS = normcdf(abs(fvals_N-mean_S), 0, sd_S);
        
        prob_SinS = normcdf(abs(fvals_S-mean_S), 0, sd_S);
                
        prob_SinN = normcdf(abs(fvals_S-mean_N), 0, sd_N);
        
        badCount(i) = sum(prob_NinS >= prob_NinN) + ...
                      sum(prob_SinN >= prob_SinS);
        
    end
    

elseif ((nargin == 4) && classificationMode == LDA)
    
end
    
badCount_unsorted = badCount;
badCount_sorted   = sort(badCount);
badCount_sorted   = badCount_sorted(end-(num_ft2rmv-1):end);
    
counter = 0;
i       = num_ft2rmv;
oldval  = 0;
while counter < num_ft2rmv
    thisval = badCount_sorted(i);
    if thisval ~= oldval
        counter = counter + sum(badCount_unsorted == thisval);
        flist   = [flist find(badCount_unsorted == thisval)];
        oldval = thisval;
    end
    i = i - 1;
end
end