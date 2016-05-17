ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 19 February 2015
} {
    evento_id:integer,optional
    upload_file:trim,optional
    upload_file.tmpfile:tmpfile,optional
}
pf::permission
if {[ad_form_new_p -key evento_id]} {
    set page_title "Nuovo evento"
    set buttons [list [list "Crea evento" new]]
} else {
    set page_title "Modifica evento"
    set buttons [list [list "Modifica evento" edit]]
}
set mime_types [parameter::get -parameter AcceptablePortraitMIMETypes -default ""]
set max_bytes [parameter::get -parameter MaxPortraitBytes -default ""]
ad_form -name evento \
    -edit_buttons $buttons \
    -has_edit 1 \
    -form {
	evento_id:key
	{tipo_id:integer(select)
	    {after_html "<a href=\"tipoevento-gest\" target=\"_blank\">Aggiungi</a>"}
	    {label "Tipo"}
	    {options {[db_list_of_lists query "SELECT denominazione, tipo_id FROM tipoevento ORDER BY denominazione"]} }
	}
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
	    {search_query "SELECT c.cognome||' '||c.nome, d.docente_id FROM docenti d LEFT OUTER JOIN crm_persone c ON d.persona_id = c.persona_id WHERE LOWER(c.cognome)||LOWER(c.nome) LIKE LOWER '%'||(:value)||'%'"}
	}
	{upload_file:text(file)
	    {help_text "Il file non può  essere superiore a $max_bytes Bytes e in formato $mime_types."}
	    {label "Immagine"}
	}
    }  -select_query {
	"SELECT evento_id, tipo_id, data, comune_id, docente_id FROM eventi WHERE evento_id = :evento_id"
    } -validate {
	{upload_file
	    {$mime_types eq "" || [lsearch $mime_types [ns_guesstype $upload_file]] > -1}
	    {Il file che hai caricato non è tra i seguenti formati accettabili: $mime_types}
	}
	{upload_file
	    {$max_bytes eq "" || [file size [ns_queryget upload_file.tmpfile]] <= $max_bytes}
	    {Il file è troppo grande. Prego ridimensionarlo a massimo [util_commify_number $max_bytes] bytes.}
	}
    } -new_data {
      	db_transaction {
	    set evento_id [db_string query "SELECT COALESCE(MAX(evento_id)+1,1) FROM eventi"]
	    regsub -all  {\\} $upload_file "<" upload_file
	    ns_rename $filepath /usr/share/openacs/packages/images/eventi_portraits/$upload_file
	    db_dml query "INSERT INTO eventi (evento_id, tipo_id, data, comune_id, docente_id, immagine) VALUES (:evento_id, :tipo_id, :data, :comune_id, :docente_id, :immagine)"
	}
    } -edit_data {
	db_dml query "UPDATE eventi SET tipo_id = :tipo_id, data = :data, comune_id = :comune_id, docente_id = :docente_id, immagine = :immagine WHERE evento_id = :evento_id"
    } -on_submit {
	set filepath [ns_queryget upload_file.tmpfile]
    } -after_submit {
	ad_returnredirect -message "Evento (ID: $evento_id) creato correttamente." "eventi-list"
	ad_script_abort
    }
