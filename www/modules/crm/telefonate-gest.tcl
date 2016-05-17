ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 19 February 2015
} {
    persona_id:integer,optional
    telefonata_id:integer,optional
}
pf::permission
if {[ad_form_new_p -key telefonata_id]} {
    set page_title "Nuova telefonata"
    set buttons [list [list "Salva telefonata" new]]
    if {$persona_id eq ""} {
	ad_return_complaint 1 " Errore: ID della persona non specificato."
	return
    }
} else {
    set page_title "Modifica telefonata"
    set buttons [list [list "Salva modifiche" edit]]
}
ad_form -name telefonata \
    -edit_buttons $buttons \
    -has_edit 1 \
    -export "persona_id" \
    -form {
	telefonata_id:key
	{data:date,to_sql(linear_date)
	    {label "Data"}
	    {format "DD/MM/YYYY HH24:MI:SS"}
	}
	{user_id:integer(select)
	    {label "Operatore"}
	    {value "[ad_conn user_id]"}
	    {options {[db_list_of_lists query "SELECT username, user_id FROM users"]}}
	}
	{commento:text(textarea)
	    {label "Commento"}
	    {html {cols "70" rows "10"}}
	}
    }  -select_query {
	"SELECT user_id, commento, data, persona_id FROM crm_telefonate WHERE telefonata_id = :telefonata_id"
    } -new_data {
      	set contatto_id [db_string query "SELECT COALESCE(MAX(telfonata_id)+1,1) FROM crm_telefonate"]
	db_dml query "INSERT INTO crm_telefonate (telefonata_id, data, persona_id, user_id, commento) VALUES (:telefonata_id, :data, :persona_id, :commento)"
    } -edit_data {
	db_dml query "UPDATE crm_telefonate SET commento = :commento WHERE telefonata_id = :telefonata_id"
    } -after_submit {
	ad_returnredirect "persone-view?persona_id=$persona_id"
	ad_script_abort
    }
