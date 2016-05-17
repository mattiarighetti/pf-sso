ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 19 February 2015
} {
    societa_id:integer,optional
}
set new [ad_form_new_p -key societa_id]
if {$new} {
    set page_title "Nuova società"
    set buttons [list [list "Aggiungi società" new]]
    set mode "edit"
} else {
    set page_title "Modifica società"
    set buttons [list [list "Modifica società" edit]]
    set mode "display"
}
ad_form -name societa \
    -mode $mode \
    -edit_buttons $buttons \
    -has_edit 1 \
    -form {
	societa_id:key
	{ragionesociale:text
	    {label "Ragione sociale"}
	    {html {size 70 maxlength 100}}
	}
    }  -select_query {
	"SELECT societa_id, ragionesociale FROM crm_societa WHERE societa_id = :societa_id"
    } -new_data {
      	set provincia_id [db_string query "SELECT COALESCE(MAX(societa_id)+1,1) FROM crm_societa"]
	db_dml query "INSERT INTO crm_societa (societa_id, ragionesociale) VALUES (:societa_id, :ragionesociale)"
    } -edit_data {
	db_dml query "UPDATE crm_societa SET ragionesociale = :ragionesociale WHERE societa_id = :societa_id"
    } -after_submit {
	ad_returnredirect "societa-list"
	ad_script_abort
    }
if {![ad_form_new_p -key societa_id]} {
    template::list::create \
	-name "gerarchia" \
	-multirow "gerarchia" \
	-key "carica_id" \
	-caption "Struttura degli incarichi" \
	-no_data "Nessun tipo di incarico presente." \
	-elements {
	    descrizione {
		label "Descrizione"
	    }
	    edit {
		link_url_col edit_url
		display_template "<img src=\"images/edit.gif\" width=\"12px\"border=\1\">"
		sub_class narrow
		link_html {title "Modifica questo incarico"}
	    }
	    delete {
		link_url_col delete_url
		display_template "<img src=\"images/delete.gif\" width=\"12px\" border=\"0\">"
		sub_class narrow
		link_html {title "Cancella questo tipo di incarico"}
	    }
	}
    db_multirow -extend {
	edit_url
	delete_url
    } gerarchia query "SELECT carica_id, descrizione FROM crm_cariche WHERE societa_id = :societa_id" {
	set edit_url [export_vars -base "cariche-gest" {carica_id}]
	set delete_url [export_vars -base "cariche-canc" {carica_id}]
    }
}
