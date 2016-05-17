ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 19 February 2015
} {
    persona_id:integer
}
pf::permission
set form_new [ad_form_new_p -key persona_id]
if {$form_new} {
    set page_title "Aggiungi persona"
    set buttons [list [list "Aggiungi persona" new]]
    set mode "edit"
} else {
    set page_title "Scheda persona"
    set buttons [list [list "Modifica anagrafica" edit]]
    set mode "display"
}
set context [list $page_title]
ad_form -name persone \
    -mode $mode \
    -edit_buttons $buttons \
    -has_edit 0 \
    -has_submit 1 \
    -form {
	persona_id:key
	{nome:text
	    {label "Nome"}
	    {html {size 70 maxlength 100}}
	}
	{sec_nome:text,optional
	    {label "Secondo nome"}
	    {html {size 70 maxlength 100}}
	}
	{cognome:text
	    {label "Cognome"}
	    {html {size 70 maxlength 100}}
	}
	{albo_pf:boolean(checkbox),optional
	    {label "Albo P.F."}
	    {options {{"" 1}}}
	}
	{societa_id:integer(select),optional
	    {after_html "<a href=\"societa-gest\" target=\"_blank\"><img src=\"http://images.professionefinanza.com/icons/new.gif\" border=\"0\" height=\"12px\"></a>"}
	    {label "Societ&agrave;"}
	    {options {[db_list_of_lists query "SELECT ragionesociale, societa_id FROM crm_societa"]}}
	}
	{carica_id:integer(select),optional
	    {after_html "<a href=\"ruoli-gest\" target=\"_blank\"><img src=\"http://images.professionefinanza.com/icons/new.gif\" border=\"0\" height=\"12px\"></a>"}
	    {label "Carica"}
	    {options {"" [db_list_of_lists query "SELECT descrizione, carica_id FROM crm_cariche"]}}
	}
	{sesso:text(radio)
	    {label "Sesso"}
	    {options {{"Maschile" "M"} {"Femminile" "F"}}}
	}
	{codicefiscale:text,optional
	    {label "Codice fiscale"}
	    {html {size 70 maxlength 16}}
	}
	{partitaiva:text,optional
	    {label "Partita IVA"}
	    {html {size 70 maxlength 11}}
	}
	{user_id:search,optional
	    {label "ID Utente"}
	    {result_datatype integer}
	    {search_query "SELECT cognome||' '||nome||' ('||person_id||')', person_id FROM users WHERE LOWER (cognome) LIKE '%'||LOWER(cognome)||'%'"}
	}
	{luogo_na:search,optional
	    {after_html "<a href=\"comuni-gest\" target=\"_blank\"><img src=\"http://images.professionefinanza.com/icons/new.gif\" border=\"0\" height=\"12px\"></a>"}
	    {label "Luogo di nascita"}
	    {result_datatype integer}
	    {select_query "SELECT denominazione, comune_id FROM comuni WHERE LOWER(denominazione) LIKE '%'||LOWER(:value)||'%'"}
	}
	{note:text(textarea),optional
	    {label "Note"}
	    {html {rows 10 cols 70 wrap soft}}
	}
    }  -select_query {
	"SELECT nome, sec_nome, cognome, albo_pf, societa_id, sesso, codicefiscale, partitaiva, user_id, luogo_na, note FROM crm_persone WHERE persona_id = :persona_id"
    } -edit_data {
	db_dml query "UPDATE crm_persone SET nome = :nome, sec_nome = :sec_nome, albo_pf = :albo_pf, societa_id = :societa_id, sesso = :sesso, codicefiscale = :codicefiscale, partitaiva = :partitaiva, user_id = :user_id, luogo_na = :luogo_na, note = :note WHERE persona_id = :persona_id"
    }
