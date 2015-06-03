% Tests for ParamsRetriever class and subclasses
%
% Copyright (c) 2014, Cornell University, Lab of Ornithology
% All rights reserved.
%
% Distributed under BSD license.  See LICENSE_BSD.txt for full license.
% 
% Author: E. L. Rayle
% date: 01/22/2014
%
% COMMAND TO RUN THESE TESTS:  runtests jsonrpc2Tests.TestParamsRetriever
%

classdef TestParamsRetriever < TestCase

% =============================================================================
%                             Setup & Teardown
% =============================================================================
    methods
        function this = TestParamsRetriever(name)
            this = this@TestCase(name);
        end

        function setUp(this)
        end

        function tearDown(this)
        end


% =============================================================================
%                         Constructor Method Tests
% =============================================================================
        function test_ParamsRetriever_constructor(this)

            testname = 'test_ParamsRetriever_constructor';

            %-------------------------
            % setup test
            %-------------------------
            
            %-------------------------
            % run method being tested
            %-------------------------
            newParams = jsonrpc2.ParamsRetriever();
            
            %-------------------------
            % test
            %-------------------------
            expected_class = 'jsonrpc2.ParamsRetriever';
            test_class     = class(newParams);
            assertTrue(strcmp(test_class,expected_class),['TEST FAIL: ',testname,' -- message parsed to incorrect params type -- ACTUAL: ',test_class,'  EXPECTED: ',expected_class]);

            assertFalse(newParams.hasParameters(),['TEST FAIL: ',testname,' -- request thinks it has parameters.']);
            assertFalse(newParams.hasPositionalParameters(),['TEST FAIL: ',testname,' -- request thinks it has positional parameters.']);
            assertFalse(newParams.hasNamedParameters(),['TEST FAIL: ',testname,' -- request thinks it has named parameters.']);

            jsonrpc2Tests.log_passingTest('TestJSONRPC2Request',testname);

        end % test_JSONRPC2Request_constructor %

% =============================================================================
%                        Factory Method Tests for No Params
% =============================================================================

        %% --------------------------------------------------------------------
        %   test_factory_withNoParams
        %% --------------------------------------------------------------------
        function test_factory_withNoParams(this)

            testname = 'test_factory_withNoParams';

            %-------------------------
            % setup test
            %-------------------------

            %-------------------------
            % run method being tested
            %-------------------------
            newParams = jsonrpc2.ParamsRetriever.Factory();

            %-------------------------
            % test
            %-------------------------
            expected_class = 'jsonrpc2.ParamsRetriever';
            test_class     = class(newParams);
            assertTrue(strcmp(test_class,expected_class),['TEST FAIL: ',testname,' -- message parsed to incorrect params type -- ACTUAL: ',test_class,'  EXPECTED: ',expected_class]);

            assertFalse(newParams.hasParameters(),['TEST FAIL: ',testname,' -- request thinks it has parameters.']);
            assertFalse(newParams.hasPositionalParameters(),['TEST FAIL: ',testname,' -- request thinks it has positional parameters.']);
            assertFalse(newParams.hasNamedParameters(),['TEST FAIL: ',testname,' -- request thinks it has named parameters.']);
 
            assertTrue(newParams.size==0,['TEST FAIL: ',testname,' -- no param message size is incorrect -- ACTUAL: ',int2str(newParams.size),'  EXPECTED: 0']);
 
            jsonrpc2Tests.log_passingTest('TestParamsRetriever',testname);

        end % test_factory_withNoParams %


