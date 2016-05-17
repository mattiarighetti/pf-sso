ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 12 November, 2014
} {
    expo_id:naturalnum
    {module "pfexpo"}
    {rows_per_page 25}
    orderby:optional
}
pf::permission
set page_title "Iscritti"
set context [list "$page_title"]
set list_name "iscritto"
template::list::create \
    -name $list_name \
    -multirow $list_name \
    -key iscritto_id \
    -elements {
	nome {
	    label "Nome"
	}
	cognome {
	    label "Cognome"
	}
	email {
	    label "Email"
	}
	pagato {
	    label "Status"
	    link_url_col pay_url
	}
	delete {
	    link_url_col delete_url
	    display_template {<img src="http://images.professionefinanza.com/icons/delete.gif" height="15px" border="0"}
            link_html {title "Cancella iscrizione."}
            sub_class narrow
	}
    } \
    -orderby {
	default_value cognome
	cognome {
	    label "Cognome"
	    orderby cognome
	}
    }
db_multirow \
    -extend {
	pay_url
	delete_url
    } $list_name query "SELECT iscritto_id, nome, cognome, email, case when pagato is true then 'Pagato' else 'Non pagato' end as pagato from expo_iscritti [template::list::filter_where_clauses -name $list_name] [template::list::orderby_clause -name $list_name -orderby]" {
	set pay_url "http://sso.professionefinanza.com/index?template=modules%2Fpfexpo%2Fiscritti%2dpagato&iscritto_id="
	append pay_url $iscritto_id
	set delete_url [export_vars -base "?template=modules%2Fpfexpo%2Fiscrizioni-canc" {iscritto_id evento_id}]
    }
