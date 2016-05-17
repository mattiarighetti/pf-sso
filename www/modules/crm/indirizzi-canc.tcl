ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 19 February 2015
} {
    indirizzo_id:integer
    persona_id:integer
}
with_catch errmsg {
    db_dml query "DELETE FROM crm_indirizzi WHERE indirizzo_id = :indirizzo_id"
} {
    ad_return_complaint 1 "<b>Attenzione: non è stato possibile cancellare l'indirizzo.</b><br>L'errore riportato dal database è:<br><br><code>$errmsg</code>"
    return
}
ad_returnredirect [export_vars -base "persone-view" {persona_id}]
ad_script_abort
