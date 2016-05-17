ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Monday 20 April 2015
} {
    categoria_id:integer
    orderby:optional
}
pf::permission
set page_title "Eventi"
set context [list $page_title]
set return_url [ad_return_url]
set actions "{Nuovo tipo} {[export_vars -base tipoevento-gest {return_url}]} {Aggiunge un nuovo tipo}"
template::list::create \
    -name eventipo \
    -multirow eventipo \
    -actions $actions \
    -elements {	
	denominazione {
	    label "Denominazione"
	    link_url_col eventdata_url
	}
	tipo_id {
	    label "ID"
	}
	eventi {
	    label "# eventi"
	}
    } \
    -orderby {
	default_value tipo_id
	tipo_id {
	    label "ID"
	    orderby tipo_id 
	}
    }
db_multirow \
    -extend {
	eventdata_url
    } eventipo query "SELECT t.denominazione, t.tipo_id, (SELECT COUNT(*) FROM eventi e WHERE e.tipo_id = t.tipo_id) AS eventi FROM tipoevento t WHERE t.categoria_id = :categoria_id [template::list::orderby_clause -name eventipo -orderby]" {
	set eventdata_url [export_vars -base "eventi-guida-3" {tipo_id}]
    }
