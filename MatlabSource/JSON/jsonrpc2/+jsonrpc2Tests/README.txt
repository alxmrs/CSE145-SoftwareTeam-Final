===================================
 README.txt for +jsonrpc2Tests
===================================
22-Jan-2014

ABOUT
-----
+jsonrpc2Tests holds classes to test the jsonrpc2 package classes.

It is open source according to the license required by MATLAB File Exchange.]
See license file for more information.


AKNOWLEDGEMENTS
---------------

+jsonrpc2Tests uses the xunit framework for testing.


DEPENDENCIES
------------
Dependencies for +jsonrpc2 classes
1.  jsonlab - (REQUIRED) [New 19 Oct 2011; Updated 26 Aug 2013] 
    http://www.mathworks.com/matlabcentral/fileexchange/33381-jsonlab-a-toolbox-to-encodedecode-json-files-in-matlaboctave

Dependencies for +jsonrpc2Tests
1.  xunit   - (REQUIRED) [New 31 Jan 2009; Updated 12 Jul 2013]
    http://www.mathworks.com/matlabcentral/fileexchange/22846-matlab-xunit-test-framework
    
2.  cprintf - (OPTIONAL) [New 12 May 2009; Updated 19 Oct 2012] 
    http://www.mathworks.com/matlabcentral/fileexchange/24093-cprintf-display-formatted-colored-text-in-the-command-window 


GETTING STARTED WITH TESTS
--------------------------
1) Follow GETTING STARTED instructions in +jsonrpc2/README.txt 
2) Download xunit from http://www.mathworks.com/matlabcentral/fileexchange/22846-matlab-xunit-test-framework.
3) Notifications that each test passed will print to the console in black.  Optionally, if you want passing test notifications in green, download cprintf from 
   http://www.mathworks.com/matlabcentral/fileexchange/24093-cprintf-display-formatted-colored-text-in-the-command-window
4) Make sure the +jsonrpc2Tests package and xunit are on the MATLAB file path.  Same for cprintf if you are using it.
5) Run tests using the following at MATLAB command line:  jsonrpc2Tests.runAllTests

All tests should pass.

Code was tested on: MATLAB R2010a, MATLAB R2012b, MATLAB R2013a.

Possible causes of failure include changes to code for DEPENDENCIES.  See dates for dependencies used for testing listed above.


