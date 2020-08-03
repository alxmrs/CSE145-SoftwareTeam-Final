% Tests for JSONRPC2Response class
%
% Copyright (c) 2014, Cornell University, Lab of Ornithology
% All rights reserved.
%
% Distributed under BSD license.  See LICENSE_BSD.txt for full license.
% 
% Author: E. L. Rayle
% date: 01/22/2014
%
% COMMAND TO RUN THESE TESTS:  runtests jsonrpc2Tests.TestJSONRPC2Response
%

classdef TestJSONRPC2Response < TestCase
 
% =============================================================================
%                             Setup & Teardown
% =============================================================================
    methods
        function this = TestJSONRPC2Response(name)
            this = this@TestCase(name);
        end

        function setUp(this)
        end

        function tearDown(this)
        end

% =============================================================================
%                         Constructor Method Tests
% =============================================================================
        function test_JSONRPC2Response_constructor(this)

            testname = 'test_JSONRPC2Response_constructor';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-1';
            result = 'SUCCESS';
            
            %-------------------------
            % run method being tested
            %-------------------------
            newResponse = jsonrpc2.JSONRPC2Response(id,result);
            
            %-------------------------
            % test
            %-------------------------
            test_id = newResponse.id;
            assertTrue(strcmp(test_id,id),['TEST FAIL: ',testname,' -- bad message ID in response -- ACTUAL: ',test_id,'  EXPECTED: ',id]);

            test_result = newResponse.result;
            assertTrue(strcmp(test_result,result),['TEST FAIL: ',testname,' -- bad result in response -- ACTUAL: ',test_result,'  EXPECTED: ',result]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Response',testname);

        end % test_JSONRPC2Response_constructor %
   
        
% =============================================================================
%                             Parse Method Tests
% =============================================================================

        %% --------------------------------------------------------------------
        %   test_parse_response
        %% --------------------------------------------------------------------
        function test_parse_response(this)

            testname = 'test_parse_response';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-2';
            result = 'SUCCESS AGAIN';
            
            responseMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"result": "',result,'",', ...
                '"id": "',id,'"', ...
            '}'];

            %-------------------------
            % run method being tested
            %-------------------------
            newResponse = jsonrpc2.JSONRPC2Response.parse(responseMsg);

            %-------------------------
            % test
            %-------------------------
            test_id = newResponse.id;
            assertTrue(strcmp(test_id,id),['TEST FAIL: ',testname,' -- bad message ID in response -- ACTUAL: ',test_id,'  EXPECTED: ',id]);

            test_result = newResponse.result;
            assertTrue(strcmp(test_result,result),['TEST FAIL: ',testname,' -- bad result in response -- ACTUAL: ',test_result,'  EXPECTED: ',result]);
            
            jsonrpc2Tests.log_passingTest('TestJSONRPC2Response',testname);

        end % test_parse_response %
        
        %% --------------------------------------------------------------------
        %   test_parse_response_badJson_missingId
        %% --------------------------------------------------------------------
        function test_parse_response_badJson_missingId(this)

            testname = 'test_parse_response_badJson_missingId';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-2';
            result  = 'SUCCESS';
                        
            responseMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"result": "',result,'"', ...
            '}'];

            %-------------------------
            % run method being tested
            %-------------------------
            caughtExpectedException = false;
            try
                newResponse = jsonrpc2.JSONRPC2Response.parse(responseMsg);
            catch Exception
                caughtExpectedException = true;
            end
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- constructing a response without an id did not throw exception']);
            
            jsonrpc2Tests.log_passingTest('TestJSONRPC2Response',testname);

        end % test_parse_response_badJson_missingId %
        
        %% --------------------------------------------------------------------
        %   test_parse_response_badJson_missingResult
        %% --------------------------------------------------------------------
        function test_parse_response_badJson_missingResult(this)

            testname = 'test_parse_response_badJson_missingResult';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-2';
            result  = 'SUCCESS';
                        
            responseMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"id": "',id,'"', ...
            '}'];

            %-------------------------
            % run method being tested
            %-------------------------
            caughtExpectedException = false;
            try
                newResponse = jsonrpc2.JSONRPC2Response.parse(responseMsg);
            catch Exception
                caughtExpectedException = true;
            end
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- constructing a response without a result did not throw exception']);
            
            jsonrpc2Tests.log_passingTest('TestJSONRPC2Response',testname);

        end % test_parse_response_badJson_missingResult %
        
        %% --------------------------------------------------------------------
        %   test_parse_response_badJson_extraStuff
        %% --------------------------------------------------------------------
        function test_parse_response_badJson_extraStuff(this)

            testname = 'test_parse_response_badJson_extraStuff';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-2';
            result  = 'SUCCESS';
                        
            responseMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"id": "',id,'"', ...
                '"result": "',result,'"', ...
                '"blah": "blah",', ...
            '}'];

            %-------------------------
            % run method being tested
            %-------------------------
            caughtExpectedException = false;
            try
                newErrorResponse = jsonrpc2.JSONRPC2Error.parse(errorMsg);
            catch Exception
                caughtExpectedException = true;
            end
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- constructing a response with extra stuff did not throw exception']);
            
            jsonrpc2Tests.log_passingTest('TestJSONRPC2Response',testname);

        end % test_parse_response_badJson_extraStuff %
        

