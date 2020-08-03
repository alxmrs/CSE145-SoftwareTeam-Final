% Tests for JSONRPC2Message class
%
% Copyright (c) 2014, Cornell University, Lab of Ornithology
% All rights reserved.
%
% Distributed under BSD license.  See LICENSE_BSD.txt for full license.
% 
% Author: E. L. Rayle
% date: 01/22/2014
%
% COMMAND TO RUN THESE TESTS:  runtests jsonrpc2Tests.TestJSONRPC2Message
%

classdef TestJSONRPC2Message < TestCase

% =============================================================================
%                             Setup & Teardown
% =============================================================================
    methods
        function this = TestJSONRPC2Message(name)
            this = this@TestCase(name);
        end

        function setUp(this)
        end

        function tearDown(this)
        end


% =============================================================================
%                             Parse Method Tests
% =============================================================================

        %% --------------------------------------------------------------------
        %   test_parse_request
        %% --------------------------------------------------------------------
        function test_parse_request(this)

            testname = 'test_parse_request';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-1';
            method = 'concat';
            params = struct;
            params.s1 = 'Hello';
            params.s2 = 'World';
            params.sep = ' ';
            
            requestMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"method": "',method,'",', ...
                '"params": { "s1": "',params.s1,'", "s2": "',params.s2,'", "sep": "',params.sep,'" },', ...
                '"id": "',id,'"', ...
            '}'];

            %-------------------------
            % run method being tested
            %-------------------------
            newRequest = jsonrpc2.JSONRPC2Message.parse(requestMsg);

            %-------------------------
            % test
            %-------------------------
            expected_class = 'jsonrpc2.JSONRPC2Request';
            test_class     = class(newRequest);
            assertTrue(strcmp(test_class,expected_class),['TEST FAIL: ',testname,' -- message parsed to incorrect type -- ACTUAL: ',test_class,'  EXPECTED: ',expected_class]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Message',testname);

        end % test_parse_request %

        %% --------------------------------------------------------------------
        %   test_parse_notification
        %% --------------------------------------------------------------------
        function test_parse_notification(this)

            testname = 'test_parse_notification';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-2';
            method = 'concat';
            params = struct;
            params.s1 = 'Hello';
            params.s2 = 'World';
            params.sep = ' ';
            
            notificationMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"method": "',method,'",', ...
                '"params": { "s1": "',params.s1,'", "s2": "',params.s2,'", "sep": "',params.sep,'" }', ...
            '}'];

            %-------------------------
            % run method being tested
            %-------------------------
            newNotification = jsonrpc2.JSONRPC2Message.parse(notificationMsg);

            %-------------------------
            % test
            %-------------------------
            expected_class = 'jsonrpc2.JSONRPC2Notification';
            test_class     = class(newNotification);
            assertTrue(strcmp(test_class,expected_class),['TEST FAIL: ',testname,' -- message parsed to incorrect type -- ACTUAL: ',test_class,'  EXPECTED: ',expected_class]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Message',testname);

        end % test_parse_notification %

        %% --------------------------------------------------------------------
        %   test_parse_response
        %% --------------------------------------------------------------------
        function test_parse_response(this)

            testname = 'test_parse_response';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-3';
            result = 'SUCCESS';
            
            responseMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"result": "',result,'",', ...
                '"id": "',id,'"', ...
            '}'];

            %-------------------------
            % run method being tested
            %-------------------------
            newResponse = jsonrpc2.JSONRPC2Message.parse(responseMsg);

            %-------------------------
            % test
            %-------------------------
            expected_class = 'jsonrpc2.JSONRPC2Response';
            test_class     = class(newResponse);
            assertTrue(strcmp(test_class,expected_class),['TEST FAIL: ',testname,' -- message parsed to incorrect type -- ACTUAL: ',test_class,'  EXPECTED: ',expected_class]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Message',testname);

        end % test_parse_response %

        %% --------------------------------------------------------------------
        %   test_parse_error
        %% --------------------------------------------------------------------
        function test_parse_error(this)

            testname = 'test_parse_error';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-4';
            errmsg  = 'FAILURE: Method Not Found';
            errcode = jsonrpc2.JSONRPC2Error.JSON_METHOD_NOT_FOUND;
                        
            errorMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"id": "',id,'",', ...
                '"error": { ', ...
                    '"code": ',int2str(errcode),',', ...
                    '"message": "',errmsg,'"', ...
                '}', ...
            '}'];

            %-------------------------
            % run method being tested
            %-------------------------
            newError = jsonrpc2.JSONRPC2Message.parse(errorMsg);

            %-------------------------
            % test
            %-------------------------
            expected_class = 'jsonrpc2.JSONRPC2Error';
            test_class     = class(newError);
            assertTrue(strcmp(test_class,expected_class),['TEST FAIL: ',testname,' -- message parsed to incorrect type -- ACTUAL: ',test_class,'  EXPECTED: ',expected_class]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Message',testname);

        end % test_parse_error %

        
    end % methods %

end % classdef %

        
