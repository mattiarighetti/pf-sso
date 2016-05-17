# 

ad_page_contract {
    
    Logout program.
    
    @author mattia (mattia.righetti@professionefinanza.com)
    @creation-date 2016-02-19
    @cvs-id $Id$
} {
    
} -properties {
} -validate {
} -errors {
}
ad_user_logout
ad_returnredirect -allow_complete_url "http://sso.professionefinanza.com/register/?logout=true"
ad_script_abort
