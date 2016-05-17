ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Tuesday 21 April 2015
} {
    {return_url ""}
    categoria_id:integer,optional
}
if {[ad_form_new_p -key categoria_id]} {
    set page_title "Nuova categoria"
    set buttons [list [list "Aggiungi categoria" new]]
} else {
    set page_title "Modifica categoria"
    set buttons [list [list "Modifica categoria" edit]]
}
ad_form -name categoria \
    -edit_buttons $buttons \
    -has_edit 1 \
    -form {
	categoria_id:key
	{descrizione:text
	    {label "Descrizione"}
	    {html {size 70 maxlength 50}}
	}
    }  -select_query {
	"SELECT categoria_id, descrizione FROM categoriaevento WHERE categoria_id = :categoria_id"
    } -new_data {
      	set categoria_id [db_string query "SELECT COALESCE(MAX(categoria_id)+1,1) FROM categoriaevento"]
	db_dml query "INSERT INTO categoriaevento (categoria_id, descrizione) VALUES (:categoria_id, :descrizione)"
    } -edit_data {
	db_dml query "UPDATE tipoevento SET denominazione = :denominazione, descrizione = :descrizione WHERE categoria_id = :categoria_id"
    } -after_submit {
	if {$return_url eq ""} {
	    set return_url "categoriaevento_list"
	}
	ad_returnredirect -message "Categoria correttamente inserita (ID: $categoria_id)." $return_url
	ad_script_abort
    }
