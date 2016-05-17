ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
} {
    domanda_id:integer
}
set user_id [ad_conn user_id]
set user_admin [db_0or1row useradmin ""]
if {$user_id == 0 || $user_admin == 1} {
    ad_returnredirect "login?return_url=/pfawards/"
}
with_catch errmsg {
    db_dml domandecanc ""
} {
    ad_return_complaint 1 "<b>Attenzione: non è stato possibile cancellare la domanda. Si prega di tornare indietro e riprovare.</b>" 
    return
}
ad_returnredirect "domande-list"
ad_script_abort