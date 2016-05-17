ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 17 February 2015
} {
    orderby:optional
}
pf::permission
set page_title "Società"
set context [list $page_title]
set actions "{Nuova società} {societa-gest} {Aggiungi una nuova società}"
template::list::create \
    -name societa \
    -multirow societa \
    -actions $actions \
    -elements {	
	ragionesociale {
	    label "Ragione sociale"
	}
	edit {
	    link_url_col edit_url
	    display_template {<img src="images/edit.gif" height="12" border="0">}
	    link_html {title "Modifica società"}
	    sub_class narrow
	}
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="/pf/images/delete.gif" height="12" border="0">}
	    link_html {title "Cancella società" onClick "return(confirm('Confermi la cancellazione?'));"}
	    sub_class narrow
	}
    } \
    -orderby {
	default_value ragionesociale
	ragionesociale {
	    label "Ragione sociale"
	    orderby ragionesociale
	}
    }
db_multirow \
    -extend {
	edit_url
	delete_url
    } societa query "SELECT * FROM crm_societa [template::list::orderby_clause -name societa -orderby]" {
	set edit_url [export_vars -base "societa-gest" {societa_id}]
	set delete_url [export_vars -base "societa-canc" {societa_id}]
    }
