ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Tuesday 21 April 2015
} {
    {return_url ""}
    tipo_id:integer,optional
    upload_file:trim,optional
    upload_file.tmpfile:tmpfile,optional
}
pf::permission
if {[ad_form_new_p -key tipo_id]} {
    set page_title "Nuovo tipo"
    set buttons [list [list "Aggiungi tipo" new]]
} else {
    set page_title "Modifica tipo"
    set buttons [list [list "Modifica tipo" edit]]
}
set mime_types [parameter::get -parameter AcceptablePortraitMIMETypes -default ""]
set max_bytes [parameter::get -parameter MaxPortraitBytes -default ""]
ad_form -name tipo \
    -edit_buttons $buttons \
    -has_edit 1 \
    -form {
	tipo_id:key
	{categoria_id:integer(select)
	    {label "Categoria"}
	    {options {[db_list_of_lists query "SELECT descrizione, categoria_id FROM categoriaevento"]}}
	}
	{denominazione:text
	    {label "Denominazione"}
	    {html {size 70 maxlength 50}}
	}
	{descrizione:text(textarea),optional
	    {label "Descrizione"}
	    {html {cols 70 rows 10}}
	}
	{upload_file:text(file)
	    {help_text "Il file non può  essere superiore a $max_bytes Bytes e in formato $mime_types."}
	    {label "Immagine"}
	}
    } -validate {
	{upload_file
	    {$mime_types eq "" || [lsearch $mime_types [ns_guesstype $upload_file]] > -1}
	    {Il file che hai caricato non è tra i seguenti formati accettabili: $mime_types}
	}
	{upload_file
	    {$max_bytes eq "" || [file size [ns_queryget upload_file.tmpfile]] <= $max_bytes}
	    {Il file è troppo grande. Prego ridimensionarlo a massimo [util_commify_number $max_bytes] bytes.}
	}
    }  -select_query {
	"SELECT tipo_id, categoria_id, denominazione, descrizione, immagine AS upload_file FROM tipoevento WHERE tipo_id = :tipo_id"
    } -new_data {
	db_transaction {
	    set tipo_id [db_string query "SELECT COALESCE(MAX(tipo_id)+1,1) FROM tipoevento"]
	    regsub -all  {\\} $upload_file "<" upload_file
	    ns_rename $filepath /usr/share/openacs/packages/images/eventi-portraits/$upload_file
	    db_dml query "INSERT INTO tipoevento (tipo_id, denominazione, descrizione, categoria_id, immagine) VALUES (:tipo_id, :denominazione, :descrizione, :categoria_id, :upload_file)"
	}
    } -edit_data {
	db_transaction {
	    regsub -all  {\\} $upload_file "<" upload_file
	     ns_rename $filepath /usr/share/openacs/packages/images/eventi-portraits/$upload_file
	    db_dml query "UPDATE tipoevento SET denominazione = :denominazione, descrizione = :descrizione, categoria_id = :categoria_id, immagine = :upload_file WHERE tipo_id = :tipo_id"
	}
    } -on_submit {
	set filepath [ns_queryget upload_file.tmpfile]
    } -after_submit {
	if {$return_url eq ""} {
	    set return_url "tipoevento-list"
	}
	ad_returnredirect -message "Tipo evento correttamente inserito (ID: $tipo_id)." $return_url
	ad_script_abort
    }
