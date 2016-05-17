ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
} {
    iscrizione_id:naturalnum
    expo_id:naturalnum
    evento_id:naturalnum
    {module "pfexpo"}
}
pf::permission
with_catch errmsg {
    db_dml query "delete from expo_iscrizioni where iscrizione_id = :iscrizione_id"
} {
    ad_return_complaint 1 "<b>Attenzione: non è stato possibile cancellare la domanda. Si prega di tornare indietro e riprovare.</b>" 
    return
}
ad_returnredirect [export_vars -base "?template=modules%2Fpfexpo%2Fiscritti-list" {expo_id evento_id}]
ad_script_abort