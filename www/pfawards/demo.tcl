# 

ad_page_contract {
    
    
    
    @author mattia (mattia.righetti@professionefinanza.com)
    @creation-date 2016-09-16
    @cvs-id $Id$
} {
    
} -properties {
} -validate {
} -errors {
}
if {[string match *professionefinanza.com* [db_string query "select email from parties where party_id = [ad_conn user_id]"]]} {
    ad_return_complaint 1 "Sei loggato con account amministratore (@professionefinanza.com). Non puoi iscriverti agli esami con tale account."
}
set persona_id [db_string query "select persona_id from crm_persone where user_id = [ad_conn user_id]"]
if {![db_0or1row query "select * from itfaw_utenti where persona_id = :persona_id limit 1"]} {
    set utente_id [db_string query "select coalesce(max(utente_id) + trunc(random()*99), trunc(random()*99)) from itfaw_utenti"]
    db_dml query "insert into itfaw_utenti (utente_id, persona_id) values (:utente_id, :persona_id)"
} else {
    set utente_id [db_string query "select utente_id from itfaw_utenti where persona_id = :persona_id"]
}
ad_returnredirect -allow_complete_url [export_vars -base "http://demo.pfawards.professionefinanza.com/categorie-list" {utente_id}]
ad_script_abort
