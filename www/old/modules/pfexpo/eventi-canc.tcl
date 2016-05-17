ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 12 June 2015
    @cvs-id processing-delete.tcl
} {
    evento_id:integer    
    expo_id:naturalnum
    {module "expo"}
}
pf::permission
with_catch errmsg {
    db_dml query "delete from expo_eventi where evento_id = :evento_id"
} {
    ad_return_complaint 1 "<b>Attenzione: non è stato possibile cancellare l'evento.</br>L'errore riportato dal database è il seguente.</br></br><code>$errmsg</code>"
    return
}
set template "modules%2Fpfexpo%2Feventi-list"
ad_returnredirect [export_vars -base "/" {expo_id module template}]
ad_script_abort