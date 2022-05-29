/* -----------------------------------------------------------------------
Macro   :    cxtf_print_trace
Version :    $version$
Author  :    Magnus Mengelbier, Limelogic AB
Project :    https://github.com/limelogic/cxtf
-----------------------------------------------------------------------
Description

Utility macro to print macro nesting sequence

A level equal to 0 is the nesting level from where the print trace macro
is called. Level 0 is default.

A level less than 0 is the nesting level relative to the current level 
from the print trace macro was called.

A level greater than 0 is the absolute nesting level, if the absolute
level is within the maximum number of nesting levels. Otherwise the 
maximum level of nests are used.

The messagetype is if the trace should be presented as a SAS Error (E), 
Warning (W) or Note (N). Note is default.

Specifying print equal to N, the options DEBUG or TRACE must be enabled. 
If print equal to Y, the options DEBUG and TRACE ignored.

-----------------------------------------------------------------------
Parameters

level 
    Nesting level

messagetype
    SAS log message type

print
    Force printing of trace details

-----------------------------------------------------------------------
Returns

-----------------------------------------------------------------------
License

GNU Public License v3
----------------------------------------------------------------------- */

%macro cxtf_print_trace( level = 0, messagetype = N, print = N );

    %* note:  low level macro so not relying on other utility macros to avoid recursive nesting ;


    %* ---  debug header  --- ;

    %global CXTF_OPTIONS ;

    %if ( ( %sysfunc(indexw( %upcase(&CXTF_OPTIONS), DEBUG, %str( ) )) > 0 ) or 
          ( %sysfunc(indexw( %upcase(&CXTF_OPTIONS), TRACE, %str( ) )) > 0 ) or 
          ( %upcase(&print) = Y ) )
    %then %do;
        %put %str(NO)TE: Macro cxtf_print_trace ;
        %put %str(NO)TE: Version $version$ ;
    %end;

    %* ---  end of debug header  --- ;
 

    %* only print trace of debug, trace or force print is enabled ;
    %if ( ( %sysfunc(indexw( %upcase(&CXTF_OPTIONS), DEBUG, %str( ) )) = 0 ) and 
          ( %sysfunc(indexw( %upcase(&CXTF_OPTIONS), TRACE, %str( ) )) = 0 ) and
          ( %upcase(&print) = N ) )
    %then %goto macro_exit ;


    %local tftrace_prefix 
           tftrace_trace tftrace_trace_i tftrace_trace_max
    ;


    %* ---  simple parameter checks  --- ;

    %if ( %sysfunc(notdigit( %sysfunc(compress( %str(&level), %nrstr(- ))) )) > 0 ) %then %do;
        %put %str(ER)ROR: The number of specified levels is not a number ;
        %goto macro_exit ;
    %end;

    %if ( ( %sysfunc(indexw( N W E, %upcase(&messagetype), %str( ) )) = 0 ) or 
          ( %sysfunc(countw( &messagetype )) ^= 1 ) ) %then %do;
        %put %str(ER)ROR: The message type is incorrect ;
        %goto macro_exit ;
    %end;

    %* ---  end of simple parameter checks  --- ;


    %if ( %upcase(&messagetype) = N ) %then
        %let tftrace_prefix = %str(NO)TE;

    %if ( %upcase(&messagetype) = W ) %then
        %let tftrace_prefix = %str(WA)RNING;

    %if ( %upcase(&messagetype) = E ) %then
        %let tftrace_prefix = %str(ER)ROR;


    %* ---  generate trace levels  --- ;

    %if ( &level <= 0 ) %then 
        %let tftrace_trace_max = %eval( %sysmexecdepth - 1 + &level );

    %if ( &level > 0 ) %then
        %let tftrace_trace_max = %sysfunc(min( %eval( %sysmexecdepth - 1 ), &level ));

    %if ( %sysmexecdepth = 1 or &tftrace_trace_max < 1 ) %then %do;
        %let tftrace = Program code ;        
    %end; %else %do;

        %let tftrace_trace = ;
        %let tftrace_trace_i = 1;
        
        %do %while ( &tftrace_trace_i <= &tftrace_trace_max );
            %let tftrace_trace = %sysfunc(strip(&tftrace_trace /%str( )%sysmexecname( &tftrace_trace_i )));        
            %let tftrace_trace_i = %eval( &tftrace_trace_i + 1 );
        %end;
    %end;

    %* ---  end of generate trace levels  --- ;


    %* ---  publish the trace to the log  --- ;
    %put &tftrace_prefix: Trace  &tftrace_trace ;


    %* ---  macro exit point  --- ;
    %macro_exit:

    %* do nothing on exit ;


%mend;
