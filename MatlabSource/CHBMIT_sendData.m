function [ success ] = CHBMIT_sendData( data)
%function [ success ] = CHBMIT_sendData( data )

% Params

dataset = data ; %+ rand(8,60*250)*.2; % rand(8, 250*60); 

MAX_BYTES = 2^14;

num_samples  = size(dataset,2);
num_channels = size(dataset,1); 

flag = struct();
flag.compress_data  = false;
flag.optimise_bytes = true;

% start of iteration, find max num of samples to send
startWindowSize = 200; 

host = 'localhost';
port = 8888;


method_metadata = 'readMetadata';
method_buffData = 'readDataSegment';
method_flush    = 'flush';


startId = 0;

metadata = struct();

metadata.subj_name      = 'Alex R.';
metadata.group_name     = 'Send Attempt 1';
metadata.num_channels   = num_channels;
metadata.channel_labels = 'F1, F2, F3, F4, F5, F6, F7, REF';
metadata.reference      = 8;
metadata.sample_rate    = 250;



% Find optimal number of samples to send per window call
data = struct();

if flag.optimise_bytes
    window_size = startWindowSize;
    data_pos = 1;
    bytesUsed = 1000000;
    id = startId;
    while (bytesUsed > MAX_BYTES)
        % Compress data
        if flag.compress_data 
            tmp_dataset = cell(1,num_channels);
            for i = 1:num_channels
                tmp_data        = dataset(i, data_pos:(data_pos+window_size));
                uint8_data      = typecast(tmp_data, 'UINT8');    
                compressed_data = zlibencode(uint8_data);

                tmp_dataset{i} = char(compressed_data);
            end

            data.data = tmp_dataset; 
        else 
            data.data = dataset(:, data_pos:(data_pos+window_size));
        end
        request = jsonrpc2.JSONRPC2Request(id, method_buffData, data);
        json_request = request.toJSONString();

        S = whos('json_request');
        bytesUsed = S.bytes; % Get bytes of json rpc call

        window_size = window_size - 1; 

    end
end
window_size = 118;
disp(['Number of samples to send per call: ', num2str(window_size),...
      ', bytes: ', num2str(bytesUsed) ]);

% Create Connection to Server
t = createConnection(host, port, MAX_BYTES);


% Send metadata to python
disp('Reached: before metadata call.');
id = startId;
response = json_rpc(method_metadata, metadata, id, t)
disp('Reached: after metadata call.');
  
  
% Transmit data
tstart = tic;
while(data_pos + window_size < size(dataset, 2))
    
     if flag.compress_data 
            tmp_dataset = cell(1,num_channels);
            for i = 1:num_channels
                tmp_data        = dataset(i, data_pos:(data_pos+window_size));
                uint8_data      = typecast(tmp_data, 'UINT8');    
                compressed_data = zlibencode(uint8_data);

                tmp_dataset{i} = char(compressed_data);
            end

            data.data = tmp_dataset; 
        else 
            data.data = dataset(:, data_pos:(data_pos+window_size));
     end
            
    id = id + 1;
    
    response = json_rpc(method_buffData, data, id, t);
    
    % Only iterate to next window of data if rpc was successful. 
    if(isempty(strfind(response, 'Success')))
        data_pos = data_pos + window_size; 
    end
    
    
end

% Flush data --> store buffered data to database
flush = struct();
id = id + 1;
response = json_rpc(method_flush, flush, id, t)
telapsed = toc(tstart);

disp(['Time to transmit ' num2str(size(dataset,2)/(250*60)) ' minutes(s) of data: ', num2str(telapsed)]);

% Close connection 
fclose(t);
% delete(t);


end

