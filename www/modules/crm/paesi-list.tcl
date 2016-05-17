ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 17 February 2015
} {
    orderby:optional
}
set page_title "Paesi"
set context [list $page_title]
set actions "{Nuovo paese} {paesi-gest} {Aggiunge un nuovo paese}"
template::list::create \
    -name paesi \
    -multirow paesi \
    -actions $actions \
    -elements {	
        paese_id {
            label "ID"
        }
	denominazione {
	    label "Denominazione"
	}
	edit {
	    link_url_col edit_url
	    display_template {<img src="images/edit.gif" height="12" border="0">}
	    link_html {title "Modifica anagrafica paese"}
	    sub_class narrow
	}
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="images/delete.gif" height="12" border="0">}
	    link_html {title "Cancella il paese" onClick "return(confirm('Confermi la cancellazione?'));"}
	    sub_class narrow
	}
    } \
    -orderby {
	default_value paese_id
	paese_id {
	    label "ID"
	    orderby paese_id
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
    } paesi query "SELECT paese_id, denominazione FROM paesi [template::list::orderby_clause -name paesi -orderby]" {
	set edit_url [export_vars -base "paesi-gest" {paese_id}]
	set delete_url [export_vars -base "paesi-canc" {paese_id}]
    }
