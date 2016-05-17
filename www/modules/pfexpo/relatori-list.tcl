ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 23 December 2014
} {
    expo_id:naturalnum
    orderby:optional
    {module "pfexpo"}
}
set page_title "Relatori"
set context [list [list ?template=modules%2Fpfexpo%2Findex&module=pfexpo "PFEXPO"] $page_title]
set actions "{Nuovo relatore} {?module=pfexpo&template=modules%2Fpfexpo%2Frelatori-gest&expo_id=$expo_id} {Aggiunge un nuovo relatore}"
template::list::create \
    -name relatori \
    -multirow relatori \
    -actions $actions \
    -elements {	
	nome {
	    label "Nome"
	}
	cognome {
	    label "Cognome"
	}
	edit {
	    link_url_col edit_url
	    display_template {<img src="http://images.professionefinanza.com/icons/edit.gif" height="12" border="0">}
	    link_html {title "Modifica relatore."}
	    sub_class narrow
	}
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="http://images.professionefinanza.com/icons/delete.gif" height="12" border="0">}
	    link_html {title "Cancella relatore." onClick "return(confirm('Sei davvero sicuro di voler cancellare il relatore?'));"}
	    sub_class narrow
	}
    } \
    -orderby {
	default_value relatore_id
	relatore_id {
	    label "Identificativo"
	    orderby relatore_id
	}
	nome {
		label "Nome"
		orderby nome
	}
	cognome {
		label "Cognome"
		orderby cognome
	}
}
db_multirow \
    -extend {
	edit_url
	delete_url
    } relatori query "SELECT relatore_id, nome, cognome from expo_relatori [template::list::filter_where_clauses -name relatori] [template::list::orderby_clause -name relatori -orderby]" {
	set edit_url [export_vars -base "?module=pfexpo&template=modules%2Fpfexpo%2Frelatori-gest" {relatore_id expo_id}]
	set delete_url [export_vars -base "?module=pfexpo&template=modules%2Fpfexpo%2Frelatori-canc" {relatore_id expo_id}]
    }
