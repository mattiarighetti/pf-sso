ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 25 November 2014
} {
}
set user_id [ad_conn user_id]
if {$user_id == 0} {
    ad_returnredirect "login?return_url=/pfawards/"
}
set html "<html>"
db_foreach query "SELECT esame_id FROM pf_esami2 ORDER BY esame_id, categoria_id" {
    set utente [db_string query "SELECT i.nome||' '||i.cognome FROM pf_iscritti i, pf_esami e WHERE i.iscritto_id = e.iscritto_id and e.esame_id = :esame_id"]
    set categoria [db_string query "SELECT c.descrizione FROM pf_categorie c, pf_esami2 e2 WHERE c.categoria_id = e2.categoria_id AND e2.esame_id = :esame_id"]
    append html "<center><b>UTENTE: $utente - CATEGORIA: $categoria</b></center>"
    set query01 [db_0or1row query "SELECT rispusr_id FROM pf_rispusr2 WHERE esame_id = :esame_id ORDER BY rispusr_id LIMIT 1"]
    if {$query01 == 1} {
	db_foreach query "SELECT rispusr_id FROM pf_rispusr2 WHERE esame_id = :esame_id ORDER BY rispusr_id" {
	    # Estrae corpo della domanda
	    set domanda_id [db_string query "SELECT domanda_id FROM pf_rispusr2 WHERE rispusr_id = :rispusr_id"]
	    set domanda [db_string query "SELECT corpo FROM pf_domande2 WHERE domanda_id = :domanda_id"]
	    append html "<br><font face=\"Georgia\" size=\"1px\">DOMANDA: $domanda</font><br>"
	    # Estrae risposta data
	    set risposta [db_string query "SELECT corpo FROM pf_rispusr2 WHERE rispusr_id = :rispusr_id"]
	    append html "<br><font face=\"Times New Roman\" size=\"3px\">$risposta</font><br>"
	}
    } else {
	append html "<b>L'utente non ha risposto all'esame</b>"
    }
    append html "<br><br><br>"
}
append html "</html>"
set filenamehtml "/tmp/all-esami-print.html"
set filenamepdf  "/tmp/all-esami-print.pdf"
set file_html [open $filenamehtml w]
puts $file_html $html
close $file_html
with_catch error_msg {
    exec htmldoc --portrait --webpage --header ... --footer ... --quiet --left 1cm --right 1cm --top 1cm --bottom 1cm --fontsize 12 -f $filenamepdf $filenamehtml
} {
    ns_log notice "errore htmldoc  <code>$error_msg </code>"
}
ns_returnfile 200 application/pdf $filenamepdf
ns_unlink $filenamepdf
ns_unlink $filenamehtml
ad_script_abort