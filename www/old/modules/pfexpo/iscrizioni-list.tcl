ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 12 November, 2014
} {
    {rows_per_page 30}
    {offset 0}
    {q ""}
    {q_evento_id 0}
    {iscrizione_id 0}
    evento_id:integer,optional
    orderby:optional
}
set user_id [ad_conn user_id]
if {$user_id == 0} {
    ad_returnredirect "login?return_url=/pfawards/"
}
set page_title "Lista iscrizioni"
set context [list "$page_title"]
ad_navbar $context
set actions {"Stampa elenco" iscrizione-stamp "Stampa l'elenco di tutte i partecipanti per evento"}
source [ah::package_root -package_key ah-util]/paging-buttons.tcl
set evento_id_options ""
append evento_id_options "<option disabled selected value=\"0\">Eventi...</option>"
db_foreach query "SELECT descrizione, evento_id FROM pf_expo_eventi" {
    if {$q_evento_id == $evento_id} {
	append evento_id_options "<option value =\"${evento_id}\" selected =\"selected\">${descrizione}</option>"
    } else {
	append evento_id_options "<option value=\"${evento_id}\">${descrizione}</option>"
    }
}
set list_name "iscrizioni"
template::list::create \
    -name $list_name \
    -multirow $list_name \
    -key iscrizione_id \
    -actions $actions \
    -row_pretty_plural "iscrizioni" \
    -no_data "Nessuna iscrizione" \
    -caption "Iscrizioni" \
    -elements {
	evento {
	    label "Evento"
	}
	iscritto {
	    label "Iscritto"
	    link_html {title "Vai alla situazione utente."}
	    link_url_col profile_url
	    sub_class narrow
	}
	pagato {
	    link_html {title "Clicca per cambiare stato pagamento."}
	    link_url_col paid_url
	    sub_class narrow
	}
    } \
    -filters {
	q {
            hide_p 1
            values {$q $q}
            where_clause {UPPER(i.iscritto_id||i.nome||i.cognome||i.email) LIKE UPPER('%$q%')}
        }
	rows_per_page {
	    label "Righe"
	    values {{Venticinque 25} {Cinquanta 50} {Cento 100}}
	    where_clause {1 = 1}
	    default_value 25
	}
	evento_id {
	    hide_p 1
	    where_clause {((e.evento_id = :q_evento_id AND :q_evento_id <> 0) OR :q_evento_id = 0)}
	}
    }
db_multirow \
    -extend {
	paid_url
	profile_url
    } $list_name query "SELECT s.iscrizione_id, i.iscritto_id, e.descrizione AS evento, i.nome||' '||i.cognome||' ('||i.iscritto_id||')' AS iscritto, CASE WHEN pagato = true THEN 'Pagato' WHEN pagato = false THEN 'Non pagato' WHEN pagato IS NULL THEN '' END AS pagato FROM pf_expo_iscrizioni s, pf_expo_eventi e, pf_expo_iscr i WHERE e.evento_id = s.evento_id AND i.iscritto_id = s.iscritto_id [template::list::filter_where_clauses -name $list_name -and] [template::list::orderby_clause -name $list_name -orderby] LIMIT $rows_per_page OFFSET $offset" {
	set current_url [ad_conn url]
	set return_url [export_vars -base $current_url {rows_per_page offset q_evento_id iscrizione_id evento_id orderby}]
	set paid_url [export_vars -base "iscrizione-paid" {iscrizione_id return_url}]
	set profile_url [export_vars -base "iscritto-gest" {iscritto_id}]
}