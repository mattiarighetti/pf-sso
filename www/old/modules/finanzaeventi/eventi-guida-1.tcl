ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Monday 20 April 2015
} {
    orderby:optional
}
pf::permission
set page_title "Eventi"
set context [list $page_title]
set return_url [ad_return_url]
set actions "{Nuova categoria} {[export_vars -base categoriaevento-gest {return_url}]} {Aggiungi una categoria}"
template::list::create \
    -name eventicat \
    -multirow eventicat \
    -actions $actions \
    -elements {	
	descrizione {
	    label "Categoria"
	    link_url_col eventipo_url
	}
	tipi {
	    label "# tipi"
	}
    } \
    -orderby {
	default_value categoria_id
	categoria_id {
	    label "ID"
	    orderby categoria_id 
	}
    }
db_multirow \
    -extend {
	eventipo_url
    } eventicat query "SELECT c.descrizione, c.categoria_id, (SELECT COUNT(*) FROM tipoevento t WHERE t.categoria_id = c.categoria_id ) AS tipi FROM categoriaevento c [template::list::orderby_clause -name eventicat -orderby]" {
	set eventipo_url [export_vars -base "eventi-guida-2" {categoria_id}]
    }
