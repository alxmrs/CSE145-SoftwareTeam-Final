% Tests for JSONRPC2Parser class
%
% Copyright (c) 2014, Cornell University, Lab of Ornithology
% All rights reserved.
%
% Distributed under BSD license.  See LICENSE_BSD.txt for full license.
% 
% Author: E. L. Rayle
% date: 01/22/2014
%
% COMMAND TO RUN THESE TESTS:  runtests jsonrpc2Tests.TestJSONRPC2Parser
%

classdef TestJSONRPC2Parser < TestCase

% =============================================================================
%                             Setup & Teardown
% =============================================================================
    methods
        function this = TestJSONRPC2Parser(name)
            this = this@TestCase(name);
        end

        function setUp(this)
        end

        function tearDown(this)
        end

% =============================================================================
%                            Public Parsing Methods
% =============================================================================

        %% --------------------------------------------------------------------
        %   test_parseJSONRPC2Message
        %     -- all possible types tested via TestJSONRPC2Message
        %% --------------------------------------------------------------------
    
        %% --------------------------------------------------------------------
        %   test_parseJSONRPC2Request
        %     -- fully tested via TestJSONRPC2Request
        %% --------------------------------------------------------------------
    
        %% --------------------------------------------------------------------
        %   test_parseJSONRPC2Notification
        %     -- tested via TestJSONRPC2Notification
        %% --------------------------------------------------------------------
    
        %% --------------------------------------------------------------------
        %   test_parseJSONRPC2Response
        %     -- tested via TestJSONRPC2Response
        %% --------------------------------------------------------------------    
    
        %% --------------------------------------------------------------------
        %   test_parseJSONRPC2Messages_multiRequestsWithOneMsg
        %% --------------------------------------------------------------------
        function test_parseJSONRPC2Messages_multiRequestsWithOneMsg(this)

            testname = 'test_parseJSONRPC2Messages_multiRequestsWithOneMsg';

            %-------------------------
            % setup test
            %-------------------------
            id1     = 'req-1';
            method1 = 'concat';
            params1 = struct;
            params1.s1 = 'Hello';
            params1.s2 = 'World';
            params1.sep = ' ';
            
            requestMsg1 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"method": "',method1,'",', ...
                '"params": { "s1": "',params1.s1,'", "s2": "',params1.s2,'", "sep": "',params1.sep,'" },', ...
                '"id": "',id1,'"', ...
            '}'];

            requestMsgs = requestMsg1;
            
            %-------------------------
            % run method being tested
            %-------------------------
            parser = jsonrpc2.JSONRPC2Parser();
            newRequests = parser.parseJSONRPC2Messages(requestMsgs);

            %-------------------------
            % test
            %-------------------------
            assertTrue(iscell(newRequests),['TEST FAIL: ',testname,' -- multiple messages are not parsed into cell array']);
            
            test_size = length(newRequests);  
            assertTrue(test_size==1,['TEST FAIL: ',testname,' -- multiple messages array is wrong size -- ACTUAL: ',test_size,'  EXPECTED: 1']);

            expected_class = 'jsonrpc2.JSONRPC2Request';
            test_class1 = class(newRequests{1});
            assertTrue(strcmp(test_class1,expected_class),['TEST FAIL: ',testname,' -- 1st message parsed to incorrect type -- ACTUAL: ',test_class1,'  EXPECTED: ',expected_class]);

            test_id1 = newRequests{1}.id;
            assertTrue(strcmp(test_id1,id1),['TEST FAIL: ',testname,' -- bad message ID in 1st request -- ACTUAL: ',test_id1,'  EXPECTED: ',id1]);

            test_method1 = newRequests{1}.method;
            assertTrue(strcmp(test_method1,method1),['TEST FAIL: ',testname,' -- bad method in 1st request -- ACTUAL: ',test_method1,'  EXPECTED: ',method1]);

            assertTrue(newRequests{1}.hasParameters(),['TEST FAIL: ',testname,' -- 1st request thinks it doesn''t have parameters.']);
            assertFalse(newRequests{1}.hasPositionalParameters(),['TEST FAIL: ',testname,' -- 1st request thinks it has positional parameters.']);
            assertTrue(newRequests{1}.hasNamedParameters(),['TEST FAIL: ',testname,' -- 1st request thinks it doesn''t have named parameters.']);

            test_params1 = newRequests{1}.params;
            assertTrue(strcmp(class(test_params1),'jsonrpc2.NamedParamsRetriever'),['TEST FAIL: ',testname,' -- params in request are not named parameters -- ACTUAL: ',class(test_params1),'  EXPECTED: NamedParamsRetriever']);

            assertTrue(test_params1.hasParam('s1'),['TEST FAIL: ',testname,' -- field s1 does not exist in params in 1st request']);
            assertTrue(test_params1.hasParam('s2'),['TEST FAIL: ',testname,' -- field s2 does not exist in params in 1st request']);
            assertTrue(test_params1.hasParam('sep'),['TEST FAIL: ',testname,' -- field sep does not exist in params in 1st request']);
            
            test1_s1  = test_params1.get('s1');
            test1_s2  = test_params1.get('s2');
            test1_sep = test_params1.get('sep');
            assertTrue(strcmp(test1_s1,params1.s1),['TEST FAIL: ',testname,' -- bad s1 value in 1st request -- ACTUAL: ',test1_s1,'  EXPECTED: ',params1.s1]);
            assertTrue(strcmp(test1_s2,params1.s2),['TEST FAIL: ',testname,' -- bad s2 value in 1st request -- ACTUAL: ',test1_s2,'  EXPECTED: ',params1.s2]);
            assertTrue(strcmp(test1_sep,params1.sep),['TEST FAIL: ',testname,' -- bad sep value in 1st request -- ACTUAL: ',test1_sep,'  EXPECTED: ',params1.sep]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Parser',testname);

        end % test_parseJSONRPC2Messages_multiRequestsWithOneMsg %            
 
        %% --------------------------------------------------------------------
        %   test_parseJSONRPC2Messages_multiRequests
        %% --------------------------------------------------------------------
        function test_parseJSONRPC2Messages_multiRequests(this)

            testname = 'test_parseJSONRPC2Messages_multiRequests';

            %-------------------------
            % setup test
            %-------------------------
            id1     = 'req-1';
            method1 = 'concat';
            params1 = struct;
            params1.s1 = 'Hello';
            params1.s2 = 'World';
            params1.sep = ' ';
            
            requestMsg1 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"method": "',method1,'",', ...
                '"params": { "s1": "',params1.s1,'", "s2": "',params1.s2,'", "sep": "',params1.sep,'" },', ...
                '"id": "',id1,'"', ...
            '}'];

            id2     = 'req-2';
            method2 = 'echo';
            params2 = struct;
            params2.text = 'Goodbye World';
            
            requestMsg2 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"method": "',method2,'",', ...
                '"params": [ "',params2.text,'" ],', ...
                '"id": "',id2,'"', ...
            '}'];

            id3     = 'req-3';
            method3 = 'whichMethod';
            
            requestMsg3 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"method": "',method3,'",', ...
                '"id": "',id3,'"', ...
            '}'];

            requestMsgs = ['[',requestMsg1,',',requestMsg2,',',requestMsg3,']'];
            
            %-------------------------
            % run method being tested
            %-------------------------
            parser = jsonrpc2.JSONRPC2Parser();
            newRequests = parser.parseJSONRPC2Messages(requestMsgs);

            %-------------------------
            % test
            %-------------------------
            assertTrue(iscell(newRequests),['TEST FAIL: ',testname,' -- multiple messages are not parsed into cell array']);
            
            test_size = length(newRequests);  
            assertTrue(test_size==3,['TEST FAIL: ',testname,' -- multiple messages array is wrong size -- ACTUAL: ',test_size,'  EXPECTED: 3']);

            expected_class = 'jsonrpc2.JSONRPC2Request';
            test_class1 = class(newRequests{1});
            test_class2 = class(newRequests{2});
            test_class3 = class(newRequests{3});
            assertTrue(strcmp(test_class1,expected_class),['TEST FAIL: ',testname,' -- 1st message parsed to incorrect type -- ACTUAL: ',test_class1,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class2,expected_class),['TEST FAIL: ',testname,' -- 2nd message parsed to incorrect type -- ACTUAL: ',test_class2,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class3,expected_class),['TEST FAIL: ',testname,' -- 3rd message parsed to incorrect type -- ACTUAL: ',test_class3,'  EXPECTED: ',expected_class]);

            test_id1 = newRequests{1}.id;
            test_id2 = newRequests{2}.id;
            test_id3 = newRequests{3}.id;
            assertTrue(strcmp(test_id1,id1),['TEST FAIL: ',testname,' -- bad message ID in 1st request -- ACTUAL: ',test_id1,'  EXPECTED: ',id1]);
            assertTrue(strcmp(test_id2,id2),['TEST FAIL: ',testname,' -- bad message ID in 2nd request -- ACTUAL: ',test_id2,'  EXPECTED: ',id2]);
            assertTrue(strcmp(test_id3,id3),['TEST FAIL: ',testname,' -- bad message ID in 3rd request -- ACTUAL: ',test_id3,'  EXPECTED: ',id3]);

            test_method1 = newRequests{1}.method;
            test_method2 = newRequests{2}.method;
            test_method3 = newRequests{3}.method;
            assertTrue(strcmp(test_method1,method1),['TEST FAIL: ',testname,' -- bad method in 1st request -- ACTUAL: ',test_method1,'  EXPECTED: ',method1]);
            assertTrue(strcmp(test_method2,method2),['TEST FAIL: ',testname,' -- bad method in 2nd request -- ACTUAL: ',test_method2,'  EXPECTED: ',method2]);
            assertTrue(strcmp(test_method3,method3),['TEST FAIL: ',testname,' -- bad method in 3rd request -- ACTUAL: ',test_method3,'  EXPECTED: ',method3]);

            assertTrue(newRequests{1}.hasParameters(),['TEST FAIL: ',testname,' -- 1st request thinks it doesn''t have parameters.']);
            assertTrue(newRequests{2}.hasParameters(),['TEST FAIL: ',testname,' -- 2nd request thinks it doesn''t have parameters.']);
            assertFalse(newRequests{3}.hasParameters(),['TEST FAIL: ',testname,' -- 3rd request thinks it has parameters.']);
            assertFalse(newRequests{1}.hasPositionalParameters(),['TEST FAIL: ',testname,' -- 1st request thinks it has positional parameters.']);
            assertTrue(newRequests{2}.hasPositionalParameters(),['TEST FAIL: ',testname,' -- 2nd request thinks it doesn''t have positional parameters.']);
            assertFalse(newRequests{3}.hasPositionalParameters(),['TEST FAIL: ',testname,' -- 3rd request thinks it has positional parameters.']);
            assertTrue(newRequests{1}.hasNamedParameters(),['TEST FAIL: ',testname,' -- 1st request thinks it doesn''t have named parameters.']);
            assertFalse(newRequests{2}.hasNamedParameters(),['TEST FAIL: ',testname,' -- 2nd request thinks it has named parameters.']);
            assertFalse(newRequests{3}.hasNamedParameters(),['TEST FAIL: ',testname,' -- 3rd request thinks it has named parameters.']);

            test_params1 = newRequests{1}.params;
            test_params2 = newRequests{2}.params;
            assertTrue(strcmp(class(test_params1),'jsonrpc2.NamedParamsRetriever'),['TEST FAIL: ',testname,' -- params in request are not named parameters -- ACTUAL: ',class(test_params1),'  EXPECTED: NamedParamsRetriever']);
            assertTrue(strcmp(class(test_params2),'jsonrpc2.PositionalParamsRetriever'),['TEST FAIL: ',testname,' -- params in request are not positional parameters -- ACTUAL: ',class(test_params2),'  EXPECTED: PositionalParamsRetriever']);

            assertTrue(test_params1.hasParam('s1'),['TEST FAIL: ',testname,' -- field s1 does not exist in params in 1st request']);
            assertTrue(test_params1.hasParam('s2'),['TEST FAIL: ',testname,' -- field s2 does not exist in params in 1st request']);
            assertTrue(test_params1.hasParam('sep'),['TEST FAIL: ',testname,' -- field sep does not exist in params in 1st request']);
            
            assertTrue(test_params2.hasParam(1),['TEST FAIL: ',testname,' -- field 1 does not exist in params in 2nd request']);
           
            test1_s1  = test_params1.get('s1');
            test1_s2  = test_params1.get('s2');
            test1_sep = test_params1.get('sep');
            assertTrue(strcmp(test1_s1,params1.s1),['TEST FAIL: ',testname,' -- bad s1 value in 1st request -- ACTUAL: ',test1_s1,'  EXPECTED: ',params1.s1]);
            assertTrue(strcmp(test1_s2,params1.s2),['TEST FAIL: ',testname,' -- bad s2 value in 1st request -- ACTUAL: ',test1_s2,'  EXPECTED: ',params1.s2]);
            assertTrue(strcmp(test1_sep,params1.sep),['TEST FAIL: ',testname,' -- bad sep value in 1st request -- ACTUAL: ',test1_sep,'  EXPECTED: ',params1.sep]);

            test2_text = test_params2.get(1);
            assertTrue(strcmp(test2_text,params2.text),['TEST FAIL: ',testname,' -- bad parm1 value in request -- ACTUAL: ',test2_text,'  EXPECTED: ',params2.text]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Parser',testname);

        end % test_parseJSONRPC2Messages_multiRequests %            
 
        %% --------------------------------------------------------------------
        %   test_parseJSONRPC2Messages_multiNotifications
        %% --------------------------------------------------------------------
        function test_parseJSONRPC2Messages_multiNotifications(this)

            testname = 'test_parseJSONRPC2Messages_multiNotifications';

            %-------------------------
            % setup test
            %-------------------------
            id1     = 'req-1';
            method1 = 'concat';
            params1 = struct;
            params1.s1 = 'Hello';
            params1.s2 = 'World';
            params1.sep = ' ';
            
            notificationMsg1 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"method": "',method1,'",', ...
                '"params": { "s1": "',params1.s1,'", "s2": "',params1.s2,'", "sep": "',params1.sep,'" }', ...
            '}'];

            id2     = 'req-2';
            method2 = 'echo';
            params2 = struct;
            params2.text = 'Goodbye World';
            
            notificationMsg2 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"method": "',method2,'",', ...
                '"params": [ "',params2.text,'" ]', ...
            '}'];

            id3     = 'req-3';
            method3 = 'whichMethod';
            
            notificationMsg3 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"method": "',method3,'"', ...
            '}'];

            notificationMsgs = ['[',notificationMsg1,',',notificationMsg2,',',notificationMsg3,']'];
            
            %-------------------------
            % run method being tested
            %-------------------------
            parser = jsonrpc2.JSONRPC2Parser();
            newNotifications = parser.parseJSONRPC2Messages(notificationMsgs);

            %-------------------------
            % test
            %-------------------------
            assertTrue(iscell(newNotifications),['TEST FAIL: ',testname,' -- multiple messages are not parsed into cell array']);
            
            test_size = length(newNotifications);  
            assertTrue(test_size==3,['TEST FAIL: ',testname,' -- multiple messages array is wrong size -- ACTUAL: ',test_size,'  EXPECTED: 3']);

            expected_class = 'jsonrpc2.JSONRPC2Notification';
            test_class1 = class(newNotifications{1});
            test_class2 = class(newNotifications{2});
            test_class3 = class(newNotifications{3});
            assertTrue(strcmp(test_class1,expected_class),['TEST FAIL: ',testname,' -- 1st message parsed to incorrect type -- ACTUAL: ',test_class1,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class2,expected_class),['TEST FAIL: ',testname,' -- 2nd message parsed to incorrect type -- ACTUAL: ',test_class2,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class3,expected_class),['TEST FAIL: ',testname,' -- 3rd message parsed to incorrect type -- ACTUAL: ',test_class3,'  EXPECTED: ',expected_class]);

            test_method1 = newNotifications{1}.method;
            test_method2 = newNotifications{2}.method;
            test_method3 = newNotifications{3}.method;
            assertTrue(strcmp(test_method1,method1),['TEST FAIL: ',testname,' -- bad method in 1st notification -- ACTUAL: ',test_method1,'  EXPECTED: ',method1]);
            assertTrue(strcmp(test_method2,method2),['TEST FAIL: ',testname,' -- bad method in 2nd notification -- ACTUAL: ',test_method2,'  EXPECTED: ',method2]);
            assertTrue(strcmp(test_method3,method3),['TEST FAIL: ',testname,' -- bad method in 3rd notification -- ACTUAL: ',test_method3,'  EXPECTED: ',method3]);

            assertTrue(newNotifications{1}.hasParameters(),['TEST FAIL: ',testname,' -- 1st notification thinks it doesn''t have parameters.']);
            assertTrue(newNotifications{2}.hasParameters(),['TEST FAIL: ',testname,' -- 2nd notification thinks it doesn''t have parameters.']);
            assertFalse(newNotifications{3}.hasParameters(),['TEST FAIL: ',testname,' -- 3rd notification thinks it has parameters.']);
            assertFalse(newNotifications{1}.hasPositionalParameters(),['TEST FAIL: ',testname,' -- 1st notification thinks it has positional parameters.']);
            assertTrue(newNotifications{2}.hasPositionalParameters(),['TEST FAIL: ',testname,' -- 2nd notification thinks it doesn''t have positional parameters.']);
            assertFalse(newNotifications{3}.hasPositionalParameters(),['TEST FAIL: ',testname,' -- 3rd notification thinks it has positional parameters.']);
            assertTrue(newNotifications{1}.hasNamedParameters(),['TEST FAIL: ',testname,' -- 1st notification thinks it doesn''t have named parameters.']);
            assertFalse(newNotifications{2}.hasNamedParameters(),['TEST FAIL: ',testname,' -- 2nd notification thinks it has named parameters.']);
            assertFalse(newNotifications{3}.hasNamedParameters(),['TEST FAIL: ',testname,' -- 3rd notification thinks it has named parameters.']);

            test_params1 = newNotifications{1}.params;
            test_params2 = newNotifications{2}.params;
            assertTrue(strcmp(class(test_params1),'jsonrpc2.NamedParamsRetriever'),['TEST FAIL: ',testname,' -- params in notification are not named parameters -- ACTUAL: ',class(test_params1),'  EXPECTED: NamedParamsRetriever']);
            assertTrue(strcmp(class(test_params2),'jsonrpc2.PositionalParamsRetriever'),['TEST FAIL: ',testname,' -- params in notification are not positional parameters -- ACTUAL: ',class(test_params2),'  EXPECTED: PositionalParamsRetriever']);

            assertTrue(test_params1.hasParam('s1'),['TEST FAIL: ',testname,' -- field s1 does not exist in params in 1st notification']);
            assertTrue(test_params1.hasParam('s2'),['TEST FAIL: ',testname,' -- field s2 does not exist in params in 1st notification']);
            assertTrue(test_params1.hasParam('sep'),['TEST FAIL: ',testname,' -- field sep does not exist in params in 1st notification']);
            
            assertTrue(test_params2.hasParam(1),['TEST FAIL: ',testname,' -- field 1 does not exist in params in 2nd notification']);
           
            test1_s1  = test_params1.get('s1');
            test1_s2  = test_params1.get('s2');
            test1_sep = test_params1.get('sep');
            assertTrue(strcmp(test1_s1,params1.s1),['TEST FAIL: ',testname,' -- bad s1 value in 1st notification -- ACTUAL: ',test1_s1,'  EXPECTED: ',params1.s1]);
            assertTrue(strcmp(test1_s2,params1.s2),['TEST FAIL: ',testname,' -- bad s2 value in 1st notification -- ACTUAL: ',test1_s2,'  EXPECTED: ',params1.s2]);
            assertTrue(strcmp(test1_sep,params1.sep),['TEST FAIL: ',testname,' -- bad sep value in 1st notification -- ACTUAL: ',test1_sep,'  EXPECTED: ',params1.sep]);

            test2_text = test_params2.get(1);
            assertTrue(strcmp(test2_text,params2.text),['TEST FAIL: ',testname,' -- bad parm1 value in notification -- ACTUAL: ',test2_text,'  EXPECTED: ',params2.text]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Parser',testname);

        end % test_parseJSONRPC2Messages_multiNotifications %            
 
        %% --------------------------------------------------------------------
        %   test_parseJSONRPC2Messages_multiResponses
        %% --------------------------------------------------------------------
        function test_parseJSONRPC2Messages_multiResponses(this)

            testname = 'test_parseJSONRPC2Messages_multiResponses';

            %-------------------------
            % setup test
            %-------------------------
            id1     = 'req-1';
            result1 = 'SUCCESS-1';
            
            responseMsg1 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"result": "',result1,'",', ...
                '"id": "',id1,'"', ...
            '}'];

            id2     = 'req-2';
            result2 = 'SUCCESS-2';
            
            responseMsg2 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"result": "',result2,'",', ...
                '"id": "',id2,'"', ...
            '}'];

            id3     = 'req-3';
            result3 = 'SUCCESS-3';
            
            responseMsg3 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"result": "',result3,'",', ...
                '"id": "',id3,'"', ...
            '}'];

            responseMsgs = ['[',responseMsg1,',',responseMsg2,',',responseMsg3,']'];
            
            %-------------------------
            % run method being tested
            %-------------------------
            parser = jsonrpc2.JSONRPC2Parser();
            newResponses = parser.parseJSONRPC2Messages(responseMsgs);

            %-------------------------
            % test
            %-------------------------
            assertTrue(iscell(newResponses),['TEST FAIL: ',testname,' -- multiple messages are not parsed into cell array']);
            
            test_size = length(newResponses);  
            assertTrue(test_size==3,['TEST FAIL: ',testname,' -- multiple messages array is wrong size -- ACTUAL: ',test_size,'  EXPECTED: 3']);

            expected_class = 'jsonrpc2.JSONRPC2Response';
            test_class1 = class(newResponses{1});
            test_class2 = class(newResponses{2});
            test_class3 = class(newResponses{3});
            assertTrue(strcmp(test_class1,expected_class),['TEST FAIL: ',testname,' -- 1st message parsed to incorrect type -- ACTUAL: ',test_class1,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class2,expected_class),['TEST FAIL: ',testname,' -- 2nd message parsed to incorrect type -- ACTUAL: ',test_class2,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class3,expected_class),['TEST FAIL: ',testname,' -- 3rd message parsed to incorrect type -- ACTUAL: ',test_class3,'  EXPECTED: ',expected_class]);

            test_id1 = newResponses{1}.id;
            test_id2 = newResponses{2}.id;
            test_id3 = newResponses{3}.id;
            assertTrue(strcmp(test_id1,id1),['TEST FAIL: ',testname,' -- bad message ID in 1st response -- ACTUAL: ',test_id1,'  EXPECTED: ',id1]);
            assertTrue(strcmp(test_id2,id2),['TEST FAIL: ',testname,' -- bad message ID in 2nd response -- ACTUAL: ',test_id2,'  EXPECTED: ',id2]);
            assertTrue(strcmp(test_id3,id3),['TEST FAIL: ',testname,' -- bad message ID in 3rd response -- ACTUAL: ',test_id3,'  EXPECTED: ',id3]);

            test_result1 = newResponses{1}.result;
            test_result2 = newResponses{2}.result;
            test_result3 = newResponses{3}.result;
            assertTrue(strcmp(test_result1,result1),['TEST FAIL: ',testname,' -- bad result in 1st response -- ACTUAL: ',test_result1,'  EXPECTED: ',result1]);
            assertTrue(strcmp(test_result2,result2),['TEST FAIL: ',testname,' -- bad result in 2nd response -- ACTUAL: ',test_result2,'  EXPECTED: ',result2]);
            assertTrue(strcmp(test_result3,result3),['TEST FAIL: ',testname,' -- bad result in 3rd response -- ACTUAL: ',test_result3,'  EXPECTED: ',result3]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Parser',testname);

        end % test_parseJSONRPC2Messages_multiResponses %            

        %% --------------------------------------------------------------------
        %   test_parseJSONRPC2Messages_multiErrors
        %% --------------------------------------------------------------------
        function test_parseJSONRPC2Messages_multiErrors(this)

            testname = 'test_parseJSONRPC2Messages_multiErrors';

            %-------------------------
            % setup test
            %-------------------------
            id1      = 'req-1';
            errmsg1  = 'FAILURE: Method Not Found';
            errcode1 = jsonrpc2.JSONRPC2Error.JSON_METHOD_NOT_FOUND;
                        
            errorMsg1 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"id": "',id1,'",', ...
                '"error": { ', ...
                    '"code": ',int2str(errcode1),',', ...
                    '"message": "',errmsg1,'"', ...
                '}', ...
            '}'];

            id2      = 'req-2';
            errmsg2  = 'FAILURE: Method Not Found';
            errcode2 = jsonrpc2.JSONRPC2Error.JSON_METHOD_NOT_FOUND;
                        
            errorMsg2 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"id": "',id2,'",', ...
                '"error": { ', ...
                    '"code": ',int2str(errcode2),',', ...
                    '"message": "',errmsg2,'"', ...
                '}', ...
            '}'];

            id3      = 'req-3';
            errmsg3  = 'FAILURE: Method Not Found';
            errcode3 = jsonrpc2.JSONRPC2Error.JSON_METHOD_NOT_FOUND;
                        
            errorMsg3 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"id": "',id3,'",', ...
                '"error": { ', ...
                    '"code": ',int2str(errcode3),',', ...
                    '"message": "',errmsg3,'"', ...
                '}', ...
            '}'];

            errorMsgs = ['[',errorMsg1,',',errorMsg2,',',errorMsg3,']'];
            
            %-------------------------
            % run method being tested
            %-------------------------
            parser = jsonrpc2.JSONRPC2Parser();
            newErrors = parser.parseJSONRPC2Messages(errorMsgs);

            %-------------------------
            % test
            %-------------------------
            assertTrue(iscell(newErrors),['TEST FAIL: ',testname,' -- multiple messages are not parsed into cell array']);
            
            test_size = length(newErrors);  
            assertTrue(test_size==3,['TEST FAIL: ',testname,' -- multiple messages array is wrong size -- ACTUAL: ',test_size,'  EXPECTED: 3']);

            expected_class = 'jsonrpc2.JSONRPC2Error';
            test_class1 = class(newErrors{1});
            test_class2 = class(newErrors{2});
            test_class3 = class(newErrors{3});
            assertTrue(strcmp(test_class1,expected_class),['TEST FAIL: ',testname,' -- 1st message parsed to incorrect type -- ACTUAL: ',test_class1,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class2,expected_class),['TEST FAIL: ',testname,' -- 2nd message parsed to incorrect type -- ACTUAL: ',test_class2,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class3,expected_class),['TEST FAIL: ',testname,' -- 3rd message parsed to incorrect type -- ACTUAL: ',test_class3,'  EXPECTED: ',expected_class]);

            test_id1 = newErrors{1}.id;
            test_id2 = newErrors{2}.id;
            test_id3 = newErrors{3}.id;
            assertTrue(strcmp(test_id1,id1),['TEST FAIL: ',testname,' -- bad message ID in 1st error -- ACTUAL: ',test_id1,'  EXPECTED: ',id1]);
            assertTrue(strcmp(test_id2,id2),['TEST FAIL: ',testname,' -- bad message ID in 2nd error -- ACTUAL: ',test_id2,'  EXPECTED: ',id2]);
            assertTrue(strcmp(test_id3,id3),['TEST FAIL: ',testname,' -- bad message ID in 3rd error -- ACTUAL: ',test_id3,'  EXPECTED: ',id3]);

            test_errcode1 = newErrors{1}.errcode;
            test_errcode2 = newErrors{2}.errcode;
            test_errcode3 = newErrors{3}.errcode;
            assertTrue(test_errcode1==errcode1,['TEST FAIL: ',testname,' -- bad errcode in 1st error -- ACTUAL: ',int2str(test_errcode1),'  EXPECTED: ',int2str(errcode1)]);
            assertTrue(test_errcode2==errcode2,['TEST FAIL: ',testname,' -- bad errcode in 2nd error -- ACTUAL: ',int2str(test_errcode2),'  EXPECTED: ',int2str(errcode2)]);
            assertTrue(test_errcode3==errcode3,['TEST FAIL: ',testname,' -- bad errcode in 3rd error -- ACTUAL: ',int2str(test_errcode3),'  EXPECTED: ',int2str(errcode3)]);

            test_errmsg1 = newErrors{1}.errmsg;
            test_errmsg2 = newErrors{2}.errmsg;
            test_errmsg3 = newErrors{3}.errmsg;
            assertTrue(strcmp(test_errmsg1,errmsg1),['TEST FAIL: ',testname,' -- bad errmsg in 1st error -- ACTUAL: ',test_errmsg1,'  EXPECTED: ',errmsg1]);
            assertTrue(strcmp(test_errmsg2,errmsg2),['TEST FAIL: ',testname,' -- bad errmsg in 2nd error -- ACTUAL: ',test_errmsg2,'  EXPECTED: ',errmsg2]);
            assertTrue(strcmp(test_errmsg3,errmsg3),['TEST FAIL: ',testname,' -- bad errmsg in 3rd error -- ACTUAL: ',test_errmsg3,'  EXPECTED: ',errmsg3]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Parser',testname);

        end % test_parseJSONRPC2Messages_multiErrors %            
 
        %% --------------------------------------------------------------------
        %   test_parseJSONRPC2Messages_multiMixRequestsNotifications
        %% --------------------------------------------------------------------
        function test_parseJSONRPC2Messages_multiMixRequestsNotifications(this)

            testname = 'test_parseJSONRPC2Messages_multiMixRequestsNotifications';

            %-------------------------
            % setup test
            %-------------------------
            id1     = 'req-1';
            method1 = 'concat';
            params1 = struct;
            params1.s1 = 'Hello';
            params1.s2 = 'World';
            params1.sep = ' ';
            
            requestMsg1 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"method": "',method1,'",', ...
                '"params": { "s1": "',params1.s1,'", "s2": "',params1.s2,'", "sep": "',params1.sep,'" },', ...
                '"id": "',id1,'"', ...
            '}'];

            id2     = 'req-2';
            method2 = 'echo';
            params2 = struct;
            params2.text = 'Goodbye World';
            
            notificationMsg2 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"method": "',method2,'",', ...
                '"params": [ "',params2.text,'" ]', ...
            '}'];

            id3     = 'req-3';
            method3 = 'whichMethod';
            
            requestMsg3 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"method": "',method3,'",', ...
                '"id": "',id3,'"', ...
            '}'];

            requestMsgs = ['[',requestMsg1,',',notificationMsg2,',',requestMsg3,']'];
            
            %-------------------------
            % run method being tested
            %-------------------------
            parser = jsonrpc2.JSONRPC2Parser();
            newMessages = parser.parseJSONRPC2Messages(requestMsgs);

            %-------------------------
            % test
            %-------------------------
            assertTrue(iscell(newMessages),['TEST FAIL: ',testname,' -- multiple messages are not parsed into cell array']);
            
            test_size = length(newMessages);  
            assertTrue(test_size==3,['TEST FAIL: ',testname,' -- multiple messages array is wrong size -- ACTUAL: ',test_size,'  EXPECTED: 3']);

            expected_class = 'jsonrpc2.JSONRPC2Request';
            test_class1 = class(newMessages{1});
            test_class3 = class(newMessages{3});
            assertTrue(strcmp(test_class1,expected_class),['TEST FAIL: ',testname,' -- 1st message parsed to incorrect type -- ACTUAL: ',test_class1,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class3,expected_class),['TEST FAIL: ',testname,' -- 3rd message parsed to incorrect type -- ACTUAL: ',test_class3,'  EXPECTED: ',expected_class]);

            expected_class = 'jsonrpc2.JSONRPC2Notification';
            test_class2 = class(newMessages{2});
            assertTrue(strcmp(test_class2,expected_class),['TEST FAIL: ',testname,' -- 2nd message parsed to incorrect type -- ACTUAL: ',test_class2,'  EXPECTED: ',expected_class]);

            test_id1 = newMessages{1}.id;
            test_id3 = newMessages{3}.id;
            assertTrue(strcmp(test_id1,id1),['TEST FAIL: ',testname,' -- bad message ID in 1st request -- ACTUAL: ',test_id1,'  EXPECTED: ',id1]);
            assertTrue(strcmp(test_id3,id3),['TEST FAIL: ',testname,' -- bad message ID in 3rd request -- ACTUAL: ',test_id3,'  EXPECTED: ',id3]);

            caughtExpectedException = false;
            try
                test_id2 = newMessages{2}.id;
            catch Exception
                caughtExpectedException = true;
            end
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- attempt to get id from a notification did not throw exception']);


            test_method1 = newMessages{1}.method;
            test_method2 = newMessages{2}.method;
            test_method3 = newMessages{3}.method;
            assertTrue(strcmp(test_method1,method1),['TEST FAIL: ',testname,' -- bad method in 1st request -- ACTUAL: ',test_method1,'  EXPECTED: ',method1]);
            assertTrue(strcmp(test_method2,method2),['TEST FAIL: ',testname,' -- bad method in 2nd notification -- ACTUAL: ',test_method2,'  EXPECTED: ',method2]);
            assertTrue(strcmp(test_method3,method3),['TEST FAIL: ',testname,' -- bad method in 3rd request -- ACTUAL: ',test_method3,'  EXPECTED: ',method3]);

            assertTrue(newMessages{1}.hasParameters(),['TEST FAIL: ',testname,' -- 1st request thinks it doesn''t have parameters.']);
            assertTrue(newMessages{2}.hasParameters(),['TEST FAIL: ',testname,' -- 2nd notification thinks it doesn''t have parameters.']);
            assertFalse(newMessages{3}.hasParameters(),['TEST FAIL: ',testname,' -- 3rd request thinks it has parameters.']);
            assertFalse(newMessages{1}.hasPositionalParameters(),['TEST FAIL: ',testname,' -- 1st request thinks it has positional parameters.']);
            assertTrue(newMessages{2}.hasPositionalParameters(),['TEST FAIL: ',testname,' -- 2nd notification thinks it doesn''t have positional parameters.']);
            assertFalse(newMessages{3}.hasPositionalParameters(),['TEST FAIL: ',testname,' -- 3rd request thinks it has positional parameters.']);
            assertTrue(newMessages{1}.hasNamedParameters(),['TEST FAIL: ',testname,' -- 1st request thinks it doesn''t have named parameters.']);
            assertFalse(newMessages{2}.hasNamedParameters(),['TEST FAIL: ',testname,' -- 2nd notification thinks it has named parameters.']);
            assertFalse(newMessages{3}.hasNamedParameters(),['TEST FAIL: ',testname,' -- 3rd request thinks it has named parameters.']);

            test_params1 = newMessages{1}.params;
            test_params2 = newMessages{2}.params;
            assertTrue(strcmp(class(test_params1),'jsonrpc2.NamedParamsRetriever'),['TEST FAIL: ',testname,' -- params in request are not named parameters -- ACTUAL: ',class(test_params1),'  EXPECTED: NamedParamsRetriever']);
            assertTrue(strcmp(class(test_params2),'jsonrpc2.PositionalParamsRetriever'),['TEST FAIL: ',testname,' -- params in request are not positional parameters -- ACTUAL: ',class(test_params2),'  EXPECTED: PositionalParamsRetriever']);

            assertTrue(test_params1.hasParam('s1'),['TEST FAIL: ',testname,' -- field s1 does not exist in params in 1st request']);
            assertTrue(test_params1.hasParam('s2'),['TEST FAIL: ',testname,' -- field s2 does not exist in params in 1st request']);
            assertTrue(test_params1.hasParam('sep'),['TEST FAIL: ',testname,' -- field sep does not exist in params in 1st request']);
            
            assertTrue(test_params2.hasParam(1),['TEST FAIL: ',testname,' -- field 1 does not exist in params in 2nd notification']);
           
            test1_s1  = test_params1.get('s1');
            test1_s2  = test_params1.get('s2');
            test1_sep = test_params1.get('sep');
            assertTrue(strcmp(test1_s1,params1.s1),['TEST FAIL: ',testname,' -- bad s1 value in 1st request -- ACTUAL: ',test1_s1,'  EXPECTED: ',params1.s1]);
            assertTrue(strcmp(test1_s2,params1.s2),['TEST FAIL: ',testname,' -- bad s2 value in 1st request -- ACTUAL: ',test1_s2,'  EXPECTED: ',params1.s2]);
            assertTrue(strcmp(test1_sep,params1.sep),['TEST FAIL: ',testname,' -- bad sep value in 1st request -- ACTUAL: ',test1_sep,'  EXPECTED: ',params1.sep]);

            test2_text = test_params2.get(1);
            assertTrue(strcmp(test2_text,params2.text),['TEST FAIL: ',testname,' -- bad parm1 value in request -- ACTUAL: ',test2_text,'  EXPECTED: ',params2.text]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Parser',testname);

        end % test_parseJSONRPC2Messages_multiMixRequestsNotifications %            
 
        %% --------------------------------------------------------------------
        %   test_parseJSONRPC2Messages_multiMixResponsesErrors
        %% --------------------------------------------------------------------
        function test_parseJSONRPC2Messages_multiMixResponsesErrors(this)

            testname = 'test_parseJSONRPC2Messages_multiMixResponsesErrors';

            %-------------------------
            % setup test
            %-------------------------
            id1     = 'req-1';
            result1 = 'SUCCESS-1';
            
            responseMsg1 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"result": "',result1,'",', ...
                '"id": "',id1,'"', ...
            '}'];

            id2      = 'req-2';
            errmsg2  = 'FAILURE: Method Not Found';
            errcode2 = jsonrpc2.JSONRPC2Error.JSON_METHOD_NOT_FOUND;
                        
            errorMsg2 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"id": "',id2,'",', ...
                '"error": { ', ...
                    '"code": ',int2str(errcode2),',', ...
                    '"message": "',errmsg2,'"', ...
                '}', ...
            '}'];

            id3     = 'req-3';
            result3 = 'SUCCESS-3';
            
            responseMsg3 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"result": "',result3,'",', ...
                '"id": "',id3,'"', ...
            '}'];

            responseMsgs = ['[',responseMsg1,',',errorMsg2,',',responseMsg3,']'];
            
            %-------------------------
            % run method being tested
            %-------------------------
            parser = jsonrpc2.JSONRPC2Parser();
            newMessages = parser.parseJSONRPC2Messages(responseMsgs);

            %-------------------------
            % test
            %-------------------------
            assertTrue(iscell(newMessages),['TEST FAIL: ',testname,' -- multiple messages are not parsed into cell array']);
            
            test_size = length(newMessages);  
            assertTrue(test_size==3,['TEST FAIL: ',testname,' -- multiple messages array is wrong size -- ACTUAL: ',test_size,'  EXPECTED: 3']);

            expected_class = 'jsonrpc2.JSONRPC2Response';
            test_class1 = class(newMessages{1});
            test_class3 = class(newMessages{3});
            assertTrue(strcmp(test_class1,expected_class),['TEST FAIL: ',testname,' -- 1st message parsed to incorrect type -- ACTUAL: ',test_class1,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class3,expected_class),['TEST FAIL: ',testname,' -- 3rd message parsed to incorrect type -- ACTUAL: ',test_class3,'  EXPECTED: ',expected_class]);

            expected_class = 'jsonrpc2.JSONRPC2Error';
            test_class2 = class(newMessages{2});
            assertTrue(strcmp(test_class2,expected_class),['TEST FAIL: ',testname,' -- 2nd message parsed to incorrect type -- ACTUAL: ',test_class2,'  EXPECTED: ',expected_class]);

            test_id1 = newMessages{1}.id;
            test_id2 = newMessages{2}.id;
            test_id3 = newMessages{3}.id;
            assertTrue(strcmp(test_id1,id1),['TEST FAIL: ',testname,' -- bad message ID in 1st response -- ACTUAL: ',test_id1,'  EXPECTED: ',id1]);
            assertTrue(strcmp(test_id2,id2),['TEST FAIL: ',testname,' -- bad message ID in 2nd response -- ACTUAL: ',test_id2,'  EXPECTED: ',id2]);
            assertTrue(strcmp(test_id3,id3),['TEST FAIL: ',testname,' -- bad message ID in 3rd response -- ACTUAL: ',test_id3,'  EXPECTED: ',id3]);

            test_result1 = newMessages{1}.result;
            test_result3 = newMessages{3}.result;
            assertTrue(strcmp(test_result1,result1),['TEST FAIL: ',testname,' -- bad result in 1st response -- ACTUAL: ',test_result1,'  EXPECTED: ',result1]);
            assertTrue(strcmp(test_result3,result3),['TEST FAIL: ',testname,' -- bad result in 3rd response -- ACTUAL: ',test_result3,'  EXPECTED: ',result3]);

            test_errmsg2 = newMessages{2}.errmsg;
            assertTrue(strcmp(test_errmsg2,errmsg2),['TEST FAIL: ',testname,' -- bad error message in 2nd response -- ACTUAL: ',test_errmsg2,'  EXPECTED: ',errmsg2]);

            test_errcode2 = newMessages{2}.errcode;
            assertTrue(test_errcode2==errcode2,['TEST FAIL: ',testname,' -- bad error code in error 2nd -- ACTUAL: ',int2str(test_errcode2),'  EXPECTED: ',int2str(errcode2)]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Parser',testname);

        end % test_parseJSONRPC2Messages_multiMixResponsesErrors %            

        %% --------------------------------------------------------------------
        %   test_parseJSONRPC2Messages_multiRequestsWithExceptions
        %% --------------------------------------------------------------------
        function test_parseJSONRPC2Messages_multiRequestsWithExceptions(this)

            testname = 'test_parseJSONRPC2Messages_multiRequestsWithExceptions';

            %-------------------------
            % setup test
            %-------------------------
            id1     = 'req-1';
            method1 = 'concat';
            params1 = struct;
            params1.s1 = 'Hello';
            params1.s2 = 'World';
            params1.sep = ' ';
            
            requestMsg1 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"method": "',method1,'",', ...
                '"params": { "s1": "',params1.s1,'", "s2": "',params1.s2,'", "sep": "',params1.sep,'" },', ...
                '"id": "',id1,'"', ...
            '}'];  % good %

            id2     = 'req-2';
            method2 = 'echo';
            params2 = struct;
            params2.text = 'Goodbye World';
            
            requestMsg2 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"params": [ "',params2.text,'" ],', ...
                '"id": "',id2,'"', ...
            '}'];  % missing method %

            id3     = 'req-3';
            method3 = 'whichMethod';
            
            requestMsg3 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"method": "',method3,'",', ...
                '"id": "',id3,'"', ...
            '}'];  % good %

            requestMsgs = ['[',requestMsg1,',',requestMsg2,',',requestMsg3,']'];
            
            %-------------------------
            % run method being tested
            %-------------------------
            parser = jsonrpc2.JSONRPC2Parser();
            newRequests = parser.parseJSONRPC2Messages(requestMsgs);

            %-------------------------
            % test
            %-------------------------
            assertTrue(iscell(newRequests),['TEST FAIL: ',testname,' -- multiple messages are not parsed into cell array']);
            
            test_size = length(newRequests);  
            assertTrue(test_size==3,['TEST FAIL: ',testname,' -- multiple messages array is wrong size -- ACTUAL: ',test_size,'  EXPECTED: 3']);

            expected_class = 'jsonrpc2.JSONRPC2Request';
            test_class1 = class(newRequests{1});
            test_class2 = class(newRequests{2});
            test_class3 = class(newRequests{3});
            assertTrue(strcmp(test_class1,expected_class),['TEST FAIL: ',testname,' -- 1st message parsed to incorrect type -- ACTUAL: ',test_class1,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class2,'double'),['TEST FAIL: ',testname,' -- 2nd message parsed to incorrect type -- ACTUAL: ',test_class3,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class3,expected_class),['TEST FAIL: ',testname,' -- 3rd message parsed to incorrect type -- ACTUAL: ',test_class3,'  EXPECTED: ',expected_class]);

            test_error = newRequests{2};
            assertTrue(test_error==jsonrpc2.JSONRPC2Error.JSON_PARSE_ERROR,['TEST FAIL: ',testname,' -- 3rd message error code is wrong -- ACTUAL: ',int2str(test_error),'  EXPECTED: ',int2str(jsonrpc2.JSONRPC2Error.JSON_PARSE_ERROR)]);
            
            test_id1 = newRequests{1}.id;
