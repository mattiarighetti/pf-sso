ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Monday 20 April 2015
} {
    orderby:optional
}
pf::permission
set page_title "Eventi"
set context [list $page_title]
set actions "{Nuovo evento} {eventi-gest} {Aggiunge un nuovo evento} {Nuovo tipo evento} {tipoevento-gest} {Aggiunge un nuovo tipo di evento}"
template::list::create \
    -name eventi \
    -multirow eventi \
    -actions $actions \
    -elements {	
        evento_id {
            label "ID"
        }
	tipo {
	    label "Tipo"
	}
	data {
	    label "Data"
	}
	denominazione {
	    label "Comune"
	}
	docente {
	    label "Docente"
	}
	edit {
	    link_url_col edit_url
	    display_template "<img src=\"http://images.professionefinanza.com/icons/edit.gif\" height=\"12\" border=\"0\">"
	    link_html {title "Modifica evento"}
	    sub_class narrow
	}
   	delete {
	    link_url_col delete_url 
	    display_template "<img src=\"http://images.professionefinanza.com/icons/delete.gif\" height=\"12\" border=\"0\">"
	    link_html {title "Cancella evento" onClick "return(confirm('Confermi la cancellazione?'));"}
	    sub_class narrow
	}
    } \
    -orderby {
	default_value data
	data {
	    label "Data"
	    orderby_desc data 
	}
    }
db_multirow \
    -extend {
	edit_url
	delete_url
    } eventi query "SELECT e.evento_id, t.denominazione AS tipo, TO_CHAR(e.data, 'DD/MM/YYYY') AS data, c.denominazione, r.nome||' '||r.cognome AS docente FROM tipoevento t, comuni c, eventi e LEFT OUTER JOIN docenti d ON e.docente_id = d.docente_id LEFT OUTER JOIN crm_persone r ON d.persona_id = r.persona_id WHERE t.tipo_id = e.tipo_id AND c.comune_id = e.comune_id [template::list::orderby_clause -name eventi -orderby]" {
	set edit_url [export_vars -base "eventi-gest" {evento_id}]
	set delete_url [export_vars -base "eventi-canc" {evento_id}]
    }
