ad_page_contract {
    @author Mattia Righetti (mattia.righetti@mail.polimi.it)
} {
    iscritto_id:integer,optional
}
set user_id [ad_conn user_id]
set user_admin [db_0or1row "SELECT * FROM pf_iscritti WHERE iscritto_id = :user_id"]
if {$user_id == 0 || $user_admin == 1} {
    ad_returnredirect "login?return_url=/pfawards/"
}
if {[ad_form_new_p -key iscritto_id]} {
    set page_title "Nuova"
    set buttons [list [list "Salva" new]]
} else {
    set page_title "Modifica #" 
    append page_title "$iscritto_id"
    set buttons [list [list "Aggiorna" edit]]
}
ad_form -name utenti \
    -edit_buttons $buttons \
    -has_edit 1 \
    -form {
	iscritto_id:key
	{nome:text
	    {label "Nome"}
	    {html {size 70}}
	}
	{cognome:text
            {label "Cognome"}
	    {html {size 70}}
	}
    } -select_query { "SELECT nome,
                              cognome
	                 FROM pf_iscritti
 	                WHERE iscritto_id = :iscritto_id"
    } -new_data {
	set iscritto_id [db_string query "SELECT COALESCE (MAX(iscritto_id) + 1, 1) FROM pf_iscritti"]
	db_dml query "INSERT INTO pf_iscritti (iscritto_id, nome, cognome) VALUES (:iscritto_id, :nome, :cognome)"
    } -edit_data {
	db_dml query "UPDATE pf_iscritti SET nome = :nome, cognome = :cognome WHERE iscritto_id = :iscritto_id"
    } -on_submit {
	set ctr_errori 0
	if {$ctr_errori > 0} {
	    break
	}
    } -after_submit {
	ad_returnredirect "utenti-list"
	ad_script_abort
    }