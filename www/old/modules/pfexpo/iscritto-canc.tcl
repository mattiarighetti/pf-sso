ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
} {
    iscritto_id:integer
    {module ""}
    expo_id:naturalnum
}
pf::permission
with_catch errmsg {
    db_dml query "DELETE FROM pf_expo_iscrizioni WHERE iscritto_id = :iscritto_id"
    db_dml query "DELETE FROM pf_expo_iscr WHERE iscritto_id = :iscritto_id"
} {
    ad_return_complaint 1 "Si è verificato un errore nel cancellare le iscrizioni dell'utente selezionato. Si prega di tornare indietro e riprovare." 
    return
}
if {$return_url ne ""} {
    ad_returnredirect $return_url
} else {
    ad_return redirect "iscritti-list"
}
ad_script_abort