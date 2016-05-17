ad_page_contract {
    Page for users to register themselves on the site.

    @cvs-id $Id: user-new.tcl,v 1.22 2007/05/06 06:58:40 maltes Exp $
} {
    {email ""}
    {return_url "http://sso.professionefinanza.com/"}
}
set page_title "Registrati ai portali PF"
set context [list $page_title]
ad_form -name register \
    -mode edit \
    -html {class "grid-form"} \
    -export {return_url} \
    -has_edit 1 \
    -has_submit 0 \
    -form {
	user_id:key
	{nome:text
	    {label "Nome"}
	}
	{cognome:text
	    {label "Cognome"}
	}
	{email:text
	    {label "Email"}
	}
	{password:text(password)
	    {label "Password"}
	}
	{password_confirm:text(password)
	    {label "Conferma password"}
	}
	{indirizzo:text,optional 
	    {label "Indirizzo"}
	}
	{provincia_id:search
	    {label "Provincia"}
	    {search_query "select denominazione, provincia_id from province where lower(denominazione)||provincia_id like '%'||lower(:value)||'%'"}
	    {result_datatype integer}
	}
    } -validate {
	{password
	    { [string length $password] > 5 }
	    {La password è troppo corta.}
	}
	{password_confirm
	    { $password eq $password_confirm }
	    {Le password non coincidono.}
	}
	{email 
	    { ![db_0or1row query "select * from parties where lower(email) like '%'||lower(:email)||'%'"] }
	    {Questa email è gia collegata ad un account.}
	}
    } -new_data {
	set nome [string totitle $nome]
	set cognome [string totitle $cognome]
	set creation_status [auth::create_user -verify_password_confirm \
				 -username $email \
				 -email $email \
				 -first_names $nome \
				 -last_name $cognome \
				 -screen_name $email \
				 -password $password \
				 -password_confirm $password_confirm]
	if {[lindex $creation_status 3] ne "ok"} {
	    ns_log notice pippa creation_status $creation_status cs_18 [lindex $creation_status 5]
	    ad_script_abort
	}
	set user_id [lindex $creation_status 17]	 
	if {![db_0or1row query "select * from crm_contatti where lower(valore) like '%'||lower(:email)||'%' limit 1"]} {
	    set persona_id [db_string query "select max(persona_id) + trunc(random() *99 + 1) from crm_persone"]
	    db_dml query "insert into crm_persone (persona_id, user_id, nome, cognome) values (:persona_id, :user_id, :nome, :cognome)"
	    set contatto_id [db_string query "select max(contatto_id) + trunc(random() *99 + 1) from crm_contatti"]
	    db_dml query "insert into crm_contatti (contatto_id, tipo_id, persona_id, valore, preferito) values (:contatto_id, 6, :persona_id, :email, true)" 
	} else {
	    set persona_id [db_string query "select persona_id from crm_contatti where lower(email) like '%'||:email||'%' limit 1"]
	    db_dml query "update crm_contatti set user_id = :user_id where persona_id = :persona_id"
	}
	set indirizzo_id [db_string query "select max(indirizzo_id) + trunc(random() *99 + 1) from crm_indirizzi"]
	db_dml query "insert into crm_indirizzi (indirizzo_id, via, provincia_id, persona_id, tipo_id) values (:indirizzo_id, :indirizzo, :provincia_id, :persona_id, 2)"
    } -after_submit {
	ad_user_login -forever $user_id
	ad_returnredirect \
	    -allow_complete_url \
	    $return_url
    }
