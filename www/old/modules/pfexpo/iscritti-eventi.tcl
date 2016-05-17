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
template::list::create \
    -name eventi \
    -multirow eventi \
    -caption "Seleziona l'evento per vederne gli iscritti." \
    -elements {	
        evento_id {
            label "ID"
        }
	denominazione {
	    label "Denominazione"
	    link_url_col iscritti_url
	}
    iscritti {
            label "Iscritti"
    }
    } 
db_multirow \
    -extend {
	iscritti_url
    } eventi query "select e.evento_id, e.denominazione, count(distinct(i.persona_id)) as iscritti from expo_eventi e, expo_iscrizioni i where e.evento_id = i.evento_id and e.expo_id = :expo_id group by e.evento_id, e.denominazione [template::list::filter_where_clauses -name eventi -and] [template::list::orderby_clause -name eventi -orderby]" {
	set iscritti_url "?module=pfexpo&expo_id=$expo_id&evento_id=$evento_id&template=modules%2Fpfexpo%2Fiscritti-list"
    }