% =============================================================================
%                     Factory Method Tests for Named Params
% =============================================================================

        %% --------------------------------------------------------------------
        %   test_factory_withNamedParams_allchar
        %% --------------------------------------------------------------------
        function test_factory_withNamedParams_allchar(this)

            testname = 'test_factory_withNamedParams_allchar';

            %-------------------------
            % setup test
            %-------------------------
            params = struct;
            params.s1 = 'Hello';
            params.s2 = 'World';
            params.sep = ' ';
            
            paramsJson1 = ['{"params": { "s1": "',params.s1,'" }}'];                                                     % test one char param
            paramsJsonlab1 = loadjson(paramsJson1);

            paramsJson2 = ['{"params": { "s1": "',params.s1,'", "s2": "',params.s2,'" }}'];                              % test two char params
            paramsJsonlab2 = loadjson(paramsJson2);

            paramsJson3 = ['{"params": { "s1": "',params.s1,'", "s2": "',params.s2,'", "sep": "',params.sep,'" }}'];     % test three char params
            paramsJsonlab3 = loadjson(paramsJson3);

            %-------------------------
            % run method being tested
            %-------------------------
            newParams1 = jsonrpc2.ParamsRetriever.Factory(paramsJsonlab1.params);
            newParams2 = jsonrpc2.ParamsRetriever.Factory(paramsJsonlab2.params);
            newParams3 = jsonrpc2.ParamsRetriever.Factory(paramsJsonlab3.params);

            %-------------------------
            % test
            %-------------------------
            expected_class = 'jsonrpc2.NamedParamsRetriever';
            
            test_class1 = class(newParams1);
            test_class2 = class(newParams2);
            test_class3 = class(newParams3);
            assertTrue(strcmp(test_class1,expected_class),['TEST FAIL: ',testname,' -- one char message parsed to incorrect params type -- ACTUAL: ',test_class1,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class2,expected_class),['TEST FAIL: ',testname,' -- two char message parsed to incorrect params type -- ACTUAL: ',test_class2,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class3,expected_class),['TEST FAIL: ',testname,' -- three char message parsed to incorrect params type -- ACTUAL: ',test_class3,'  EXPECTED: ',expected_class]);

            assertTrue(newParams1.hasParameters(),['TEST FAIL: ',testname,' -- one char param message thinks it doesn''t have parameters.']);
            assertTrue(newParams2.hasParameters(),['TEST FAIL: ',testname,' -- two char param message thinks it doesn''t have parameters.']);
            assertTrue(newParams3.hasParameters(),['TEST FAIL: ',testname,' -- three char param message thinks it doesn''t have parameters.']);
            
            assertFalse(newParams1.hasPositionalParameters(),['TEST FAIL: ',testname,' -- one char param message thinks it has positional parameters.']);
            assertFalse(newParams2.hasPositionalParameters(),['TEST FAIL: ',testname,' -- two char param message thinks it has positional parameters.']);
            assertFalse(newParams3.hasPositionalParameters(),['TEST FAIL: ',testname,' -- three char param message thinks it has positional parameters.']);

            assertTrue(newParams1.hasNamedParameters(),['TEST FAIL: ',testname,' -- one char param message thinks it doesn''t have named parameters.']);
            assertTrue(newParams2.hasNamedParameters(),['TEST FAIL: ',testname,' -- two char param message thinks it doesn''t have named parameters.']);
            assertTrue(newParams3.hasNamedParameters(),['TEST FAIL: ',testname,' -- three char param message thinks it doesn''t have named parameters.']);

            assertTrue(newParams1.size==1,['TEST FAIL: ',testname,' -- one char param message size is incorrect -- ACTUAL: ',int2str(newParams1.size),'  EXPECTED: 1']);
            assertTrue(newParams2.size==2,['TEST FAIL: ',testname,' -- two char param message size is incorrect -- ACTUAL: ',int2str(newParams2.size),'  EXPECTED: 2']);
            assertTrue(newParams3.size==3,['TEST FAIL: ',testname,' -- three char param message size is incorrect -- ACTUAL: ',int2str(newParams3.size),'  EXPECTED: 3']);

            assertTrue(newParams1.hasParam('s1'),['TEST FAIL: ',testname,' -- field s1 does not exist in params in one char param message']);

            assertTrue(newParams2.hasParam('s1'),['TEST FAIL: ',testname,' -- field s1 does not exist in params in two char param message']);
            assertTrue(newParams2.hasParam('s2'),['TEST FAIL: ',testname,' -- field s2 does not exist in params in two char param message']);

            assertTrue(newParams3.hasParam('s1'),['TEST FAIL: ',testname,' -- field s1 does not exist in params in three char param message']);
            assertTrue(newParams3.hasParam('s2'),['TEST FAIL: ',testname,' -- field s2 does not exist in params in three char param message']);
            assertTrue(newParams3.hasParam('sep'),['TEST FAIL: ',testname,' -- field sep does not exist in params in three char param message']);
            
            test_s1 = newParams1.get('s1');
            assertTrue(strcmp(test_s1,params.s1),['TEST FAIL: ',testname,' -- bad s1 value in one char param message -- ACTUAL: ',test_s1,'  EXPECTED: ',params.s1]);

            test_s1 = newParams2.get('s1');
            test_s2 = newParams2.get('s2');
            assertTrue(strcmp(test_s1,params.s1),['TEST FAIL: ',testname,' -- bad s1 value in two char param message -- ACTUAL: ',test_s1,'  EXPECTED: ',params.s1]);
            assertTrue(strcmp(test_s2,params.s2),['TEST FAIL: ',testname,' -- bad s2 value in two char param message -- ACTUAL: ',test_s2,'  EXPECTED: ',params.s2]);

            test_s1 = newParams3.get('s1');
            test_s2 = newParams3.get('s2');
            test_sep = newParams3.get('sep');
            assertTrue(strcmp(test_s1,params.s1),['TEST FAIL: ',testname,' -- bad s1 value in three char param message -- ACTUAL: ',test_s1,'  EXPECTED: ',params.s1]);
            assertTrue(strcmp(test_s2,params.s2),['TEST FAIL: ',testname,' -- bad s2 value in three char param message -- ACTUAL: ',test_s2,'  EXPECTED: ',params.s2]);
            assertTrue(strcmp(test_sep,params.sep),['TEST FAIL: ',testname,' -- bad n3 value in three char param message -- ACTUAL: ',test_sep,'  EXPECTED: ',params.sep]);
 
            jsonrpc2Tests.log_passingTest('TestParamsRetriever',testname);

        end % test_factory_withNamedParams_allchar %

        %% --------------------------------------------------------------------
        %   test_factory_withNamedParams_allnum
        %% --------------------------------------------------------------------
        function test_factory_withNamedParams_allnum(this)

            testname = 'test_factory_withNamedParams_allnum';

            %-------------------------
            % setup test
            %-------------------------
            params = struct;
            params.n1 = 1;
            params.n2 = 2;
            params.n3 = 3;
            
            paramsJson1 = ['{"params": { "n1": ',int2str(params.n1),' }}'];                                                                     % test one num param
            paramsJsonlab1 = loadjson(paramsJson1);

            paramsJson2 = ['{"params": { "n1": ',int2str(params.n1),', "n2": ',int2str(params.n2),' }}'];                                     % test two num params
            paramsJsonlab2 = loadjson(paramsJson2);

            paramsJson3 = ['{"params": { "n1": ',int2str(params.n1),', "n2": ',int2str(params.n2),', "n3": ',int2str(params.n3),' }}'];     % test three num params
            paramsJsonlab3 = loadjson(paramsJson3);

            %-------------------------
            % run method being tested
            %-------------------------
            newParams1 = jsonrpc2.ParamsRetriever.Factory(paramsJsonlab1.params);
            newParams2 = jsonrpc2.ParamsRetriever.Factory(paramsJsonlab2.params);
            newParams3 = jsonrpc2.ParamsRetriever.Factory(paramsJsonlab3.params);

            %-------------------------
            % test
            %-------------------------
            expected_class = 'jsonrpc2.NamedParamsRetriever';
            
            test_class1 = class(newParams1);
            test_class2 = class(newParams2);
            test_class3 = class(newParams3);
            assertTrue(strcmp(test_class1,expected_class),['TEST FAIL: ',testname,' -- one char message parsed to incorrect params type -- ACTUAL: ',test_class1,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class2,expected_class),['TEST FAIL: ',testname,' -- two char message parsed to incorrect params type -- ACTUAL: ',test_class2,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class3,expected_class),['TEST FAIL: ',testname,' -- three char message parsed to incorrect params type -- ACTUAL: ',test_class3,'  EXPECTED: ',expected_class]);

            assertTrue(newParams1.hasParameters(),['TEST FAIL: ',testname,' -- one char param message thinks it doesn''t have parameters.']);
            assertTrue(newParams2.hasParameters(),['TEST FAIL: ',testname,' -- two char param message thinks it doesn''t have parameters.']);
            assertTrue(newParams3.hasParameters(),['TEST FAIL: ',testname,' -- three char param message thinks it doesn''t have parameters.']);
            
            assertFalse(newParams1.hasPositionalParameters(),['TEST FAIL: ',testname,' -- one char param message thinks it has positional parameters.']);
            assertFalse(newParams2.hasPositionalParameters(),['TEST FAIL: ',testname,' -- two char param message thinks it has positional parameters.']);
            assertFalse(newParams3.hasPositionalParameters(),['TEST FAIL: ',testname,' -- three char param message thinks it has positional parameters.']);

            assertTrue(newParams1.hasNamedParameters(),['TEST FAIL: ',testname,' -- one char param message thinks it doesn''t have named parameters.']);
            assertTrue(newParams2.hasNamedParameters(),['TEST FAIL: ',testname,' -- two char param message thinks it doesn''t have named parameters.']);
            assertTrue(newParams3.hasNamedParameters(),['TEST FAIL: ',testname,' -- three char param message thinks it doesn''t have named parameters.']);

            assertTrue(newParams1.size==1,['TEST FAIL: ',testname,' -- one char param message size is incorrect -- ACTUAL: ',int2str(newParams1.size),'  EXPECTED: 1']);
            assertTrue(newParams2.size==2,['TEST FAIL: ',testname,' -- two char param message size is incorrect -- ACTUAL: ',int2str(newParams2.size),'  EXPECTED: 2']);
            assertTrue(newParams3.size==3,['TEST FAIL: ',testname,' -- three char param message size is incorrect -- ACTUAL: ',int2str(newParams3.size),'  EXPECTED: 3']);

            assertTrue(newParams1.hasParam('n1'),['TEST FAIL: ',testname,' -- field n1 does not exist in params in one char param message']);

            assertTrue(newParams2.hasParam('n1'),['TEST FAIL: ',testname,' -- field n1 does not exist in params in two char param message']);
            assertTrue(newParams2.hasParam('n2'),['TEST FAIL: ',testname,' -- field n2 does not exist in params in two char param message']);

            assertTrue(newParams3.hasParam('n1'),['TEST FAIL: ',testname,' -- field n1 does not exist in params in three char param message']);
            assertTrue(newParams3.hasParam('n2'),['TEST FAIL: ',testname,' -- field n2 does not exist in params in three char param message']);
            assertTrue(newParams3.hasParam('n3'),['TEST FAIL: ',testname,' -- field n3 does not exist in params in three char param message']);
            
            test_n1 = newParams1.get('n1');
            assertTrue(test_n1==params.n1,['TEST FAIL: ',testname,' -- bad n1 value in one char param message -- ACTUAL: ',int2str(test_n1),'  EXPECTED: ',int2str(params.n1)]);

            test_n1 = newParams1.get('n1');
            test_n2 = newParams2.get('n2');
            assertTrue(test_n1==params.n1,['TEST FAIL: ',testname,' -- bad n1 value in two char param message -- ACTUAL: ',int2str(test_n1),'  EXPECTED: ',int2str(params.n1)]);
            assertTrue(test_n2==params.n2,['TEST FAIL: ',testname,' -- bad n2 value in two char param message -- ACTUAL: ',int2str(test_n2),'  EXPECTED: ',int2str(params.n2)]);

            test_n1 = newParams1.get('n1');
            test_n2 = newParams2.get('n2');
            test_n3 = newParams3.get('n3');
            assertTrue(test_n1==params.n1,['TEST FAIL: ',testname,' -- bad n1 value in three char param message -- ACTUAL: ',int2str(test_n1),'  EXPECTED: ',int2str(params.n1)]);
            assertTrue(test_n2==params.n2,['TEST FAIL: ',testname,' -- bad n2 value in three char param message -- ACTUAL: ',int2str(test_n2),'  EXPECTED: ',int2str(params.n2)]);
            assertTrue(test_n3==params.n3,['TEST FAIL: ',testname,' -- bad n3 value in three char param message -- ACTUAL: ',int2str(test_n3),'  EXPECTED: ',int2str(params.n3)]);
 
            jsonrpc2Tests.log_passingTest('TestParamsRetriever',testname);

        end % test_factory_withNamedParams_allnum %

        %% --------------------------------------------------------------------
        %   test_factory_withNamedParams_allnumAsChar
        %% --------------------------------------------------------------------
        function test_factory_withNamedParams_allnumAsChar(this)

            testname = 'test_factory_withNamedParams_allnumAsChar';

            %-------------------------
            % setup test
            %-------------------------
            params = struct;
            params.sn1 = '1';
            params.sn2 = '2';
            params.sn3 = '3';
            
            paramsJson1 = ['{"params": { "sn1": "',params.sn1,'" }}'];                                                       % test one char param
            paramsJsonlab1 = loadjson(paramsJson1);

            paramsJson2 = ['{"params": { "sn1": "',params.sn1,'", "sn2": "',params.sn2,'" }}'];                              % test two char params
            paramsJsonlab2 = loadjson(paramsJson2);

            paramsJson3 = ['{"params": { "sn1": "',params.sn1,'", "sn2": "',params.sn2,'", "sn3": "',params.sn3,'" }}'];     % test three char params
            paramsJsonlab3 = loadjson(paramsJson3);

            %-------------------------
            % run method being tested
            %-------------------------
            newParams1 = jsonrpc2.ParamsRetriever.Factory(paramsJsonlab1.params);
            newParams2 = jsonrpc2.ParamsRetriever.Factory(paramsJsonlab2.params);
            newParams3 = jsonrpc2.ParamsRetriever.Factory(paramsJsonlab3.params);

            %-------------------------
            % test
            %-------------------------
            expected_class = 'jsonrpc2.NamedParamsRetriever';
            
            test_class1 = class(newParams1);
            test_class2 = class(newParams2);
            test_class3 = class(newParams3);
            assertTrue(strcmp(test_class1,expected_class),['TEST FAIL: ',testname,' -- one char message parsed to incorrect params type -- ACTUAL: ',test_class1,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class2,expected_class),['TEST FAIL: ',testname,' -- two char message parsed to incorrect params type -- ACTUAL: ',test_class2,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class3,expected_class),['TEST FAIL: ',testname,' -- three char message parsed to incorrect params type -- ACTUAL: ',test_class3,'  EXPECTED: ',expected_class]);

            assertTrue(newParams1.hasParameters(),['TEST FAIL: ',testname,' -- one char param message thinks it doesn''t have parameters.']);
            assertTrue(newParams2.hasParameters(),['TEST FAIL: ',testname,' -- two char param message thinks it doesn''t have parameters.']);
            assertTrue(newParams3.hasParameters(),['TEST FAIL: ',testname,' -- three char param message thinks it doesn''t have parameters.']);
            
            assertFalse(newParams1.hasPositionalParameters(),['TEST FAIL: ',testname,' -- one char param message thinks it has positional parameters.']);
            assertFalse(newParams2.hasPositionalParameters(),['TEST FAIL: ',testname,' -- two char param message thinks it has positional parameters.']);
            assertFalse(newParams3.hasPositionalParameters(),['TEST FAIL: ',testname,' -- three char param message thinks it has positional parameters.']);

            assertTrue(newParams1.hasNamedParameters(),['TEST FAIL: ',testname,' -- one char param message thinks it doesn''t have named parameters.']);
            assertTrue(newParams2.hasNamedParameters(),['TEST FAIL: ',testname,' -- two char param message thinks it doesn''t have named parameters.']);
            assertTrue(newParams3.hasNamedParameters(),['TEST FAIL: ',testname,' -- three char param message thinks it doesn''t have named parameters.']);

            assertTrue(newParams1.size==1,['TEST FAIL: ',testname,' -- one char param message size is incorrect -- ACTUAL: ',int2str(newParams1.size),'  EXPECTED: 1']);
            assertTrue(newParams2.size==2,['TEST FAIL: ',testname,' -- two char param message size is incorrect -- ACTUAL: ',int2str(newParams2.size),'  EXPECTED: 2']);
            assertTrue(newParams3.size==3,['TEST FAIL: ',testname,' -- three char param message size is incorrect -- ACTUAL: ',int2str(newParams3.size),'  EXPECTED: 3']);

            assertTrue(newParams1.hasParam('sn1'),['TEST FAIL: ',testname,' -- field sn1 does not exist in params in one char param message']);

            assertTrue(newParams2.hasParam('sn1'),['TEST FAIL: ',testname,' -- field sn1 does not exist in params in two char param message']);
            assertTrue(newParams2.hasParam('sn2'),['TEST FAIL: ',testname,' -- field sn2 does not exist in params in two char param message']);

            assertTrue(newParams3.hasParam('sn1'),['TEST FAIL: ',testname,' -- field sn1 does not exist in params in three char param message']);
            assertTrue(newParams3.hasParam('sn2'),['TEST FAIL: ',testname,' -- field sn2 does not exist in params in three char param message']);
            assertTrue(newParams3.hasParam('sn3'),['TEST FAIL: ',testname,' -- field sn3 does not exist in params in three char param message']);
            
            test_sn1 = newParams1.get('sn1');
            assertTrue(strcmp(test_sn1,params.sn1),['TEST FAIL: ',testname,' -- bad sn1 value in one char param message -- ACTUAL: ',test_sn1,'  EXPECTED: ',params.sn1]);

            test_sn1 = newParams2.get('sn1');
            test_sn2 = newParams2.get('sn2');
            assertTrue(strcmp(test_sn1,params.sn1),['TEST FAIL: ',testname,' -- bad sn1 value in two char param message -- ACTUAL: ',test_sn1,'  EXPECTED: ',params.sn1]);
            assertTrue(strcmp(test_sn2,params.sn2),['TEST FAIL: ',testname,' -- bad sn2 value in two char param message -- ACTUAL: ',test_sn2,'  EXPECTED: ',params.sn2]);

            test_sn1 = newParams3.get('sn1');
            test_sn2 = newParams3.get('sn2');
            test_sn3 = newParams3.get('sn3');
            assertTrue(strcmp(test_sn1,params.sn1),['TEST FAIL: ',testname,' -- bad sn1 value in three char param message -- ACTUAL: ',test_sn1,'  EXPECTED: ',params.sn1]);
            assertTrue(strcmp(test_sn2,params.sn2),['TEST FAIL: ',testname,' -- bad sn2 value in three char param message -- ACTUAL: ',test_sn2,'  EXPECTED: ',params.sn2]);
            assertTrue(strcmp(test_sn3,params.sn3),['TEST FAIL: ',testname,' -- bad sn3 value in three char param message -- ACTUAL: ',test_sn3,'  EXPECTED: ',params.sn3]);
 
            jsonrpc2Tests.log_passingTest('TestParamsRetriever',testname);

        end % test_factory_withNamedParams_allnumAsChar %

        %% --------------------------------------------------------------------
        %   test_factory_withNamedParams_mixCharFirst
        %% --------------------------------------------------------------------
        function test_factory_withNamedParams_mixCharFirst(this)

            testname = 'test_factory_withNamedParams_mixCharFirst';

            %-------------------------
            % setup test
            %-------------------------
            params = struct;
            params.s1 = 'foo';
            params.n2 = 2;
            params.n3 = 3;
            
            paramsJson = ['{"params": { "s1": "',params.s1,'", "n2": ',int2str(params.n2),', "n3": ',int2str(params.n3),' }}'];
            paramsJsonlab = loadjson(paramsJson);

            %-------------------------
            % run method being tested
            %-------------------------
            newParams = jsonrpc2.ParamsRetriever.Factory(paramsJsonlab.params);

            %-------------------------
            % test
            %-------------------------
            expected_class = 'jsonrpc2.NamedParamsRetriever';
            test_class     = class(newParams);
            assertTrue(strcmp(test_class,expected_class),['TEST FAIL: ',testname,' -- message parsed to incorrect params type -- ACTUAL: ',test_class,'  EXPECTED: ',expected_class]);

            assertTrue(newParams.hasParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have parameters.']);
            assertFalse(newParams.hasPositionalParameters(),['TEST FAIL: ',testname,' -- request thinks it has positional parameters.']);
            assertTrue(newParams.hasNamedParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have named parameters.']);

            assertTrue(newParams.size==3,['TEST FAIL: ',testname,' -- three char param message size is incorrect -- ACTUAL: ',int2str(newParams.size),'  EXPECTED: 3']);

            assertTrue(newParams.hasParam('s1'),['TEST FAIL: ',testname,' -- field s1 does not exist in params in request']);
            assertTrue(newParams.hasParam('n2'),['TEST FAIL: ',testname,' -- field n2 does not exist in params in request']);
            assertTrue(newParams.hasParam('n3'),['TEST FAIL: ',testname,' -- field n3 does not exist in params in request']);
            
            test_s1 = newParams.get('s1');
            assertTrue(strcmp(test_s1,params.s1),['TEST FAIL: ',testname,' -- bad s1 value in request -- ACTUAL: ',test_s1,'  EXPECTED: ',params.s1]);

            test_n2 = newParams.get('n2');
            assertTrue(test_n2==params.n2,['TEST FAIL: ',testname,' -- bad n2 value in request -- ACTUAL: ',int2str(test_n2),'  EXPECTED: ',int2str(params.n2)]);

            test_n3 = newParams.get('n3');
            assertTrue(test_n3==params.n3,['TEST FAIL: ',testname,' -- bad n3 value in request -- ACTUAL: ',int2str(test_n3),'  EXPECTED: ',int2str(params.n3)]);
 
            jsonrpc2Tests.log_passingTest('TestParamsRetriever',testname);

        end % test_factory_withNamedParams_mixCharFirst %
        
        %% --------------------------------------------------------------------
        %   test_factory_withNamedParams_mixNumFirst
        %% --------------------------------------------------------------------
        function test_factory_withNamedParams_mixNumFirst(this)

            testname = 'test_factory_withNamedParams_mixNumFirst';

            %-------------------------
            % setup test
            %-------------------------
            params = struct;
            params.n1 = 1;
            params.s2 = 'bar';
            params.n3 = 3;
            
            paramsJson = ['{"params": { "n1": ',int2str(params.n1),', "s2": "',params.s2,'", "n3": ',int2str(params.n3),' }}'];
            paramsJsonlab = loadjson(paramsJson);

            %-------------------------
            % run method being tested
            %-------------------------
            newParams = jsonrpc2.ParamsRetriever.Factory(paramsJsonlab.params);

            %-------------------------
            % test
            %-------------------------
            expected_class = 'jsonrpc2.NamedParamsRetriever';
            test_class     = class(newParams);
            assertTrue(strcmp(test_class,expected_class),['TEST FAIL: ',testname,' -- message parsed to incorrect params type -- ACTUAL: ',test_class,'  EXPECTED: ',expected_class]);

            assertTrue(newParams.hasParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have parameters.']);
            assertFalse(newParams.hasPositionalParameters(),['TEST FAIL: ',testname,' -- request thinks it has positional parameters.']);
            assertTrue(newParams.hasNamedParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have named parameters.']);

            assertTrue(newParams.size==3,['TEST FAIL: ',testname,' -- three char param message size is incorrect -- ACTUAL: ',int2str(newParams.size),'  EXPECTED: 3']);

            assertTrue(newParams.hasParam('n1'),['TEST FAIL: ',testname,' -- field n1 does not exist in params in request']);
            assertTrue(newParams.hasParam('s2'),['TEST FAIL: ',testname,' -- field s2 does not exist in params in request']);
            assertTrue(newParams.hasParam('n3'),['TEST FAIL: ',testname,' -- field n3 does not exist in params in request']);
            
            test_n1 = newParams.get('n1');
            assertTrue(test_n1==params.n1,['TEST FAIL: ',testname,' -- bad n1 value in request -- ACTUAL: ',int2str(test_n1),'  EXPECTED: ',int2str(params.n1)]);

            test_s2 = newParams.get('s2');
            assertTrue(strcmp(test_s2,params.s2),['TEST FAIL: ',testname,' -- bad s2 value in request -- ACTUAL: ',test_s2,'  EXPECTED: ',params.s2]);

            test_n3 = newParams.get('n3');
            assertTrue(test_n3==params.n3,['TEST FAIL: ',testname,' -- bad n3 value in request -- ACTUAL: ',int2str(test_n3),'  EXPECTED: ',int2str(params.n3)]);
 
            jsonrpc2Tests.log_passingTest('TestParamsRetriever',testname);

        end % test_factory_withNamedParams_mixNumFirst %


% =============================================================================
%                  Factory Method Tests for Positional Params
% =============================================================================

        %% --------------------------------------------------------------------
        %   test_factory_withPositionalParams_allchar
        %% --------------------------------------------------------------------
        function test_factory_withPositionalParams_allchar(this)

            testname = 'test_factory_withPositionalParams_allchar';

            %-------------------------
            % setup test
            %-------------------------
            params = struct;
            params.s1 = 'Hello';
            params.s2 = 'World';
            params.sep = ' ';
            
            paramsJson1 = ['{"params": "',params.s1,'"}'];                                            % test one char param
            paramsJsonlab1 = loadjson(paramsJson1);

            paramsJson1a = ['{"params": ["',params.s1,'"]}'];                                          % test one char param as array
            paramsJsonlab1a = loadjson(paramsJson1a);

            paramsJson2 = ['{"params": [ "',params.s1,'", "',params.s2,'"]}'];                        % test two char params
            paramsJsonlab2 = loadjson(paramsJson2);

            paramsJson3 = ['{"params": [ "',params.s1,'", "',params.s2,'", "',params.sep,'" ]}'];     % test three char params
            paramsJsonlab3 = loadjson(paramsJson3);

            %-------------------------
            % run method being tested
            %-------------------------
            newParams1 = jsonrpc2.ParamsRetriever.Factory(paramsJsonlab1.params);
            newParams1a = jsonrpc2.ParamsRetriever.Factory(paramsJsonlab1a.params);
            newParams2 = jsonrpc2.ParamsRetriever.Factory(paramsJsonlab2.params);
            newParams3 = jsonrpc2.ParamsRetriever.Factory(paramsJsonlab3.params);

            %-------------------------
            % test
            %-------------------------
            expected_class = 'jsonrpc2.PositionalParamsRetriever';
            
            test_class1  = class(newParams1);
            test_class1a = class(newParams1a);
            test_class2  = class(newParams2);
            test_class3  = class(newParams3);
            assertTrue(strcmp(test_class1,expected_class),['TEST FAIL: ',testname,' -- one char param message parsed to incorrect params type -- ACTUAL: ',test_class1,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class1a,expected_class),['TEST FAIL: ',testname,' -- one char param (as array) message parsed to incorrect params type -- ACTUAL: ',test_class1a,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class2,expected_class),['TEST FAIL: ',testname,' -- two char param message parsed to incorrect params type -- ACTUAL: ',test_class2,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class3,expected_class),['TEST FAIL: ',testname,' -- three char param message parsed to incorrect params type -- ACTUAL: ',test_class3,'  EXPECTED: ',expected_class]);

            assertTrue(newParams1.hasParameters(),['TEST FAIL: ',testname,' -- one char param message thinks it doesn''t have parameters.']);
            assertTrue(newParams1a.hasParameters(),['TEST FAIL: ',testname,' -- one char param (as array) message thinks it doesn''t have parameters.']);
            assertTrue(newParams2.hasParameters(),['TEST FAIL: ',testname,' -- two char param message thinks it doesn''t have parameters.']);
            assertTrue(newParams3.hasParameters(),['TEST FAIL: ',testname,' -- three char param message thinks it doesn''t have parameters.']);
            
            assertTrue(newParams1.hasPositionalParameters(),['TEST FAIL: ',testname,' -- one char param message thinks it doesn''t have positional parameters.']);
            assertTrue(newParams1a.hasPositionalParameters(),['TEST FAIL: ',testname,' -- one char param (as array) message thinks it doesn''t have positional parameters.']);
            assertTrue(newParams2.hasPositionalParameters(),['TEST FAIL: ',testname,' -- two char param message thinks it doesn''t have positional parameters.']);
            assertTrue(newParams3.hasPositionalParameters(),['TEST FAIL: ',testname,' -- three char param message thinks it doesn''t have positional parameters.']);

            assertFalse(newParams1.hasNamedParameters(),['TEST FAIL: ',testname,' -- one char param message thinks it has named parameters.']);
            assertFalse(newParams1a.hasNamedParameters(),['TEST FAIL: ',testname,' -- one char param (as array) message thinks it has named parameters.']);
            assertFalse(newParams2.hasNamedParameters(),['TEST FAIL: ',testname,' -- two char param message thinks it has named parameters.']);
            assertFalse(newParams3.hasNamedParameters(),['TEST FAIL: ',testname,' -- three char param message thinks it has named parameters.']);

            assertTrue(newParams1.size==1,['TEST FAIL: ',testname,' -- one char param message size is incorrect -- ACTUAL: ',int2str(newParams1.size),'  EXPECTED: 1']);
            assertTrue(newParams1a.size==1,['TEST FAIL: ',testname,' -- one char param (as array) message size is incorrect -- ACTUAL: ',int2str(newParams1.size),'  EXPECTED: 1']);
            assertTrue(newParams2.size==2,['TEST FAIL: ',testname,' -- two char param message size is incorrect -- ACTUAL: ',int2str(newParams2.size),'  EXPECTED: 2']);
            assertTrue(newParams3.size==3,['TEST FAIL: ',testname,' -- three char param message size is incorrect -- ACTUAL: ',int2str(newParams3.size),'  EXPECTED: 3']);

            assertTrue(newParams1.hasParam(1),['TEST FAIL: ',testname,' -- field 1 does not exist in params in one char param message']);
            assertTrue(newParams1a.hasParam(1),['TEST FAIL: ',testname,' -- field 1 does not exist in params in one char param (as array) message']);

            assertTrue(newParams2.hasParam(1),['TEST FAIL: ',testname,' -- field 1 does not exist in params in two char param message']);
            assertTrue(newParams2.hasParam(2),['TEST FAIL: ',testname,' -- field 2 does not exist in params in two char param message']);

            assertTrue(newParams3.hasParam(1),['TEST FAIL: ',testname,' -- field 1 does not exist in params in three char param message']);
            assertTrue(newParams3.hasParam(2),['TEST FAIL: ',testname,' -- field 2 does not exist in params in three char param message']);
            assertTrue(newParams3.hasParam(3),['TEST FAIL: ',testname,' -- field 3 does not exist in params in three char param message']);
            
            test_s1 = newParams1.get(1);
            test_s1a = newParams1a.get(1);
            assertTrue(strcmp(test_s1,params.s1),['TEST FAIL: ',testname,' -- bad 1st value in one char param message -- ACTUAL: ',test_s1,'  EXPECTED: ',params.s1]);
            assertTrue(strcmp(test_s1a,params.s1),['TEST FAIL: ',testname,' -- bad 1st value in one char param (as array) message -- ACTUAL: ',test_s1a,'  EXPECTED: ',params.s1]);

            test_s1 = newParams2.get(1);
            test_s2 = newParams2.get(2);
            assertTrue(strcmp(test_s1,params.s1),['TEST FAIL: ',testname,' -- bad s1 value in two char param message -- ACTUAL: ',test_s1,'  EXPECTED: ',params.s1]);
            assertTrue(strcmp(test_s2,params.s2),['TEST FAIL: ',testname,' -- bad s2 value in two char param message -- ACTUAL: ',test_s2,'  EXPECTED: ',params.s2]);

            test_s1 = newParams3.get(1);
            test_s2 = newParams3.get(2);
            test_sep = newParams3.get(3);
            assertTrue(strcmp(test_s1,params.s1),['TEST FAIL: ',testname,' -- bad s1 value in three char param message -- ACTUAL: ',test_s1,'  EXPECTED: ',params.s1]);
            assertTrue(strcmp(test_s2,params.s2),['TEST FAIL: ',testname,' -- bad s2 value in three char param message -- ACTUAL: ',test_s2,'  EXPECTED: ',params.s2]);
            assertTrue(strcmp(test_sep,params.sep),['TEST FAIL: ',testname,' -- bad n3 value in three char param message -- ACTUAL: ',test_sep,'  EXPECTED: ',params.sep]);
 
            jsonrpc2Tests.log_passingTest('TestParamsRetriever',testname);

        end % test_factory_withPositionalParams_allchar %

        %% --------------------------------------------------------------------
        %   test_factory_withPositionalParams_allnum
        %% --------------------------------------------------------------------
        function test_factory_withPositionalParams_allnum(this)

            testname = 'test_factory_withPositionalParams_allnum';

            %-------------------------
            % setup test
            %-------------------------
            params = struct;
            params.n1 = 1;
            params.n2 = 2;
            params.n3 = 3;
            
            paramsJson1 = ['{"params": [',int2str(params.n1),']}'];
            paramsJson2 = ['{"params": [',int2str(params.n1),', ',int2str(params.n2),']}'];
            paramsJson3 = ['{"params": [',int2str(params.n1),', ',int2str(params.n2),', ',int2str(params.n3),']}'];
            paramsJsonlab1 = loadjson(paramsJson1);
            paramsJsonlab2 = loadjson(paramsJson2);
            paramsJsonlab3 = loadjson(paramsJson3);

            %-------------------------
            % run method being tested
            %-------------------------
            newParams1 = jsonrpc2.ParamsRetriever.Factory(paramsJsonlab1.params);
            newParams2 = jsonrpc2.ParamsRetriever.Factory(paramsJsonlab2.params);
            newParams3 = jsonrpc2.ParamsRetriever.Factory(paramsJsonlab3.params);

            %-------------------------
            % test
            %-------------------------
            expected_class = 'jsonrpc2.PositionalParamsRetriever';
            
            test_class1 = class(newParams1);
            test_class2 = class(newParams2);
            test_class3 = class(newParams3);
            assertTrue(strcmp(test_class1,expected_class),['TEST FAIL: ',testname,' -- one num param message parsed to incorrect params type -- ACTUAL: ',test_class1,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class2,expected_class),['TEST FAIL: ',testname,' -- two num param message parsed to incorrect params type -- ACTUAL: ',test_class2,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class3,expected_class),['TEST FAIL: ',testname,' -- three num param message parsed to incorrect params type -- ACTUAL: ',test_class3,'  EXPECTED: ',expected_class]);

            assertTrue(newParams1.hasParameters(),['TEST FAIL: ',testname,' -- one num param message thinks it doesn''t have parameters.']);
            assertTrue(newParams2.hasParameters(),['TEST FAIL: ',testname,' -- two num param message thinks it doesn''t have parameters.']);
            assertTrue(newParams3.hasParameters(),['TEST FAIL: ',testname,' -- three num param message thinks it doesn''t have parameters.']);
            
            assertTrue(newParams1.hasPositionalParameters(),['TEST FAIL: ',testname,' -- one num param message thinks it doesn''t have positional parameters.']);
            assertTrue(newParams2.hasPositionalParameters(),['TEST FAIL: ',testname,' -- two num param message thinks it doesn''t have positional parameters.']);
            assertTrue(newParams3.hasPositionalParameters(),['TEST FAIL: ',testname,' -- three num param message thinks it doesn''t have positional parameters.']);

            assertFalse(newParams1.hasNamedParameters(),['TEST FAIL: ',testname,' -- one num param message thinks it has named parameters.']);
            assertFalse(newParams2.hasNamedParameters(),['TEST FAIL: ',testname,' -- two num param message thinks it has named parameters.']);
            assertFalse(newParams3.hasNamedParameters(),['TEST FAIL: ',testname,' -- three num param message thinks it has named parameters.']);

            assertTrue(newParams1.size==1,['TEST FAIL: ',testname,' -- one num param message size is incorrect -- ACTUAL: ',int2str(newParams1.size),'  EXPECTED: 1']);
            assertTrue(newParams2.size==2,['TEST FAIL: ',testname,' -- two num param message size is incorrect -- ACTUAL: ',int2str(newParams2.size),'  EXPECTED: 2']);
            assertTrue(newParams3.size==3,['TEST FAIL: ',testname,' -- three num param message size is incorrect -- ACTUAL: ',int2str(newParams3.size),'  EXPECTED: 3']);

            assertTrue(newParams1.hasParam(1),['TEST FAIL: ',testname,' -- field 1 does not exist in params in one num param message']);

            assertTrue(newParams2.hasParam(1),['TEST FAIL: ',testname,' -- field 1 does not exist in params in two num param message']);
            assertTrue(newParams2.hasParam(2),['TEST FAIL: ',testname,' -- field 2 does not exist in params in two num param message']);

            assertTrue(newParams3.hasParam(1),['TEST FAIL: ',testname,' -- field 1 does not exist in params in three num param message']);
            assertTrue(newParams3.hasParam(2),['TEST FAIL: ',testname,' -- field 2 does not exist in params in three num param message']);
            assertTrue(newParams3.hasParam(3),['TEST FAIL: ',testname,' -- field 3 does not exist in params in three num param message']);
            
            test_n1 = newParams1.get(1);
            assertTrue(test_n1==params.n1,['TEST FAIL: ',testname,' -- bad 1st value in one num param message -- ACTUAL: ',int2str(test_n1),'  EXPECTED: ',int2str(params.n1)]);

            test_n1 = newParams2.get(1);
            test_n2 = newParams2.get(2);
            assertTrue(test_n1==params.n1,['TEST FAIL: ',testname,' -- bad s1 value in two num param message -- ACTUAL: ',int2str(test_n1),'  EXPECTED: ',int2str(params.n1)]);
            assertTrue(test_n2==params.n2,['TEST FAIL: ',testname,' -- bad s2 value in two num param message -- ACTUAL: ',int2str(test_n2),'  EXPECTED: ',int2str(params.n2)]);

            test_n1 = newParams3.get(1);
            test_n2 = newParams3.get(2);
            test_n3 = newParams3.get(3);
            assertTrue(test_n1==params.n1,['TEST FAIL: ',testname,' -- bad s1 value in three num param message -- ACTUAL: ',int2str(test_n1),'  EXPECTED: ',int2str(params.n1)]);
            assertTrue(test_n2==params.n2,['TEST FAIL: ',testname,' -- bad s2 value in three num param message -- ACTUAL: ',int2str(test_n2),'  EXPECTED: ',int2str(params.n2)]);
            assertTrue(test_n3==params.n3,['TEST FAIL: ',testname,' -- bad n3 value in three num param message -- ACTUAL: ',int2str(test_n3),'  EXPECTED: ',int2str(params.n3)]);
 
            jsonrpc2Tests.log_passingTest('TestParamsRetriever',testname);

        end % test_factory_withPositionalParams_allnum %

        %% --------------------------------------------------------------------
        %   test_factory_withPositionalParams_allnumAsChar
        %% --------------------------------------------------------------------
        function test_factory_withPositionalParams_allnumAsChar(this)

            testname = 'test_factory_withPositionalParams_allnumAsChar';

            %-------------------------
            % setup test
            %-------------------------
            params = struct;
            params.sn1 = '1';
            params.sn2 = '2';
            params.sn3 = '3';
            
            paramsJson1 = ['{"params": "',params.sn1,'"}'];                                             % test one char param
            paramsJsonlab1 = loadjson(paramsJson1);

            paramsJson1a = ['{"params": ["',params.sn1,'"]}'];                                          % test one char param as array
            paramsJsonlab1a = loadjson(paramsJson1a);

            paramsJson2 = ['{"params": [ "',params.sn1,'", "',params.sn2,'"]}'];                        % test two char params
            paramsJsonlab2 = loadjson(paramsJson2);

            paramsJson3 = ['{"params": [ "',params.sn1,'", "',params.sn2,'", "',params.sn3,'" ]}'];     % test three char params
            paramsJsonlab3 = loadjson(paramsJson3);

            %-------------------------
            % run method being tested
            %-------------------------
            newParams1 = jsonrpc2.ParamsRetriever.Factory(paramsJsonlab1.params);
            newParams1a = jsonrpc2.ParamsRetriever.Factory(paramsJsonlab1a.params);
            newParams2 = jsonrpc2.ParamsRetriever.Factory(paramsJsonlab2.params);
            newParams3 = jsonrpc2.ParamsRetriever.Factory(paramsJsonlab3.params);

            %-------------------------
            % test
            %-------------------------
            expected_class = 'jsonrpc2.PositionalParamsRetriever';
            
            test_class1  = class(newParams1);
            test_class1a = class(newParams1a);
            test_class2  = class(newParams2);
            test_class3  = class(newParams3);
            assertTrue(strcmp(test_class1,expected_class),['TEST FAIL: ',testname,' -- one char param message parsed to incorrect params type -- ACTUAL: ',test_class1,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class1a,expected_class),['TEST FAIL: ',testname,' -- one char param (as array) message parsed to incorrect params type -- ACTUAL: ',test_class1a,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class2,expected_class),['TEST FAIL: ',testname,' -- two char param message parsed to incorrect params type -- ACTUAL: ',test_class2,'  EXPECTED: ',expected_class]);
            assertTrue(strcmp(test_class3,expected_class),['TEST FAIL: ',testname,' -- three char param message parsed to incorrect params type -- ACTUAL: ',test_class3,'  EXPECTED: ',expected_class]);

            assertTrue(newParams1.hasParameters(),['TEST FAIL: ',testname,' -- one char param message thinks it doesn''t have parameters.']);
            assertTrue(newParams1a.hasParameters(),['TEST FAIL: ',testname,' -- one char param (as array) message thinks it doesn''t have parameters.']);
            assertTrue(newParams2.hasParameters(),['TEST FAIL: ',testname,' -- two char param message thinks it doesn''t have parameters.']);
            assertTrue(newParams3.hasParameters(),['TEST FAIL: ',testname,' -- three char param message thinks it doesn''t have parameters.']);
            
            assertTrue(newParams1.hasPositionalParameters(),['TEST FAIL: ',testname,' -- one char param message thinks it doesn''t have positional parameters.']);
            assertTrue(newParams1a.hasPositionalParameters(),['TEST FAIL: ',testname,' -- one char param (as array) message thinks it doesn''t have positional parameters.']);
            assertTrue(newParams2.hasPositionalParameters(),['TEST FAIL: ',testname,' -- two char param message thinks it doesn''t have positional parameters.']);
            assertTrue(newParams3.hasPositionalParameters(),['TEST FAIL: ',testname,' -- three char param message thinks it doesn''t have positional parameters.']);

            assertFalse(newParams1.hasNamedParameters(),['TEST FAIL: ',testname,' -- one char param message thinks it has named parameters.']);
            assertFalse(newParams1a.hasNamedParameters(),['TEST FAIL: ',testname,' -- one char param (as array) message thinks it has named parameters.']);
            assertFalse(newParams2.hasNamedParameters(),['TEST FAIL: ',testname,' -- two char param message thinks it has named parameters.']);
            assertFalse(newParams3.hasNamedParameters(),['TEST FAIL: ',testname,' -- three char param message thinks it has named parameters.']);

            assertTrue(newParams1.size==1,['TEST FAIL: ',testname,' -- one char param message size is incorrect -- ACTUAL: ',int2str(newParams1.size),'  EXPECTED: 1']);
            assertTrue(newParams1a.size==1,['TEST FAIL: ',testname,' -- one char param (as array) message size is incorrect -- ACTUAL: ',int2str(newParams1.size),'  EXPECTED: 1']);
            assertTrue(newParams2.size==2,['TEST FAIL: ',testname,' -- two char param message size is incorrect -- ACTUAL: ',int2str(newParams2.size),'  EXPECTED: 2']);
            assertTrue(newParams3.size==3,['TEST FAIL: ',testname,' -- three char param message size is incorrect -- ACTUAL: ',int2str(newParams3.size),'  EXPECTED: 3']);

            assertTrue(newParams1.hasParam(1),['TEST FAIL: ',testname,' -- field 1 does not exist in params in one char param message']);
            assertTrue(newParams1a.hasParam(1),['TEST FAIL: ',testname,' -- field 1 does not exist in params in one char param (as array) message']);

            assertTrue(newParams2.hasParam(1),['TEST FAIL: ',testname,' -- field 1 does not exist in params in two char param message']);
            assertTrue(newParams2.hasParam(2),['TEST FAIL: ',testname,' -- field 2 does not exist in params in two char param message']);

            assertTrue(newParams3.hasParam(1),['TEST FAIL: ',testname,' -- field 1 does not exist in params in three char param message']);
            assertTrue(newParams3.hasParam(2),['TEST FAIL: ',testname,' -- field 2 does not exist in params in three char param message']);
            assertTrue(newParams3.hasParam(3),['TEST FAIL: ',testname,' -- field 3 does not exist in params in three char param message']);
            
            test_sn1 = newParams1.get(1);
            test_sn1a = newParams1a.get(1);
            assertTrue(strcmp(test_sn1,params.sn1),['TEST FAIL: ',testname,' -- bad 1st value in one char param message -- ACTUAL: ',test_sn1,'  EXPECTED: ',params.sn1]);
            assertTrue(strcmp(test_sn1a,params.sn1),['TEST FAIL: ',testname,' -- bad 1st value in one char param (as array) message -- ACTUAL: ',test_sn1a,'  EXPECTED: ',params.sn1]);

            test_sn1 = newParams2.get(1);
            test_sn2 = newParams2.get(2);
            assertTrue(strcmp(test_sn1,params.sn1),['TEST FAIL: ',testname,' -- bad sn1 value in two char param message -- ACTUAL: ',test_sn1,'  EXPECTED: ',params.sn1]);
            assertTrue(strcmp(test_sn2,params.sn2),['TEST FAIL: ',testname,' -- bad sn2 value in two char param message -- ACTUAL: ',test_sn2,'  EXPECTED: ',params.sn2]);

            test_sn1 = newParams3.get(1);
            test_sn2 = newParams3.get(2);
            test_sn3 = newParams3.get(3);
            assertTrue(strcmp(test_sn1,params.sn1),['TEST FAIL: ',testname,' -- bad sn1 value in three char param message -- ACTUAL: ',test_sn1,'  EXPECTED: ',params.sn1]);
            assertTrue(strcmp(test_sn2,params.sn2),['TEST FAIL: ',testname,' -- bad sn2 value in three char param message -- ACTUAL: ',test_sn2,'  EXPECTED: ',params.sn2]);
            assertTrue(strcmp(test_sn3,params.sn3),['TEST FAIL: ',testname,' -- bad n3 value in three char param message -- ACTUAL: ',test_sn3,'  EXPECTED: ',params.sn3]);
 
            jsonrpc2Tests.log_passingTest('TestParamsRetriever',testname);

        end % test_factory_withPositionalParams_allnumAsChar %

        %% --------------------------------------------------------------------
        %   test_factory_withPositionalParams_mixCharFirst
        %% --------------------------------------------------------------------
        function test_factory_withPositionalParams_mixCharFirst(this)

            testname = 'test_factory_withPositionalParams_mixCharFirst';

            %-------------------------
            % setup test
            %-------------------------
            params = struct;
            params.s1 = 'foo';
            params.n2 = 2;
            params.n3 = 3;
            
            paramsJson = ['{"params": [ "',params.s1,'", ',int2str(params.n2),', ',int2str(params.n3),' ]}'];
            paramsJsonlab = loadjson(paramsJson);

            %-------------------------
            % run method being tested
            %-------------------------
            newParams = jsonrpc2.ParamsRetriever.Factory(paramsJsonlab.params);

            %-------------------------
            % test
            %-------------------------
            expected_class = 'jsonrpc2.PositionalParamsRetriever';
            test_class     = class(newParams);
            assertTrue(strcmp(test_class,expected_class),['TEST FAIL: ',testname,' -- message parsed to incorrect params type -- ACTUAL: ',test_class,'  EXPECTED: ',expected_class]);

            assertTrue(newParams.hasParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have parameters.']);
            assertTrue(newParams.hasPositionalParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have positional parameters.']);
            assertFalse(newParams.hasNamedParameters(),['TEST FAIL: ',testname,' -- request thinks it has named parameters.']);

            assertTrue(newParams.size==3,['TEST FAIL: ',testname,' -- three char param message size is incorrect -- ACTUAL: ',int2str(newParams.size),'  EXPECTED: 3']);

            assertTrue(newParams.hasParam(1),['TEST FAIL: ',testname,' -- field 1 does not exist in three char param message']);
            assertTrue(newParams.hasParam(2),['TEST FAIL: ',testname,' -- field 2 does not exist in three char param message']);
            assertTrue(newParams.hasParam(3),['TEST FAIL: ',testname,' -- field 3 does not exist in three char param message']);
            
            test_s1 = newParams.get(1);
            assertTrue(strcmp(test_s1,params.s1),['TEST FAIL: ',testname,' -- bad s1 value in three char param message -- ACTUAL: ',test_s1,'  EXPECTED: ',params.s1]);

            test_n2 = newParams.get(2);
            assertTrue(test_n2==params.n2,['TEST FAIL: ',testname,' -- bad n2 value in three char param message -- ACTUAL: ',int2str(test_n2),'  EXPECTED: ',int2str(params.n2)]);

            test_n3 = newParams.get(3);
            assertTrue(test_n3==params.n3,['TEST FAIL: ',testname,' -- bad n3 value in three char param message -- ACTUAL: ',int2str(test_n3),'  EXPECTED: ',int2str(params.n3)]);
 
            jsonrpc2Tests.log_passingTest('TestParamsRetriever',testname);

        end % test_factory_withPositionalParams_mixCharFirst %
        
        %% --------------------------------------------------------------------
        %   test_factory_withPositionalParams_mixNumFirst
        %% --------------------------------------------------------------------
        function test_factory_withPositionalParams_mixNumFirst(this)

            testname = 'test_factory_withPositionalParams_mixNumFirst';

            %-------------------------
            % setup test
            %-------------------------
            params = struct;
            params.n1 = 1;
            params.s2 = 'bar';
            params.n3 = 3;
            
            paramsJson = ['{"params": [ ',int2str(params.n1),', "',params.s2,'", ',int2str(params.n3),' ]}'];
            paramsJsonlab = loadjson(paramsJson);

            %-------------------------
            % run method being tested
            %-------------------------
            newParams = jsonrpc2.ParamsRetriever.Factory(paramsJsonlab.params);

            %-------------------------
            % test
            %-------------------------
            expected_class = 'jsonrpc2.PositionalParamsRetriever';
            test_class     = class(newParams);
            assertTrue(strcmp(test_class,expected_class),['TEST FAIL: ',testname,' -- message parsed to incorrect params type -- ACTUAL: ',test_class,'  EXPECTED: ',expected_class]);

            assertTrue(newParams.hasParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have parameters.']);
            assertTrue(newParams.hasPositionalParameters(),['TEST FAIL: ',testname,' -- request thinks it doesn''t have positional parameters.']);
            assertFalse(newParams.hasNamedParameters(),['TEST FAIL: ',testname,' -- request thinks it has named parameters.']);

            assertTrue(newParams.hasParam(1),['TEST FAIL: ',testname,' -- field n1 does not exist in params in three char param message']);
            assertTrue(newParams.hasParam(2),['TEST FAIL: ',testname,' -- field s2 does not exist in params in three char param message']);
            assertTrue(newParams.hasParam(3),['TEST FAIL: ',testname,' -- field n3 does not exist in params in three char param message']);
            
            test_n1 = newParams.get(1);
            assertTrue(test_n1==params.n1,['TEST FAIL: ',testname,' -- bad n1 value in three char param message -- ACTUAL: ',int2str(test_n1),'  EXPECTED: ',int2str(params.n1)]);

            test_s2 = newParams.get(2);
            assertTrue(strcmp(test_s2,params.s2),['TEST FAIL: ',testname,' -- bad s2 value in three char param message -- ACTUAL: ',test_s2,'  EXPECTED: ',params.s2]);

            test_n3 = newParams.get(3);
            assertTrue(test_n3==params.n3,['TEST FAIL: ',testname,' -- bad n3 value in three char param message -- ACTUAL: ',int2str(test_n3),'  EXPECTED: ',int2str(params.n3)]);
 
            jsonrpc2Tests.log_passingTest('TestParamsRetriever',testname);

        end % test_factory_withPositionalParams_mixNumFirst %

        
    end % methods %

end % classdef %

        
