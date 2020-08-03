function [N S] =Bonn_parse()
%function [N S] = Bonn_parse()
%
%   Parse Data
%   Create record files

fprintf('\n');
fprintf('Parsing Bonn data...\n');

%%%%% DATA INFO

sampling_rate = 173.61;


%%%%% FILENAMES

N_template_1to9   = 'N00sub.txt';
S_template_1to9   = 'S00sub.txt';

N_template_10to99 = 'N0sub.txt';
S_template_10to99 = 'S0sub.txt';


for i = (1:9)
    num_str = num2str(i);
    
    N_filename(i,:) = strrep(N_template_1to9, 'sub', num_str);
    S_filename(i,:) = strrep(S_template_1to9, 'sub', num_str);
end

for i = (10:99)
    num_str = num2str(i);
    
    N_filename(i,:) = strrep(N_template_10to99, 'sub', num_str);
    S_filename(i,:) = strrep(S_template_10to99, 'sub', num_str);
end

N_filename(100,:) = 'N100.txt';
S_filename(100,:) = 'S100.txt';


%%%%% CONVERT TO MATLAB ARRAY

for i = (1:100)
    N_path = 'Bonn/N/sub';
    S_path = 'Bonn/S/sub';
    
    N(i,1).record(1,:) = csvread(strrep(N_path, 'sub', N_filename(i,:)));
    S(i,1).record(1,:) = csvread(strrep(S_path, 'sub', S_filename(i,:)));
    
    N(i,1).hdr.sf = 173.61;
    S(i,1).hdr.sf = 173.61;
end

fprintf('Done.\n');
fprintf('\n');

end