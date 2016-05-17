ad_page_contract {
} {
    user_id
}
set persona_id [db_string query "select persona_id from crm_persone where user_id = :user_id"]
db_dml query "delete from crm_contatti where persona_id = :persona_id"
db_dml query "delete from crm_indirizzi where persona_id = :persona_id"
db_dml query "delete from crm_persone where persona_id = :persona_id"
acs_user::delete -user_id $user_id -permanent
