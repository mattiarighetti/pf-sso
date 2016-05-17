ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Saturday 1 November, 2014
} {
    {rows_per_page 100}
    {offset 0}
    {q ""}
    {q_categoria_id 0}
    categoria_id:integer,optional
    orderby:optional
}
set user_id [ad_conn user_id]
set user_admin [db_0or1row query "SELECT * FROM pf_iscritti WHERE iscritto_id = :user_id"]
if {$user_id == 0 || $user_admin == 1} {
    ad_returnredirect "login?return_url=/pfawards/"
}
set page_title "Sessioni d'esame - PFAwards"
set actions {"Aggiungi" esami-gest "Aggiunge una nuova sessione." "Stampa lista" esami-stamp "Stampa gli esami."}
source [ah::package_root -package_key ah-util]/paging-buttons.tcl
set categoria_id_options ""
append categoria_id_options "<option value=\"0\">Tutte</option>"
db_foreach query "SELECT descrizione, categoria_id FROM pf_categorie ORDER BY categoria_id" {
    if {$q_categoria_id == $categoria_id} {
        append categoria_id_options "<option value =\"${categoria_id}\" selected =\"selected\">${descrizione}</option>"
    } else {
        append categoria_id_options "<option value=\"${categoria_id}\">${descrizione}</option>"
    }
}
template::list::create \
    -name esami \
    -multirow esami \
    -actions $actions \
    -elements {
	numero {
	    label "Numero"
	}	
	iscritto {
	    label "Utente"
	}
	descrizione {
	    label "Categoria"
	}
	punti {
	    label "Punti"
	}
	case2 {
	    label "Promosso"
	}
	reset {
	    link_url_col reset_url
	    display_template {<img src="images/reset_timer.png" width="20px" height="20px" border="0">}
	    link_html {title "Resetta tempo." onClick "return(confirm('Cliccando su OK aggiungerai 30 minuti in più.'));"}
	    sub_class narrow
	}
	view {
	    link_url_col view_url
            display_template {<img src="images/view.gif" width="35px" border="0">}
            link_html {title "Scarica PDF."}
            sub_class narrow
	}
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="images/icona-delete.ico" width="20px" height="20px" border="0">}
	    link_html {title "Annulla esame." onClick "return(confirm('Vuoi davvero annullare l'esame?'));"}
	    sub_class narrow
	}
    } \
    -filters {
	q {
            hide_p 1
            values {$q $q}
            where_clause {UPPER(i.nome||i.cognome||e.esame_id) LIKE UPPER('%$q%')}
        }
	rows_per_page {
	    label "Righe"
	    values {{Quindici 15} {Trenta 30} {Cinquanta 50}}
	    where_clause {1 = 1}
	    default_value 50
	}
	categoria_id {
	    hide_p 1
	    where_clause {((e.categoria_id = :q_categoria_id AND :q_categoria_id <> 0) OR :q_categoria_id = 0)}
	}
    } \
    -orderby {
	default_value numero
	numero {
	    label "Numero"
	    orderby e.esame_id
	}
	utente {
	    label "Utente"
	    orderby i.cognome
	}
	punti {
	    label "Punti"
	    orderby punti
	}
    }
db_multirow \
    -extend {
	edit_url
	view_url
	reset_url
	delete_url 
    } esami query "SELECT e.esame_id, '#'||e.esame_id AS numero, i.cognome||' '||i.nome AS iscritto, SUM(r.punti) AS punti, c.descrizione, e.fase_2,
             CASE WHEN e.fase_2=1 THEN 'sì' ELSE 'no' END AS case2 
                       FROM pf_iscritti i, pf_categorie c, pf_esami e
            LEFT OUTER JOIN pf_rispusr u ON e.esame_id = u.esame_id
            LEFT OUTER JOIN pf_risposte r ON u.risposta_id = r.risposta_id
                      WHERE e.categoria_id = c.categoria_id
                        AND e.iscritto_id = i.iscritto_id
                            [template::list::filter_where_clauses -name esami -and]
                   GROUP BY e.esame_id, numero, iscritto, descrizione
                            [template::list::orderby_clause -name esami -orderby]
                      LIMIT $rows_per_page
                     OFFSET $offset" {
			 set edit_url [export_vars -base "esami-gest" {esame_id}]
			 set view_url [export_vars -base "esami-stamp" {esame_id}]
			 set reset_url [export_vars -base "esami-reset" {esame_id}]
			 set delete_url [export_vars -base "esami-canc" {esame_id}]
		       }