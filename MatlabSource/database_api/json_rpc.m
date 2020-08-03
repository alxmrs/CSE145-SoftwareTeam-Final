function response  = json_rpc( method, params, id, t)
%json-rpc client for json-rpc protocol. 
% dependencies: jsonlab-1.0 and jsonrpc2. 
% Make sure to modify the addpaths at top of function. 
% EG: response  = json_rpc( method, params, id, t)

% Matlab --> Python arrays
% addpath('/Users/Xander/Documents/MATLAB/array'); % http://tinyurl.com/qyohjrc

DEBUG = 0;

% Check that params is a struct
if ~isstruct(params)
    display('params needs to be a struct!');
    return;
end

% Generate JSON request
request = jsonrpc2.JSONRPC2Request(id, method, params);
json_request = request.toJSONString();
json_request(json_request == char(10)) = ' '; % remove the newline chars

% disp(json_request);


if nargin == 3
    disp('Making RPC to default destination: localhost:8888');
    t = createConnection('localhost', 8888);
    try
        fopen(t);
        disp('Connection opened');
    catch ME
        display(ME.identifier);
        display('Safely closing connection');
        fclose(t);
        delete(t);
        rethrow(ME);
    end
end

% set timeout value to be 20 seconds
set(t,'timeout',20);

try
    if(DEBUG) 
        disp('Sending json request'); 
    end
    fwrite(t, json_request);
catch ME
    display(ME.identifier);
    display('Safely closing connection');
    fclose(t);
    delete(t);
    rethrow(ME);
end
if(DEBUG)
    disp('Request sent successfully.');
    disp('Waiting for response...');
end


json_resp = '';
while(t.BytesAvailable == 0)
end

while(t.BytesAvailable > 0)
    if(DEBUG) 
        disp('incoming response...'); 
    end
     try
        json_resp = fread(t, t.BytesAvailable);
    catch ME
        display(ME.identifier);
        display('Safely closing connection');
        fclose(t);
        delete(t);

        json_resp = savejson('', {'message', 'error with read'});

        rethrow(ME);
     end
end

if(isnumeric(json_resp(1)))
    json_resp = char(json_resp);
end


response = json_resp'; %loadjson(json_resp);
if(DEBUG) disp('recieved:'); end
% disp(response);



end

