function runAllTests()
% Run all tests for jsonrpc2 package.
%
% Copyright (c) 2013, Cornell University, Lab of Ornithology
% All rights reserved.
%
% Distributed under BSD license.  See LICENSE_BSD.txt for full license.
% 
% Author: E. L. Rayle
%

    runtests jsonrpc2Tests.TestJSONRPC2Message
    runtests jsonrpc2Tests.TestJSONRPC2Request
    runtests jsonrpc2Tests.TestJSONRPC2Notification
    runtests jsonrpc2Tests.TestJSONRPC2Response
    runtests jsonrpc2Tests.TestJSONRPC2Error
    runtests jsonrpc2Tests.TestJSONRPC2Parser
    runtests jsonrpc2Tests.TestParamsRetriever
    
end