if {!$form_new} {
    template::list::create \
	-name "contatti" \
	-multirow "contatti" \
	-key persona_id \
	-no_data "Nessun contatto è stato inserito per questo profilo." \
	-class "table table-hover" \
	-row_pretty_plural "contatti" \
	-elements {
	    contatto {
		label "Contatti"
	    }
	    edit {
		link_url_col edit_url
		display_template "<img src=\"http://images.professionefinanza.com/icons/edit.gif\" height=\"12px\" border=\"0\">"
		link_html {title "Modifica contatto"}
		sub_class narrow
	    }
	    delete {
		link_url_col delete_url
		display_template "<img src=\"http://images.professionefinanza.com/icons/delete.gif\" height=\"12px\" border=\"0\">"
		link_html {title "Cancella contatto" onClick "return(confirm('Attenzione: azione non reversibile.\n Sei sicuro di voler continuare?"}
		sub_class narrow
	    }
	}
    db_multirow \
	-extend {
	    edit_url
	    delete_url
	} contatti query "SELECT c.valore||' ('||t.descrizione||') ' AS contatto FROM crm_contatti c, crm_tipocontatto t WHERE c.persona_id = :persona_id AND t.tipo_id = c.tipo_id" {
	    set edit_url [export_vars -base "contatti-gest" {contatto_id persona_id}]
	    set delete_url [export_vars -base "contatti-canc" {contatto_id persona_id}]
	}
    template::list::create \
	-name "eventi" \
	-multirow "eventi" \
	-key persona_id \
	-no_data "Non risultano presenze a nessun evento per questo profilo." \
	-class "table table-hover" \
	-row_pretty_plural "eventi" \
	-elements {
	    denominazione {
		label "Evento"
	    }
	    luogo {
		label "Luogo"
	    }
	    data {
		label "Data"
	    }
	    delete {
		link_url_col delete_url
		display_template "<img src=\"http://images.professionefinanza.com/images/delete.gif\" height=\"12px\" border=\"0\">"
		link_html {title "Cancella contatto" onClick "return(confirm('Attenzione: azione non reversibile.\n Sei sicuro di voler continuare?"}
		sub_class narrow
	    }
	}
    db_multirow \
	-extend {
	    delete_url
	} eventi query "SELECT p.partecipazione_id, e.data, t.denominazione, c.denominazione AS luogo FROM eventi e, tipoevento t, comuni c, partecipazioni p WHERE p.persona_id = :persona_id AND e.tipo_id = t.tipo_id AND p.evento_id = e.evento_id AND e.comune_id = c.comune_id" {
	    set delete_url [export_vars -base "partecipazione-canc" {partecipazione_id persona_id}]
	}
    template::list::create \
	-name "indirizzi" \
	-multirow "indirizzi" \
	-key persona_id \
	-class "table table-hover" \
	-no_data "Non risultano indirizzi collegati a questo profilo." \
	-row_pretty_plural "indirizzi" \
	-elements {
	    via {
		label "Via"
	    }
	    comune {
		label "Comune"
	    }
	    provincia {
		label "Provincia"
	    }
	    cap {
		label "CAP"
	    }
	    delete {
		link_url_col delete_url
		display_template "<img src=\"http://images.professionefinanza.com/icons/delete.gif\" height=\"12px\" border=\"0\">"
		link_html {title "Cancella indirizzoo" onClick "return(confirm('Attenzione: azione non reversibile.\n Sei sicuro di voler continuare?"}
		sub_class narrow
	    }
	}
    db_multirow \
	-extend {
	    delete_url
	} indirizzi query "SELECT i.indirizzo_id, i.via, c.denominazione AS comune, p.denominazione AS provincia, c.cap FROM crm_indirizzi i, comuni c, province p WHERE i.persona_id = :persona_id AND c.comune_id = i.comune_id AND p.provincia_id = c.provincia_id AND i.persona_id = :persona_id" {
	    set delete_url [export_vars -base "indirizzi-canc" {indirizzo_id persona_id}]
	}
    template::list::create \
	-name "telefonate" \
	-multirow "telefonate" \
	-key persona_id \
	-class "table table-hover" \
	-no_data "Nessuna chiamata risulta registrata per questa persona." \
	-row_pretty_plural "telefonate" \
	-elements {
	    persona {
		label "Persona"
	    }
	    data {
		label "Data"
	    }
	    commento {
		label "Commento"
	    }
	    delete {
		link_url_col delete_url
		display_template "<img src=\"http://images.professionefinanza.com/icons/delete.gif\" height=\"12px\" border=\"0\">"
		link_html {title "Cancella telefonata" onClick "return(confirm('Attenzione: azione non reversibile.\n Sei sicuro di voler continuare?"}
		sub_class narrow
	    }
	}
    db_multirow \
	-extend {
	    delete_url
	} telefonate query "SELECT t.telefonata_id, u.screen_name AS persona, t.data, t.commento FROM crm_telefonate t, users u WHERE u.user_id = t.user_id AND t.persona_id = :persona_id" {
	    set delete_url [export_vars -base "telefonate-canc" {telefonata_id persona_id}]
	}
}
