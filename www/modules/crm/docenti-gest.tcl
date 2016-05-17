ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 19 February 2015
} {
    comune_id:integer,optional
}
if {[ad_form_new_p -key comune_id]} {
    set page_title "Nuovo comune"
    set buttons [list [list "Aggiungi comune" new]]
} else {
    set page_title "Modifica comune"
    set buttons [list [list "Modifica comune" edit]]
}
ad_form -name comune \
    -edit_buttons $buttons \
    -has_edit 1 \
    -form {
	comune_id:key
	{denominazione:text
	    {label "Denominazione"}
	    {html {size 70 maxlength 100}}
	}
	{cap:text
	    {label "CAP"}
	}
	{provincia_id:integer(select)
	    {after_html "<a href=\"provincie-gest\" target=\"_blank\">Aggiungi</a>"}
	    {label "Provincia"}
	    {options {[db_list_of_lists query "SELECT denominazione, provincia_id FROM provincie ORDER BY denominazione"]} }
	}
    }  -select_query {
	"SELECT comune_id, denominazione, cap, provincia_id FROM comuni WHERE comune_id = :comune_id"
    } -new_data {
      	set comune_id [db_string query "SELECT COALESCE(MAX(comune_id)+1,1) FROM comuni"]
	db_dml query "INSERT INTO comuni (comune_id, denominazione, provincia_id, cap) VALUES (:comune_id, :denominazione, :provincia_id, :cap)"
    } -edit_data {
	db_dml query "UPDATE eventi SET denominazione = :denominazione, tipo_id = :tipo_id, docente_id = :docente_id, descrizione = :descrizione, link = :link WHERE evento_id = :evento_id"
    } -after_submit {
	ad_returnredirect "comuni-list"
	ad_script_abort
    }
