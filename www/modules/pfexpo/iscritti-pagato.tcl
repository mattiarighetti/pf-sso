ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
} {
    return_url:optional
    iscritto_id:integer
}
set return_url "http://sso.professionefinanza.com/?module=pfexpo&expo%5fid=1&template=modules%2fpfexpo%2fiscritti%2dlist"
db_dml query "update expo_iscritti set pagato = true where iscritto_id = :iscritto_id"
ad_returnredirect -allow_complete_url $return_url
ad_script_abort
