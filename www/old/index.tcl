ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Monday 18 May 2015
}
pf::user_must_login
template::head::add_css -href dashboard.css
set page_title "Dashboard - ProfessioneFinanza"
set context ""
set dash_menu [pf::dash_menu "utenza"]
ad_return_template
