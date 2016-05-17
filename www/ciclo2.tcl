# 

ad_page_contract {
    
    
    
    @author mattia (mattia.righetti@professionefinanza.com)
    @creation-date 2016-02-16
    @cvs-id $Id$
} {
    
} -properties {
} -validate {
} -errors {
}
db_foreach query "select user_id, initcap(lower(cognome)) as cognome from dati_mailchimp" {
    set password [regsub -all {\s} $cognome {}]
    append password [ad_generate_random_string 5]
    ad_change_password $user_id $password
    db_dml query "update dati_mailchimp set password = :password where user_id = :user_id"
}
ad_script_abort
