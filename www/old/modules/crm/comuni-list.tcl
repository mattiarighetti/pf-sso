ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 17 February 2015
} {
    orderby:optional
}
pf::permission
set page_title "Elenco comuni"
set context [list $page_title]
set actions "{Nuovo comune} {comuni-gest} {Aggiunge un nuovo comune}"
template::list::create \
    -name comuni \
    -multirow comuni \
    -actions $actions \
    -elements {	
        comune_id {
            label "ID"
        }
	denominazione {
	    label "Denominazione"
	}
	cap {
	    label "CAP"
	}
	provincia {
	    label "Provincia"
	}
	edit {
	    link_url_col edit_url
	    display_template {<img src="images/edit.gif" height="12" border="0">}
	    link_html {title "Modifica anagrafica comuni"}
	    sub_class narrow
	}
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="images/delete.gif" height="12" border="0">}
	    link_html {title "Cancella il comune" onClick "return(confirm('Confermi la cancellazione?'));"}
	    sub_class narrow
	}
    } \
    -orderby {
	default_value comune_id
	comune_id {
	    label "ID"
	    orderby comune_id
	}
	denominazione {
	    label "Denominazione"
	    orderby denominazione
	}
	provincia {
	    label "Provincia"
	    orderby p.denominazione
	}
    }
db_multirow \
    -extend {
	edit_url
	delete_url
    } comuni query "SELECT c.comune_id, c.denominazione, c.cap, p.denominazione FROM comuni c, provincie p WHERE c.provincia_id = p.provincia_id [template::list::filter_where_clauses -name eventi -and] [template::list::orderby_clause -name eventi -orderby]" {
	set edit_url [export_vars -base "comuni-gest" {comune_id}]
	set delete_url [export_vars -base "comuni-canc" {comune_id}]
    }
