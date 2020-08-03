% Tests for JSONRPC2Notification class
%
% Copyright (c) 2014, Cornell University, Lab of Ornithology
% All rights reserved.
%
% Distributed under BSD license.  See LICENSE_BSD.txt for full license.
% 
% Author: E. L. Rayle
% date: 01/22/2014
%
% COMMAND TO RUN THESE TESTS:  runtests jsonrpc2Tests.TestJSONRPC2Notification
%

classdef TestJSONRPC2Notification < TestCase

% =============================================================================
%                             Setup & Teardown
% =============================================================================
    methods
        function this = TestJSONRPC2Notification(name)
            this = this@TestCase(name);
        end

        function setUp(this)
        end

        function tearDown(this)
        end

% =============================================================================
%                         Constructor Method Tests
% =============================================================================
        function test_JSONRPC2Notification_constructor_withParams(this)

            testname = 'test_JSONRPC2Notification_constructor_withParams';

            %-------------------------
            % setup test
            %-------------------------
            method = 'foo';

            params = struct;
            params.parm1 = 'hello';
            params.parm2 = 'world';
            
            %-------------------------
            % run method being tested
            %-------------------------
            newNotification = jsonrpc2.JSONRPC2Notification(method,params);
            
            %-------------------------
            % test
            %-------------------------
            assertTrue(strcmp(class(newNotification),'jsonrpc2.JSONRPC2Notification'),['TEST FAIL: ',testname,' -- wrong class created -- ACTUAL: ',class(newNotification),'  EXPECTED: jsonrpc2.JSONRPC2Notification']);

            test_method = newNotification.method;
            assertTrue(strcmp(test_method,method),['TEST FAIL: ',testname,' -- bad method in notification -- ACTUAL: ',test_method,'  EXPECTED: ',method]);

            assertTrue(newNotification.hasParameters(),['TEST FAIL: ',testname,' -- notification thinks it doesn''t have parameters.']);
            assertFalse(newNotification.hasPositionalParameters(),['TEST FAIL: ',testname,' -- notification thinks it has positional parameters.']);
            assertTrue(newNotification.hasNamedParameters(),['TEST FAIL: ',testname,' -- notification thinks it doesn''t have named parameters.']);

            test_params = newNotification.params;
            assertTrue(strcmp(class(test_params),'jsonrpc2.NamedParamsRetriever'),['TEST FAIL: ',testname,' -- params in notification are not named parameters -- ACTUAL: ',class(test_params),'  EXPECTED: NamedParamsRetriever']);
            assertTrue(test_params.hasParam('parm1'),['TEST FAIL: ',testname,' -- field parm1 does not exist in params in notification']);
            assertTrue(test_params.hasParam('parm2'),['TEST FAIL: ',testname,' -- field parm2 does not exist in params in notification']);
            
            test_parm1 = test_params.get('parm1');
            assertTrue(strcmp(test_parm1,params.parm1),['TEST FAIL: ',testname,' -- bad parm1 value in notification -- ACTUAL: ',test_parm1,'  EXPECTED: ',params.parm1]);

            test_parm2 = test_params.get('parm2');
            assertTrue(strcmp(test_parm2,params.parm2),['TEST FAIL: ',testname,' -- bad parm1 value in notification -- ACTUAL: ',test_parm2,'  EXPECTED: ',params.parm2]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Notification',testname);

        end % test_JSONRPC2Notification_constructor_withParams %
   
        function test_JSONRPC2Notification_constructor_withoutParams(this)

            testname = 'test_JSONRPC2Notification_constructor_withoutParams';

            %-------------------------
            % setup test
            %-------------------------
            method = 'foo';

            %-------------------------
            % run method being tested
            %-------------------------
            newNotification = jsonrpc2.JSONRPC2Notification(method);
            
            %-------------------------
            % test
            %-------------------------
            assertTrue(strcmp(class(newNotification),'jsonrpc2.JSONRPC2Notification'),['TEST FAIL: ',testname,' -- wrong class created -- ACTUAL: ',class(newNotification),'  EXPECTED: jsonrpc2.JSONRPC2Notification']);

            test_method = newNotification.method;
            assertTrue(strcmp(test_method,method),['TEST FAIL: ',testname,' -- bad method in notification -- ACTUAL: ',test_method,'  EXPECTED: ',method]);

            assertFalse(newNotification.hasParameters(),['TEST FAIL: ',testname,' -- notification thinks it has parameters.']);
            assertFalse(newNotification.hasPositionalParameters(),['TEST FAIL: ',testname,' -- notification thinks it has positional parameters.']);
            assertFalse(newNotification.hasNamedParameters(),['TEST FAIL: ',testname,' -- notification thinks it has named parameters.']);

            test_params = newNotification.params;
            assertTrue(strcmp(class(test_params),'jsonrpc2.ParamsRetriever'),['TEST FAIL: ',testname,' -- wrong params class created -- ACTUAL: ',class(test_params),'  EXPECTED: jsonrpc2.ParamsRetriever']);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Notification',testname);

        end % test_JSONRPC2Notification_constructor_withoutParams %
   

% =============================================================================
%                             Parse Method Tests
% =============================================================================

        %% --------------------------------------------------------------------
        %   test_parse_notification
        %% --------------------------------------------------------------------
        function test_parse_notification(this)

            testname = 'test_parse_notification';

            %-------------------------
            % setup test
            %-------------------------
            method = 'concat';
            params = struct;
            params.s1 = 'Hello';
            params.s2 = 'World';
            params.sep = ' ';
            
            notificationMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"method": "',method,'",', ...
                '"params": { "s1": "',params.s1,'", "s2": "',params.s2,'", "sep": "',params.sep,'" }' ...
            '}'];

            %-------------------------
            % run method being tested
            %-------------------------
            newNotification = jsonrpc2.JSONRPC2Notification.parse(notificationMsg);

            %-------------------------
            % test
            %-------------------------
            assertTrue(strcmp(class(newNotification),'jsonrpc2.JSONRPC2Notification'),['TEST FAIL: ',testname,' -- wrong class created -- ACTUAL: ',class(newNotification),'  EXPECTED: jsonrpc2.JSONRPC2Notification']);

            test_method = newNotification.method;
            assertTrue(strcmp(test_method,method),['TEST FAIL: ',testname,' -- bad method in notification -- ACTUAL: ',test_method,'  EXPECTED: ',method]);

            assertTrue(newNotification.hasParameters(),['TEST FAIL: ',testname,' -- notification thinks it doesn''t have parameters.']);
            assertFalse(newNotification.hasPositionalParameters(),['TEST FAIL: ',testname,' -- notification thinks it has positional parameters.']);
            assertTrue(newNotification.hasNamedParameters(),['TEST FAIL: ',testname,' -- notification thinks it doesn''t have named parameters.']);

            test_params = newNotification.params;
            assertTrue(strcmp(class(test_params),'jsonrpc2.NamedParamsRetriever'),['TEST FAIL: ',testname,' -- params in notification are not named parameters -- ACTUAL: ',class(test_params),'  EXPECTED: NamedParamsRetriever']);
            assertTrue(test_params.hasParam('s1'),['TEST FAIL: ',testname,' -- field s1 does not exist in params in notification']);
            assertTrue(test_params.hasParam('s2'),['TEST FAIL: ',testname,' -- field s2 does not exist in params in notification']);
            assertTrue(test_params.hasParam('sep'),['TEST FAIL: ',testname,' -- field sep does not exist in params in notification']);
            
            test_s1 = test_params.get('s1');
            assertTrue(strcmp(test_s1,params.s1),['TEST FAIL: ',testname,' -- bad s1 value in notification -- ACTUAL: ',test_s1,'  EXPECTED: ',params.s1]);

            test_s2 = test_params.get('s2');
            assertTrue(strcmp(test_s2,params.s2),['TEST FAIL: ',testname,' -- bad s2 value in notification -- ACTUAL: ',test_s2,'  EXPECTED: ',params.s2]);

            test_sep = test_params.get('sep');
            assertTrue(strcmp(test_sep,params.sep),['TEST FAIL: ',testname,' -- bad parm1 value in notification -- ACTUAL: ',test_sep,'  EXPECTED: ',params.sep]);
            
            jsonrpc2Tests.log_passingTest('TestJSONRPC2Notification',testname);

        end % test_parse_notification %

        %% --------------------------------------------------------------------
        %   test_parse_notification_usingRequestClass
        %% --------------------------------------------------------------------
        function test_parse_notification_usingRequestClass(this)

            testname = 'test_parse_notification_usingRequestClass';

            %-------------------------
            % setup test
            %-------------------------
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
            newNotification = jsonrpc2.JSONRPC2Request.parse(notificationMsg);

            %-------------------------
            % test
            %-------------------------
            assertTrue(strcmp(class(newNotification),'jsonrpc2.JSONRPC2Notification'),['TEST FAIL: ',testname,' -- wrong class created -- ACTUAL: ',class(newNotification),'  EXPECTED: jsonrpc2.JSONRPC2Notification']);

            test_method = newNotification.method;
            assertTrue(strcmp(test_method,method),['TEST FAIL: ',testname,' -- bad method in notification -- ACTUAL: ',test_method,'  EXPECTED: ',method]);

            assertTrue(newNotification.hasParameters(),['TEST FAIL: ',testname,' -- notification thinks it doesn''t have parameters.']);
            assertFalse(newNotification.hasPositionalParameters(),['TEST FAIL: ',testname,' -- notification thinks it has positional parameters.']);
            assertTrue(newNotification.hasNamedParameters(),['TEST FAIL: ',testname,' -- notification thinks it doesn''t have named parameters.']);

            test_params = newNotification.params;
            assertTrue(strcmp(class(test_params),'jsonrpc2.NamedParamsRetriever'),['TEST FAIL: ',testname,' -- params in notification are not named parameters -- ACTUAL: ',class(test_params),'  EXPECTED: NamedParamsRetriever']);
            assertTrue(test_params.hasParam('s1'),['TEST FAIL: ',testname,' -- field s1 does not exist in params in notification']);
            assertTrue(test_params.hasParam('s2'),['TEST FAIL: ',testname,' -- field s2 does not exist in params in notification']);
            assertTrue(test_params.hasParam('sep'),['TEST FAIL: ',testname,' -- field sep does not exist in params in notification']);
            
            test_s1 = test_params.get('s1');
            assertTrue(strcmp(test_s1,params.s1),['TEST FAIL: ',testname,' -- bad s1 value in notification -- ACTUAL: ',test_s1,'  EXPECTED: ',params.s1]);

            test_s2 = test_params.get('s2');
            assertTrue(strcmp(test_s2,params.s2),['TEST FAIL: ',testname,' -- bad s2 value in notification -- ACTUAL: ',test_s2,'  EXPECTED: ',params.s2]);

            test_sep = test_params.get('sep');
            assertTrue(strcmp(test_sep,params.sep),['TEST FAIL: ',testname,' -- bad parm1 value in notification -- ACTUAL: ',test_sep,'  EXPECTED: ',params.sep]);
            
            jsonrpc2Tests.log_passingTest('TestJSONRPC2Notification',testname);

        end % test_parse_notification_usingRequestClass %
         
        %% --------------------------------------------------------------------
        %   test_parse_notification_badJson_missingMethod
        %% --------------------------------------------------------------------
        function test_parse_notification_badJson_missingMethod(this)

            testname = 'test_parse_notification_badJson_missingMethod';

            %-------------------------
            % setup test
            %-------------------------
            method = 'concat';
            params = struct;
            params.s1 = 'Hello';
            params.s2 = 'World';
            params.sep = ' ';
            
            notificationMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"params": { "s1": "',params.s1,'", "s2": "',params.s2,'", "sep": "',params.sep,'" },', ...
            '}'];

            %-------------------------
            % run method being tested
            %-------------------------
            caughtExpectedException = false;
            try
                newNotification = jsonrpc2.JSONRPC2Notification.parse(notificationMsg);
            catch Exception
                caughtExpectedException = true;
            end
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- constructing a notification without a method did not throw exception']);
            
            jsonrpc2Tests.log_passingTest('TestJSONRPC2Error',testname);

        end % test_parse_notification_badJson_missingMethod %
        
        %% --------------------------------------------------------------------
        %   test_parse_notification_badJson_extraStuff
        %% --------------------------------------------------------------------
        function test_parse_notification_badJson_extraStuff(this)

            testname = 'test_parse_notification_badJson_extraStuff';

            %-------------------------
            % setup test
            %-------------------------
            method = 'concat';
            params = struct;
            params.s1 = 'Hello';
            params.s2 = 'World';
            params.sep = ' ';
            
            notificationMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"method": "',method,'",', ...
                '"params": { "s1": "',params.s1,'", "s2": "',params.s2,'", "sep": "',params.sep,'" },', ...
                '"blah": "blah",', ...
            '}'];

            %-------------------------
            % run method being tested
            %-------------------------
            caughtExpectedException = false;
            try
                newNotification = jsonrpc2.JSONRPC2Notification.parse(notificationMsg);
            catch Exception
                caughtExpectedException = true;
            end
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- constructing a notification with extra stuff did not throw exception']);
            
            jsonrpc2Tests.log_passingTest('TestJSONRPC2Error',testname);

        end % test_parse_notification_badJson_extraStuff %
        

