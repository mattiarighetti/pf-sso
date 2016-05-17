ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 19 February 2015
} {
    tipo_id:integer
}
with_catch errmsg {
    db_dml query "DELETE FROM crm_tipocontatto WHERE tipo_id = :tipo_id"
} {
    ad_return_complaint 1 "<b>Attenzione: non è stato possibile cancellare il tipo.</b><br>L'errore riportato dal sistema è:<br><br><code>$errmsg</code>"
    return
}
ad_returnredirect "tipocontatto-list"
ad_script_abort
