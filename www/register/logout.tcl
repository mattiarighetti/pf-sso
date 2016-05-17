ad_page_contract {
    Logs a user out
    
    @cvs-id $Id: logout.tcl,v 1.4 2007/01/10 21:22:09 gustafn Exp $
    
} {
    {return_url ""}
}
if { $return_url eq "" } {
    set return_url [parameter::get -parameter "SystemURL" -package_id 68]
}
ad_user_logout 
db_release_unused_handles
ad_returnredirect \
    -allow_complete_url \
    -message "Logout effettuato." \
    $return_url
