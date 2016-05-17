ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Monday 3 November, 2014
} {
    domanda_id:integer,optional
}
set user_id [ad_conn user_id]
set user_admin [db_0or1row useradmin ""]
if {$user_id == 0 || $user_admin == 1} {
    ad_returnredirect "login?return_url=/pfawards/"
}
if {[ad_form_new_p -key domanda_id]} {
    set page_title "Nuova"
    set buttons [list [list "Salva" new]]
} else {
    set modifica [db_string domandanum ""]
    set page_title "$modifica"
    set buttons [list [list "Aggiorna" edit]]
}
ad_form -name domande \
    -mode edit \
    -edit_buttons $buttons \
    -has_edit 1 \
    -select_query_name selectdomanda \
    -form {
	domanda_id:key
	{corpo:text(textarea),nospell
	    {label "Corpo"}
	    {html {rows 6 cols 50 wrap soft}}
	}
	{categoria_id:text(select)
	    {options {{"" ""} [db_list_of_lists categorialist ""]}} 
      	    {html {size 1 style "width:39.5em"}}
            {label "Categoria"}
	}
    } -new_data {
	set domanda_id [db_string maxdomandaid ""]
	db_dml insert ""
    } -edit_data {
	db_dml update ""
    } -on_submit {
	set ctr_errori 0
	if {$ctr_errori > 0} {
	    break
	}
    } -after_submit {
	ad_returnredirect "domande-list"
	ad_script_abort
    }