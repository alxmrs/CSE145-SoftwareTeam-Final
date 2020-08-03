% Tests for JSONRPC2Error class
%
% Copyright (c) 2014, Cornell University, Lab of Ornithology
% All rights reserved.
%
% Distributed under BSD license.  See LICENSE_BSD.txt for full license.
% 
% Author: E. L. Rayle
% date: 01/22/2014
%
% COMMAND TO RUN THESE TESTS:  runtests jsonrpc2Tests.TestJSONRPC2Error
%

classdef TestJSONRPC2Error < TestCase

% =============================================================================
%                             Setup & Teardown
% =============================================================================
    methods
        function this = TestJSONRPC2Error(name)
            this = this@TestCase(name);
        end

        function setUp(this)
        end

        function tearDown(this)
        end

% =============================================================================
%                         Constructor Method Tests
% =============================================================================
        function test_JSONRPC2Error_constructor(this)

            testname = 'test_JSONRPC2Error_constructor';

            %-------------------------
            % setup test
            %-------------------------
            id      = 'req-1';
            errmsg  = 'FAILURE: Invalid Request';
            errcode = jsonrpc2.JSONRPC2Error.JSON_INVALID_REQUEST;
            
            %-------------------------
            % run method being tested
            %-------------------------
            newErrorResponse = jsonrpc2.JSONRPC2Error(id, errcode, errmsg);
            
            %-------------------------
            % test
            %-------------------------
            test_id = newErrorResponse.id;
            assertTrue(strcmp(test_id,id),['TEST FAIL: ',testname,' -- bad message ID in error response -- ACTUAL: ',test_id,'  EXPECTED: ',id]);

            test_errmsg = newErrorResponse.errmsg;
            assertTrue(strcmp(test_errmsg,errmsg),['TEST FAIL: ',testname,' -- bad error message in error response -- ACTUAL: ',test_errmsg,'  EXPECTED: ',errmsg]);

            test_errcode = newErrorResponse.errcode;
            assertTrue(test_errcode==errcode,['TEST FAIL: ',testname,' -- bad error code in error response -- ACTUAL: ',int2str(test_errcode),'  EXPECTED: ',int2str(errcode)]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Error',testname);

        end % test_JSONRPC2Error_constructor %
   
        
% =============================================================================
%                             Parse Method Tests
% =============================================================================

        %% --------------------------------------------------------------------
        %   test_parse_error
        %% --------------------------------------------------------------------
        function test_parse_error(this)

            testname = 'test_parse_error';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-2';
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
            newErrorResponse = jsonrpc2.JSONRPC2Error.parse(errorMsg);

            %-------------------------
            % test
            %-------------------------
            assertTrue(strcmp(class(newErrorResponse),'jsonrpc2.JSONRPC2Error'),['TEST FAIL: ',testname,' -- wrong class -- ACTUAL: ',class(newErrorResponse),'  EXPECTED: jsonrpc2.JSONRPC2Error']);

            test_id = newErrorResponse.id;
            assertTrue(strcmp(test_id,id),['TEST FAIL: ',testname,' -- bad message ID in error response -- ACTUAL: ',test_id,'  EXPECTED: ',id]);

            test_errmsg = newErrorResponse.errmsg;
            assertTrue(strcmp(test_errmsg,errmsg),['TEST FAIL: ',testname,' -- bad error message in error response -- ACTUAL: ',test_errmsg,'  EXPECTED: ',errmsg]);

            test_errcode = newErrorResponse.errcode;
            assertTrue(test_errcode==errcode,['TEST FAIL: ',testname,' -- bad error code in error response -- ACTUAL: ',int2str(test_errcode),'  EXPECTED: ',int2str(errcode)]);
            
            jsonrpc2Tests.log_passingTest('TestJSONRPC2Error',testname);

        end % test_parse_error %
        

        %% --------------------------------------------------------------------
        %   test_parse_usingResponseClass
        %% --------------------------------------------------------------------
        function test_parse_usingResponseClass(this)

            testname = 'test_parse_usingResponseClass';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-2';
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
            newErrorResponse = jsonrpc2.JSONRPC2Response.parse(errorMsg);

            %-------------------------
            % test
            %-------------------------
            assertTrue(strcmp(class(newErrorResponse),'jsonrpc2.JSONRPC2Error'),['TEST FAIL: ',testname,' -- wrong class -- ACTUAL: ',class(newErrorResponse),'  EXPECTED: jsonrpc2.JSONRPC2Error']);

            test_id = newErrorResponse.id;
            assertTrue(strcmp(test_id,id),['TEST FAIL: ',testname,' -- bad message ID in error response -- ACTUAL: ',test_id,'  EXPECTED: ',id]);

            test_errmsg = newErrorResponse.errmsg;
            assertTrue(strcmp(test_errmsg,errmsg),['TEST FAIL: ',testname,' -- bad error message in error response -- ACTUAL: ',test_errmsg,'  EXPECTED: ',errmsg]);

            test_errcode = newErrorResponse.errcode;
            assertTrue(test_errcode==errcode,['TEST FAIL: ',testname,' -- bad error code in error response -- ACTUAL: ',int2str(test_errcode),'  EXPECTED: ',int2str(errcode)]);
            
            jsonrpc2Tests.log_passingTest('TestJSONRPC2Error',testname);

        end % test_parse_usingResponseClass %

        %% --------------------------------------------------------------------
        %   test_parse_error_badJson_missingId
        %% --------------------------------------------------------------------
        function test_parse_error_badJson_missingId(this)

            testname = 'test_parse_error_badJson_missingId';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-2';
            errmsg  = 'FAILURE: Method Not Found';
            errcode = jsonrpc2.JSONRPC2Error.JSON_METHOD_NOT_FOUND;
                        
            errorMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"error": { ', ...
                    '"code": ',int2str(errcode),',', ...
                    '"message": "',errmsg,'"', ...
                '}', ...
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
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- constructing a error response without an id did not throw exception']);
            
            jsonrpc2Tests.log_passingTest('TestJSONRPC2Error',testname);

        end % test_parse_error_badJson_missingId %
        
        %% --------------------------------------------------------------------
        %   test_parse_error_badJson_missingError
        %% --------------------------------------------------------------------
        function test_parse_error_badJson_missingError(this)

            testname = 'test_parse_error_badJson_missingError';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-2';
            errmsg  = 'FAILURE: Method Not Found';
            errcode = jsonrpc2.JSONRPC2Error.JSON_METHOD_NOT_FOUND;
                        
            errorMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"id": "',id,'",', ...
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
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- constructing a error response without an error did not throw exception']);
            
            jsonrpc2Tests.log_passingTest('TestJSONRPC2Error',testname);

        end % test_parse_error_badJson_missingError %
        
        %% --------------------------------------------------------------------
        %   test_parse_error_badJson_missingErrorCode
        %% --------------------------------------------------------------------
        function test_parse_error_badJson_missingErrorCode(this)

            testname = 'test_parse_error_badJson_missingErrorCode';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-2';
            errmsg  = 'FAILURE: Method Not Found';
            errcode = jsonrpc2.JSONRPC2Error.JSON_METHOD_NOT_FOUND;
                        
            errorMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"id": "',id,'",', ...
                '"error": { ', ...
                    '"message": "',errmsg,'"', ...
                '}', ...
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
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- constructing a error response without an error code did not throw exception']);
            
            jsonrpc2Tests.log_passingTest('TestJSONRPC2Error',testname);

        end % test_parse_error_badJson_missingErrorCode %
        
        %% --------------------------------------------------------------------
        %   test_parse_error_badJson_missingErrorMessage
        %% --------------------------------------------------------------------
        function test_parse_error_badJson_missingErrorMessage(this)

            testname = 'test_parse_error_badJson_missingErrorMessage';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-2';
            errmsg  = 'FAILURE: Method Not Found';
            errcode = jsonrpc2.JSONRPC2Error.JSON_METHOD_NOT_FOUND;
                        
            errorMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"id": "',id,'",', ...
                '"error": { ', ...
                    '"code": ',int2str(errcode),',', ...
                '}', ...
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
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- constructing a error response without an error message did not throw exception']);            
            
            jsonrpc2Tests.log_passingTest('TestJSONRPC2Error',testname);

        end % test_parse_error_badJson_missingErrorMessage %
        
        %% --------------------------------------------------------------------
        %   test_parse_error_badJson_extraStuff
        %% --------------------------------------------------------------------
        function test_parse_error_badJson_extraStuff(this)

            testname = 'test_parse_error_badJson_extraStuff';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-2';
            errmsg  = 'FAILURE: Method Not Found';
            errcode = jsonrpc2.JSONRPC2Error.JSON_METHOD_NOT_FOUND;
                        
            errorMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"id": "',id,'",', ...
                '"error": { ', ...
                    '"code": ',int2str(errcode),',', ...
                    '"message": "',errmsg,'"', ...
                '}', ...
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
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- constructing a response error with extra stuff did not throw exception']);
            
            jsonrpc2Tests.log_passingTest('TestJSONRPC2Error',testname);

        end % test_parse_error_badJson_extraStuff %
        

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
            errmsg  = 'FAILURE: Invalid Params';
            errcode = jsonrpc2.JSONRPC2Error.JSON_INVALID_PARAMS;

            newErrorResponse = jsonrpc2.JSONRPC2Error(id, errcode, errmsg);
            
            %-------------------------
            % run method being tested
            %-------------------------
            test_id = newErrorResponse.id;
            assertTrue(strcmp(test_id,id),['TEST FAIL: ',testname,' -- bad message ID in error response -- ACTUAL: ',test_id,'  EXPECTED: ',id]);

            %-------------------------
            % modify and re-run
            %-------------------------
            set_id = 'req-3-mod';
            newErrorResponse.id = set_id;
            test_id = newErrorResponse.id;
            assertTrue(strcmp(test_id,set_id),['TEST FAIL: ',testname,' -- bad updated message ID in error response -- ACTUAL: ',test_id,'  EXPECTED: ',set_id]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Error',testname);

        end % test_getterSetter_ID %

        %% --------------------------------------------------------------------
        %   test_getterSetter_ErrorCode
        %% --------------------------------------------------------------------
        function test_getterSetter_ErrorCode(this)

            testname = 'test_getterSetter_ErrorCode';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-4';
            errmsg  = 'FAILURE: Internal Error';
            errcode = jsonrpc2.JSONRPC2Error.JSON_INTERNAL_ERROR;

            newErrorResponse = jsonrpc2.JSONRPC2Error(id, errcode, errmsg);
            
            %-------------------------
            % run method being tested
            %-------------------------
            test_errcode = newErrorResponse.errcode;
            assertTrue(test_errcode==errcode,['TEST FAIL: ',testname,' -- bad error code in error response -- ACTUAL: ',int2str(test_errcode),'  EXPECTED: ',int2str(errcode)]);

            %-------------------------
            % modify and re-run
            %-------------------------
            set_errcode = jsonrpc2.JSONRPC2Error.JSON_PARSE_ERROR;
            newErrorResponse.errcode = set_errcode;
            test_errcode = newErrorResponse.errcode;
            assertTrue(test_errcode==set_errcode,['TEST FAIL: ',testname,' -- bad updated error code in error response -- ACTUAL: ',int2str(test_errcode),'  EXPECTED: ',int2str(set_errcode)]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Error',testname);

        end % test_getterSetter_ErrorCode %

        %% --------------------------------------------------------------------
        %   test_getterSetter_ErrorMessage
        %% --------------------------------------------------------------------
        function test_getterSetter_ErrorMessage(this)

            testname = 'test_getterSetter_ErrorMessage';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-5';
            errmsg  = 'FAILURE: Job Transport Error';
            errcode = jsonrpc2.JSONRPC2Error.JSON_TRANSPORT_ERROR;

            newErrorResponse = jsonrpc2.JSONRPC2Error(id, errcode, errmsg);
            
            %-------------------------
            % run method being tested
            %-------------------------
            test_errmsg = newErrorResponse.errmsg;
            assertTrue(strcmp(test_errmsg,errmsg),['TEST FAIL: ',testname,' -- bad error message in error response -- ACTUAL: ',test_errmsg,'  EXPECTED: ',errmsg]);

            %-------------------------
            % modify and re-run
            %-------------------------
            set_errmsg = 'FAILURE: Job Transport Error - mod';
            newErrorResponse.errmsg = set_errmsg;
            test_errmsg = newErrorResponse.errmsg;
            assertTrue(strcmp(test_errmsg,set_errmsg),['TEST FAIL: ',testname,' -- bad updated error message in error response -- ACTUAL: ',test_errmsg,'  EXPECTED: ',set_errmsg]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Error',testname);

        end % test_getterSetter_ErrorMessage %

        %% --------------------------------------------------------------------
        %   test_getterSetter_Result_when_iserror
        %% --------------------------------------------------------------------
        function test_getterSetter_Result_when_iserror(this)

            testname = 'test_getterSetter_Result_when_iserror';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-6';
            errmsg  = 'FAILURE: Application Error';
            errcode = jsonrpc2.JSONRPC2Error.JSON_APPLICATION_ERROR;

            newErrorResponse = jsonrpc2.JSONRPC2Error(id, errcode, errmsg);
            
            %-------------------------
            % test for exception when attempt to get result for error response
            %-------------------------
            caughtExpectedException = false;
            try
                test_result = newErrorResponse.result;
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
                newErrorResponse.result = test_result;
            catch Exception
                caughtExpectedException = true;
            end
            
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- setting result when response is an error did not throw exception']);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Error',testname);

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
            id     = 'req-7';
            errmsg  = 'FAILURE: Parse Error Unsupported Encoding';
            errcode = jsonrpc2.JSONRPC2Error.JSON_PARSE_ERROR_UNSUPPORTED_ENCODING;

            newErrorResponse = jsonrpc2.JSONRPC2Error(id, errcode, errmsg);
            
            %-------------------------
            % run method being tested
            %-------------------------
            iserror = newErrorResponse.isError();
            assertTrue(iserror,['TEST FAIL: ',testname,' -- isError() does not think this error response is an error.']);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Error',testname);

        end % test_isError_when_iserror %

        %% --------------------------------------------------------------------
        %   test_toJSONString
        %% --------------------------------------------------------------------
        function test_toJSONString(this)

            testname = 'test_toJSONString';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-2';
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

            newErrorResponse = jsonrpc2.JSONRPC2Response.parse(errorMsg);
            
            %-------------------------
            % run method being tested
            %-------------------------
            test_errorMsg = newErrorResponse.toJSONString();
            match = jsonrpc2Tests.strcmpiw(errorMsg,test_errorMsg);
            assertTrue(match,['TEST FAIL: ',testname,' -- original and generated JSON do not match -- GENERATED: ',test_errorMsg,'  ORIGINAL: ',errorMsg]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Error',testname);

        end % test_toJSONString %

    end % methods %

end % classdef %

        
