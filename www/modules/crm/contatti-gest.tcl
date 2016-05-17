ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 19 February 2015
} {
    persona_id:integer,optional
    contatto_id:integer,optional
}
if {[ad_form_new_p -key contatto_id]} {
    set page_title "Nuovo contatto"
    set buttons [list [list "Aggiungi contatto" new]]
    if {$persona_id eq ""} {
	ad_return_complaint 1 " Errore: ID della persona non specificato."
	return
    }
} else {
    set page_title "Modifica contatto"
    set buttons [list [list "Salva modifiche" edit]]
}
ad_form -name contatto \
    -edit_buttons $buttons \
    -has_edit 1 \
    -export "persona_id" \
    -form {
	contatto_id:key
	{tipo_id:integer(select)
	    {label "Tipo"}
	    {options {[db_list_of_lists query "SELECT descrizione, tipo_id FROM crm_tipocontatto"]}}
	}
	{valore:text
	    {label "Valore"}
	}
    }  -select_query {
	"SELECT tipo_id, valore FROM crm_contatti WHERE contatto_id = :contatto_id"
    } -new_data {
      	set contatto_id [db_string query "SELECT COALESCE(MAX(contatto_id)+1,1) FROM crm_contatti"]
	db_dml query "INSERT INTO crm_contatti (contatto_id, persona_id, tipo_id, valore) VALUES (:contatto_id, :persona_id, :tipo_id, :valore)"
    } -edit_data {
	db_dml query "UPDATE crm_contatti SET tipo_id = :tipo_id, valore = :valore WHERE contatto_id = :contatto_id"
    } -after_submit {
	ad_returnredirect "persone-view?persona_id=$persona_id"
	ad_script_abort
    }
