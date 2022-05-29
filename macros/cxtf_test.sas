/* -----------------------------------------------------------------------
Macro   :    cxtf_test
Version :    $version$
Author  :    Magnus Mengelbier, Limelogic AB
Project :    https://github.com/limelogic/cxtf
-----------------------------------------------------------------------
Description

Utility macro to execute one or more tests

-----------------------------------------------------------------------
Parameters

path 
    Path to a single or directory of test programs

fileprefix
    One or more file name prefixes to identify a test program

testprefix
    One or more macro name prefixes to identify a test scenario

out
    Directory for outputs 

verbose 
    Enable verbose messages during processing

-----------------------------------------------------------------------
License

GNU Public License v3
----------------------------------------------------------------------- */

%macro cxtf_test( path = , out = , fileprefix = test, testprefix = test, verbose = N );

    %* ---  add macro metadata details  --- ;
    %local meta_version ;

    %let meta_version = $version$ ;
    %* ---  end of add macro metadata details  --- ;

    %* macro header and debug ;
    %cxtf_print_header();
    %cxtf_print_debug();


    %* initialize ;
    %_cxtf_init();



%mend;
