ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 17 February 2015
} {
    orderby:optional
}
set page_title "Provincie"
set context [list $page_title]
set actions "{Nuova provincia} {provincie-gest} {Aggiungi una nuova provincia}"
template::list::create \
    -name provincie \
    -multirow provincie \
    -actions $actions \
    -elements {	
        provincia_id {
            label "ID"
        }
	denominazione {
	    label "Denominazione"
	}
	edit {
	    link_url_col edit_url
	    display_template {<img src="images/edit.gif" height="12" border="0">}
	    link_html {title "Modifica provincia"}
	    sub_class narrow
	}
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="/pf/images/delete.gif" height="12" border="0">}
	    link_html {title "Cancella provincia" onClick "return(confirm('Confermi la cancellazione?'));"}
	    sub_class narrow
	}
    } \
    -orderby {
	default_value provincia_id
	provincia_id {
	    label "ID"
	    orderby provincia_id
	}
	denominazione {
	    label "Denominazione"
	    orderby denominazione
	}
    }
db_multirow \
    -extend {
	edit_url
	delete_url
    } provincie query "SELECT provincia_id, denominazione FROM pf_provincie [template::list::orderby_clause -name provincie -orderby]" {
	set edit_url [export_vars -base "provincie-gest" {provincia_id}]
	set delete_url [export_vars -base "provincie-canc" {provincia_id}]
    }