%            test_id2 = newRequests{2}.id;  % HAS ERROR, so no ID
            test_id3 = newRequests{3}.id;
            assertTrue(strcmp(test_id1,id1),['TEST FAIL: ',testname,' -- bad message ID in 1st request -- ACTUAL: ',test_id1,'  EXPECTED: ',id1]);
%            assertTrue(strcmp(test_id2,id2),['TEST FAIL: ',testname,' -- bad message ID in 2nd request -- ACTUAL: ',test_id2,'  EXPECTED: ',id2]);
            assertTrue(strcmp(test_id3,id3),['TEST FAIL: ',testname,' -- bad message ID in 3rd request -- ACTUAL: ',test_id3,'  EXPECTED: ',id3]);

            test_method1 = newRequests{1}.method;
%            test_method2 = newRequests{2}.method;  % HAS ERROR, so no method
            test_method3 = newRequests{3}.method;
            assertTrue(strcmp(test_method1,method1),['TEST FAIL: ',testname,' -- bad method in 1st request -- ACTUAL: ',test_method1,'  EXPECTED: ',method1]);
%            assertTrue(strcmp(test_method2,method2),['TEST FAIL: ',testname,' -- bad method in 2nd request -- ACTUAL: ',test_method2,'  EXPECTED: ',method2]);
            assertTrue(strcmp(test_method3,method3),['TEST FAIL: ',testname,' -- bad method in 3rd request -- ACTUAL: ',test_method3,'  EXPECTED: ',method3]);

            assertTrue(newRequests{1}.hasParameters(),['TEST FAIL: ',testname,' -- 1st request thinks it doesn''t have parameters.']);
