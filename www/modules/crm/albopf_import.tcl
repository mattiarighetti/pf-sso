ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 1 April 2015
}
pf::permission
ad_progress_bar_begin \
    -title "Scaricamento e aggiornamento dei record CRM da albopf.it" \
    -message_1 "Il processo è in corso. Si prega di attendere..."

with_catch errmsg {
    exec wget -q -P /usr/share/openacs/packages/crm/www/tmp/ https://www.albopf.it/XXDomain/AlboStatico/html/sezioneI.zip 
} {
    ad_return_complaint 1 "<b>Attenzione: si è verificato un errore nello scaricamento del CSV \"Sezione I\". L'errore riportato è il seguente:<br><br><code>$errmsg</code>"
    return
}
with_catch errmsg {
    exec unzip /usr/share/openacs/packages/crm/www/tmp/sezioneI.zip
} {
    ad_return_complaint 1 "<b>Attenzione: si è verificato un errore nel processo di unzipping del file scaricato. L'errore riportato è il seguente:<br><br><code>$errmsg</code>"
}


ad_progress_bar_end -url "index"
ad_script_abort
