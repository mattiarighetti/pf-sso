ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Monday 3 November, 2014
} {
    esame_id:integer
    rispusr_id:integer,optional
}
set page_title "Sessione"
# Prepara descrizione categoria esame
set categoria [db_string categoria ""]
# Controllo utente
set user_id [ad_conn user_id]
if {$user_id == 0} {
    ad_returnredirect "login?return_url=/pfawards/"
}
set utente [db_string utente ""]
set now [db_string adesso ""]
# Se è la prima domanda (rispusr_id 0) prende la prima e imposta lo start_time
if {$rispusr_id == "0"} {
    set rispusr_id [db_string rispusrid ""]
    db_dml instime ""
}
set domanda_num [db_string query "SELECT COUNT(*)+1 FROM pf_rispusr WHERE esame_id = :esame_id AND rispusr_id < :rispusr_id"]
# Controllo tempo
set timer [db_string query "select to_char(((start_time - current_timestamp) * (-1)), 'MI') from pf_esami where esame_id=:esame_id"]
if {$timer < 30} {
    set mode "edit"
} else {
    ad_returnredirect "/pfawards/"
}
# Prepara il corpo della domanda
set domanda_id [db_string domanda_id ""]
set domanda [db_string domanda ""]
# Se risposta già data, prepara ad_form in edit, se no in new
set risp_ok [db_string risp_ok ""]
if {$risp_ok == ""} {
    set buttons [list [list "Salva" new]]
} else {
    set buttons [list [list "Aggiorna" edit]]
}
ad_form -name risposta \
    -mode $mode \
    -edit_buttons $buttons \
    -has_edit 1 \
    -export {esame_id} \
    -select_query_name load_risposta \
    -cancel_url "/pfawards/" \
    -cancel_label "Concludi test" \
    -form {
	rispusr_id:key
        {risposta_id:integer(checkbox),optional
            {label "Risposte"}
  	    {options {[db_list_of_lists risposte ""]}}
            {html {size 4}}
	    {help_text "Puoi scegliere solo una risposta. In caso di modifica, deseleziona la precedente."}
        }
    } -new_data {
	db_transaction {
	    db_dml ins_risp ""
	}
    } -edit_data {
	db_dml upd_risp ""
    } -on_submit {
        set ctr_errori 0
        if {$ctr_errori > 0} {
            break
        }
    } -after_submit {
	if {$domanda_num == 30} {
	    ad_returnredirect "/pfawards/sessione?esame_id=$esame_id&rispusr_id=$rispusr_id"
        } else {
	    incr rispusr_id
	    ad_returnredirect "/pfawards/sessione?esame_id=$esame_id&rispusr_id=$rispusr_id"
	}
	ad_script_abort
    }
set righello "<tr>"
set conta 1
db_foreach righello "" {
    set risp_ok [db_string risp_ok ""]
    if {$risp_ok == ""} {
    append righello "<td><a href=\"/pfawards/sessione?esame_id=${esame_id}&rispusr_id=${rispusr_id}\"><font size=\"4\"><b><center>${conta}</center></b></font></a></td>"
    } else {
	append righello "<td background=\"images/tic.png\"><a href=\"/pfawards/sessione?esame_id=${esame_id}&rispusr_id=${rispusr_id}\"><font color=\"grey\" size=\"4\"><b><center>${conta}</center></b></font></a></td>"
    }
    incr conta
}
append righello "</tr>"