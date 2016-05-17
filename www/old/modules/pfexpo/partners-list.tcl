ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 23 December 2014
} {
    expo_id:naturalnum
    {module "pfexpo"}
    orderby:optional
}
pf::permission
set page_title "Partners"
set context [list [list / "Dashboard"] [list [export_vars -base "?template=modules%2Fpfexpo%2Findex" {expo_id module}] "PFEXPO"] $page_title]
set actions "{Nuovo partner} {[export_vars -base ?template=modules%2Fpfexpo%2Fpartners-gest&expo_id=$expo_id]} {Aggiunge un nuovo partner.}"
template::list::create \
    -name partners \
    -multirow partners \
    -actions $actions \
    -elements {	
	denominazione {
	    label "Denominazione"
	}
	user_id {
	    label "ID utente"
	}
	edit {
	    link_url_col edit_url
	    display_template {<img src="http://images.professionefinanza.com/icons/edit.gif" height="12" border="0">}
	    link_html {title "Modifica partner."}
	    sub_class narrow
	}
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="http://images.professionefinanza.com/icons/delete.gif" height="12" border="0">}
	    link_html {title "Cancella partner." onClick "return(confirm('Sei davvero sicuro di voler cancellare il partner? Ci&ograve; non comporterà la cancellazione dell'account.'));"}
	    sub_class narrow
	}
    } 
db_multirow \
    -extend {
	edit_url
	delete_url
    } partners query "select partner_id, denominazione, user_id from expo_partners [template::list::filter_where_clauses -name partners] [template::list::orderby_clause -name partners -orderby]" {
	set edit_url [export_vars -base "docenti-gest" {docente_id}]
	set delete_url [export_vars -base "docenti-canc" {docente_id}]
    }
