ad_page_contract {  
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 7 November 2014
} {
    esame_id:integer
}
# Controllo utenza
set user_id [ad_conn user_id]
if {$user_id == 0} {
    ad_returnredirect "login?return_url=/pfawards/"
} else {
    set utenza "Benvenuto "
    append utenza [db_string utente ""]
    append utenza " (<a href=\"/register/logout?return_url=/pfawards/\">Esci</a>). "
    append utenza "<a href=\"/pfawards/\">Torna alla home.</a>"
}
set page_title "ProfessioneFinanza Awards"
set package_id [ad_conn package_id]
set parameters_url [export_vars -base "/shared/parameters" {package_id return_url} ]
set esame ""
db_foreach domande "" {
    set conta 1
    append esame "<br><p>:conta — <b>:corpo_dom</b></p><br>"
    append esame "Quella che hai scelto: "
    append esame [db_string rispchosen ""]
    append esame "</p>"
    db_foreach riposte "" {
	append esame "<p>:corpo_risp</p>"
    }
    incr conta
}