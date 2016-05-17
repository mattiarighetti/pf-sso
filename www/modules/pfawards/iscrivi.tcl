ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 29 July 2015
} {
    categoria_id:naturalnum
}
if {[ad_conn user_id]} {
    set persona_id [db_string query "select persona_id from crm_persone where user_id = [ad_conn user_id]"]
} else {
    ad_returnredirect -allow_complete_url "http://sso.professionefinanza.com/register/user-new?return_url=[ad_return_url -qualified -urlencode]"
    ad_script_abort
}
if {![db_0or1row query "select * from awards_iscritti where categoria_id = :categoria_id and persona_id = :persona_id limit 1"]} {
    set iscrizione_id [db_string query "select coalesce(max(iscrizione_id) + trunc(random() *99+1)) from awards_iscritti"]
    with_catch error_message {
	db_dml query "insert into awards_iscritti (iscrizione_id, persona_id, categoria_id) values (:iscrizione_id, :persona_id, :categoria_id)"
    } {
	ad_return_complaint 1 "<b>Attenzione!</b> Non è stato possibile eseguire l'operazione desiderata. Si prega di tornare indietro e riprovare ad eseguirla di nuovo. In caso di persistenza, contattare il webmaster a <a href=\"mailto:webmaster@professionefinanza.com\">webmaster@professionefinanza.com</a>.<br>L'errore riportato dal sistema è il seguente.<br><code>$error_message</code>"
	return
    }
} else {
    with_catch error_message {
        db_dml query "delete from awards_iscritti where persona_id = :persona_id and categoria_id = :categoria_id"
    } {
        ad_return_complaint 1 "<b>Attenzione!</b> Non è stato possibile eseguire l'operazione desiderata. Si prega di tornare indietro e riprovare ad eseguirla di nuovo. In caso di persistenza, contattare il webmaster a <a href=\"mailto:webmaster@professionefinanza.com\">webmaster@professionefinanza.com</a>.<br>L'errore riportato dal sistema è il seguente.<br><code>$error_message</code>"
        return
    }
}
ad_returnredirect -allow_complete_url "iscriviti"
ad_script_abort
