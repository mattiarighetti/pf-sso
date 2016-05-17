ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Tuesday 21 April 2015
} {
    orderby:optional
}
pf::permission
set page_title "Categorie di evento"
set context [list $page_title]
set actions "{Nuova categoria} {categoriaevento-gest} {Aggiunge una nuova categoria}"
template::list::create \
    -name categorie \
    -multirow categorie \
    -actions $actions \
    -elements {	
        categoria_id {
            label "ID"
        }
	descrizione {
	    label "Categoria"
	}
	edit {
	    link_url_col edit_url
	    display_template {<img src="images/edit.gif" height="12" border="0">}
	    link_html {title "Modifica categoria"}
	    sub_class narrow
	}
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="images/delete.gif" height="12" border="0">}
	    link_html {title "Cancella categoria" onClick "return(confirm('Confermi la cancellazione?'));"}
	    sub_class narrow
	}
    } \
    -orderby {
	default_value categoria_id
	categoria_id {
	    label "ID"
	    orderby categoria_id 
	}
	descrizione {
	    label "Categoria"
	    orderby descrizione
	}
    }
db_multirow \
    -extend {
	edit_url
	delete_url
    } categorie query "SELECT categoria_id, descrizione FROM categoriaevento [template::list::orderby_clause -name categorie -orderby]" {
	set edit_url [export_vars -base "?template=categoriaevento-gest" {categoria_id}]
	set delete_url [export_vars -base "?template=categoriaevento-canc" {categoria_id}]
    }
