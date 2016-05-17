ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
}
db_foreach query "select email from expo_tmp" {
    if {[db_0or1row query "select * from expo_iscritti where email ilike '%$email%' limit 1"]} {
	db_dml query "update expo_tmp set andata = true"
	db_dml query "update expo_iscritti set pagato = true where email ilike '%$email%'"
    }
}
ad_returnredirect -allow_complete_url index
ad_script_abort
