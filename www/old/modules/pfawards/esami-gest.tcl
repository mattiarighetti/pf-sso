ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
} {
    esame_id:integer,optional
}
set user_id [ad_conn user_id]
set user_admin [db_0or1row useradmin ""]
if {$user_id == 0 || $user_admin == 1} {
    ad_returnredirect "login?return_url=/pfawards/"
}
if {[ad_form_new_p -key domanda_id]} {
    set page_title "Nuova"
    set buttons [list [list "Salva" new]]
} else {
    set modifica [db_string query "SELECT 'Numero #'||domanda_id FROM pf_domande WHERE domanda_id = :domanda_id"]
    set page_title "$modifica"
    set buttons [list [list "Aggiorna" edit]]
}
ad_form -name domande \
    -edit_buttons $buttons \
    -has_edit 1 \
    -form {
	esame_id:key
	{utente:text(select)
	    {options {{"" ""} [db_list_of_lists query "SELECT cognome||' '||nome AS utente, iscritto_id FROM pf_iscritti ORDER BY cognome"]}}
	    {label "Utente"}
	    {html {size 1 style "width:39.5em"}}
	}
	{categoria_id:text(select)
	    {options {{"" ""} [db_list_of_lists query "SELECT descrizione, categoria_id FROM pf_categorie ORDER BY categoria_id"]} }
      	    {html {size 1 style "width:39.5em"}}
            {label "Categoria"}
	}
    } -select_query {
	"SELECT iscritto_id, categoria_id FROM pf_esami WHERE esame_id = :esame_id"
    } -new_data {
	set esame_id [db_string query "SELECT COALESCE (MAX(esame_id) + 1, 1) FROM pf_esami"]
	db_dml query "INSERT INTO pf_esami (esame_id, iscritto_id, categoria_id) VALUES (:esame_id, :iscritto_id, :categoria_id)"
	set conta 0
	while {$conta < 20} {
	    set flag 1
	    while {$flag > 0} {
		set domanda_ok 1
		while {$domanda_ok == 1} {
		    set domanda_id [db_string query "SELECT domanda_id FROM pf_domande WHERE categoria_id = :categoria_id ORDER BY RANDOM() LIMIT 1"]
		    set punti [db_string query "SELECT MAX(punti) FROM pf_risposte WHERE domanda_id = :domanda_id"]
		    if {$punti == 3} {
			set domanda_ok 0
		    }
		}
		set flag [db_string query "SELECT COUNT(*) FROM pf_rispusr WHERE domanda_id = :domanda_id AND esame_id = :esame_id"]
	    }
	    set rispusr_id [db_string query "SELECT COALESCE(MAX(rispusr_id)+1,1) FROM pf_rispusr"]
	    db_dml query "INSERT INTO pf_rispusr (rispusr_id, domanda_id, esame_id) VALUES (:rispusr_id, :domanda_id, :esame_id)"
	    incr conta
	}
	set conta 0
	while {$conta < 10} {
	    set flag 1
	    while {$flag > 0} {
		set domanda_ok 1
		while {$domanda_ok == 1} {
		    set domanda_id [db_string query "SELECT domanda_id FROM pf_domande WHERE categoria_id = :categoria_id ORDER BY RANDOM() LIMIT 1"]
		    set punti [db_string query "SELECT MAX(punti) FROM pf_risposte WHERE domanda_id = :domanda_id"]
		    if {$punti == 4} {
			set domanda_ok 0
		    }
		}
		set flag [db_string query "SELECT COUNT(*) FROM pf_rispusr WHERE domanda_id = :domanda_id AND esame_id = :esame_id"]
	    }
	    set rispusr_id [db_string query "SELECT COALESCE(MAX(rispusr_id)+1,1) FROM pf_rispusr"]
	    db_dml query "INSERT INTO pf_rispusr (rispusr_id, domanda_id, esame_id) VALUES (:rispusr_id, :domanda_id, :esame_id)"
	    incr conta
	}
    } -edit_data {
	db_dml query "DELETE FROM pf_rispusr WHERE esame_id = :esame_id"
	db_dml query "UPDATE pf_esami SET iscritto_id = :iscritto_id, categoria_id = :categoria_id WHERE esame_id = :esame_id"
	set conta 0
	while {$conta < 20} {
	    set flag 1
	    while {$flag > 0} {
		set domanda_ok 1
		while {$domanda_ok == 1} {
		    set domanda_id [db_string query "SELECT domanda_id FROM pf_domande WHERE categoria_id = :categoria_id ORDER BY RANDOM() LIMIT 1"]
		    set punti [db_string query "SELECT MAX(punti) FROM pf_risposte WHERE domanda_id = :domanda_id"]
		    if {$punti == 3} {
			set domanda_ok 0
		    }
		}
		set flag [db_string query "SELECT COUNT(*) FROM pf_rispusr WHERE domanda_id = :domanda_id AND esame_id = :esame_id"]
	    }
	    set rispusr_id [db_string query "SELECT COALESCE(MAX(rispusr_id)+1,1) FROM pf_rispusr"]
	    db_dml query "INSERT INTO pf_rispusr (rispusr_id, domanda_id, esame_id) VALUES (:rispusr_id, :domanda_id, :esame_id)"
	    incr conta
	}
	set conta 0
	while {$conta < 10} {
	    set flag 1
	    while {$flag > 0} {
		set domanda_ok 1
		while {$domanda_ok == 1} {
		    set domanda_id [db_string query "SELECT domanda_id FROM pf_domande WHERE categoria_id = :categoria_id ORDER BY RANDOM() LIMIT 1"]
		    set punti [db_string query "SELECT MAX(punti) FROM pf_risposte WHERE domanda_id = :domanda_id"]
		    if {$punti == 4} {
			set domanda_ok 0
		    }
		}
		set flag [db_string query "SELECT COUNT(*) FROM pf_rispusr WHERE domanda_id = :domanda_id AND esame_id = :esame_id"]
	    }
	    set rispusr_id [db_string query "SELECT COALESCE(MAX(rispusr_id)+1,1) FROM pf_rispusr"]
	    db_dml query "INSERT INTO pf_rispusr (rispusr_id, domanda_id, esame_id) VALUES (:rispusr_id, :domanda_id, :esame_id)"
	    incr conta
	}
    } -on_submit {
	set ctr_errori 0
	if {$ctr_errori > 0} {
	    break
	}
    } -after_submit {
	ad_returnredirect "esami-list"
	ad_script_abort
    }