%            assertTrue(newRequests{2}.hasParameters(),['TEST FAIL: ',testname,' -- 2nd request thinks it doesn''t have parameters.']);
            assertFalse(newRequests{3}.hasParameters(),['TEST FAIL: ',testname,' -- 3rd request thinks it has parameters.']);
            assertFalse(newRequests{1}.hasPositionalParameters(),['TEST FAIL: ',testname,' -- 1st request thinks it has positional parameters.']);
%            assertTrue(newRequests{2}.hasPositionalParameters(),['TEST FAIL: ',testname,' -- 2nd request thinks it doesn''t have positional parameters.']);
            assertFalse(newRequests{3}.hasPositionalParameters(),['TEST FAIL: ',testname,' -- 3rd request thinks it has positional parameters.']);
            assertTrue(newRequests{1}.hasNamedParameters(),['TEST FAIL: ',testname,' -- 1st request thinks it doesn''t have named parameters.']);
%            assertFalse(newRequests{2}.hasNamedParameters(),['TEST FAIL: ',testname,' -- 2nd request thinks it has named parameters.']);
            assertFalse(newRequests{3}.hasNamedParameters(),['TEST FAIL: ',testname,' -- 3rd request thinks it has named parameters.']);

            test_params1 = newRequests{1}.params;
