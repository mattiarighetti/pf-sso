ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 25 December 2014
} {
    iscrizione_id:integer
    return_url:optional
}
set user_id [ad_conn user_id]
if {$user_id == 0} {
    ad_return_complaint 1 "<font face='courier' size=5><b>Operazione non consentita.<br>Si prega di identificarsi cliccando <a href=\"/register/\">quà</a>.</b></font>"
}
set query01 [db_0or1row query "SELECT * FROM pf_expo_iscrizioni WHERE pagato = TRUE AND iscrizione_id = :iscrizione_id LIMIT 1"]
if {$query01 == 0} {
    with_catch errmsg {
	db_dml query "UPDATE pf_expo_iscrizioni SET pagato = TRUE WHERE iscrizione_id = :iscrizione_id"
    } {
	ad_return_complaint 1 "Si è verificato un errore nel processare la sua richiesta per la registrazione del pagamento.</br>Si prega di riportare l'errore restituito qua sotto all'assistenza (<a href=\"mailto:webmaster@professionefinanza.com\">webmaster@professionefinanza.com</a>). Grazie.<br><br><code>$errmsg</code>"
	return
    }
} else {
    with_catch errmsg {
	db_dml query "UPDATE pf_expo_iscrizioni SET pagato = FALSE WHERE iscrizione_id = :iscrizione_id"
    } {
	ad_return_complaint 1 "Si è verificato un errore nel processare la sua richiesta per la registrazione del pagamento.</br>Si prega di riportare l'errore restituito qua sotto all'assistenza (<a href=\"mailto:webmaster@professionefinanza.com\">webmaster@professionefinanza.com</a>). Grazie.<br><br><code>$errmsg</code>"
	return
    }
}
ad_returnredirect $return_url
ad_script_abort