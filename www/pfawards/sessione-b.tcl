ad_page_contract {
    @author Mattia Righetti (mattia.righetti@mail.polimi.it)
    @creation-date Monday 3 November, 2014
} {
    esame_id:integer
}
set page_title "Seconda fase - PFAwards15"
# Controllo utenza
set user_id [ad_conn user_id]
if {$user_id == 0} {
    ad_returnredirect "login?return_url=/pfawards/"
}
# Imposta nome utente per la visualizzazione
set utente [db_string query "SELECT first_names||' '||last_name FROM persons WHERE person_id = :user_id"]
# Imposta categoria e prepara descrizione per visualizzazione
set categoria_id [db_string query "SELECT categoria_id FROM pf_esami2 WHERE esame_id = :esame_id"]
set categoria [db_string query "SELECT c.descrizione FROM pf_categorie c, pf_esami e WHERE e.categoria_id = c.categoria_id AND e.esame_id = :esame_id"]
# Imposta domanda e prepara testo per la visualizzazione
set domanda_id [db_string query "SELECT domanda_id FROM pf_domande2 WHERE categoria_id = :categoria_id ORDER BY domanda_id LIMIT 1"]
set domanda [db_string query "SELECT corpo FROM pf_domande2 WHERE domanda_id = :domanda_id"]
# Imposta form su nuovo o modifica
if {[ad_form_new_p -key risposta_id]} {
    set buttons [list [list "Salva e procedi" new]]
} else {
    set buttons [list [list "Salva e procedi" edit]]
}
ad_form -name secfase \
    -edit_buttons $buttons \
    -has_edit 1 \
    -export {esame_id} \
    -form {
	rispusr_id:key
	{corpo:text(textarea),nospell
	    {label "Corpo"}
	    {html {rows 20 cols 90 wrap soft}}
	}
    } -select_query {
	"SELECT corpo FROM pf_rispusr2 WHERE rispusr_id = :rispusr_id"
    } -new_data {
	set rispusr_id [db_string query "SELECT COALESCE(MAX(rispusr_id)+1,1) FROM pf_rispusr2"]
	db_dml query "INSERT INTO pf_rispusr2 (rispusr_id, corpo, esame_id, domanda_id) VALUES (:rispusr_id, :corpo, :esame_id, :domanda_id)"
    } -edit_data {
	db_dml query "UPDATE pf_rispusr2 SET corpo = :corpo WHERE rispusr_id = :rispusr_id"
    } -on_submit {
	set ctr_errori 0
	if {$ctr_errori > 0} {
	    break
	}
    } -after_submit {
	ad_returnredirect "sessione-b2?esame_id=$esame_id"
	ad_script_abort
    }