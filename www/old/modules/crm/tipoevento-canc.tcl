ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 19 February 2015
} {
    tipo_id:integer
}
with_catch errmsg {
    db_dml query "DELETE FROM tipoevento WHERE tipo_id = :tipo_id"
} {
    ad_return_complaint 1 "<b>Attenzione: non è stato possibile cancellare la tipologia evento.</b><br>L'errore riportato dal database è:<br><br><code>$errmsg</code>"
    return
}
ad_returnredirect "tipoevento-list"
ad_script_abort
