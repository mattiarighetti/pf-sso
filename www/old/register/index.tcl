ad_page_contract {
    Prompt the user for email and password.
    @cvs-id $Id: index.tcl,v 1.13.10.1 2014/08/05 09:49:26 gustafn Exp $
} {
    {authority_id:naturalnum ""}
    {username ""}
    {email ""}
    {return_url ""}
}

set subsite_id [ad_conn subsite_id]
set login_template [parameter::get -parameter "LoginTemplate" -package_id $subsite_id]

if {$login_template eq ""} {
    set login_template "/packages/sso/lib/login"
}

