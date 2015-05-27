function [patient_data] = CHBMIT_parse(patientNum, segments)
% [patient_data] = CHBMIT_parse(patientNum, numSegments)

assert(nargin == 2);

sampling_frequency = 256;

bottomSeg = segments(1);
topSeg    = segments(2);

assert(bottomSeg <= topSeg);

%%%%%%%%% READ .edf %%%%%%%%%

patientNum_str  = num2str(patientNum);

if patientNum < 10
    path_str_1to9   = 'Data/CHBMIT/chb0pnum/chb0pnum_0snum.edf';
    path_str_10to99 = 'Data/CHBMIT/chb0pnum/chb0pnum_snum.edf';
else
    path_str_1to9   = 'Data/CHBMIT/chbpnum/chbpnum_0snum.edf';
    path_str_10to99 = 'Data/CHBMIT/chbpnum/chbpnum_snum.edf';
end

for i = bottomSeg:topSeg

    if i<10
        temp_str      = strrep(path_str_1to9, 'pnum', patientNum_str);
        filename(i,:) = strrep(temp_str,      'snum', num2str(i)    );
    else
        temp_str      = strrep(path_str_10to99, 'pnum', patientNum_str);
        filename(i,:) = strrep(temp_str,        'snum', num2str(i)    );
    end
    
end

fprintf('\n');
fprintf('Patient %d - Segments %d to %d\n', patientNum, bottomSeg, topSeg);
fprintf('\n');

patient_data = [];

for i = bottomSeg:topSeg
    fprintf('Parsing segment %d\n', i);
    [hdr record] = edfread(filename(i,:));
    this.record = record;
    this.hdr    = hdr;
    this.hdr.sf = 256;
    patient_data = [patient_data; this];
    fprintf('\n');
end

end