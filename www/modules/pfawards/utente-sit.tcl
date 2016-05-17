ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Tuesday 28 October, 2014
} {
    iscritto_id:integer
}
set user_id [ad_conn user_id]
set user_admin [db_0or1row query "SELECT * FROM pf_iscritti WHERE iscritto_id = :user_id"]
if {$user_id == 0 || $user_admin == 1} {
    ad_returnredirect "login?return_url=/pfawards/"
}
set page_title "Esami"
template::list::create \
    -name esami \
    -multirow esami \
    -key esame_id \
    -elements {
	numero {
	    label "Numero"
	}
	categoria {
	    label "Esame"
	}
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="images/icona-delete.ico" width="20px" height="20px" border="0">}
	    link_html {title "Cancella scheda utente." onClick "return(confirm('Vuoi davvero cancellare la scheda?'));" width="20px"}
	    sub_class narrow
	}
    } \
    -orderby {
	default_value numero
	numero {
	    label "Esame"
	    orderby c.categoria_id
	}
    }
db_multirow \
    -extend {
	delete_url 
    } esami query "SELECT '#'||e.esame_id AS numero, c.descrizione AS categoria
                      FROM pf_esami e, pf_categorie c
                     WHERE e.iscritto_id = :iscritto_id
                           [template::list::orderby_clause -name esami -orderby]
                    " {
			set delete_url [export_vars -base "esami-canc" {esame_id}]
		    }