%            test_params2 = newRequests{2}.params;  % HAS ERROR, so no params
            assertTrue(strcmp(class(test_params1),'jsonrpc2.NamedParamsRetriever'),['TEST FAIL: ',testname,' -- params in request are not named parameters -- ACTUAL: ',class(test_params1),'  EXPECTED: NamedParamsRetriever']);
%            assertTrue(strcmp(class(test_params2),'jsonrpc2.PositionalParamsRetriever'),['TEST FAIL: ',testname,' -- params in request are not positional parameters -- ACTUAL: ',class(test_params2),'  EXPECTED: PositionalParamsRetriever']);

            assertTrue(test_params1.hasParam('s1'),['TEST FAIL: ',testname,' -- field s1 does not exist in params in 1st request']);
            assertTrue(test_params1.hasParam('s2'),['TEST FAIL: ',testname,' -- field s2 does not exist in params in 1st request']);
            assertTrue(test_params1.hasParam('sep'),['TEST FAIL: ',testname,' -- field sep does not exist in params in 1st request']);
            
%            assertTrue(test_params2.hasParam(1),['TEST FAIL: ',testname,' -- field 1 does not exist in params in 2nd request']);
           
            test1_s1  = test_params1.get('s1');
            test1_s2  = test_params1.get('s2');
            test1_sep = test_params1.get('sep');
            assertTrue(strcmp(test1_s1,params1.s1),['TEST FAIL: ',testname,' -- bad s1 value in 1st request -- ACTUAL: ',test1_s1,'  EXPECTED: ',params1.s1]);
            assertTrue(strcmp(test1_s2,params1.s2),['TEST FAIL: ',testname,' -- bad s2 value in 1st request -- ACTUAL: ',test1_s2,'  EXPECTED: ',params1.s2]);
            assertTrue(strcmp(test1_sep,params1.sep),['TEST FAIL: ',testname,' -- bad sep value in 1st request -- ACTUAL: ',test1_sep,'  EXPECTED: ',params1.sep]);

