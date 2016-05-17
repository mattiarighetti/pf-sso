ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 19 February 2015
} {
    societa_id:integer
}
with_catch errmsg {
    db_dml query "DELETE FROM crm_societa WHERE societa_id = :societa_id"
} {
    ad_return_complaint 1 "<b>Attenzione: non è stato possibile cancellare la società.</b><br>L'errore riportato dal sistema è:<br><br><code>$errmsg</code>"
    return
}
ad_returnredirect "societa-list"
ad_script_abort
