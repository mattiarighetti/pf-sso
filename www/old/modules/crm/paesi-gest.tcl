ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 19 February 2015
} {
    paese_id:integer,optional
}
if {[ad_form_new_p -key paese_id]} {
    set page_title "Nuovo paese"
    set buttons [list [list "Aggiungi paese" new]]
} else {
    set page_title "Modifica paese"
    set buttons [list [list "Modifica paese" edit]]
}
ad_form -name paese \
    -edit_buttons $buttons \
    -has_edit 1 \
    -form {
	paese_id:key
	{denominazione:text
	    {label "Denominazione"}
	    {html {size 70 maxlength 100}}
	}
    }  -select_query {
	"SELECT paese_id, denominazione FROM paesi WHERE paese_id = :paese_id"
    } -new_data {
      	set paese_id [db_string query "SELECT COALESCE(MAX(paese_id)+1,1) FROM paesi"]
	db_dml query "INSERT INTO paesi (paese_id, denominazione) VALUES (:paese_id, :denominazione)"
    } -edit_data {
	db_dml query "UPDATE paesi SET denominazione = :denominazione WHERE paese_id = :paese_id"
    } -after_submit {
	ad_returnredirect "paesi-list"
	ad_script_abort
    }
