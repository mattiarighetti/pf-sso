ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 17 February 2015
} {
}
set page_title "Tipo contatto"
set context [list $page_title]
set actions "{Nuova tipo} {tipocontatto-gest} {Aggiungi un nuovo contatto}"
template::list::create \
    -name tipo \
    -multirow tipo \
    -actions $actions \
    -elements {	
	descrizione {
	    label "Tipologia di contatto"
	}
       	edit {
	    link_url_col edit_url
	    display_template {<img src="images/edit.gif" height="12" border="0">}
	    link_html {title "Modifica tipologia"}
	    sub_class narrow
	}
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="images/delete.gif" height="12" border="0">}
	    link_html {title "Cancella tipologia" onClick "return(confirm('Confermi la cancellazione?'));"}
	    sub_class narrow
	}
    }
db_multirow \
    -extend {
	edit_url
	delete_url
    } tipo query "SELECT * FROM crm_tipocontatto" {
	set edit_url [export_vars -base "tipocontatto-gest" {tipo_id}]
	set delete_url [export_vars -base "tipocontatto-canc" {tipo_id}]
    }
