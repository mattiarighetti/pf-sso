ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Monday 27 October, 2014
} {
    {rows_per_page 30}
    {offset 0}
    {q ""}
    {q_categoria_id 0}
    {domanda_id 0}
    categoria_id:integer,optional
    orderby:optional
}
set user_id [ad_conn user_id]
set user_admin [db_0or1row query ""]
if {$user_id == 0 || $user_admin == 1} {
    ad_returnredirect "login?return_url=/pfawards/"
}
set page_title "Gestione domande"
set actions {"Aggiungi" domande-gest "Aggiunge una nuova domanda." "Stampa lista" domande-stamp "Stampa l'elenco di tutte le domande."}
source [ah::package_root -package_key ah-util]/paging-buttons.tcl
set categoria_id_options ""
append categoria_id_options "<option value=\"0\">Tutte</option>"
db_foreach categorielist "" {
    if {$q_categoria_id == $categoria_id} {
	append categoria_id_options "<option value =\"${categoria_id}\" selected =\"selected\">${descrizione}</option>"
    } else {
	append categoria_id_options "<option value=\"${categoria_id}\">${descrizione}</option>"
    }
}
template::list::create \
    -name domande \
    -multirow domande \
    -actions $actions \
    -elements {
	numero {
	    label "Numero"
	}	
	corpo {
	    label "Corpo"
	}
	descrizione {
	    label "Categoria"
	}
	punti_s {
	    label "Punti"
	}
	risp {
	    link_url_col risp_url
	    display_template {<font size="2px">Risposte</font>}
	    link_html {title "Modifica risposte."}
	    sub_class narrow
	}
        edit {
            link_url_col edit_url
            display_template {<img src="images/icona-edit.ico" width="20px" height="20px" border="0">}
            link_html {title "Modifica domanda." width="20px"}
            sub_class narrow
        }
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="images/icona-delete.ico" width="20px" height="20px" border="0">}
	    link_html {title "Cancella domanda." onClick "return(confirm('Vuoi davvero cancellare la domanda?'));" width="20px"}
	    sub_class narrow
	}
    } \
    -filters {
	q {
            hide_p 1
            values {$q $q}
            where_clause {UPPER(d.corpo||d.domanda_id) LIKE UPPER('%$q%')}
        }
	rows_per_page {
	    label "Righe"
	    values {{Quindici 15} {Trenta 30} {Cinquanta 50}}
	    where_clause {1 = 1}
	    default_value 50
	}
	categoria_id {
	    hide_p 1
	    where_clause {((d.categoria_id = :q_categoria_id AND :q_categoria_id <> 0) OR :q_categoria_id = 0)}
	}
    } \
    -orderby {
	default_value numero
	numero {
	    label "Numero"
	    orderby d.domanda_id
	}
	corpo {
	    label "Corpo"
	    orderby d.corpo
	}
    }
db_multirow \
    -extend {
	risp_url
	edit_url
	delete_url 
    } domande domandelist ""{
	set risp_url [export_vars -base "risposte-list" {domanda_id}]
	set edit_url [export_vars -base "domande-gest" {domanda_id}]
	set delete_url [export_vars -base "domande-canc" {domanda_id}]
    }