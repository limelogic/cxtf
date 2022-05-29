


%macro cxtf_options( options = );

    %global CXTF_OPTIONS ;

    %if ( %sysfunc(indexw( %upcase(&CXTF_OPTIONS), DEBUG, %str( ) )) > 0 ) %then %do;
        %put %str(NO)TE:  Macro cxtf_options ;
        %put %str(NO)TE:  Version $version$ ;
    %end;


    %* ---  simple futility check  --- ;
    
    %if ( &options = %str() ) %then %goto macro_exit ;


    %local tfopt_item tfopt_item_i ;


    %let tfopt_item_i = 1 ;

    %do %while( %scan( &options, &tfopt_item_i, %str( ) ) ^= %str() );
        
        %let tfopt_item = %scan( &options, &tfopt_item_i, %str( ) );

        %if ( %length(%sysfunc(strip(&tfopt_item))) < 2 ) %then %do;
            %put %str(WA)RNING: Option &tfopt_item is not a valid option name ;
            %cxtf_print_trace( messagetype = W );
            %goto do_while_continue;
        %end;




        %do_while_continue:

        %let tfopt_item_i = %eval( &tfopt_item_i + 1 ) ;
    %end;



    %macro_exit:




%mend;
