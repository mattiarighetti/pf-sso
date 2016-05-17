ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 19 February 2015
} {
    societa_id:integer
}
set page_title "Nuova società"
set buttons [list [list "Salva e procedi" new]]
ad_form -name societa \
    -edit_buttons $buttons \
    -has_edit 1 \
    -form {
	societa_id:key
	{ragionesociale:text
	    {label "Ragione sociale"}
	    {html {size 70 maxlength 100}}
	}
    } -new_data {
      	set societa_id [db_string query "SELECT COALESCE(MAX(societa_id)+1,1) FROM crm_societa"]
	db_dml query "INSERT INTO crm_societa (societa_id, ragionesociale) VALUES (:societa_id, :ragionesociale)"
    } -edit_data {
	db_dml query "UPDATE crm_societa SET ragionesociale = :ragionesociale WHERE societa_id = :societa_id"
    } -after_submit {
	ad_returnredirect "societa-add-2?societa_id=$societa_id"
	ad_script_abort
    }
