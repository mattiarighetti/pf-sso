ad_page_contract {
    @author Mattia Righetti (mattia.righetti@mail.polimi.it)
    @creation-date Tuesday 28 October, 2014
} {
    {rows_per_page 30}
    {offset 0}
    domanda_id:integer
}
set user_id [ad_conn user_id]
set user_admin [db_0or1row query "SELECT * FROM pf_iscritti WHERE iscritto_id = :user_id"]
if {$user_id == 0 || $user_admin == 1} {
    ad_returnredirect "login?return_url=/pfawards/"
}
set page_title "Risposte alla #"
append page_title "$domanda_id"
set add_link "risposte-gest?domanda_id="
append add_link "$domanda_id"
set actions {"Aggiungi" risposte-gest?domanda_id= "Aggiunge una nuova risposta."}
source [ah::package_root -package_key ah-util]/paging-buttons.tcl
template::list::create \
    -name risposte \
    -multirow risposte \
    -actions $actions \
    -elements {
	numero {
	    label "Numero"
	}
	corpo {
	    label "Corpo"
	}
	punti {
	    label "Punti"
	}
        edit {
            link_url_col edit_url
            display_template {<img src="images/icona-edit.ico" width="20px" height="20px" border="0">}
            link_html {title "Modifica risposta." width="20px"}
            sub_class narrow
        }
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="images/icona-delete.ico" width="20px" height="20px" border="0">}
	    link_html {title "Cancella risposta." onClick "return(confirm('Vuoi davvero cancellare la domanda?'));" width="20px"}
	    sub_class narrow
	}
    } \
    -filters {
	rows_per_page {
	    label "Righe"
	    values {{Quindici 15} {Trenta 30} {Cinquanta 50}}
	    where_clause {1 = 1}
	    default_value 50
	}
    } \
    -orderby {
	default_value punti
	punti {
	    label "Punti"
	    orderby_desc punti
	}
    }
db_multirow \
    -extend {
	edit_url
	delete_url 
    } risposte query "SELECT '#'||risposta_id AS numero, corpo, punti, risposta_id
                       FROM pf_risposte
                      WHERE domanda_id = :domanda_id
                            [template::list::filter_where_clauses -name risposte -and]
                            [template::list::orderby_clause -name risposte -orderby]
                      LIMIT $rows_per_page
                     OFFSET $offset" {
			 set edit_url [export_vars -base "risposte-gest" {domanda_id risposta_id}]
			 set delete_url [export_vars -base "risposte-canc" {risposta_id}]
		       }