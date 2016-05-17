ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 29 May 2015
} {
    expo_id:integer
    orderby:optional
}
set page_title "Sale"
set luogo [db_string query "select l.descrizione from expo_luoghi l, expo_edizioni e where e.luogo_id = l.luogo_id and e.expo_id = :expo_id"]
set context [list [list / "Dashboard"] [list ?module=pfexpo "PFEXPO"] $page_title]
set actions "{Nuova sala} {?module=pfexpo&expo_id=1&template=modules%2Fpfexpo%2Fsale-gest} {Aggiunge una nuova sala}"
template::list::create \
    -name sale \
    -multirow sale \
    -actions $actions \
    -elements {	
	denominazione {
	    label "Denominazione"
	}
	edit {
	    link_url_col edit_url
	    display_template {<img src="http://images.professionefinanza.com/icons/edit.gif" height="12" border="0">}
	    link_html {title "Modifica sala."}
	    sub_class narrow
	}
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="http://images.professionefinanza.com/icons/delete.gif" height="12" border="0">}
	    link_html {title "Cancella sala." onClick "return(confirm('Sei davvero sicuro di voler cancellare la sala?'));"}
	    sub_class narrow
	}
}
db_multirow \
    -extend {
	edit_url
	delete_url
    } sale query "select s.sala_id, s.denominazione from expo_sale s, expo_edizioni e where s.luogo_id = e.luogo_id and e.expo_id = :expo_id [template::list::filter_where_clauses -name sale] order by sala_id" {
	set edit_url "?module=pfexpo&expo_id=1&sala_id=:sala_id&template=modules%2Fpfexpo%2Fsale-gest"
	set delete_url "?module=pfexpo&expo_id=1&sala_id=:sala_id&template=modules%2Fpfexpo%2Fsale-canc"
    }
