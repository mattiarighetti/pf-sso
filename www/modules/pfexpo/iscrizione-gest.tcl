ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Monday 7 November, 2014
}
pf::permission
set page_title "Iscriviti"
set user_id [ad_conn user_id]
set context [list $page_title]
set form_name "iscrizione"
ad_form -name $form_name \
    -mode edit \
    -confirm_template "Iscriviti" \
    -form {
	iscrizione_id:key
	{nome:text(text)
	    {label "Nome"}
	    {section "asdf"}
	}
	{cognome:text(text)
	    {label "Cognome"}
	}
    }