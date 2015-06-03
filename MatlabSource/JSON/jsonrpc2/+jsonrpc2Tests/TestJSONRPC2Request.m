% Tests for JSONRPC2Request class
%
% Copyright (c) 2014, Cornell University, Lab of Ornithology
% All rights reserved.
%
% Distributed under BSD license.  See LICENSE_BSD.txt for full license.
% 
% Author: E. L. Rayle
% date: 01/22/2014
%
% COMMAND TO RUN THESE TESTS:  runtests jsonrpc2Tests.TestJSONRPC2Request
%

classdef TestJSONRPC2Request < TestCase

% =============================================================================
%                             Setup & Teardown
% =============================================================================
    methods
        function this = TestJSONRPC2Request(name)
            this = this@TestCase(name);
        end

        function setUp(this)
        end

        function tearDown(this)
        end

% =============================================================================
%                         Constructor Method Tests
% =============================================================================
        function test_JSONRPC2Request_constructor(this)

            testname = 'test_JSONRPC2Request_constructor';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-1';
            method = 'foo';

            params = struct;
            params.parm1 = 'hello';
            params.parm2 = 'world';
            
            %-------------------------
            % run method being tested
            %-------------------------
            newRequest = jsonrpc2.JSONRPC2Request(id,method,params);
            
            %-------------------------
            % test
            %-------------------------
            test_id = newRequest.id;
            assertTrue(strcmp(test_id,id),['TEST FAIL: ',testname,' -- bad message ID in request -- ACTUAL: ',test_id,'  EXPECTED: ',id]);

            test_method = newRequest.method;
            assertTrue(strcmp(test_method,method),['TEST FAIL: ',testname,' -- bad method in request -- ACTUAL: ',test_method,'  EXPECTED: ',method]);

            assertTrue(newRequest.hasParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have parameters.']);
            assertFalse(newRequest.hasPositionalParameters(),['TEST FAIL: ',testname,' -- request thinks it has positional parameters.']);
            assertTrue(newRequest.hasNamedParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have named parameters.']);

            test_params = newRequest.params;
            assertTrue(strcmp(class(test_params),'jsonrpc2.NamedParamsRetriever'),['TEST FAIL: ',testname,' -- params in request are not named parameters -- ACTUAL: ',class(test_params),'  EXPECTED: NamedParamsRetriever']);
            assertTrue(test_params.hasParam('parm1'),['TEST FAIL: ',testname,' -- field parm1 does not exist in params in request']);
            assertTrue(test_params.hasParam('parm2'),['TEST FAIL: ',testname,' -- field parm2 does not exist in params in request']);
            
            test_parm1 = test_params.get('parm1');
            assertTrue(strcmp(test_parm1,params.parm1),['TEST FAIL: ',testname,' -- bad parm1 value in request -- ACTUAL: ',test_parm1,'  EXPECTED: ',params.parm1]);

            test_parm2 = test_params.get('parm2');
            assertTrue(strcmp(test_parm2,params.parm2),['TEST FAIL: ',testname,' -- bad parm1 value in request -- ACTUAL: ',test_parm2,'  EXPECTED: ',params.parm2]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Request',testname);

        end % test_JSONRPC2Request_constructor %

% =============================================================================
%                             Parse Method Tests
% =============================================================================

        %% --------------------------------------------------------------------
        %   test_parse_multiParamsByName
        %% --------------------------------------------------------------------
        function test_parse_multiParamsByName(this)

            testname = 'test_parse_multiParamsByName';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-2';
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
            newRequest = jsonrpc2.JSONRPC2Request.parse(requestMsg);

            %-------------------------
            % test
            %-------------------------
            test_id = newRequest.id;
            assertTrue(strcmp(test_id,id),['TEST FAIL: ',testname,' -- bad message ID in request -- ACTUAL: ',test_id,'  EXPECTED: ',id]);

            test_method = newRequest.method;
            assertTrue(strcmp(test_method,method),['TEST FAIL: ',testname,' -- bad method in request -- ACTUAL: ',test_method,'  EXPECTED: ',method]);

            assertTrue(newRequest.hasParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have parameters.']);
            assertFalse(newRequest.hasPositionalParameters(),['TEST FAIL: ',testname,' -- request thinks it has positional parameters.']);
            assertTrue(newRequest.hasNamedParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have named parameters.']);

            test_params = newRequest.params;
            assertTrue(strcmp(class(test_params),'jsonrpc2.NamedParamsRetriever'),['TEST FAIL: ',testname,' -- params in request are not named parameters -- ACTUAL: ',class(test_params),'  EXPECTED: NamedParamsRetriever']);
            assertTrue(test_params.hasParam('s1'),['TEST FAIL: ',testname,' -- field s1 does not exist in params in request']);
            assertTrue(test_params.hasParam('s2'),['TEST FAIL: ',testname,' -- field s2 does not exist in params in request']);
            assertTrue(test_params.hasParam('sep'),['TEST FAIL: ',testname,' -- field sep does not exist in params in request']);
            
            test_s1 = test_params.get('s1');
            assertTrue(strcmp(test_s1,params.s1),['TEST FAIL: ',testname,' -- bad s1 value in request -- ACTUAL: ',test_s1,'  EXPECTED: ',params.s1]);

            test_s2 = test_params.get('s2');
            assertTrue(strcmp(test_s2,params.s2),['TEST FAIL: ',testname,' -- bad s2 value in request -- ACTUAL: ',test_s2,'  EXPECTED: ',params.s2]);

            test_sep = test_params.get('sep');
            assertTrue(strcmp(test_sep,params.sep),['TEST FAIL: ',testname,' -- bad parm1 value in request -- ACTUAL: ',test_sep,'  EXPECTED: ',params.sep]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Request',testname);

        end % test_parse_multiParamsByName %

        %% --------------------------------------------------------------------
        %   test_parse_singleParamByName
        %% --------------------------------------------------------------------
        function test_parse_singleParamByName(this)

            testname = 'test_parse_singleParamByName';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-3';
            method = 'echo';
            params = struct;
            params.text = 'Goodbye World';
            
            requestMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"method": "',method,'",', ...
                '"params": { "text": "',params.text,'" },', ...
                '"id": "',id,'"', ...
            '}'];

            %-------------------------
            % run method being tested
            %-------------------------
            newRequest = jsonrpc2.JSONRPC2Request.parse(requestMsg);

            %-------------------------
            % test
            %-------------------------
            test_id = newRequest.id;
            assertTrue(strcmp(test_id,id),['TEST FAIL: ',testname,' -- bad message ID in request -- ACTUAL: ',test_id,'  EXPECTED: ',id]);

            test_method = newRequest.method;
            assertTrue(strcmp(test_method,method),['TEST FAIL: ',testname,' -- bad method in request -- ACTUAL: ',test_method,'  EXPECTED: ',method]);

            assertTrue(newRequest.hasParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have parameters.']);
            assertFalse(newRequest.hasPositionalParameters(),['TEST FAIL: ',testname,' -- request thinks it has positional parameters.']);
            assertTrue(newRequest.hasNamedParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have named parameters.']);

            test_params = newRequest.params;
            assertTrue(strcmp(class(test_params),'jsonrpc2.NamedParamsRetriever'),['TEST FAIL: ',testname,' -- params in request are not named parameters -- ACTUAL: ',class(test_params),'  EXPECTED: NamedParamsRetriever']);
            assertTrue(test_params.hasParam('text'),['TEST FAIL: ',testname,' -- field text does not exist in params in request']);
            
            test_text = test_params.get('text');
            assertTrue(strcmp(test_text,params.text),['TEST FAIL: ',testname,' -- bad text value in request -- ACTUAL: ',test_text,'  EXPECTED: ',params.text]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Request',testname);

        end % test_parse_singleParamByName %

        %% --------------------------------------------------------------------
        %   test_parse_noParamsByName
        %% --------------------------------------------------------------------
        function test_parse_noParams(this)

            testname = 'test_parse_noParams';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-4';
            method = 'whichMethod';
            
            requestMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"method": "',method,'",', ...
                '"id": "',id,'"', ...
            '}'];

            %-------------------------
            % run method being tested
            %-------------------------
            newRequest = jsonrpc2.JSONRPC2Request.parse(requestMsg);

            %-------------------------
            % test
            %-------------------------
            test_id = newRequest.id();
            assertTrue(strcmp(test_id,id),['TEST FAIL: ',testname,' -- bad message ID in request -- ACTUAL: ',test_id,'  EXPECTED: ',id]);

            test_method = newRequest.method();
            assertTrue(strcmp(test_method,method),['TEST FAIL: ',testname,' -- bad method in request -- ACTUAL: ',test_method,'  EXPECTED: ',method]);

            assertFalse(newRequest.hasParameters(),['TEST FAIL: ',testname,' -- request thinks it has parameters.']);
            assertFalse(newRequest.hasPositionalParameters(),['TEST FAIL: ',testname,' -- request thinks it has positional parameters.']);
            assertFalse(newRequest.hasNamedParameters(),['TEST FAIL: ',testname,' -- request thinks it has named parameters.']);

            test_params = newRequest.params;
            assertTrue(strcmp(class(test_params),'jsonrpc2.ParamsRetriever'),['TEST FAIL: ',testname,' -- params in request is not empty -- ACTUAL: ',class(test_params),'  EXPECTED: ParamsRetriever']);
 
            caughtExpectedException = false;
            try
                test_params.getParams();
            catch Exception
                caughtExpectedException = true;
            end
            
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- getting non-existent parameters did not throw exception']);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Request',testname);

        end % test_parse_noParamsByName %

        %% --------------------------------------------------------------------
        %   test_parse_multiParamsByOrder
        %% --------------------------------------------------------------------
        function test_parse_multiParamsByOrder(this)

            testname = 'test_parse_multiParamsByOrder';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-5';
            method = 'concat';
            params = struct;
            params.s1 = 'Hello';
            params.s2 = 'World';
            params.sep = ' ';
            
            requestMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"method": "',method,'",', ...
                '"params": [ "',params.s1,'", "',params.s2,'", "',params.sep,'" ],', ...
                '"id": "',id,'"', ...
            '}'];

            %-------------------------
            % run method being tested
            %-------------------------
            newRequest = jsonrpc2.JSONRPC2Request.parse(requestMsg);

            %-------------------------
            % test
            %-------------------------
            test_id = newRequest.id;
            assertTrue(strcmp(test_id,id),['TEST FAIL: ',testname,' -- bad message ID in request -- ACTUAL: ',test_id,'  EXPECTED: ',id]);

            test_method = newRequest.method;
            assertTrue(strcmp(test_method,method),['TEST FAIL: ',testname,' -- bad method in request -- ACTUAL: ',test_method,'  EXPECTED: ',method]);

            assertTrue(newRequest.hasParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have parameters.']);
            assertFalse(newRequest.hasNamedParameters(),['TEST FAIL: ',testname,' -- request thinks it has named parameters.']);
            assertTrue(newRequest.hasPositionalParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have positional parameters.']);

            test_params = newRequest.params;
            assertTrue(strcmp(class(test_params),'jsonrpc2.PositionalParamsRetriever'),['TEST FAIL: ',testname,' -- params in request are not ordered parameters -- ACTUAL: ',class(test_params),'  EXPECTED: PositionalParamsRetriever']);
            
            test_numParams = test_params.size();
            assertTrue(test_numParams==3,['TEST FAIL: ',testname,' -- params in request has wrong number of parameters -- ACTUAL: ',test_numParams,'  EXPECTED: 3']);
            
            test_s1 = test_params.get(1);
            assertTrue(strcmp(test_s1,params.s1),['TEST FAIL: ',testname,' -- bad s1 value in request -- ACTUAL: ',test_s1,'  EXPECTED: ',params.s1]);

            test_s2 = test_params.get(2);
            assertTrue(strcmp(test_s2,params.s2),['TEST FAIL: ',testname,' -- bad s2 value in request -- ACTUAL: ',test_s2,'  EXPECTED: ',params.s2]);

            test_sep = test_params.get(3);
            assertTrue(strcmp(test_sep,params.sep),['TEST FAIL: ',testname,' -- bad parm1 value in request -- ACTUAL: ',test_sep,'  EXPECTED: ',params.sep]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Request',testname);

        end % test_parse_multiParamsByOrder %

        %% --------------------------------------------------------------------
        %   test_parse_singleParamByOrder
        %% --------------------------------------------------------------------
        function test_parse_singleParamByOrder(this)

            testname = 'test_parse_singleParamByOrder';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-6';
            method = 'echo';
            params = struct;
            params.text = 'Goodbye World';
            
            requestMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"method": "',method,'",', ...
                '"params": [ "',params.text,'" ],', ...
                '"id": "',id,'"', ...
            '}'];

            %-------------------------
            % run method being tested
            %-------------------------
            newRequest = jsonrpc2.JSONRPC2Request.parse(requestMsg);

            %-------------------------
            % test
            %-------------------------
            test_id = newRequest.id;
            assertTrue(strcmp(test_id,id),['TEST FAIL: ',testname,' -- bad message ID in request -- ACTUAL: ',test_id,'  EXPECTED: ',id]);

            test_method = newRequest.method;
            assertTrue(strcmp(test_method,method),['TEST FAIL: ',testname,' -- bad method in request -- ACTUAL: ',test_method,'  EXPECTED: ',method]);

            assertTrue(newRequest.hasParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have parameters.']);
            assertFalse(newRequest.hasNamedParameters(),['TEST FAIL: ',testname,' -- request thinks it has named parameters.']);
            assertTrue(newRequest.hasPositionalParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have positional parameters.']);

            test_params = newRequest.params;
            assertTrue(strcmp(class(test_params),'jsonrpc2.PositionalParamsRetriever'),['TEST FAIL: ',testname,' -- params in request are not ordered parameters -- ACTUAL: ',class(test_params),'  EXPECTED: PositionalParamsRetriever']);
            
            test_numParams = test_params.size();
            assertTrue(test_numParams==1,['TEST FAIL: ',testname,' -- params in request has wrong number of parameters -- ACTUAL: ',test_numParams,'  EXPECTED: 1']);
            
            test_text = test_params.get(1);
            assertTrue(strcmp(test_text,params.text),['TEST FAIL: ',testname,' -- bad text value in request -- ACTUAL: ',test_text,'  EXPECTED: ',params.text]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Request',testname);

        end % test_parse_singleParamByOrder %

        %% --------------------------------------------------------------------
        %   test_parse_numarrayParamsByOrder
        %% --------------------------------------------------------------------
        function test_parse_numarrayParamsByOrder(this)

            testname = 'test_parse_numarrayParamsByOrder';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-5';
            method = 'concat';
            params = struct;
            params.n1 = 1;
            params.n2 = 2;
            params.n3 = 3;
            
            requestMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"method": "',method,'",', ...
                '"params": [ ',int2str(params.n1),', ',int2str(params.n2),', ',int2str(params.n3),' ],', ...
                '"id": "',id,'"', ...
            '}'];

            %-------------------------
            % run method being tested
            %-------------------------
            newRequest = jsonrpc2.JSONRPC2Request.parse(requestMsg);

            %-------------------------
            % test
            %-------------------------
            test_id = newRequest.id;
            assertTrue(strcmp(test_id,id),['TEST FAIL: ',testname,' -- bad message ID in request -- ACTUAL: ',test_id,'  EXPECTED: ',id]);

            test_method = newRequest.method;
            assertTrue(strcmp(test_method,method),['TEST FAIL: ',testname,' -- bad method in request -- ACTUAL: ',test_method,'  EXPECTED: ',method]);

            assertTrue(newRequest.hasParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have parameters.']);
            assertFalse(newRequest.hasNamedParameters(),['TEST FAIL: ',testname,' -- request thinks it has named parameters.']);
            assertTrue(newRequest.hasPositionalParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have positional parameters.']);

            test_params = newRequest.params;
            assertTrue(strcmp(class(test_params),'jsonrpc2.PositionalParamsRetriever'),['TEST FAIL: ',testname,' -- params in request are not ordered parameters -- ACTUAL: ',class(test_params),'  EXPECTED: PositionalParamsRetriever']);
            
            test_numParams = test_params.size();
            assertTrue(test_numParams==3,['TEST FAIL: ',testname,' -- params in request has wrong number of parameters -- ACTUAL: ',test_numParams,'  EXPECTED: 3']);
            
            test_n1 = test_params.get(1);
            assertTrue(test_n1==params.n1,['TEST FAIL: ',testname,' -- bad n1 value in request -- ACTUAL: ',int2str(test_n1),'  EXPECTED: ',int2str(params.n1)]);

            test_n2 = test_params.get(2);
            assertTrue(test_n2==params.n2,['TEST FAIL: ',testname,' -- bad n2 value in request -- ACTUAL: ',int2str(test_n2),'  EXPECTED: ',int2str(params.n2)]);

            test_n3 = test_params.get(3);
            assertTrue(test_n3==params.n3,['TEST FAIL: ',testname,' -- bad n3 value in request -- ACTUAL: ',int2str(test_n3),'  EXPECTED: ',int2str(params.n3)]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Request',testname);

        end % test_parse_numarrayParamsByOrder %

        %% --------------------------------------------------------------------
        %   test_parse_charParamByOrder
        %% --------------------------------------------------------------------
        function test_parse_charParamByOrder(this)

            testname = 'test_parse_charParamByOrder';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-6';
            method = 'echo';
            params = struct;
            params.text = 'Goodbye World';
            
            requestMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"method": "',method,'",', ...
                '"params": "',params.text,'",', ...
                '"id": "',id,'"', ...
            '}'];

            %-------------------------
            % run method being tested
            %-------------------------
            newRequest = jsonrpc2.JSONRPC2Request.parse(requestMsg);

            %-------------------------
            % test
            %-------------------------
            test_id = newRequest.id;
            assertTrue(strcmp(test_id,id),['TEST FAIL: ',testname,' -- bad message ID in request -- ACTUAL: ',test_id,'  EXPECTED: ',id]);

            test_method = newRequest.method;
            assertTrue(strcmp(test_method,method),['TEST FAIL: ',testname,' -- bad method in request -- ACTUAL: ',test_method,'  EXPECTED: ',method]);

            assertTrue(newRequest.hasParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have parameters.']);
            assertFalse(newRequest.hasNamedParameters(),['TEST FAIL: ',testname,' -- request thinks it has named parameters.']);
            assertTrue(newRequest.hasPositionalParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have positional parameters.']);

            test_params = newRequest.params;
            assertTrue(strcmp(class(test_params),'jsonrpc2.PositionalParamsRetriever'),['TEST FAIL: ',testname,' -- params in request are not ordered parameters -- ACTUAL: ',class(test_params),'  EXPECTED: PositionalParamsRetriever']);
            
            test_numParams = test_params.size();
            assertTrue(test_numParams==1,['TEST FAIL: ',testname,' -- params in request has wrong number of parameters -- ACTUAL: ',test_numParams,'  EXPECTED: 1']);
            
            test_text = test_params.get(1);
            assertTrue(strcmp(test_text,params.text),['TEST FAIL: ',testname,' -- bad text value in request -- ACTUAL: ',test_text,'  EXPECTED: ',params.text]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Request',testname);

        end % test_parse_charParamByOrder %

        %% --------------------------------------------------------------------
        %   test_parse_request_badJson_missingId
        %% --------------------------------------------------------------------
        function test_parse_request_badJson_missingId(this)

            testname = 'test_parse_request_badJson_missingId';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-6';
            method = 'concat';
            params = struct;
            params.s1 = 'Hello';
            params.s2 = 'World';
            params.sep = ' ';
            
            requestMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"method": "',method,'"', ...
                '"params": { "s1": "',params.s1,'", "s2": "',params.s2,'", "sep": "',params.sep,'" },', ...
            '}'];

            %-------------------------
            % run method being tested
            %-------------------------
            caughtExpectedException = false;
            try
                newNotification = jsonrpc2.JSONRPC2Notification.parse(requestMsg);
            catch Exception
                caughtExpectedException = true;
            end
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- constructing a request without an id did not throw exception']);
            
            jsonrpc2Tests.log_passingTest('TestJSONRPC2Error',testname);

        end % test_parse_request_badJson_missingId %
        
        %% --------------------------------------------------------------------
        %   test_parse_request_badJson_missingMethod
        %% --------------------------------------------------------------------
        function test_parse_request_badJson_missingMethod(this)

            testname = 'test_parse_request_badJson_missingMethod';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-6';
            method = 'concat';
            params = struct;
            params.s1 = 'Hello';
            params.s2 = 'World';
            params.sep = ' ';
            
            requestMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"params": { "s1": "',params.s1,'", "s2": "',params.s2,'", "sep": "',params.sep,'" },', ...
                '"id": "',id,'"', ...
            '}'];

            %-------------------------
            % run method being tested
            %-------------------------
            caughtExpectedException = false;
            try
                newNotification = jsonrpc2.JSONRPC2Notification.parse(requestMsg);
            catch Exception
                caughtExpectedException = true;
            end
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- constructing a request without a method did not throw exception']);
            
            jsonrpc2Tests.log_passingTest('TestJSONRPC2Error',testname);

        end % test_parse_request_badJson_missingMethod %
        
        %% --------------------------------------------------------------------
        %   test_parse_request_badJson_extraStuff
        %% --------------------------------------------------------------------
        function test_parse_request_badJson_extraStuff(this)

            testname = 'test_parse_request_badJson_extraStuff';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-6';
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
                '"blah": "blah",', ...
            '}'];

            %-------------------------
            % run method being tested
            %-------------------------
            caughtExpectedException = false;
            try
                newNotification = jsonrpc2.JSONRPC2Notification.parse(requestMsg);
            catch Exception
                caughtExpectedException = true;
            end
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- constructing a request with extra stuff did not throw exception']);
            
            jsonrpc2Tests.log_passingTest('TestJSONRPC2Error',testname);

        end % test_parse_request_badJson_extraStuff %
        

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
            id     = 'req-7';
            method = 'foo';

            params = struct;
            params.parm1 = 'hello';
            params.parm2 = 'world';
            
            newRequest = jsonrpc2.JSONRPC2Request(id,method,params);
            
            %-------------------------
            % run method being tested
            %-------------------------
            test_id = newRequest.id;
            assertTrue(strcmp(test_id,id),['TEST FAIL: ',testname,' -- bad message ID in request -- ACTUAL: ',test_id,'  EXPECTED: ',id]);

            %-------------------------
            % modify and re-run
            %-------------------------
            set_id = 'req-7-mod';
            newRequest.id = set_id;
            test_id = newRequest.id;
            assertTrue(strcmp(test_id,set_id),['TEST FAIL: ',testname,' -- bad updated message ID in request -- ACTUAL: ',test_id,'  EXPECTED: ',set_id]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Request',testname);

        end % test_getterSetter_ID %

        %% --------------------------------------------------------------------
        %   test_getterSetter_Method
        %% --------------------------------------------------------------------
        function test_getterSetter_Method(this)

            testname = 'test_getterSetter_Method';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-8';
            method = 'foo';

            params = struct;
            params.parm1 = 'hello';
            params.parm2 = 'world';
            
            newRequest = jsonrpc2.JSONRPC2Request(id,method,params);
            
            %-------------------------
            % run method being tested
            %-------------------------
            test_method = newRequest.method;
            assertTrue(strcmp(test_method,method),['TEST FAIL: ',testname,' -- bad message Method in request -- ACTUAL: ',test_method,'  EXPECTED: ',method]);

            %-------------------------
            % modify and re-run
            %-------------------------
            set_method = 'foo-mod';
            newRequest.method = set_method;
            test_method = newRequest.method;
            assertTrue(strcmp(test_method,set_method),['TEST FAIL: ',testname,' -- bad updated message Method in request -- ACTUAL: ',test_method,'  EXPECTED: ',set_method]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Request',testname);

        end % test_getterSetter_Method %


        %% --------------------------------------------------------------------
        %   test_getterSetter_Params_bothNamed
        %% --------------------------------------------------------------------
        function test_getterSetter_Params_bothNamed(this)

            testname = 'test_getterSetter_Params_bothNamed';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-9';
            method = 'foo';

            params = struct;
            params.s1  = 'Hello';
            params.s2  = 'World';
            params.sep = ' ';
            
            newRequest = jsonrpc2.JSONRPC2Request(id,method,params);
            
            %-------------------------
            % run method being tested
            %-------------------------
            test_params = newRequest.params;

            assertTrue(newRequest.hasParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have parameters.']);
            assertFalse(newRequest.hasPositionalParameters(),['TEST FAIL: ',testname,' -- request thinks it has positional parameters.']);
            assertTrue(newRequest.hasNamedParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have named parameters.']);

            assertTrue(strcmp(class(test_params),'jsonrpc2.NamedParamsRetriever'),['TEST FAIL: ',testname,' -- params in request are not named parameters -- ACTUAL: ',class(test_params),'  EXPECTED: NamedParamsRetriever']);
            assertTrue(test_params.hasParam('s1'),['TEST FAIL: ',testname,' -- field s1 does not exist in params in request']);
            assertTrue(test_params.hasParam('s2'),['TEST FAIL: ',testname,' -- field s2 does not exist in params in request']);
            assertTrue(test_params.hasParam('sep'),['TEST FAIL: ',testname,' -- field sep does not exist in params in request']);
            
            test_s1 = test_params.get('s1');
            assertTrue(strcmp(test_s1,params.s1),['TEST FAIL: ',testname,' -- bad s1 value in request -- ACTUAL: ',test_s1,'  EXPECTED: ',params.s1]);

            test_s2 = test_params.get('s2');
            assertTrue(strcmp(test_s2,params.s2),['TEST FAIL: ',testname,' -- bad s2 value in request -- ACTUAL: ',test_s2,'  EXPECTED: ',params.s2]);

            test_sep = test_params.get('sep');
            assertTrue(strcmp(test_sep,params.sep),['TEST FAIL: ',testname,' -- bad parm1 value in request -- ACTUAL: ',test_sep,'  EXPECTED: ',params.sep]);

            %-------------------------
            % modify and re-run
            %-------------------------
            mod_params = struct;
            mod_params.text = 'Goodbye World';
            newRequest.params = mod_params;
            
            assertTrue(newRequest.hasParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have parameters.']);
            assertFalse(newRequest.hasPositionalParameters(),['TEST FAIL: ',testname,' -- request thinks it has positional parameters.']);
            assertTrue(newRequest.hasNamedParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have named parameters.']);

            test_mod_params = newRequest.params;
            assertTrue(strcmp(class(test_mod_params),'jsonrpc2.NamedParamsRetriever'),['TEST FAIL: ',testname,' -- params in request are not named parameters -- ACTUAL: ',class(test_params),'  EXPECTED: NamedParamsRetriever']);
            assertTrue(test_mod_params.hasParam('text'),['TEST FAIL: ',testname,' -- field text does not exist in params in request']);
            
            test_mod_text = test_mod_params.get('text');
            assertTrue(strcmp(test_mod_text,mod_params.text),['TEST FAIL: ',testname,' -- bad s1 value in request -- ACTUAL: ',test_mod_text,'  EXPECTED: ',mod_params.text]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Request',testname);

        end % test_getterSetter_Params_bothNamed %

        %% --------------------------------------------------------------------
        %   test_getterSetter_Params_bothOrdered
        %% --------------------------------------------------------------------
        function test_getterSetter_Params_bothOrdered(this)

            testname = 'test_getterSetter_Params_bothOrdered';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-9';
            method = 'foo';

            params = cell(1,3);
            params{1}  = 'Hello';
            params{2}  = 'World';
            params{3} = ' ';
            
            newRequest = jsonrpc2.JSONRPC2Request(id,method,params);
            
            %-------------------------
            % run method being tested
            %-------------------------
            test_params = newRequest.params;

            assertTrue(newRequest.hasParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have parameters.']);
            assertFalse(newRequest.hasNamedParameters(),['TEST FAIL: ',testname,' -- request thinks it has named parameters.']);
            assertTrue(newRequest.hasPositionalParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have positional parameters.']);

            assertTrue(strcmp(class(test_params),'jsonrpc2.PositionalParamsRetriever'),['TEST FAIL: ',testname,' -- params in request are not ordered parameters -- ACTUAL: ',class(test_params),'  EXPECTED: PositionalParamsRetriever']);
            
            test_numParams = test_params.size();
            assertTrue(test_numParams==3,['TEST FAIL: ',testname,' -- params in request has wrong number of parameters -- ACTUAL: ',test_numParams,'  EXPECTED: 3']);

            test_s1 = test_params.get(1);
            assertTrue(strcmp(test_s1,params{1}),['TEST FAIL: ',testname,' -- bad s1 value in request -- ACTUAL: ',test_s1,'  EXPECTED: ',params{1}]);

            test_s2 = test_params.get(2);
            assertTrue(strcmp(test_s2,params{2}),['TEST FAIL: ',testname,' -- bad s2 value in request -- ACTUAL: ',test_s2,'  EXPECTED: ',params{2}]);

            test_sep = test_params.get(3);
            assertTrue(strcmp(test_sep,params{3}),['TEST FAIL: ',testname,' -- bad parm1 value in request -- ACTUAL: ',test_sep,'  EXPECTED: ',params{3}]);

            %-------------------------
            % modify and re-run
            %-------------------------
            mod_params = cell(1,1);
            mod_params{1} = 'Goodbye World';
            newRequest.params = mod_params;
            
            assertTrue(newRequest.hasParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have parameters.']);
            assertFalse(newRequest.hasNamedParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have named parameters.']);
            assertTrue(newRequest.hasPositionalParameters(),['TEST FAIL: ',testname,' -- request thinks it has positional parameters.']);

            test_mod_params = newRequest.params;

            assertTrue(strcmp(class(test_mod_params),'jsonrpc2.PositionalParamsRetriever'),['TEST FAIL: ',testname,' -- params in request are not positional parameters -- ACTUAL: ',class(test_mod_params),'  EXPECTED: PositionalParamsRetriever']);
            
            test_numParams = test_mod_params.size();
            assertTrue(test_numParams==1,['TEST FAIL: ',testname,' -- params in request has wrong number of parameters -- ACTUAL: ',test_numParams,'  EXPECTED: 1']);

            test_mod_text = test_mod_params.get(1);
            assertTrue(strcmp(test_mod_text,mod_params{1}),['TEST FAIL: ',testname,' -- bad s1 value in request -- ACTUAL: ',test_mod_text,'  EXPECTED: ',mod_params{1}]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Request',testname);

        end % test_getterSetter_Params_bothOrdered %
        
        %% --------------------------------------------------------------------
        %   test_getterSetter_Params_bothNamed
        %% --------------------------------------------------------------------
        function test_getterSetter_Params_NamedThenOrdered(this)

            testname = 'test_getterSetter_Params_bothNamed';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-9';
            method = 'foo';

            params = struct;
            params.s1  = 'Hello';
            params.s2  = 'World';
            params.sep = ' ';
            
            newRequest = jsonrpc2.JSONRPC2Request(id,method,params);
            
            %-------------------------
            % run method being tested
            %-------------------------
            test_params = newRequest.params;

            assertTrue(newRequest.hasParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have parameters.']);
            assertFalse(newRequest.hasPositionalParameters(),['TEST FAIL: ',testname,' -- request thinks it has positional parameters.']);
            assertTrue(newRequest.hasNamedParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have named parameters.']);

            assertTrue(strcmp(class(test_params),'jsonrpc2.NamedParamsRetriever'),['TEST FAIL: ',testname,' -- params in request are not named parameters -- ACTUAL: ',class(test_params),'  EXPECTED: NamedParamsRetriever']);
            assertTrue(test_params.hasParam('s1'),['TEST FAIL: ',testname,' -- field s1 does not exist in params in request']);
            assertTrue(test_params.hasParam('s2'),['TEST FAIL: ',testname,' -- field s2 does not exist in params in request']);
            assertTrue(test_params.hasParam('sep'),['TEST FAIL: ',testname,' -- field sep does not exist in params in request']);
            
            test_s1 = test_params.get('s1');
            assertTrue(strcmp(test_s1,params.s1),['TEST FAIL: ',testname,' -- bad s1 value in request -- ACTUAL: ',test_s1,'  EXPECTED: ',params.s1]);

            test_s2 = test_params.get('s2');
            assertTrue(strcmp(test_s2,params.s2),['TEST FAIL: ',testname,' -- bad s2 value in request -- ACTUAL: ',test_s2,'  EXPECTED: ',params.s2]);

            test_sep = test_params.get('sep');
            assertTrue(strcmp(test_sep,params.sep),['TEST FAIL: ',testname,' -- bad parm1 value in request -- ACTUAL: ',test_sep,'  EXPECTED: ',params.sep]);

            %-------------------------
            % modify and re-run
            %-------------------------
            mod_params = cell(1,1);
            mod_params{1} = 'Goodbye World';
            newRequest.params = mod_params;
            
            assertTrue(newRequest.hasParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have parameters.']);
            assertFalse(newRequest.hasNamedParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have named parameters.']);
            assertTrue(newRequest.hasPositionalParameters(),['TEST FAIL: ',testname,' -- request thinks it has positional parameters.']);

            test_mod_params = newRequest.params;

            assertTrue(strcmp(class(test_mod_params),'jsonrpc2.PositionalParamsRetriever'),['TEST FAIL: ',testname,' -- params in request are not positional parameters -- ACTUAL: ',class(test_mod_params),'  EXPECTED: PositionalParamsRetriever']);
            
            test_numParams = test_mod_params.size();
            assertTrue(test_numParams==1,['TEST FAIL: ',testname,' -- params in request has wrong number of parameters -- ACTUAL: ',test_numParams,'  EXPECTED: 1']);

            test_mod_text = test_mod_params.get(1);
            assertTrue(strcmp(test_mod_text,mod_params{1}),['TEST FAIL: ',testname,' -- bad s1 value in request -- ACTUAL: ',test_mod_text,'  EXPECTED: ',mod_params{1}]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Request',testname);

        end % test_getterSetter_Params_bothNamed %

        %% --------------------------------------------------------------------
        %   test_getterSetter_Params_bothOrdered
        %% --------------------------------------------------------------------
        function test_getterSetter_Params_OrderedThenNamed(this)

            testname = 'test_getterSetter_Params_bothOrdered';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-9';
            method = 'foo';

            params = cell(1,3);
            params{1}  = 'Hello';
            params{2}  = 'World';
            params{3} = ' ';
            
            newRequest = jsonrpc2.JSONRPC2Request(id,method,params);
            
            %-------------------------
            % run method being tested
            %-------------------------
            test_params = newRequest.params;

            assertTrue(newRequest.hasParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have parameters.']);
            assertFalse(newRequest.hasNamedParameters(),['TEST FAIL: ',testname,' -- request thinks it has named parameters.']);
            assertTrue(newRequest.hasPositionalParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have positional parameters.']);

            assertTrue(strcmp(class(test_params),'jsonrpc2.PositionalParamsRetriever'),['TEST FAIL: ',testname,' -- params in request are not ordered parameters -- ACTUAL: ',class(test_params),'  EXPECTED: PositionalParamsRetriever']);
            
            test_numParams = test_params.size();
            assertTrue(test_numParams==3,['TEST FAIL: ',testname,' -- params in request has wrong number of parameters -- ACTUAL: ',test_numParams,'  EXPECTED: 3']);

            test_s1 = test_params.get(1);
            assertTrue(strcmp(test_s1,params{1}),['TEST FAIL: ',testname,' -- bad s1 value in request -- ACTUAL: ',test_s1,'  EXPECTED: ',params{1}]);

            test_s2 = test_params.get(2);
            assertTrue(strcmp(test_s2,params{2}),['TEST FAIL: ',testname,' -- bad s2 value in request -- ACTUAL: ',test_s2,'  EXPECTED: ',params{2}]);

            test_sep = test_params.get(3);
            assertTrue(strcmp(test_sep,params{3}),['TEST FAIL: ',testname,' -- bad parm1 value in request -- ACTUAL: ',test_sep,'  EXPECTED: ',params{3}]);

            %-------------------------
            % modify and re-run
            %-------------------------
            mod_params = struct;
            mod_params.text = 'Goodbye World';
            newRequest.params = mod_params;
            
            assertTrue(newRequest.hasParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have parameters.']);
            assertFalse(newRequest.hasPositionalParameters(),['TEST FAIL: ',testname,' -- request thinks it has positional parameters.']);
            assertTrue(newRequest.hasNamedParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have named parameters.']);

            test_mod_params = newRequest.params;
            assertTrue(strcmp(class(test_mod_params),'jsonrpc2.NamedParamsRetriever'),['TEST FAIL: ',testname,' -- params in request are not named parameters -- ACTUAL: ',class(test_params),'  EXPECTED: NamedParamsRetriever']);
            assertTrue(test_mod_params.hasParam('text'),['TEST FAIL: ',testname,' -- field text does not exist in params in request']);
            
            test_mod_text = test_mod_params.get('text');
            assertTrue(strcmp(test_mod_text,mod_params.text),['TEST FAIL: ',testname,' -- bad s1 value in request -- ACTUAL: ',test_mod_text,'  EXPECTED: ',mod_params.text]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Request',testname);

        end % test_getterSetter_Params_bothOrdered %
         
% =============================================================================
%                             Test Instance Methods
% =============================================================================
    
        %% --------------------------------------------------------------------
        %   test_isNotification_when_isrequest
        %% --------------------------------------------------------------------
        function test_isNotification_when_isrequest(this)

            testname = 'test_isNotification_when_isrequest';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-7';
            method = 'foo';

            params = struct;
            params.parm1 = 'hello';
            params.parm2 = 'world';
            
            newRequest = jsonrpc2.JSONRPC2Request(id,method,params);
            
            %-------------------------
            % run method being tested
            %-------------------------
            isnotification = newRequest.isNotification();
            assertFalse(isnotification,['TEST FAIL: ',testname,' -- isNotification() thinks a request is a notification.']);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Request',testname);

        end % test_isNotification_when_isrequest %

        %% --------------------------------------------------------------------
        %   test_isNotification_when_isnotification
        %% --------------------------------------------------------------------
        function test_isNotification_when_isnotification(this)

            testname = 'test_isNotification_when_isnotification';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-7';
            method = 'foo';

            params = struct;
            params.parm1 = 'hello';
            params.parm2 = 'world';
            
            newNotification = jsonrpc2.JSONRPC2Notification(method,params);
            
            %-------------------------
            % run method being tested
            %-------------------------
            isnotification = newNotification.isNotification();
            assertTrue(isnotification,['TEST FAIL: ',testname,' -- isNotification() does not think a notification is a notification.']);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Request',testname);

        end % test_isNotification_when_isnotification %

        %% --------------------------------------------------------------------
        %   test_toJSONString
        %% --------------------------------------------------------------------
        function test_toJSONString(this)

            testname = 'test_toJSONString';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-10';
            method = 'concat';
            params = struct;
            params.s1 = 'Hello';
            params.s2 = 'World';
            params.sep = ' ';
            
            requestMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"id": "',id,'",', ...
                '"method": "',method,'",', ...
                '"params": { "s1": "',params.s1,'", "s2": "',params.s2,'", "sep": "',params.sep,'" }', ...
            '}'];

            newRequest = jsonrpc2.JSONRPC2Request.parse(requestMsg);
            
            %-------------------------
            % run method being tested
            %-------------------------
            test_requestMsg = newRequest.toJSONString();
            match = jsonrpc2Tests.strcmpiw(requestMsg,test_requestMsg);
            assertTrue(match,['TEST FAIL: ',testname,' -- original and generated JSON do not match -- GENERATED: ',test_requestMsg,'  ORIGINAL: ',requestMsg]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Request',testname);

        end % test_toJSONString %

% =============================================================================
%                             Test Helper Methods
% =============================================================================
        
        %% --------------------------------------------------------------------
        %   test_getParams_with_named_params
        %% --------------------------------------------------------------------
        function test_getParams_with_named_params(this)

            testname = 'test_getParams_with_named_params';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-11';
            method = 'concat';
            params = struct;
            params.s1 = 'Hello';
            params.s2 = 'World';
            params.sep = ' ';
            
            requestMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"id": "',id,'",', ...
                '"method": "',method,'",', ...
                '"params": { "s1": "',params.s1,'", "s2": "',params.s2,'", "sep": "',params.sep,'" }', ...
            '}'];

            newRequest = jsonrpc2.JSONRPC2Request.parse(requestMsg);
            
            %-------------------------
            % run method being tested
            %-------------------------
            newParams = newRequest.getParams();

            assertTrue(isstruct(newParams),['TEST FAIL: ',testname,' -- params is wrong type -- ACTUAL: ',class(newParams),'  EXPECTED: struct']);
            assertTrue(isfield(newParams,'s1'),['TEST FAIL: ',testname,' -- params is missing parameter s1']);
            assertTrue(isfield(newParams,'s2'),['TEST FAIL: ',testname,' -- params is missing parameter s2']);
            assertTrue(isfield(newParams,'sep'),['TEST FAIL: ',testname,' -- params is missing parameter sep']);

            assertTrue(strcmp(newParams.s1,params.s1),['TEST FAIL: ',testname,' -- param has is wrong value -- ACTUAL: ',newParams.s1,'  EXPECTED: ',params.s1]);
            assertTrue(strcmp(newParams.s2,params.s2),['TEST FAIL: ',testname,' -- param has is wrong value -- ACTUAL: ',newParams.s2,'  EXPECTED: ',params.s2]);
            assertTrue(strcmp(newParams.sep,params.sep),['TEST FAIL: ',testname,' -- param has is wrong value -- ACTUAL: ',newParams.sep,'  EXPECTED: ',params.sep]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Request',testname);

        end % test_getParams_with_named_params %

        %% --------------------------------------------------------------------
        %   test_getParams_with_ordered_params
        %% --------------------------------------------------------------------
        function test_getParams_with_ordered_params(this)

            testname = 'test_getParams_with_ordered_params';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-11';
            method = 'concat';
            params = struct;
            params.s1 = 'Hello';
            params.s2 = 'World';
            params.sep = ' ';
            numParams = 3;
            
            requestMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"id": "',id,'",', ...
                '"method": "',method,'",', ...
                '"params": [ "',params.s1,'", "',params.s2,'", "',params.sep,'" ]', ...
            '}'];

            newRequest = jsonrpc2.JSONRPC2Request.parse(requestMsg);
            
            %-------------------------
            % run method being tested
            %-------------------------
            newParams = newRequest.getParams();

            assertTrue(iscell(newParams),['TEST FAIL: ',testname,' -- params is wrong type -- ACTUAL: ',class(newParams),'  EXPECTED: cell']);
            assertTrue(length(newParams)==numParams,['TEST FAIL: ',testname,' -- number of params is different -- ACTUAL: ',num2str(length(newParams)),'  EXPECTED: ',num2str(numParams)]);
            
            assertTrue(strcmp(newParams(1),params.s1),['TEST FAIL: ',testname,' -- param has is wrong value -- ACTUAL: ',newParams(1),'  EXPECTED: ',params.s1]);
            assertTrue(strcmp(newParams(2),params.s2),['TEST FAIL: ',testname,' -- param has is wrong value -- ACTUAL: ',newParams(2),'  EXPECTED: ',params.s2]);
            assertTrue(strcmp(newParams(3),params.sep),['TEST FAIL: ',testname,' -- param has is wrong value -- ACTUAL: ',newParams(3),'  EXPECTED: ',params.sep]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Request',testname);

        end % test_getParams_with_ordered_params %

        %% --------------------------------------------------------------------
        %   test_getParams_with_no_params
        %% --------------------------------------------------------------------
        function test_getParams_with_no_params(this)

            testname = 'test_getParams_with_no_params';

            %-------------------------
            % setup test
            %-------------------------
            id     = 'req-11';
            method = 'concat';
            params = struct;
            params.s1 = 'Hello';
            params.s2 = 'World';
            params.sep = ' ';
            
            requestMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"id": "',id,'",', ...
                '"method": "',method,'"', ...
            '}'];

            newRequest = jsonrpc2.JSONRPC2Request.parse(requestMsg);
            
            %-------------------------
            % run method being tested
            %-------------------------
            newParams = newRequest.getParams();

            assertTrue(isa(newParams,'double'),['TEST FAIL: ',testname,' -- params is wrong type -- ACTUAL: ',class(newParams),'  EXPECTED: double']);
            assertTrue(isempty(newParams),['TEST FAIL: ',testname,' -- value of params is not empty -- ACTUAL: ',newParams,'  EXPECTED: []']);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Request',testname);

        end % test_getParams_with_no_params %

    end % methods %

end % classdef %

        
