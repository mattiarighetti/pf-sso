# 

ad_page_contract {
    
    Pagina indice della dashboard.
    
    @author mattia (mattia.righetti@professionefinanza.com)
    @creation-date 2016-02-10
    @cvs-id $Id$
} {
    
} -properties {
} -validate {
} -errors {
}
set user_id [auth::require_login]
acs_user::get -user_id $user_id -array user_info -include_bio
#if {$user_info(username) == ""} {
    set username $user_info(first_names)
    append username " " $user_info(last_name)
#}
set nome $user_info(first_names)
set cognome $user_info(last_name)
set email $user_info(email)
set bio $user_info(bio)

set notifications "<li><a href=\"#\">Alert Name <span class=\"label label-warning\">Alert Badge</span></a></li>"

ad_return_template
