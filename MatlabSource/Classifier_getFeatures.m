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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   Variance/Energy/Skewness/Kurtosis

fv_var  = var(input');
fv_en   = sum((input.^2)');
fv_skew = skewness(input');
fv_kurt = kurtosis(input');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   Hjorth Paramaters

fv_mob  = [];
fv_comp = [];

for i = (1:5)
    [mobility,complexity] = HjorthParameters(input(i,:));
    
    fv_mob  = [fv_mob  mobility];
    fv_comp = [fv_comp complexity];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   Max/Min power bands

N  = size(input,2);

input_dft = fft(input')';
input_dft = input_dft(:,1:N/2+1);
input_psd = (1/N) * abs(input_dft).^2;

input_psd  = input_psd(:, 2:end-1);

fv_psd_max = max(input_psd');

for i = (1:5)
    fv_psd_max_index(i) = ...
        max(find( input_psd(i,:) == fv_psd_max(i) ));
end

fv = [fv_var fv_en fv_skew fv_kurt fv_mob fv_comp ...
    fv_psd_max fv_psd_max_index]; 

if nargin == 2 && log_flag
    fv = [log(fv(1:10)  + exp(1)) ... log var, energy
              fv(11:20)           ... no log skew,kurt
          log(fv(21:35) + exp(1)) ... log mob, comp, psd_man
              fv(36:40)];             % no log on psd max loc
end

end

function [mobility,complexity] = HjorthParameters(input)

input_diff     = diff(input);
input_var      = var(input);
input_diff_var = var(input_diff);

mobility = sqrt(input_diff_var/input_var);

input_diff2     = diff(input_diff);
input_diff2_var = var(input_diff2);
mobility2       = sqrt(input_diff2_var/input_diff_var);

complexity = mobility2/mobility;
 
end
