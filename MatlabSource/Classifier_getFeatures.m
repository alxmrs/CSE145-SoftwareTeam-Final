function [ fv ] = Classifier_getFeatures( input, log_flag )
%function [ fv ] = Classifier_getFeatures( input )
%   Does not accept full records, rather subsegments
%
%   Features:
%       - Variance
%       - Energy
%       - Max/Min power bands

assert(nargin >= 1)
    
inputLen =  size(input,2);

%%%%%%%%%%%
%
%   Variance/Energy

fv_var = var(input');
fv_en  = sum((input.^2)');


%%%%%%%%%%%
%
%   Max/Min power bands

N  = size(input,2);

input_dft = fft(input')';
input_dft = input_dft(:,1:N/2+1);
input_psd = (1/N) * abs(input_dft).^2;

input_psd(2:end-1) = 2*input_psd(2:end-1);

fv_psd_max = max(input_psd');
fv_psd_min = min(input_psd');


fv_shanent_delta = entropy(input(1,:));
fv_shanent_theta = entropy(input(2,:));
fv_shanent_alpha = entropy(input(3,:));
fv_shanent_beta  = entropy(input(4,:));
fv_shanent_gamma = entropy(input(5,:));

fv_shanent = [fv_shanent_delta fv_shanent_theta fv_shanent_alpha, ...
              fv_shanent_beta  fv_shanent_gamma];
          

fv_specent_delta = entropy(input_psd(1,:));
fv_specent_theta = entropy(input_psd(2,:));
fv_specent_alpha = entropy(input_psd(3,:));
fv_specent_beta  = entropy(input_psd(4,:));
fv_specent_gamma = entropy(input_psd(5,:));


fv_specent = [fv_specent_delta fv_specent_theta fv_specent_alpha, ...
              fv_specent_beta  fv_specent_gamma];

fv = [fv_var fv_en fv_psd_max fv_psd_min fv_shanent fv_specent];

if nargin == 2 && log_flag
    fv = log(fv + exp(1));
end

end

function [ ent ] = entropy( input )

    input  = sort(input);
    tot    = size(input,2);
    count  = [];
    
    inputIndex = 1;
    countIndex = 1;
    
    while inputIndex <= tot
        
        counts(countIndex) = size(find(input == input(inputIndex)),2);
        inputIndex = inputIndex + counts(countIndex);
        countIndex = countIndex + 1;
        
    end
    
    p   = counts.*(1/tot);
    ent = -p*log(p').*(1/log(2));
    
end
