ad_page_contract {
    @author Mattia Righetti (mattia.righetti@mail.polimi.it)
    @creation-date Monday 3 November, 2014
} {
    risposta_id:integer,optional
    domanda_id:integer
}
set user_id [ad_conn user_id]
set user_admin [db_0or1row query "SELECT * FROM pf_iscritti WHERE iscritto_id = :user_id"]
if {$user_id == 0 || $user_admin == 1} {
    ad_returnredirect "login?return_url=/pfawards/"
}
if {[ad_form_new_p -key risposta_id]} {
    set page_title "Nuova"
    set buttons [list [list "Salva" new]]
} else {
    set page_title "Modifica #" 
    append page_title "$risposta_id"
    set buttons [list [list "Aggiorna" edit]]
}
ad_form -name risposte \
    -edit_buttons $buttons \
    -has_edit 1 \
    -export {domanda_id} \
    -form {
	risposta_id:key
	{corpo:text(textarea),nospell
	    {label "Corpo"}
	    {html {rows 6 cols 50 wrap soft}}
	}
	{punti:text
            {label "Punti"}
	    {html {size 70 maxlenght 2}}
	}
    } -select_query {
	"SELECT corpo, punti FROM pf_risposte WHERE risposta_id = :risposta_id"
    } -new_data {
	set risposta_id [db_string query "SELECT COALESCE (MAX(risposta_id) + 1, 1) FROM pf_risposte"]
	db_dml query "INSERT INTO pf_risposte (risposta_id, corpo, punti, domanda_id) VALUES (:risposta_id, :corpo, :punti, :domanda_id)"
    } -edit_data {
	db_dml query "UPDATE pf_risposte SET corpo = :corpo, punti = :punti WHERE risposta_id = :risposta_id"
    } -on_submit {
	set ctr_errori 0
	if {$ctr_errori > 0} {
	    break
	}
    } -after_submit {
	ad_returnredirect "risposte-list?domanda_id=$domanda_id"
	ad_script_abort
    }