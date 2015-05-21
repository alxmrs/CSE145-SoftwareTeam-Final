function [ output ] = Bonn_upsample( input )
%function [ output ] = Bonn_upsample( input )
%
%   173.61Hz -> 256Hz

    samplingFreq_old = 173.61;
    samplingFreq_new = 256;
    
    ratio = samplingFreq_old/samplingFreq_new;
    
    numSamples_old = size(input.record,2);
    numSamples_new = floor(numSamples_old/ratio);
    
    oldrec = input.record;
    newrec = zeros(1,numSamples_new);
    
        oldpos = 1;
    for newpos = (1:numSamples_old)
       
        oldpos = oldpos + ratio;
        low    = floor(oldpos);
        high   = ceil(oldpos);
        prop   = oldpos-low;
        
        newrec(1,newpos) = oldrec(1,low) + ...
                           prop*(oldrec(1,high)-oldrec(1,low));
        
    end
      
    output = input;
    
    output.record = newrec;
    output.hdr.sf = samplingFreq_new;

end