%            test2_text = test_params2.get(1);
%            assertTrue(strcmp(test2_text,params2.text),['TEST FAIL: ',testname,' -- bad parm1 value in request -- ACTUAL: ',test2_text,'  EXPECTED: ',params2.text]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Parser',testname);

        end % test_parseJSONRPC2Messages_multiRequestsWithExceptions %            
 
        %% --------------------------------------------------------------------
        %   test_parseJSONRPC2Messages_multiResponsesWithExceptions
        %% --------------------------------------------------------------------
        function test_parseJSONRPC2Messages_multiResponsesWithExceptions(this)

            testname = 'test_parseJSONRPC2Messages_multiResponsesWithExceptions';

            %-------------------------
            % setup test
            %-------------------------
            id1     = 'req-1';
            result1 = 'SUCCESS-1';
            
            responseMsg1 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"result": "',result1,'",', ...
                '"id": "',id1,'"', ...
            '}'];  % good %

            id2     = 'req-2';
            result2 = 'SUCCESS-2';
            
            responseMsg2 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"result": "',result2,'",', ...
                '"id": "',id2,'"', ...
            '}'];  % good %

            id3     = 'req-3';
            result3 = 'SUCCESS-3';
            
            responseMsg3 = ['{', ...
                '"jsonrpc": "2.0",', ...
                '"id": "',id3,'"', ...
            '}'];  % missing result %

            responseMsgs = ['[',responseMsg1,',',responseMsg2,',',responseMsg3,']'];
            
            %-------------------------
            % run method being tested
            %-------------------------
            parser = jsonrpc2.JSONRPC2Parser();
            newResponses = parser.parseJSONRPC2Messages(responseMsgs);

            %-------------------------
            % test
            %-------------------------
            assertTrue(iscell(newResponses),['TEST FAIL: ',testname,' -- multiple messages are not parsed into cell array']);
            
            test_size = length(newResponses);  
            assertTrue(test_size==3,['TEST FAIL: ',testname,' -- multiple messages array is wrong size -- ACTUAL: ',test_size,'  EXPECTED: 3']);

            expected_class = 'jsonrpc2.JSONRPC2Response';
            test_class1 = class(newResponses{1});
            test_class2 = class(newResponses{2});
            test_class3 = class(newResponses{3});
            assertTrue(strcmp(test_class1,expected_class),['TEST FAIL: ',testname,' -- 1st message parsed to incorrect type -- ACTUAL: ',test_class1,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class2,expected_class),['TEST FAIL: ',testname,' -- 2nd message parsed to incorrect type -- ACTUAL: ',test_class2,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class3,'double'),['TEST FAIL: ',testname,' -- 3rd message parsed to incorrect type -- ACTUAL: ',test_class3,'  EXPECTED: ',expected_class]);

            test_error = newResponses{3};
            assertTrue(test_error==jsonrpc2.JSONRPC2Error.JSON_PARSE_ERROR,['TEST FAIL: ',testname,' -- 3rd message error code is wrong -- ACTUAL: ',int2str(test_error),'  EXPECTED: ',int2str(jsonrpc2.JSONRPC2Error.JSON_PARSE_ERROR)]);
            
            test_id1 = newResponses{1}.id;
            test_id2 = newResponses{2}.id;
