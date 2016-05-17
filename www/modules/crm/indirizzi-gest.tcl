ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 19 February 2015
} {
    persona_id:integer
    indirizzo_id:integer,optional
}
if {[ad_form_new_p -key indirizzo_id]} {
    set page_title "Nuovo indirizzo"
    set buttons [list [list "Salva e aggiungi" new]]
} else {
    set page_title "Modifica indirizzo"
    set buttons [list [list "Salva modifiche" edit]]
}
ad_form -name indirizzo \
    -edit_buttons $buttons \
    -has_edit 1 \
    -export "persona_id" \
    -form {
	indirizzo_id:key
	{via:text
	    {label "Via"}
	    {html {size 70 maxlength 100}}
	}
	{comune_id:search
	    {result_datatype integer}
	    {label "Comune"}
	    {search_query "SELECT denominazione, comune_id FROM comuni WHERE LOWER(denominazione) LIKE '%'||LOWER(:value)||'%'"}
	}
	{cap:text,optional
	    {label "CAP"}
	    {html {size "70" maxlength "10"}}
	}
	{tipo_id:integer(select),optional
	    {label "Tipo"}
	    {options {[db_list_of_lists query "SELECT descrizione, tipo_id FROM crm_tipoindirizzo"]}}
	    {after_html "<a href=\"tipoindirizzo-gest\"><img src=\"http://images.professionefinanza.com/icons/new.gif\" /></a>"}
	}
    }  -select_query {
	"SELECT via, comune_id, cap, tipo_id FROM crm_indirizzi WHERE indirizzo_id = :indirizzo_id"
    } -new_data {
      	set indirizzo_id [db_string query "SELECT COALESCE(MAX(indirizzo_id)+1,1) FROM crm_indirizzi"]
	db_dml query "INSERT INTO crm_indirizzi (indirizzo_id, persona_id, cap, via, comune_id, tipo_id) VALUES (:indirizzo_id, :persona_id, :cap, :via, :comune_id, :tipo_id)"
    } -edit_data {
	db_dml query "UPDATE crm_indirizzi SET via = :via, comune_id = :comune_id, tipo_id = :tipo_id, cap = :cap WHERE indirizzo_id = :indirizzo_id"
    } -after_submit {
	ad_returnredirect -message "Indirizzo (ID: $indirizzo_id) inserito correttamente." [export_vars -base "persone-view" {persona_id}]
	ad_script_abort
    }
