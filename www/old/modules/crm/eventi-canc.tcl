ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 19 February 2015
} {
    evento_id:integer
}
with_catch errmsg {
    db_dml query "DELETE FROM eventi WHERE evento_id = :evento_id"
} {
    ad_return_complaint 1 "<b>Attenzione: non è stato possibile cancellare l'evento.</b><br>L'errore riportato dal database è:<br><br><code>$errmsg</code>"
    return
}
ad_returnredirect "eventi-list"
ad_script_abort
