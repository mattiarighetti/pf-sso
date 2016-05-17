ad_page_contract {
}
set conta 0
db_foreach query "select lower(email) as email, initcap(lower(nome)) as nome, initcap(lower(cognome)) as cognome, lower(citta) as citta, lower(interm) as interm from mailchimp_db151" {
    #Controlla se c'è gia utenza oacs
    if {![db_0or1row query "select * from parties where email ilike :email limit 1"]} {
	#Crea utente oacs
	# Creazione password
	set password [regsub -all {\s} $cognome {}]
	append password [db_string query "select substring(md5(random()::text) from 0 for 6)"]
	array set creation_info [auth::create_user -email $email -first_names $nome -last_name $cognome -password $password]
	if {$creation_info(creation_status) eq "ok" && ([info exists rel_group_id] && $rel_group_id ne "")} {
	    set user_id $creation_info(user_id)
	    set group_id [application_group::group_id_from_package_id]
	    group::add_member \
		-group_id $rel_group_id \
		-user_id $user_id
	    
	}
    } else {
	set user_id [db_string query "select party_id from parties where email ilike :email limit 1"]
	set password "La password che avevi scelto per i PFAwards"
    }
    #Controlla inserimento/aggiornamento nel crm
    if {[db_0or1row query "select * from crm_contatti where valore ilike :email limit 1"]} {
	set persona_id [db_string query "select persona_id from crm_contatti where valore ilike :email limit 1"]
	db_dml query "update crm_persone set user_id = :user_id where persona_id = :persona_id"
    } else {
	#prova ad impostare societa
	set societa [string range $interm 0 7]
	if {[db_0or1row query "select * from crm_societa where ragionesociale ilike :societa"]} {
	    set societa_id [db_string query "select societa_id from crm_societa where ragionesociale ilike :societa"]
	} else {
	    set societa_id ""
	}
	set persona_id [db_string query "select max(persona_id) + trunc(random()*99) +1 from crm_persone"]
	db_dml query "insert into crm_persone (persona_id, user_id, nome, cognome, societa_id) values (:persona_id, :user_id, :nome, :cognome, :societa_id)"
	set contatto_id [db_string query "select max(contatto_id) + trunc(random()*99) +1 from crm_contatti"]
	db_dml query "insert into crm_contatti (contatto_id, tipo_id, persona_id, valore) values (:contatto_id, 6, :persona_id, :email)"
    }
    incr conta
    if {![db_0or1row query "select * from dati_mailchimp where user_id = :user_id"]} {
	db_dml query "insert into dati_mailchimp (user_id, nome, cognome, persona_id, email, password) values (:user_id, :nome, :cognome, :persona_id, :email, :password)"   
    }
}
ad_return_complaint 1 "Conta: $conta"
