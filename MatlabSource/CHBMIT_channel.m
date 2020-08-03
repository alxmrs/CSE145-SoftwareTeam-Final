function [output] = CHBMIT_channel(input, channel)
%function [output] = CHBMIT_channel(input, channel)

numRecords = size(input,1);

for i = (1:numRecords)

	header = input(i).hdr;
	record = input(i).record;

	channel_index = find(strcmp(header.label,channel));
	record        = record(channel_index,:);
    
    header.ns          = 1;
    header.label       = header.label(channel_index);
    header.transducer  = header.transducer(channel_index);
    header.units       = header.units(channel_index);
    header.physicalMin = header.physicalMin(channel_index);
    header.physicalMax = header.physicalMax(channel_index);
    header.digitalMin  = header.digitalMin(channel_index);
    header.digitalMax  = header.digitalMax(channel_index);
    header.prefilter   = header.prefilter(channel_index);
    header.samples     = header.samples(channel_index);

    output(i,1).record(1,:) = record;
    output(i,1).hdr         = header;
  
end

end