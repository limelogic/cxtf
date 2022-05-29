


%macro cxtf_mvar_value( variable = , scope = , return = );

    %global CXTF_OPTIONS ;

    %if ( %sysfunc(indexw( %upcase(&CXTF_OPTIONS), DEBUG, %str( ) )) > 0 ) %then %do;
        %put %str(NO)TE:  Macro cxtf_mvar_value ;
        %put %str(NO)TE:  Version $version$ ;
    %end;


    %local  tfmvarval_trace
            tfmvarval_trace_i
            tfmvarval_rc 
    ; 

    %* get prior condition and set normal for now to always execute ;
    %let tfmvarval_syscc = &syscc ;
    %let tfmvarval_sysmsg = &sysmsg ;

    %let syscc = 0;
    %let sysmsg = ;


    %* ---  idenfity the calling macro scope  ---;

    %if ( %sysmexecdepth = 1 ) %then %do;
        %let tfmvarval_trace = PROGRAM CODE;
    %end; %else %do;

        %* generate breadcrumbs ;
        %* this is a low level macro so not using the cxtf_trace macro to avoid infinite nesting ;
        %let tfmvarval_trace = ;
        %let tfmvarval_trace_i = 1;
        
        %do %while (&tfmvarval_trace_i <= %eval( %sysmexecdepth - 1 );
            %let ttfmvarval_trace = &tfmvarval_trace / %sysmexecname( &tfmvarval_trace_i );        
            %let tfmvarval_trace_i = %eval( &tfmvarval_trace_i + 1 );
        %end;

        %if ( %sysfunc(indexw( %upcase(&CXTF_OPTIONS), DEBUG, %str( ) )) > 0 ) %then %do;
            %put %str(NO)TE: Trace &tfmvarval_trace ;
        %end;

    %end;

    %* ---  end of idenfity the calling macro scope  ---;

    
    %* --- simple parameter checks  --- ;

    %if ( &variable = %str() ) %then %do;
        %put %str(ER)ROR: Parameter variable not specified ;
        %put %str(ER)ROR: Trace &tfmvarval_trace ;
        %goto macro_exit;
    %end;

    %if ( &scope = %str() ) %then %do;
        %put %str(ER)ROR: Parameter variable not specified ;
        %put %str(ER)ROR: Trace &tfmvarval_trace ;
        %goto macro_exit;
    %end;

    %* --- end of simple parameter checks  --- ;



    %macro_exit:


    %let syscc = &tfmvarval_syscc ;
    %let sysmsg = &tfmvarval_sysmsg ;


%mend;
