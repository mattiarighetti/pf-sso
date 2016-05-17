ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 19 February 2015
} {
    provincia_id:integer,optional
}
if {[ad_form_new_p -key provincia_id]} {
    set page_title "Nuova provincia"
    set buttons [list [list "Aggiungi provincia" new]]
} else {
    set page_title "Modifica provincia"
    set buttons [list [list "Modifica provincia" edit]]
}
ad_form -name provincia \
    -edit_buttons $buttons \
    -has_edit 1 \
    -form {
	provincia_id:key
	{denominazione:text
	    {label "Denominazione"}
	    {html {size 70 maxlength 100}}
	}
	{paese_id:integer(select)
	    {after_html "<a href=\"paesi-gest\" target=\"_blank\">Aggiungi</a>"}
	    {label "Paesi"}
	    {options {[db_list_of_lists query "SELECT denominazione, paese_id FROM pf_paesi ORDER BY denominazione"]} }
	}
    }  -select_query {
	"SELECT provincia_id, denominazione FROM pf_provincie WHERE provincia_id = :provincia_id"
    } -new_data {
      	set provincia_id [db_string query "SELECT COALESCE(MAX(provincia_id)+1,1) FROM pf_provincie"]
	db_dml query "INSERT INTO pf_provincie (provincia_id, denominazione, paese_id) VALUES (:provincia_id, :denominazione, :paese_id)"
    } -edit_data {
	db_dml query "UPDATE pf_provincie SET denominazione = :denominazione, paese_id = :paese_id WHERE provincia_id = :provincia_id"
    } -after_submit {
	ad_returnredirect "provincie-list"
	ad_script_abort
    }
