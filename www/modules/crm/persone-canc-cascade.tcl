ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 19 February 2015
} {
    persona_id:integer
}
pf::permission
with_catch errmsg {
    db_dml query "DELETE FROM crm_indirizzi WHERE persona_id = :persona_id"
    db_dml query "DELETE FROM crm_telefonate WHERE persona_id = :persona_id"
    db_dml query "DELETE FROM crm_persone WHERE persona_id = :persona_id"
} {
    ad_return_complaint 1 "<b>Attenzione: non è stato possibile cancellare la persona.</b><br>L'errore riportato dal database è:<br><br><code>$errmsg</code>"
    return
}
ad_returnredirect "persone-list"
ad_script_abort
