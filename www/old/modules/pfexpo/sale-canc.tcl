ad_page_contract {
    Programma per la cancellazione docente.
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 29 May 2015
    @cvs-id processing-delete.tcl
    @param genere_id The id to delete
} {
    sala_id:integer
    expo_id:integer
}
pf::permission
with_catch errmsg {
    db_dml query "delete from expo_sale where sala_id = :sala_id"
} {
    ad_return_complaint 1 "<b>Attenzione: non è stato possibile cancellare la sala, probabilmente è ancora referenziato da qualche altra tabella.</b><br>L'errore riportato dal database è il seguente.<br><br><code>$errmsg</code>"
    return
}
ad_returnredirect "?module=pfexpo&expo_id=1&template=modules%2Fpfexpo%2Fsale-list"
ad_script_abort
