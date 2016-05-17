ad_page_contract {
    Page for users to register themselves on the site.

    @cvs-id $Id: user-new.tcl,v 1.22 2007/05/06 06:58:40 maltes Exp $
} {
    {email ""}
    {return_url "http://pfawards.professionefinanza.com/"}
    {ref ""}
}
set logo ""
set menu ""
if {$ref == "pfawards"} {
    template::head::add_css -href "http://pfawards.professionefinanza.com/awards_style.css" 
    set logo "http://images.professionefinanza.com/pfawards/logos/awards-2016.png"
    set menu [pf::fe_html_menu -id 18]
}
set registration_url [parameter::get -parameter RegistrationRedirectUrl]
if {$registration_url ne ""} {
    ad_returnredirect [export_vars -base "$registration_url" -url {return_url email}]
}

set subsite_id [ad_conn subsite_id]
set user_new_template [parameter::get -parameter "UserNewTemplate" -package_id $subsite_id]

if {$user_new_template eq ""} {
    set user_new_template "/packages/sso/lib/user-new"
}