% =============================================================================
%                      Test Getter/Setter Methods
% =============================================================================

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
            
            newNotification = jsonrpc2.JSONRPC2Notification(method,params);
            
            %-------------------------
            % run method being tested
            %-------------------------
            test_method = newNotification.method;
            assertTrue(strcmp(test_method,method),['TEST FAIL: ',testname,' -- bad message Method in notification -- ACTUAL: ',test_method,'  EXPECTED: ',method]);

            %-------------------------
            % modify and re-run
            %-------------------------
            set_method = 'foo-mod';
            newNotification.method = set_method;
            test_method = newNotification.method;
            assertTrue(strcmp(test_method,set_method),['TEST FAIL: ',testname,' -- bad updated message Method in notification -- ACTUAL: ',test_method,'  EXPECTED: ',set_method]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Notification',testname);

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
            
            newNotification = jsonrpc2.JSONRPC2Notification(method,params);
            
            %-------------------------
            % run method being tested
            %-------------------------
            test_params = newNotification.params;

            assertTrue(newNotification.hasParameters(),['TEST FAIL: ',testname,' -- notification thinks it doesn''t have parameters.']);
            assertFalse(newNotification.hasPositionalParameters(),['TEST FAIL: ',testname,' -- notification thinks it has positional parameters.']);
            assertTrue(newNotification.hasNamedParameters(),['TEST FAIL: ',testname,' -- notification thinks it doesn''t have named parameters.']);

            assertTrue(strcmp(class(test_params),'jsonrpc2.NamedParamsRetriever'),['TEST FAIL: ',testname,' -- params in notification are not named parameters -- ACTUAL: ',class(test_params),'  EXPECTED: NamedParamsRetriever']);
            assertTrue(test_params.hasParam('s1'),['TEST FAIL: ',testname,' -- field s1 does not exist in params in notification']);
            assertTrue(test_params.hasParam('s2'),['TEST FAIL: ',testname,' -- field s2 does not exist in params in notification']);
            assertTrue(test_params.hasParam('sep'),['TEST FAIL: ',testname,' -- field sep does not exist in params in notification']);
            
            test_s1 = test_params.get('s1');
            assertTrue(strcmp(test_s1,params.s1),['TEST FAIL: ',testname,' -- bad s1 value in notification -- ACTUAL: ',test_s1,'  EXPECTED: ',params.s1]);

            test_s2 = test_params.get('s2');
            assertTrue(strcmp(test_s2,params.s2),['TEST FAIL: ',testname,' -- bad s2 value in notification -- ACTUAL: ',test_s2,'  EXPECTED: ',params.s2]);

            test_sep = test_params.get('sep');
            assertTrue(strcmp(test_sep,params.sep),['TEST FAIL: ',testname,' -- bad parm1 value in notification -- ACTUAL: ',test_sep,'  EXPECTED: ',params.sep]);

            %-------------------------
            % modify and re-run
            %-------------------------
            mod_params = struct;
            mod_params.text = 'Goodbye World';
            newNotification.params = mod_params;
            
            assertTrue(newNotification.hasParameters(),['TEST FAIL: ',testname,' -- notification thinks it doesn''t have parameters.']);
            assertFalse(newNotification.hasPositionalParameters(),['TEST FAIL: ',testname,' -- notification thinks it has positional parameters.']);
            assertTrue(newNotification.hasNamedParameters(),['TEST FAIL: ',testname,' -- notification thinks it doesn''t have named parameters.']);

            test_mod_params = newNotification.params;
            assertTrue(strcmp(class(test_mod_params),'jsonrpc2.NamedParamsRetriever'),['TEST FAIL: ',testname,' -- params in notification are not named parameters -- ACTUAL: ',class(test_params),'  EXPECTED: NamedParamsRetriever']);
            assertTrue(test_mod_params.hasParam('text'),['TEST FAIL: ',testname,' -- field text does not exist in params in notification']);
            
            test_mod_text = test_mod_params.get('text');
            assertTrue(strcmp(test_mod_text,mod_params.text),['TEST FAIL: ',testname,' -- bad s1 value in notification -- ACTUAL: ',test_mod_text,'  EXPECTED: ',mod_params.text]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Notification',testname);

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
            
            newNotification = jsonrpc2.JSONRPC2Notification(method,params);
            
            %-------------------------
            % run method being tested
            %-------------------------
            test_params = newNotification.params;

            assertTrue(newNotification.hasParameters(),['TEST FAIL: ',testname,' -- notification thinks it doesn''t have parameters.']);
            assertFalse(newNotification.hasNamedParameters(),['TEST FAIL: ',testname,' -- notification thinks it has named parameters.']);
            assertTrue(newNotification.hasPositionalParameters(),['TEST FAIL: ',testname,' -- notification thinks it doesn''t have positional parameters.']);

            assertTrue(strcmp(class(test_params),'jsonrpc2.PositionalParamsRetriever'),['TEST FAIL: ',testname,' -- params in notification are not ordered parameters -- ACTUAL: ',class(test_params),'  EXPECTED: PositionalParamsRetriever']);
            
            test_numParams = test_params.size();
            assertTrue(test_numParams==3,['TEST FAIL: ',testname,' -- params in notification has wrong number of parameters -- ACTUAL: ',int2str(test_numParams),'  EXPECTED: 3']);

            test_s1 = test_params.get(1);
            assertTrue(strcmp(test_s1,params{1}),['TEST FAIL: ',testname,' -- bad s1 value in notification -- ACTUAL: ',test_s1,'  EXPECTED: ',params{1}]);

            test_s2 = test_params.get(2);
            assertTrue(strcmp(test_s2,params{2}),['TEST FAIL: ',testname,' -- bad s2 value in notification -- ACTUAL: ',test_s2,'  EXPECTED: ',params{2}]);

            test_sep = test_params.get(3);
            assertTrue(strcmp(test_sep,params{3}),['TEST FAIL: ',testname,' -- bad parm1 value in notification -- ACTUAL: ',test_sep,'  EXPECTED: ',params{3}]);

            %-------------------------
            % modify and re-run
            %-------------------------
            mod_params = cell(1,1);
            mod_params{1} = 'Goodbye World';
            newNotification.params = mod_params;
            
            assertTrue(newNotification.hasParameters(),['TEST FAIL: ',testname,' -- notification thinks it doesn''t have parameters.']);
            assertFalse(newNotification.hasNamedParameters(),['TEST FAIL: ',testname,' -- notification thinks it doesn''t have named parameters.']);
            assertTrue(newNotification.hasPositionalParameters(),['TEST FAIL: ',testname,' -- notification thinks it has positional parameters.']);

            test_mod_params = newNotification.params;

            assertTrue(strcmp(class(test_mod_params),'jsonrpc2.PositionalParamsRetriever'),['TEST FAIL: ',testname,' -- params in notification are not positional parameters -- ACTUAL: ',class(test_mod_params),'  EXPECTED: PositionalParamsRetriever']);
            
            test_numParams = test_mod_params.size();
            assertTrue(test_numParams==1,['TEST FAIL: ',testname,' -- params in notification has wrong number of parameters -- ACTUAL: ',int2str(test_numParams),'  EXPECTED: 1']);

            test_mod_text = test_mod_params.get(1);
            assertTrue(strcmp(test_mod_text,mod_params{1}),['TEST FAIL: ',testname,' -- bad s1 value in notification -- ACTUAL: ',test_mod_text,'  EXPECTED: ',mod_params{1}]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Notification',testname);

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
            
            newNotification = jsonrpc2.JSONRPC2Notification(method,params);
            
            %-------------------------
            % run method being tested
            %-------------------------
            test_params = newNotification.params;

            assertTrue(newNotification.hasParameters(),['TEST FAIL: ',testname,' -- notification thinks it doesn''t have parameters.']);
            assertFalse(newNotification.hasPositionalParameters(),['TEST FAIL: ',testname,' -- notification thinks it has positional parameters.']);
            assertTrue(newNotification.hasNamedParameters(),['TEST FAIL: ',testname,' -- notification thinks it doesn''t have named parameters.']);

            assertTrue(strcmp(class(test_params),'jsonrpc2.NamedParamsRetriever'),['TEST FAIL: ',testname,' -- params in notification are not named parameters -- ACTUAL: ',class(test_params),'  EXPECTED: NamedParamsRetriever']);
            assertTrue(test_params.hasParam('s1'),['TEST FAIL: ',testname,' -- field s1 does not exist in params in notification']);
            assertTrue(test_params.hasParam('s2'),['TEST FAIL: ',testname,' -- field s2 does not exist in params in notification']);
            assertTrue(test_params.hasParam('sep'),['TEST FAIL: ',testname,' -- field sep does not exist in params in notification']);
            
            test_s1 = test_params.get('s1');
            assertTrue(strcmp(test_s1,params.s1),['TEST FAIL: ',testname,' -- bad s1 value in notification -- ACTUAL: ',test_s1,'  EXPECTED: ',params.s1]);

            test_s2 = test_params.get('s2');
            assertTrue(strcmp(test_s2,params.s2),['TEST FAIL: ',testname,' -- bad s2 value in notification -- ACTUAL: ',test_s2,'  EXPECTED: ',params.s2]);

            test_sep = test_params.get('sep');
            assertTrue(strcmp(test_sep,params.sep),['TEST FAIL: ',testname,' -- bad parm1 value in notification -- ACTUAL: ',test_sep,'  EXPECTED: ',params.sep]);

            %-------------------------
            % modify and re-run
            %-------------------------
            mod_params = cell(1,1);
            mod_params{1} = 'Goodbye World';
            newNotification.params = mod_params;
            
            assertTrue(newNotification.hasParameters(),['TEST FAIL: ',testname,' -- notification thinks it doesn''t have parameters.']);
            assertFalse(newNotification.hasNamedParameters(),['TEST FAIL: ',testname,' -- notification thinks it doesn''t have named parameters.']);
            assertTrue(newNotification.hasPositionalParameters(),['TEST FAIL: ',testname,' -- notification thinks it has positional parameters.']);

            test_mod_params = newNotification.params;

            assertTrue(strcmp(class(test_mod_params),'jsonrpc2.PositionalParamsRetriever'),['TEST FAIL: ',testname,' -- params in notification are not positional parameters -- ACTUAL: ',class(test_mod_params),'  EXPECTED: PositionalParamsRetriever']);
            
            test_numParams = test_mod_params.size();
            assertTrue(test_numParams==1,['TEST FAIL: ',testname,' -- params in notification has wrong number of parameters -- ACTUAL: ',int2str(test_numParams),'  EXPECTED: 1']);

            test_mod_text = test_mod_params.get(1);
            assertTrue(strcmp(test_mod_text,mod_params{1}),['TEST FAIL: ',testname,' -- bad s1 value in notification -- ACTUAL: ',test_mod_text,'  EXPECTED: ',mod_params{1}]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Notification',testname);

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
            
            newNotification = jsonrpc2.JSONRPC2Notification(method,params);
            
            %-------------------------
            % run method being tested
            %-------------------------
            test_params = newNotification.params;

            assertTrue(newNotification.hasParameters(),['TEST FAIL: ',testname,' -- notification thinks it doesn''t have parameters.']);
            assertFalse(newNotification.hasNamedParameters(),['TEST FAIL: ',testname,' -- notification thinks it has named parameters.']);
            assertTrue(newNotification.hasPositionalParameters(),['TEST FAIL: ',testname,' -- notification thinks it doesn''t have positional parameters.']);

            assertTrue(strcmp(class(test_params),'jsonrpc2.PositionalParamsRetriever'),['TEST FAIL: ',testname,' -- params in notification are not ordered parameters -- ACTUAL: ',class(test_params),'  EXPECTED: PositionalParamsRetriever']);
            
            test_numParams = test_params.size();
            assertTrue(test_numParams==3,['TEST FAIL: ',testname,' -- params in notification has wrong number of parameters -- ACTUAL: ',int2str(test_numParams),'  EXPECTED: 3']);

            test_s1 = test_params.get(1);
            assertTrue(strcmp(test_s1,params{1}),['TEST FAIL: ',testname,' -- bad s1 value in notification -- ACTUAL: ',test_s1,'  EXPECTED: ',params{1}]);

            test_s2 = test_params.get(2);
            assertTrue(strcmp(test_s2,params{2}),['TEST FAIL: ',testname,' -- bad s2 value in notification -- ACTUAL: ',test_s2,'  EXPECTED: ',params{2}]);

            test_sep = test_params.get(3);
            assertTrue(strcmp(test_sep,params{3}),['TEST FAIL: ',testname,' -- bad parm1 value in notification -- ACTUAL: ',test_sep,'  EXPECTED: ',params{3}]);

            %-------------------------
            % modify and re-run
            %-------------------------
            mod_params = struct;
            mod_params.text = 'Goodbye World';
            newNotification.params = mod_params;
            
            assertTrue(newNotification.hasParameters(),['TEST FAIL: ',testname,' -- notification thinks it doesn''t have parameters.']);
            assertFalse(newNotification.hasPositionalParameters(),['TEST FAIL: ',testname,' -- notification thinks it has positional parameters.']);
            assertTrue(newNotification.hasNamedParameters(),['TEST FAIL: ',testname,' -- notification thinks it doesn''t have named parameters.']);

            test_mod_params = newNotification.params;
            assertTrue(strcmp(class(test_mod_params),'jsonrpc2.NamedParamsRetriever'),['TEST FAIL: ',testname,' -- params in notification are not named parameters -- ACTUAL: ',class(test_params),'  EXPECTED: NamedParamsRetriever']);
            assertTrue(test_mod_params.hasParam('text'),['TEST FAIL: ',testname,' -- field text does not exist in params in notification']);
            
            test_mod_text = test_mod_params.get('text');
            assertTrue(strcmp(test_mod_text,mod_params.text),['TEST FAIL: ',testname,' -- bad s1 value in notification -- ACTUAL: ',test_mod_text,'  EXPECTED: ',mod_params.text]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Notification',testname);

        end % test_getterSetter_Params_bothOrdered %
         
        %% --------------------------------------------------------------------
        %   test_getterSetter_ID_whenNotification
        %% --------------------------------------------------------------------
        function test_getterSetter_ID_whenNotification(this)

            testname = 'test_getterSetter_ID_whenNotification';

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
            % test for exception when attempt to get id for notification
            %-------------------------
            caughtExpectedException = false;
            try
                test_id = newNotification.id;
            catch Exception
                caughtExpectedException = true;
            end
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- getting id for notification did not throw exception']);

            %-------------------------
            % modify and re-run
            %-------------------------
            caughtExpectedException = false;
            try
                newNotification.id = 'new id';
            catch Exception
                caughtExpectedException = true;
            end
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- setting id for notification did not throw exception']);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Notification',testname);

        end % test_getterSetter_ID_whenNotification %


% =============================================================================
%                             Test Instance Methods
% =============================================================================

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
            assertTrue(isnotification,['TEST FAIL: ',testname,' -- isNotification() does not think this is a notification.']);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Notification',testname);

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
            
            notificationMsg = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"method": "',method,'",', ...
                '"params": { "s1": "',params.s1,'", "s2": "',params.s2,'", "sep": "',params.sep,'" }', ...
            '}'];

            newRequest = jsonrpc2.JSONRPC2Notification.parse(notificationMsg);
            
            %-------------------------
            % run method being tested
            %-------------------------
            test_notificationMsg = newRequest.toJSONString();
            match = jsonrpc2Tests.strcmpiw(notificationMsg,test_notificationMsg);
            assertTrue(match,['TEST FAIL: ',testname,' -- original and generated JSON do not match -- GENERATED: ',test_notificationMsg,'  ORIGINAL: ',notificationMsg]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Request',testname);

        end % test_toJSONString %
        
    end % methods %

end % classdef %

        
        