%            test_id3 = newResponses{3}.id;  % HAS ERROR, so no ID
            assertTrue(strcmp(test_id1,id1),['TEST FAIL: ',testname,' -- bad message ID in 1st response -- ACTUAL: ',test_id1,'  EXPECTED: ',id1]);
            assertTrue(strcmp(test_id2,id2),['TEST FAIL: ',testname,' -- bad message ID in 2nd response -- ACTUAL: ',test_id2,'  EXPECTED: ',id2]);
%            assertTrue(strcmp(test_id3,id3),['TEST FAIL: ',testname,' -- bad message ID in 3rd response -- ACTUAL: ',test_id3,'  EXPECTED: ',id3]);

            test_result1 = newResponses{1}.result;
            test_result2 = newResponses{2}.result;
%            test_result3 = newResponses{3}.result;   % HAS ERROR, so no result
            assertTrue(strcmp(test_result1,result1),['TEST FAIL: ',testname,' -- bad result in 1st response -- ACTUAL: ',test_result1,'  EXPECTED: ',result1]);
            assertTrue(strcmp(test_result2,result2),['TEST FAIL: ',testname,' -- bad result in 2nd response -- ACTUAL: ',test_result2,'  EXPECTED: ',result2]);
%            assertTrue(strcmp(test_result3,result3),['TEST FAIL: ',testname,' -- bad result in 3rd response -- ACTUAL: ',test_result3,'  EXPECTED: ',result3]);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Parser',testname);

        end % test_parseJSONRPC2Messages_multiResponsesWithExceptions %            

        %% --------------------------------------------------------------------
        %   test_parseJSONRPC2Messages_blankRequestString
        %% --------------------------------------------------------------------
        function test_parseJSONRPC2Messages_blankRequestString(this)

            testname = 'test_parseJSONRPC2Messages_blankRequestString';

            %-------------------------
            % setup test
            %-------------------------

            requestMsgs = '';
            
            %-------------------------
            % run method being tested
            %-------------------------
            parser = jsonrpc2.JSONRPC2Parser();
            caughtExpectedException = false;
            try
                newRequests = parser.parseJSONRPC2Messages(requestMsgs);
            catch Exception
                caughtExpectedException = true;
                expected_exception_identifier = 'JsonRpc:Invalid';
                expected_exception_message = 'Cannot parse empty JSON message. (-32700)';
                assertTrue(strcmp(Exception.identifier,expected_exception_identifier),['TEST FAIL: ',testname,' -- unexpected exception identifier -- ACTUAL: ',Exception.identifier,'  EXPECTED: ',expected_exception_identifier]);
                assertTrue(strcmp(Exception.message,expected_exception_message),['TEST FAIL: ',testname,' -- unexpected exception message -- ACTUAL: ',Exception.message,'  EXPECTED: ',expected_exception_message]);
            end
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- attempt to parse blank string did not throw exception']);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Parser',testname);

        end % test_parseJSONRPC2Messages_blankRequestString %            

        %% --------------------------------------------------------------------
        %   test_parseJSONRPC2Message_blankRequestString
        %% --------------------------------------------------------------------
        function test_parseJSONRPC2Message_blankRequestString(this)

            testname = 'test_parseJSONRPC2Message_blankRequestString';

            %-------------------------
            % setup test
            %-------------------------

            requestMsg = '';
            
            %-------------------------
            % run method being tested
            %-------------------------
            parser = jsonrpc2.JSONRPC2Parser();
            caughtExpectedException = false;
            try
                newRequest = parser.parseJSONRPC2Message(requestMsg);
            catch Exception
                caughtExpectedException = true;
                expected_exception_identifier = 'JsonRpc:Invalid';
                expected_exception_message = 'Cannot parse empty JSON message. (-32700)';
                assertTrue(strcmp(Exception.identifier,expected_exception_identifier),['TEST FAIL: ',testname,' -- unexpected exception identifier -- ACTUAL: ',Exception.identifier,'  EXPECTED: ',expected_exception_identifier]);
                assertTrue(strcmp(Exception.message,expected_exception_message),['TEST FAIL: ',testname,' -- unexpected exception message -- ACTUAL: ',Exception.message,'  EXPECTED: ',expected_exception_message]);
           end
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- attempt to parse blank string did not throw exception']);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Parser',testname);

        end % test_parseJSONRPC2Message_blankRequestString %            

        %% --------------------------------------------------------------------
        %   test_parseJSONRPC2Messages_numericRequestString
        %% --------------------------------------------------------------------
        function test_parseJSONRPC2Messages_numericRequestString(this)

            testname = 'test_parseJSONRPC2Messages_numericRequestString';

            %-------------------------
            % setup test
            %-------------------------

            requestMsgs = 2;
            
            %-------------------------
            % run method being tested
            %-------------------------
            parser = jsonrpc2.JSONRPC2Parser();
            caughtExpectedException = false;
            try
                newRequests = parser.parseJSONRPC2Messages(requestMsgs);
            catch Exception
                caughtExpectedException = true;
                expected_exception_identifier = 'Parameter:InvalidType';
                expected_exception_message = 'Parameter ''jsonString'' must be a string.';
                assertTrue(strcmp(Exception.identifier,expected_exception_identifier),['TEST FAIL: ',testname,' -- unexpected exception identifier -- ACTUAL: ',Exception.identifier,'  EXPECTED: ',expected_exception_identifier]);
                assertTrue(strcmp(Exception.message,expected_exception_message),['TEST FAIL: ',testname,' -- unexpected exception message -- ACTUAL: ',Exception.message,'  EXPECTED: ',expected_exception_message]);
            end
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- attempt to parse numeric message did not throw exception']);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Parser',testname);

        end % test_parseJSONRPC2Messages_numericRequestString %            

        %% --------------------------------------------------------------------
        %   test_parseJSONRPC2Message_numericRequestString
        %% --------------------------------------------------------------------
        function test_parseJSONRPC2Message_numericRequestString(this)

            testname = 'test_parseJSONRPC2Message_numericRequestString';

            %-------------------------
            % setup test
            %-------------------------

            requestMsg = 2;
            
            %-------------------------
            % run method being tested
            %-------------------------
            parser = jsonrpc2.JSONRPC2Parser();
            caughtExpectedException = false;
            try
                newRequest = parser.parseJSONRPC2Message(requestMsg);
            catch Exception
                caughtExpectedException = true;
                expected_exception_identifier = 'Parameter:InvalidType';
                expected_exception_message = 'Parameter ''jsonString'' must be a string.';
                assertTrue(strcmp(Exception.identifier,expected_exception_identifier),['TEST FAIL: ',testname,' -- unexpected exception identifier -- ACTUAL: ',Exception.identifier,'  EXPECTED: ',expected_exception_identifier]);
                assertTrue(strcmp(Exception.message,expected_exception_message),['TEST FAIL: ',testname,' -- unexpected exception message -- ACTUAL: ',Exception.message,'  EXPECTED: ',expected_exception_message]);
            end
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- attempt to parse numeric message did not throw exception']);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Parser',testname);

        end % test_parseJSONRPC2Message_numericRequestString %            

        %% --------------------------------------------------------------------
        %   test_parseJSONRPC2Messages_structRequestString
        %% --------------------------------------------------------------------
        function test_parseJSONRPC2Messages_structRequestString(this)

            testname = 'test_parseJSONRPC2Messages_structRequestString';

            %-------------------------
            % setup test
            %-------------------------

            requestMsgs = struct;
            requestMsgs.id=1;
            requestMsgs.method='foo';
            
            %-------------------------
            % run method being tested
            %-------------------------
            parser = jsonrpc2.JSONRPC2Parser();
            caughtExpectedException = false;
            try
                newRequests = parser.parseJSONRPC2Messages(requestMsgs);
            catch Exception
                caughtExpectedException = true;
                expected_exception_identifier = 'Parameter:InvalidType';
                expected_exception_message = 'Parameter ''jsonString'' must be a string.';
                assertTrue(strcmp(Exception.identifier,expected_exception_identifier),['TEST FAIL: ',testname,' -- unexpected exception identifier -- ACTUAL: ',Exception.identifier,'  EXPECTED: ',expected_exception_identifier]);
                assertTrue(strcmp(Exception.message,expected_exception_message),['TEST FAIL: ',testname,' -- unexpected exception message -- ACTUAL: ',Exception.message,'  EXPECTED: ',expected_exception_message]);
            end
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- attempt to parse numeric message did not throw exception']);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Parser',testname);

        end % test_parseJSONRPC2Messages_structRequestString %            

        %% --------------------------------------------------------------------
        %   test_parseJSONRPC2Message_structRequestString
        %% --------------------------------------------------------------------
        function test_parseJSONRPC2Message_structRequestString(this)

            testname = 'test_parseJSONRPC2Message_structRequestString';

            %-------------------------
            % setup test
            %-------------------------

            requestMsg = struct;
            requestMsg.id=1;
            requestMsg.method='foo';
            
            %-------------------------
            % run method being tested
            %-------------------------
            parser = jsonrpc2.JSONRPC2Parser();
            caughtExpectedException = false;
            try
                newRequest = parser.parseJSONRPC2Message(requestMsg);
            catch Exception
                caughtExpectedException = true;
                expected_exception_identifier = 'Parameter:InvalidType';
                expected_exception_message = 'Parameter ''jsonString'' must be a string.';
                assertTrue(strcmp(Exception.identifier,expected_exception_identifier),['TEST FAIL: ',testname,' -- unexpected exception identifier -- ACTUAL: ',Exception.identifier,'  EXPECTED: ',expected_exception_identifier]);
                assertTrue(strcmp(Exception.message,expected_exception_message),['TEST FAIL: ',testname,' -- unexpected exception message -- ACTUAL: ',Exception.message,'  EXPECTED: ',expected_exception_message]);
            end
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- attempt to parse numeric message did not throw exception']);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Parser',testname);

        end % test_parseJSONRPC2Message_structRequestString %            

        %% --------------------------------------------------------------------
        %   test_parseJSONRPC2Messages_cellRequestString
        %% --------------------------------------------------------------------
        function test_parseJSONRPC2Messages_cellRequestString(this)

            testname = 'test_parseJSONRPC2Messages_cellRequestString';

            %-------------------------
            % setup test
            %-------------------------

            requestMsgs = cell(1,2);
            requestMsgs{1,1}=1;
            requestMsgs{1,2}='foo';
            
            %-------------------------
            % run method being tested
            %-------------------------
            parser = jsonrpc2.JSONRPC2Parser();
            caughtExpectedException = false;
            try
                newRequests = parser.parseJSONRPC2Messages(requestMsgs);
            catch Exception
                caughtExpectedException = true;
                expected_exception_identifier = 'Parameter:InvalidType';
                expected_exception_message = 'Parameter ''jsonString'' must be a string.';
                assertTrue(strcmp(Exception.identifier,expected_exception_identifier),['TEST FAIL: ',testname,' -- unexpected exception identifier -- ACTUAL: ',Exception.identifier,'  EXPECTED: ',expected_exception_identifier]);
                assertTrue(strcmp(Exception.message,expected_exception_message),['TEST FAIL: ',testname,' -- unexpected exception message -- ACTUAL: ',Exception.message,'  EXPECTED: ',expected_exception_message]);
            end
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- attempt to parse numeric message did not throw exception']);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Parser',testname);

        end % test_parseJSONRPC2Messages_cellRequestString %            

        %% --------------------------------------------------------------------
        %   test_parseJSONRPC2Message_cellRequestString
        %% --------------------------------------------------------------------
        function test_parseJSONRPC2Message_cellRequestString(this)

            testname = 'test_parseJSONRPC2Message_cellRequestString';

            %-------------------------
            % setup test
            %-------------------------

            requestMsg = cell(1,2);
            requestMsg{1,1}=1;
            requestMsg{1,2}='foo';
            
            %-------------------------
            % run method being tested
            %-------------------------
            parser = jsonrpc2.JSONRPC2Parser();
            caughtExpectedException = false;
            try
                newRequest = parser.parseJSONRPC2Message(requestMsg);
            catch Exception
                caughtExpectedException = true;
                expected_exception_identifier = 'Parameter:InvalidType';
                expected_exception_message = 'Parameter ''jsonString'' must be a string.';
                assertTrue(strcmp(Exception.identifier,expected_exception_identifier),['TEST FAIL: ',testname,' -- unexpected exception identifier -- ACTUAL: ',Exception.identifier,'  EXPECTED: ',expected_exception_identifier]);
                assertTrue(strcmp(Exception.message,expected_exception_message),['TEST FAIL: ',testname,' -- unexpected exception message -- ACTUAL: ',Exception.message,'  EXPECTED: ',expected_exception_message]);
            end
            assertTrue(caughtExpectedException,['TEST FAIL: ',testname,' -- attempt to parse numeric message did not throw exception']);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Parser',testname);

        end % test_parseJSONRPC2Message_cellRequestString %            

    end % methods %
    
end % classdef %

        
