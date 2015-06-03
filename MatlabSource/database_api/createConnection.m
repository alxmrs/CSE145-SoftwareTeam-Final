function [ t_obj ] = createConnection( host, port, byteAvail, mode )
%CREATECONNECTION creates TCPIP connection object with correct host, port.
%   Will use the object returned from this function to make remote
%   procedure calls. 



% t_obj;
try
    localport = randi([2000, 65535], 1)
    t_obj = tcpip(host, port, 'NetworkRole', 'client',...
    'localport', localport);
catch ME
    display(ME.identifier);
    display('Safely closing connection');
    fclose(t_obj);
    delete(t_obj);    
    rethrow(ME);
end

if nargin == 2
    mode = 'byte';
    byteAvail = 2^13; % 2^12;
end
if nargin == 3
   mode = 'byte'; 
end


t_obj.OutputBufferSize = byteAvail;
t_obj.BytesAvailableFcnMode = mode;
% t_obj.BytesAvailableFcnCount = byteAvail;


disp('Created TCPIP Object.');

try
    fopen(t_obj);
    disp('Connection opened');
catch ME
    display(ME.identifier);
    display('Safely closing connection');
    fclose(t_obj);
    delete(t_obj);
    rethrow(ME);
end



end

