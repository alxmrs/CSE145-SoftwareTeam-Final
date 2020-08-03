function log_passingTest(testclass,testmethod)
% Write test passed message to the console.
%
% Copyright (c) 2013, Cornell University, Lab of Ornithology
% All rights reserved.
%
% Distributed under BSD license.  See LICENSE_BSD.txt for full license.
% 
% Author: E. L. Rayle
%

    msg = ['TEST PASSED:  ',testclass,'.',testmethod,'()'];
    if( exist('cprintf','file') ) 
        cprintf('-comment','%s\n', msg);
    else
        disp(msg);
    end
        
end    