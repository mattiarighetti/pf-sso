ad_page_contract {
    @author Mattia Righetti (mattia.righetti@mail.polimi.it)
    @creation-date Tuesday 28 October, 2014
} {
    {rows_per_page 30}
    {offset 0}
    {q ""}
    {utente_id 0}
    orderby:optional
}
set user_id [ad_conn user_id]
set user_admin [db_0or1row query "SELECT * FROM pf_iscritti WHERE iscritto_id = :user_id"]
if {$user_id == 0 || $user_admin == 1} {
    ad_returnredirect "login?return_url=/pfawards/"
}
set page_title "Iscritti"
set actions {"Aggiungi" utenti-gest "Aggiunge un nuovo utente."}
source [ah::package_root -package_key ah-util]/paging-buttons.tcl
template::list::create \
    -name utenti \
    -multirow utenti \
    -key utente_id \
    -actions $actions \
    -elements {
	numero {
	    label "Numero"
	}
	utente {
	    label "Nome e Cognome"
	}
	email {
	    label "Email"
	}
	telefono {
	    label "Telefono"
	}
	password {
	    label "Password"
	}
	esami {
	    link_url_col esami_url
            display_template {<img src="images/esami.png" width="20px" height="20px" border="0">}
            link_html {title "Visualizza situazione esami." width="20px"}
            sub_class narrow
	}
        edit {
            link_url_col edit_url
            display_template {<img src="images/icona-edit.ico" width="20px" height="20px" border="0">}
            link_html {title "Modifica scheda utente." width="20px"}
            sub_class narrow
        }
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="images/icona-delete.ico" width="20px" height="20px" border="0">}
	    link_html {title "Cancella scheda utente." onClick "return(confirm('Vuoi davvero cancellare la scheda?'));" width="20px"}
	    sub_class narrow
	}
    } \
    -filters {
	q {
	    hide_p 1
	    values {$q $q}
	    where_clause {UPPER (iscritto_id||nome||cognome) LIKE UPPER ('%$q%')}
	}
	rows_per_page {
	    label "Righe"
	    values {{Quindici 15} {Trenta 30} {Cinquanta 50}}
	    where_clause {1 = 1}
	    default_value 50
	}
    } \
    -orderby {
	default_value numero
	numero {
	    label "Numero"
	    orderby iscritto_id
	}
    }
db_multirow \
    -extend {
	esami_url
	edit_url
	delete_url 
    } utenti query "SELECT '#'||iscritto_id AS numero, iscritto_id, nome||' '||cognome AS utente, azienda, email, telefono, password
                      FROM pf_iscritti
                     WHERE 1=1
                           [template::list::filter_where_clauses -name utenti -and]
                           [template::list::orderby_clause -name utenti -orderby]
                     LIMIT $rows_per_page
                    OFFSET $offset" {
			set esami_url [export_vars -base "utente-sit" {iscritto_id}]
			set edit_url [export_vars -base "utenti-gest" {iscritto_id}]
			set delete_url [export_vars -base "utenti-canc" {iscritto_id}]
		    }