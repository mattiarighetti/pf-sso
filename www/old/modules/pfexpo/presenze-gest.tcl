ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Monday 7 November, 2014
} {
    iscritto_id:integer,optional
}
set user_id [ad_conn user_id]
if {[ad_form_new_p -key iscritto_id]} {
    set page_title "Nuova"
    set buttons [list [list "Salva" new]]
} else {
    set modifica [db_string iscrittonum ""]
    set page_title "$modifica"
    set buttons [list [list "Aggiorna" edit]]
}
set context [list $page_title]
ad_form -name iscrizione \
    -mode edit \
    -edit_buttons $buttons \
    -has_edit 1 \
    -select_query_name selectiscrizione \
    -form {
	iscritto_id:key
	{nome:text
	    {label "Nome"}
	    {html {size 50}}
	    {help_text "Inserisci il tuo nome con l'iniziale maiuscola. (Es.: Mario)"}
	}
	{cognome:text
	    {label "Cognome"}
	    {html {size 50}}
	    {help_text "Inserisci il tuo cognome con l'iniziale maiuscola. (Es.: Rossi)"}
	}
	{eventi:text(checkbox),multiple
	    {label "Eventi"}
	    {html {size 1}}
	    {options {{"" ""} [db_list_of_lists eventilist ""]}}
	    {help_text "Non puoi selezionare eventi in contemporanea."}
	}
    } -new_data {
	set iscritto_id [db_string maxiscrittoid ""]
	db_dml insert ""
    } -edit_data {
	db_dml update ""
    } -on_submit {
	set ctr_errori 0
	if {$ctr_errori > 0} {
	    break
	}
    } -after_submit {
	ad_returnredirect "iscrizione-pre-stamp"
	ad_script_abort
    }