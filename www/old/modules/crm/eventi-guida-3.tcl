ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 19 February 2015
} {
    tipo_id:integer
}
pf::permission
set page_title "Nuovo evento"
set buttons [list [list "Crea evento" new]]
ad_form -name evento \
    -edit_buttons $buttons \
    -has_edit 1 \
    -export {tipo_id} \
    -form {
	evento_id:key
	{data:date,to_sql(linear_date_no_time),to_html(sql_date)
	    {format "DD MONTH YYYY"}
	    {label "Data"}
	}
	{comune_id:search
            {result_datatype integer}
            {label "Comune"}
            {search_query "SELECT denominazione, comune_id FROM comuni WHERE LOWER(denominazione) LIKE '%'||LOWER(:value)||'%'"}
        }
	{docente_id:search,optional
	    {after_html "<a href=\"docenti-gest\" target=\"_blank\">Aggiungi</a>"}
	    {label "Docente"}
	    {search_query "SELECT c.cognome||' '||c.nome, d.docente_id FROM docenti d LEFT OUTER JOIN crm_persone c ON d.persona_id = c.persona_id WHERE LOWER(c.cognome)||LOWER(c.nome) LIKE '%'||LOWER(:value)||'%'"}
	}
    }  -select_query {
	"SELECT evento_id, tipo_id, data, comune_id, docente_id FROM eventi WHERE evento_id = :evento_id"
    } -new_data {
      	db_transaction {
	    set evento_id [db_string query "SELECT COALESCE(MAX(evento_id)+1,1) FROM eventi"]
	    db_dml query "INSERT INTO eventi (evento_id, tipo_id, data, comune_id, docente_id) VALUES (:evento_id, :tipo_id, :data, :comune_id, :docente_id)"
	}
    } -after_submit {
	set categoria_id [db_string query "select categoria_id from tipoevento where tipo_id = :tipo_id"]
	set return_url [export_vars -base "eventi-guida-2" {categoria_id}]
	ad_returnredirect -message "Evento (ID: $evento_id) creato correttamente." $return_url
	ad_script_abort
    }
