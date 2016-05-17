ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday, 13 February 2015
} {
    {rows_per_page 25}
    {offset 0}
    {q ""}
    orderby:optional
    comune_id:integer,optional
    {cerca_comune_id 0}
}
pf::permission
set page_title "Consulta"
set context [list $page_title]
set actions "{Nuovo profilo} {persone-gest} {Crea un nuovo profilo}"
source [ah::package_root -package_key ah-util]/paging-buttons.tcl
set comune_id_options ""
append comune_id_options "<option value=0>Tutti</option>"
db_foreach query "SELECT denominazione, comune_id FROM comuni ORDER BY denominazione" {
    if {$cerca_comune_id == $comune_id} {
        append comune_id_options " <option value=${comune_id} selected=\"selected\">${denominazione}</option>"
    } else {
        append comune_id_options " <option value=${comune_id}>${denominazione}</option>"
    }
}
template::list::create \
    -name "persone" \
    -multirow "persone" \
    -key persona_id \
    -actions $actions \
    -no_data "Nessuna persona corrisponde ai criteri di ricerca impostati." \
    -row_pretty_plural "persone" \
    -elements {
	nome {
	    label "Nome"
	}
	cognome {
	    label "Cognome"
	}
	ragionesociale {
	    label "Società"
	}
	view {
	    link_url_col view_url
	    display_template "<img src=\"http://images.professionefinanza.com/icons/view.gif\" height=\"12px\" border=\"0\">"
	    link_html {title "Apri scheda"}
	    sub_class narrow
	}
	delete {
	    link_url_col delete_url
	    display_template "<img src=\"http://images.professionefinanza.com/icons/delete.gif\" height=\"12px\" border=\"0\""
            link_html {title "Cancellazione rapida" onClick "return(confirm('Attenzione: azione non reversibile.\nSei sicuro di voler cancellare questo profilo?"}
            sub_class narrow
	}
    } \
    -filters {
	q {
            hide_p 1
            values {$q $q}
            where_clause {UPPER(p.nome||p.cognome) LIKE UPPER('%$q%')}
        }
	comune_id {
	    hide_p 1
            where_clause {((EXISTS (SELECT * FROM crm_indirizzi i WHERE i.persona_id = p.persona_id AND i.comune_id = :cerca_comune_id AND :cerca_comune_id <> 0)) or :cerca_comune_id = 0)}
        }
	rows_per_page {
	    label "Righe"
	    values {{Venticinque 25} {Cinquanta 50} {Cento 100}}
	    where_clause {1 = 1}
	    default_value 25
	}
    } \
    -orderby {
	nome {
	    label "Nome"
	    orderby p.nome
	}
	cognome {
	    label "Cognome"
	    orderby p.cognome
	}
    }
db_multirow \
    -extend {
	view_url
	delete_url
    } persone query "SELECT p.persona_id, INITCAP(LOWER(p.nome)) AS nome, INITCAP(LOWER(p.cognome)) AS cognome, s.ragionesociale FROM crm_persone p LEFT OUTER JOIN crm_societa s ON s.societa_id = p.societa_id WHERE [template::list::filter_where_clauses -name persone] [template::list::orderby_clause -name persone -orderby] LIMIT $rows_per_page OFFSET $offset" {
	set view_url [export_vars -base "persone-view" {persona_id}]
	set delete_url [export_vars -base "persone-canc" {persona_id}]
    }
