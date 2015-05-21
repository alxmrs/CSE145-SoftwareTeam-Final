function [patient_data] = CHBMIT_parse(patientNum, segments);
% [patient_data] = CHBMIT_parse(patientNum, numSegments)

assert(nargin == 2);

sampling_frequency = 256;

bottomSeg = segments(1);
topSeg    = segments(2);

assert(bottomSeg <= topSeg);

%%%%%%%%% READ .edf %%%%%%%%%

patientNum_str  = num2str(patientNum);
path_str_1to9   = 'CHB-MIT/Patient pnum/edf Files/chb0pnum_0snum.edf';
path_str_10to99 = 'CHB-MIT/Patient pnum/edf Files/chb0pnum_snum.edf';

for i = (bottomSeg:topSeg)

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

for i = (bottomSeg:topSeg)
    fprintf('Parsing segment %d\n', i);
    [hdr record] = edfread(filename(i,:));
    this.hdr     = hdr;
    this.hdr.sf  = 256;
    this.record  = record;
    patient_data = [patient_data; this];
    fprintf('\n');
end

end