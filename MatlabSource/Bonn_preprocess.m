function [ output ] = Bonn_preprocess( input )
%function [ output ] = Bonn_preprocess( input )
%
%   Upsample: 173.61Hz -> 256Hz
%   LPF to 100Hz
%   Wavelet Decomposition

numInputs = size(input,1);

fprintf('\n');
fprintf('Preprocessing Bonn data...\n');

%%%%%%%
% Upsample: 173.61Hz -> 256Hz

fprintf('\n');
fprintf('Upsampling to 256Hz...\n');

for i = (1:numInputs)
    output(i,1) = Bonn_upsample(input(i,1));
end

%%%%%%%
% LPF to 100Hz

fprintf('\n');
fprintf('Low-pass filtering [fc = 100Hz]...\n');

lpf_cutoff            = 100;
lpf_cutoff_normalised = 100/256;
lpf_order             = 8;

for i = (1:numInputs)
    record = output(i,1).record;

    [num_coeff dec_coeff] = butter(lpf_order, lpf_cutoff_normalised);
    record                = filter(num_coeff, dec_coeff, record);

    output(i,1).record = record;
end

fprintf('Done.\n');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Wavelet Decomposition
%

fprintf('\n');
fprintf('Decomposing signal into the following bands:\n');
fprintf(' - Delta [0  -  4Hz]\n');
fprintf(' - Theta [4  -  8Hz]\n');
fprintf(' - Alpha [8  - 16Hz]\n');
fprintf(' - Beta  [16 - 32Hz]\n');
fprintf(' - Gamma [32 - 64Hz]\n');
fprintf('...\n');
for i = (1:numInputs)
    output(i,1) = Classifier_decompose(output(i,1),256);
end
fprintf('Done.\n');

fprintf('\n');

end

