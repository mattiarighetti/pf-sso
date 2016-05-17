ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Tuesday 21 April 2015
} {
    orderby:optional
}
set page_title "Tipi di evento"
set context [list $page_title]
set actions "{Nuovo tipo} {tipoevento-gest} {Aggiunge un nuovo tipo di evento}"
pf::permission
template::list::create \
    -name tipi \
    -multirow tipi \
    -actions $actions \
    -elements {	
        tipo_id {
            label "ID"
        }
	categoria {
	    label "Categoria"
	}
	denominazione {
	    label "Denominazione"
	}
	edit {
	    link_url_col edit_url
	    display_template "<img src=\"http://images.professionefinanza.com/icons/edit.gif\" height=\"12\" border=\"0\">"
	    link_html {title "Modifica tipo"}
	    sub_class narrow
	}
   	delete {
	    link_url_col delete_url 
	    display_template "<img src=\"http://images.professionefinanza.com/icons/delete.gif\" height=\"12\" border=\"0\">"
	    link_html {title "Cancella tipo" onClick "return(confirm('Confermi la cancellazione?'));"}
	    sub_class narrow
	}
    } \
    -orderby {
	default_value tipo_id
	tipo_id {
	    label "ID"
	    orderby tipo_id 
	}
	denominazione {
	    label "Denominazione"
	    orderby denominazione
	}
    }
db_multirow \
    -extend {
	edit_url
	delete_url
    } tipi query "SELECT t.tipo_id, t.denominazione, c.descrizione AS categoria FROM tipoevento t LEFT OUTER JOIN categoriaevento c ON t.categoria_id = c.categoria_id [template::list::orderby_clause -name tipi -orderby]" {
	set edit_url [export_vars -base "tipoevento-gest" {tipo_id}]
	set delete_url [export_vars -base "tipoevento-canc" {tipo_id}]
    }
