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
% Variance

fv_var = var(input');


%%%%%%%%%%%
%
% Energy

fv_en  = sum((input.^2)');


%%%%%%%%%%%
%
% Max/Min power bands

N  = size(input,2);

input_dft = fft(input')';
input_dft = input_dft(:,1:N/2+1);
input_psd = (1/N) * abs(input_dft).^2;

input_psd(2:end-1) = 2*input_psd(2:end-1);

fv_psd_max = max(input_psd');
fv_psd_min = min(input_psd');

fv = [fv_var fv_en fv_psd_max fv_psd_min];

if nargin == 2 && log_flag
    fv = log(fv + exp(1));
end

end

