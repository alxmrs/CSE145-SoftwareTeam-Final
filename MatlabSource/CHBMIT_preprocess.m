function [output] = CHBMIT_preprocess(input)
%function [output] = CHBMIT_preprocess(data)
%
%  - Low Pass Filtering to 100Hz
%  - Wavelet Decomposition

fprintf('\n');
fprintf('Preprocessing CHB-MIT data...\n');

numRecords    = size(input,1);
sampling_freq = 256;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% LPF to 100Hz
%

fprintf('\n');
fprintf('Low-pass filtering [fc = 100Hz]...\n');

lpf_cutoff            = 100;
lpf_cutoff_normalised = 100/sampling_freq;
lpf_order             = 8;



for i = (1:numRecords)
    
    record        = input(i,1).record;

    [num_coeff dec_coeff] = butter(lpf_order, lpf_cutoff_normalised);
    record                = filter(num_coeff, dec_coeff, record);

    input(i).record = record;
    
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
for i = (1:numRecords)
    output(i,1) = Classifier_decompose(input(i),1024);
end

fprintf('\n');
fprintf('Done.\n');
fprintf('\n');

end