

%macro cxtf_print_header() ;

    %global CXTF_OPTIONS ;

    %if ( %sysfunc(indexw( %upcase(&CXTF_OPTIONS), DEBUG, %str( ) )) > 0 ) %then %do;
        %put %str(NO)TE:  Macro cxtf_print_header ;
        %put %str(NO)TE:  Version $version$ ;
    %end;


    %local tfprinthead_caller
           tfprinthead_rc
           tfprinthead_version
    ;


    %* ---  idenfity the calling macro ---;

    %if ( %sysmexecdepth = 1 ) %then 
        %goto macro_exit;


    %let tfprinthead_caller = %sysmexecname( %eval( %sysmexecdepth - 1 ) ) ;

    %* default version ;
    %let tfprinthead_rc = $version$ ;

    %cxtf_



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


    %* ---  end of idenfity the calling macro scope  ---;
 
    

    %macro_exit:


%mend;
