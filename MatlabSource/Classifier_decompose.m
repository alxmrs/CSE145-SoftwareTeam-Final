function [ output ] = Classifier_decompose( input, window_size )
%function [ output ] = Classifier_decompose( input, window_size )

input_record = input.record;

output = input;
output.record = [];

recordLength = size(input_record,2);

for i = (1:window_size:recordLength-window_size)
    
    record = input_record(i:i+window_size-1);
    
    %Construct Daubauchies filter at 8th level
    h = daubcqf(8,'min');
    
    %Use filter to compute DWT at level 5
    [coeffs,L] = mdwt(record,h,5);

    %DWTs of respective bands found through zeroing irrelevant components    
    dwt_noise = [zeros(1,window_size/2)                   ...
                 coeffs(window_size/2+1:window_size)];

    zero_count = window_size/2;
    
    dwt_gamma = [zeros(1,window_size/4)                   ... 
                 coeffs(window_size/4+1:window_size/2)    ...
                 zeros(1,zero_count)];

    zero_count = zero_count + window_size/4;

    dwt_beta  = [zeros(1,window_size/8)                   ...
                 coeffs(window_size/8+1:window_size/4)    ...
                 zeros(1,zero_count)];

    zero_count = zero_count + window_size/8;

    dwt_alpha = [zeros(1,window_size/16)                  ...
                 coeffs(window_size/16+1:window_size/8)   ...
                 zeros(1,zero_count)];

    zero_count = zero_count + window_size/16;

    dwt_theta = [zeros(1,window_size/32)                  ...
                 coeffs(window_size/32+1:window_size/16)  ...
                 zeros(1,zero_count)];

    zero_count = zero_count + window_size/32;

    dwt_delta = [coeffs(1:window_size/32)                 ...
                 zeros(1,zero_count)];

     
    %IDWTs of band coefficients        
    [out_gamma, L] = midwt(dwt_gamma, h, 5);
    [out_beta,  L] = midwt(dwt_beta, h, 5); 
    [out_alpha, L] = midwt(dwt_alpha, h, 5); 
    [out_theta, L] = midwt(dwt_theta, h, 5); 
    [out_delta, L] = midwt(dwt_delta, h, 5);

    newSegment = [out_delta;
                  out_theta;
                  out_alpha;
                  out_beta;
                  out_gamma];
    
    output.record = [output.record newSegment];

end

    output.hdr.bands = cellstr(['delta'; 'theta'; 'alpha'; ...
                                'beta '; 'gamma'])';

end

