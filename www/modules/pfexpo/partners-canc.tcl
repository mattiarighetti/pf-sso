ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Sunday 14 June 2015
    @cvs-id processing-delete.tcl
    @param genere_id The id to delete
} {
    partner_id:integer
    expo_id:naturalnum
    {module "pfexpo"}
}
pf::permission
with_catch errmsg {
    if {[db_0or1row query "select immagine from expo_partners where partner_id = :partner_id"]} {
	with_catch error_message {
	    set immagine [db_string query "select immagine from expo_partners where partner_id = :partner_id"]
	    exec rm -rf /usr/share/partner_portraits/$immagine
	} {
	    ad_return_complaint 1 "<b>Attenzione: non è stato possibile cancellare il partner, probabilmente è ancora referenziato da qualche altra tabella.</b><br>L'errore riportato dal sistema è il seguente.</br></br><code>$error_message</code>"
	}
    }
    db_dml query "DELETE FROM expo_partners WHERE partner_id = :partner_id"
} {
    ad_return_complaint 1 "<b>Attenzione: non è stato possibile cancellare il partner, probabilmente è ancora referenziato da qualche altra tabella.</b><br>L'errore riportato dal database è il seguente.<br><br><code$errmsg</code>"
    return
}
ad_returnredirect [export_vars -base "?template=modules%2Fpfexpo%2Fpartners-list" {expo_id module}]
ad_script_abort
