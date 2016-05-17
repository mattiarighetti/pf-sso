ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 23 December 2014
} {
    expo_id:integer
    {module "pfexpo"}
    orderby:optional
}
pf::permission
set page_title "Eventi"
set context [list [list ?module=pfexpo "PFEXPO"] $page_title]
set actions [list "Nuovo evento" [export_vars -base ?template=modules%2Fpfexpo%2Feventi-gest {module expo_id}] "Aggiunge un nuovo evento."]
template::list::create \
    -name eventi \
    -multirow eventi \
    -actions $actions \
    -elements {	
	denominazione {
	    label "Denominazione"
	    link_url_col edit_url
	}
	iscritti {
	    label "Iscritti"
	    link_url_col subscribed_url
	}
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="http://images.professionefinanza.com/icons/delete.gif" height="12" border="0">}
	    link_html {title "Cancella l'evento." onClick "return(confirm('Sei davvero sicuro di voler cancellare l'evento?'));"}
	    sub_class narrow
	}
    } \
    -orderby {
	default_value evento_id
	evento_id {
	    label "ID"
	    orderby evento_id
	}
    }
db_multirow \
    -extend {
	edit_url
	subscribed_url
	delete_url
    } eventi query "select e.evento_id, e.denominazione, count(i.iscritto_id) as iscritti from expo_eventi e, expo_iscrizioni i where i.evento_id = e.evento_id and expo_id = :expo_id [template::list::filter_where_clauses -name eventi -and] group by e.evento_id, e.denominazione [template::list::orderby_clause -name eventi -orderby]" {
	set edit_url [export_vars -base "?template=modules%2Fpfexpo%2Feventi-gest" {module expo_id evento_id}]
	set subscribed_url [export_vars -base "?template=modules%2Fpfexpo%2Fiscritti-list" {module expo_id evento_id}]
	set delete_url [export_vars -base "?template=modules%2Fpfexpo%2Feventi-canc" {module expo_id evento_id}]
    }
