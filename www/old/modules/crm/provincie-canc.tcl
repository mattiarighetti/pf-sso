ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 19 February 2015
} {
    provincie_id:integer
}
set user_id [ad_conn user_id]
if {$user_id == 0} {
    ad_returnredirect "/register"
}
with_catch errmsg {
    db_dml query "DELETE FROM provincie WHERE provincia_id = :provincia_id"
} {
    ad_return_complaint 1 "<b>Attenzione: non è stato possibile cancellare la provincia.</b><br>L'errore riportato dal sistema è:<br><br><code>$errmsg</code>"
    return
}
ad_returnredirect "provincia-list"
ad_script_abort
