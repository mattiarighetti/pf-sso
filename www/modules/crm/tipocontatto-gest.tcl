ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 19 February 2015
} {
    tipo_id:integer,optional
}
if {[ad_form_new_p -key tipo_id]} {
    set page_title "Nuova tipologia"
    set buttons [list [list "Aggiungi" new]]
} else {
    set page_title "Modifica tipologia"
    set buttons [list [list "Modifica" edit]]
}
ad_form -name societa \
    -edit_buttons $buttons \
    -has_edit 1 \
    -form {
	tipo_id:key
	{descrizione:text
	    {label "Descrizione"}
	    {html {size 70 maxlength 100}}
	}
    }  -select_query {
	"SELECT * FROM crm_tipocontatto WHERE tipo_id = :tipo_id"
    } -new_data {
      	set tipo_id [db_string query "SELECT COALESCE(MAX(tipo_id)+1,1) FROM crm_tipocontatto"]
	db_dml query "INSERT INTO crm_tipocontatto (tipo_id, descrizione) VALUES (:tipo_id, :descrizione)"
    } -edit_data {
	db_dml query "UPDATE crm_tipocontatto SET descrizione = :descrizione WHERE tipo_id = :tipo_id"
    } -after_submit {
	ad_returnredirect "tipocontatto-gest"
	ad_script_abort
    }
