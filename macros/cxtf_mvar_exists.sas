/* -----------------------------------------------------------------------
Macro   :    cxtf_mvar_exists
Version :    $version$
Author  :    Magnus Mengelbier, Limelogic AB
Project :    https://github.com/limelogic/cxtf
-----------------------------------------------------------------------
Description

Utility macro to check if macro variable exists in specified scope

Return macro variable must exist in the calling scope, wheter it is 
a macro or directly from a program. If this macro is called from a
program, the global macro variable scope is assumed.

-----------------------------------------------------------------------
Parameters

variable 
    Macro variable name

scope
    Macro variable scope

return
    Macro variable name for return value. 

-----------------------------------------------------------------------
Returns

Returns TRUE if the variables exists in scope. FALSE otherwise.

If a failure occurs, a missing value is returned.

-----------------------------------------------------------------------
License

GNU Public License v3
----------------------------------------------------------------------- */


%macro cxtf_mvar_exists( variable =, scope = , return = );

    %global CXTF_OPTIONS ;

    %if ( %sysfunc(indexw( %upcase(&CXTF_OPTIONS), DEBUG, %str( ) )) > 0 ) %then %do;
        %put %str(NO)TE:  Macro cxtf_mvar_exists ;
        %put %str(NO)TE:  Version $version$ ;
    %end;


    %local tfmvarexists_syscc tfmvarexists_sysmsg
           tfmvarexists_caller  tfmvarexists_trace
           tfmvarexists_scope
           tfmvarexists_sighup
           tfmvarexists_return
    ;


    %* get prior condition and set normal for now to always execute ;
    %let tfmvarexists_syscc = &syscc ;
    %let tfmvarexists_sysmsg = &sysmsg ;

    %let syscc = 0;
    %let sysmsg = ;


    %* ---  idenfity the calling macro scope  ---;

    %if ( %sysmexecdepth = 1 ) %then %do;
        %let tfmvarexists_caller = global ;
        %let tfmvarexists_trace = PROGRAM CODE;
    %end; %else %do;
        %let tfmvarexists_caller = %sysmexecname( %eval( %sysmexecdepth - 1 ) ) ;

        %* generate breadcrumbs ;
        %* this is a low level macro so not using the cxtf_trace macro to avoid infinite nesting ;
        %let tfmvarexists_trace = ;
        %let tfmvarexists_trace_i = 1;
        
        %do %while (&tfmvarexists_trace_i <= %eval( %sysmexecdepth - 1 );
            %let tfmvarexists_trace = &tfmvarexists_trace / %sysmexecname( &tfmvarexists_trace_i );        
            %let tfmvarexists_trace_i = %eval( &tfmvarexists_trace_i + 1 );
        %end;

        %if ( %sysfunc(indexw( %upcase(&CXTF_OPTIONS), DEBUG, %str( ) )) > 0 ) %then %do;
            %put %str(NO)TE: Trace &tfmvarexists_trace ;
        %end;

    %end;

    %* ---  end of idenfity the calling macro scope  ---;


    %* --- simple parameter checks  --- ;

    %if ( &variable = %str() ) %then %do;
        %put %str(ER)ROR: Parameter variable not specified ;
        %put %str(ER)ROR: Trace &tfmvarexists_trace ;
        %goto macro_exit;
    %end;

    %* --- end of simple parameter checks  --- ;

    %if ( &scope ^= %str() ) %then %do;
        %let tfmvarexists_scope = &scope ;
    %end; %else %do;
        %let tfmvarexists_scope = &tfmvarexists_caller ;
    %end;

    
    %* poor mans check that the return variable exists ;
    %* not calling cxtf_mvar_exists to avoid infinite recursion ;
    %let tfmvarexists_sighup = 1;

    data _null_ ;
        work sashelp.vmacro ;
        where ( upcase(scope) = upcase("&tfmvarexists_caller") ) and 
              ( upcase(name) = upcase("&return") ;
        call symput( 'tfmvarexists_sighup', '0' );
    run;

    %if ( &syscc > 0 ) %then %do;
        %put %str(ER)ROR: Could not verify that return variable %upcase(&return) exists in the parent scope (&tfmvarexists_caller);
        %goto macro_exit;
    %end;

    %if ( &tfmvarexists_sighup > 0 ) %then %do;
        %put %str(WA)RNING: The return variable %upcase(&return) does not exist in the parent scope (&tfmvarexists_caller);
        %goto macro_exit;
    %end;

 
    %* ---  check if variable exists in scope  ---;

    %let tfmvarexists_return = FALSE ;

    data _null_ ;
        work sashelp.vmacro ;
        where ( upcase(scope) = upcase("&scope") ) and 
              ( upcase(name) = upcase("&variable") ;
        call symput( 'tfmvarexists_return', 'TRUE' );
    run;

    %if ( &syscc > 0 ) %then %do;
        %put %str(ER)ROR: Could not verify that variable %upcase(&variable) exists in the scope (&scope);
        %let &return = ;
        %goto macro_exit;
    %end;

    %* ---  end of check if variable exists in scope  ---;

    %* return result ;
    %let &return = &tfmvarexists_return ;


    %*  macro exit point ;
    %macro_exit:

    %* reset condition code to prior values ;
    %let syscc = &tfmvarexists_syscc;
    %let sysmsg = &tfmvarexists_sysmsg ;

%mend;