% =============================================================================
%                      Test Getter/Setter Methods
% =============================================================================

        %% --------------------------------------------------------------------
        %   test_getterSetter_ID
        %% --------------------------------------------------------------------
        function test_getterSetter_ID(this)

            testname = 'test_getterSetter_ID';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-3';
            result = 'YES, SUCCESS';

            newResponse = jsonrpc2.JSONRPC2Response(id,result);
            
            %-------------------------
            % run method being tested
            %-------------------------
            test_id = newResponse.id;
            assertTrue(strcmp(test_id,id),['TEST FAIL: ',testname,' -- bad message ID in response -- ACTUAL: ',test_id,'  EXPECTED: ',id]);

            %-------------------------
            % modify and re-run
            %-------------------------
            set_id = 'req-3-mod';
            newResponse.id = set_id;
            test_id = newResponse.id;
            assertTrue(strcmp(test_id,set_id),['TEST FAIL: ',testname,' -- bad updated message ID in response -- ACTUAL: ',test_id,'  EXPECTED: ',set_id]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Response',testname);

        end % test_getterSetter_ID %

        %% --------------------------------------------------------------------
        %   test_getterSetter_Result
        %% --------------------------------------------------------------------
        function test_getterSetter_Result(this)

            testname = 'test_getterSetter_Result';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-4';
            result = 'Oh Yea, SUCCESS';

            newResponse = jsonrpc2.JSONRPC2Response(id,result);
            
            %-------------------------
            % run method being tested
            %-------------------------
            test_result = newResponse.result;
            assertTrue(strcmp(test_result,result),['TEST FAIL: ',testname,' -- bad message Result in response -- ACTUAL: ',test_result,'  EXPECTED: ',result]);

            %-------------------------
            % modify and re-run
            %-------------------------
            set_result = 'Oh Yea, SUCCESS - mod';
            newResponse.result = set_result;
            test_result = newResponse.result;
            assertTrue(strcmp(test_result,set_result),['TEST FAIL: ',testname,' -- bad updated message Result in response -- ACTUAL: ',test_result,'  EXPECTED: ',set_result]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Response',testname);

        end % test_getterSetter_Result %

        %% --------------------------------------------------------------------
        %   test_getterSetter_Result_when_iserror
        %% --------------------------------------------------------------------
        function test_getterSetter_Result_when_iserror(this)

            testname = 'test_getterSetter_Result_when_iserror';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-5';

            newErrResponse = jsonrpc2.JSONRPC2Error(id,123,'BAD');
            
            %-------------------------
            % test for exception when attempt to get result for error response
            %-------------------------
            caughtExpectedException = false;
            try
                test_result = newErrResponse.result;
            catch Exception
                caughtExpectedException = true;
            end
            
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- getting result when response is an error did not throw exception']);

            %-------------------------
            % test for exception when attempt to set result for error response
            %-------------------------
            caughtExpectedException = false;
            try
                test_result = 'Should Cause Exception';
                newErrResponse.result = test_result;
            catch Exception
                caughtExpectedException = true;
            end
            
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- setting result when response is an error did not throw exception']);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Response',testname);

        end % test_getterSetter_Result_when_iserror %


% =============================================================================
%                             Test Instance Methods
% =============================================================================

        %% --------------------------------------------------------------------
        %   test_isError_when_iserror
        %% --------------------------------------------------------------------
        function test_isError_when_iserror(this)

            testname = 'test_isError_when_iserror';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-6';

            newErrResponse = jsonrpc2.JSONRPC2Error(id,123,'BAD');
            
            %-------------------------
            % run method being tested
            %-------------------------
            iserror = newErrResponse.isError();
            assertTrue(iserror,['TEST FAIL: ',testname,' -- isError() does not think this error response is an error.']);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Response',testname);

        end % test_isError_when_iserror %

        %% --------------------------------------------------------------------
        %   test_isError_when_noterror
        %% --------------------------------------------------------------------
        function test_isError_when_noterror(this)

            testname = 'test_isError_when_noterror';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-7';
            result = 'YEP, SUCCESS AGAIN';

            newResponse = jsonrpc2.JSONRPC2Response(id,result);
            
            %-------------------------
            % run method being tested
            %-------------------------
            iserror = newResponse.isError();
            assertFalse(iserror,['TEST FAIL: ',testname,' -- isError() thinks this success response is an error.']);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Response',testname);

        end % test_isError_when_noterror %

        %% --------------------------------------------------------------------
        %   test_toJSONString
        %% --------------------------------------------------------------------
        function test_toJSONString(this)

            testname = 'test_toJSONString';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-8';
            result = 'FINAL SUCCESS';
            
            responseMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"id": "',id,'",', ...
                '"result": "',result,'"', ...
            '}'];

            newResponse = jsonrpc2.JSONRPC2Response.parse(responseMsg);
            
            %-------------------------
            % run method being tested
            %-------------------------
            test_responseMsg = newResponse.toJSONString();
            match = jsonrpc2Tests.strcmpiw(responseMsg,test_responseMsg);
            assertTrue(match,['TEST FAIL: ',testname,' -- original and generated JSON do not match -- GENERATED: ',test_responseMsg,'  ORIGINAL: ',responseMsg]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Response',testname);

        end % test_toJSONString %

    end % methods %

end % classdef %

        
