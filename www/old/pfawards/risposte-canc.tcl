ad_page_contract {
    @author Mattia Righetti (mattia.righetti@mail.polimi.it)
} {
    risposta_id:integer
}
set user_id [ad_conn user_id]
set user_admin [db_0or1row query "SELECT * FROM pf_iscritti WHERE iscritto_id = :user_id"]
if {$user_id == 0 || $user_admin == 1} {
    ad_returnredirect "login?return_url=/pfawards/"
}
with_catch errmsg {
    db_dml query "DELETE FROM pf_risposte WHERE risposta_id = :risposte_id"
} {
    ad_return_complaint 1 "<b>Attenzione: non è stato possibile cancellare la domanda. Si prega di tornare indietro e riprovare.</b>" 
    return
}
ad_returnredirect "risposte-list"
ad_script_abort