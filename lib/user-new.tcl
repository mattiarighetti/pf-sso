
# Expects parameters:
#
# self_register_p - Is the form for users who self register (1) or
#                   for administrators who create other users (0)?
# next_url        - Any url to redirect to after the form has been submitted. The
#                   variables user_id, password, and account_messages will be added to the URL. Optional.
# email           - Prepopulate the register form with given email. Optional.
# return_url      - URL to redirect to after creation, will not get any query vars added
# rel_group_id    - The name of a group which you want to relate this user to after creating the user.
#                   Will add an element to the form where the user can pick a relation among the permissible 
#                   rel-types for the group.

set next_url "http://pfawards.professionefinanza.com/iscriviti"

# Pre-generate user_id for double-click protection
set user_id [db_nextval acs_object_id_seq]

ad_form -name register -export {next_url user_id return_url} -form {
    {email:text(text)
	{label Email}
	{html {size 30}}
    }
    {first_names:text(text)
	{label {Nome}} 
	{html {size 30}}
    }
    {last_name:text(text)
	{label Cognome}
	{html {size 30}}
    }
    {password:text(password)
	{label Password:}
	{html {size 30}}
    }
    {password_confirm:text(password) 
	{label {Conferma password:}} 
	{html {size 30}}
    }
    {societa_man:text
	{label "Società"}
	{html {size 30}}
    }
    {indirizzo:text,optional
	{label "Indirizzo"}
	{html {size 30}}
    }
    {provincia_id:search
	{label "Provincia"}
	{search_query "select denominazione, provincia_id from province where lower(denominazione)||provincia_id like '%'||lower(:value)||'%'"}
	{result_datatype integer}
	{html {size 30}}
    }
} -validate {
    {email
        {[string equal "" [party::get_by_email -email $email]]}
        "[_ acs-subsite.Email_already_exists]"
    }
    {password
	{ [string length $password] > 5 } 
	{La password è troppo corta.}
    } 
    {password_confirm 
	{ $password eq $password_confirm }
	{Le password non coincidono.}
    }
} -on_submit {
    
    db_transaction {
        array set creation_info [auth::create_user \
                                     -user_id $user_id \
                                     -verify_password_confirm \
				     -email $email \
                                     -first_names $first_names \
                                     -last_name $last_name \
				     -password $password \
                                     -password_confirm $password_confirm]
          }
  
    # Handle registration problems
  
    switch $creation_info(creation_status) {
        ok {
            # Continue below
        }
        default {
            # Adding the error to the first element, but only if there are no element messages
            if { [llength $creation_info(element_messages)] == 0 } {
                array set reg_elms [auth::get_registration_elements]
                set first_elm [lindex [concat $reg_elms(required) $reg_elms(optional)] 0]
                form set_error register $first_elm $creation_info(creation_message)
            }
	    
            # Element messages
            foreach { elm_name elm_error } $creation_info(element_messages) {
                form set_error register $elm_name $elm_error
            }
            break
        }
    }
    
    switch $creation_info(account_status) {
        ok {
            # Continue below
        }
        default {

	    if {[parameter::get -parameter RegistrationRequiresEmailVerificationP -default 0] &&
		$creation_info(account_status) eq "closed"} {
		ad_return_warning "Email Validation is required" $creation_info(account_message)
		ad_script_abort
	    }
	    if {[parameter::get -parameter RegistrationRequiresApprovalP -default 0] &&
		$creation_info(account_status) eq "closed"} {
		ad_return_warning "Account approval is required" $creation_info(account_message)
		ad_script_abort
	    }

            # Display the message on a separate page
            ad_returnredirect \
                -message $creation_info(account_message) \
                -html \
		"[subsite::get_element -element url]register/account-closed"
            ad_script_abort
        }
    }
    if {![db_0or1row query "select * from crm_contatti where lower(valore) like '%'||lower(:email)||'%' limit 1"]} {
	set persona_id [db_string query "select max(persona_id) + trunc(random() *99 + 1) from crm_persone"]
            db_dml query "insert into crm_persone (persona_id, user_id, nome, cognome, societa_man) values (:persona_id, :user_id, :first_names, :last_name, :societa_man)"
	set contatto_id [db_string query "select max(contatto_id) + trunc(random() *99 + 1) from crm_contatti"]
            db_dml query "insert into crm_contatti (contatto_id, tipo_id, persona_id, valore, preferito) values (:contatto_id, 6, :persona_id, :email, true)"
    } else {
	set persona_id [db_string query "select persona_id from crm_contatti where lower(valore) like '%'||:email||'%' limit 1"]
	db_dml query "update crm_persone set user_id = :user_id where persona_id = :persona_id"
    }
    set indirizzo_id [db_string query "select max(indirizzo_id) + trunc(random() *99 + 1) from crm_indirizzi"]
    db_dml query "insert into crm_indirizzi (indirizzo_id, via, provincia_id, persona_id, tipo_id) values (:indirizzo_id, :indirizzo, :provincia_id, :persona_id, 2)"

} -after_submit {
    

set body {
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>[SUBJECT]</title>
<style type="text/css">
body {
  padding-top: 0 !important;
  padding-bottom: 0 !important;
  padding-top: 0 !important;
  padding-bottom: 0 !important;
  margin: 0 !important;
  width: 100% !important;
  -webkit-text-size-adjust: 100% !important;
  -ms-text-size-adjust: 100% !important;
  -webkit-font-smoothing: antialiased !important;
}
.tableContent img {
  border: 0 !important;
  display: block !important;
  outline: none !important;
}
a {
  color: #382F2E;
}
p, h1 {
  color: #382F2E;
  margin: 0;
}
div, p, ul, h1 {
  margin: 0;
}
p {
  font-size: 13px;
  color: #99A1A6;
  line-height: 19px;
}
h2, h1 {
  color: #444444;
  font-weight: normal;
  font-size: 22px;
  margin: 0;
}
a.link2 {
  padding: 15px;
  font-size: 13px;
  text-decoration: none;
  background: #2D94DF;
  color: #ffffff;
  border-radius: 6px;
  -moz-border-radius: 6px;
  -webkit-border-radius: 6px;
}
.bgBody {
  background: #f6f6f6;
}
.bgItem {
  background: #2C94E0;
}
</style>
</head>
<body paddingwidth="0" paddingheight="0" bgcolor="#d1d3d4" style="padding-top: 0; padding-bottom: 0; padding-top: 0; padding-bottom: 0; background-repeat: repeat; width: 100% !important; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; -webkit-font-smoothing: antialiased;" offset="0" toppadding="0" leftpadding="0">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tableContent bgBody" align="center" style="font-family:Helvetica, Arial,serif;">
  
  <!-- =============================== Header ====================================== -->
  
  <tr>
    <td><table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
        <tr>
          <td class="movableContentContainer"><div class="movableContent">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                <tr>
                  <td height="25" colspan="3"></td>
                </tr>
                <tr>
                  <td valign="top" colspan="3"><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                      <tr>
                        <td align="left" valign="middle"><div class="contentEditableContainer contentImageEditable">
                            <div class="contentEditable">
                              <center>
                                <img src="http://images.professionefinanza.com/logos/professionefinanza.png" alt="Compagnie logo" data-default="placeholder" data-max-width="300" width="274" height="auto">
                              </center>
                            </div>
                          </div></td>
                      </tr>
                    </table></td>
                </tr>
              </table>
            </div>
            <div class="movableContent">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                <tr>
                  <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center">
                      <tr>
                        <td height="50">&nbsp;</td>
                      </tr>
                    </table></td>
                </tr>
              </table>
            </div>
            
            <!--icone 2--><!--fine icone2--> 
            
            <!--icone--><!--fine icone--> 
            <!---azzurro-->
            
            <div class="movableContent">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                <tr>
                  <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="27567E" valign="top">
                      <tr>
                        <td colspan="3" height="15"></td>
                      </tr>
                      <tr>
                        <td width="50"></td>
                        <td width="500"><table width="549" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                            <tr>
                              <td align="center"><div class="contentEditableContainer contentTextEditable">
                                  <div class="contentEditable">
                                    <h1 style="font-size:22px; color:#FFF">Grazie per esserti registrato su ProfessioneFinanza!</h1>
                                  </div>
                                </div></td>
                            </tr>
                            <tr>
                              <td align="center"></td>
                            </tr>
                          </table></td>
                        <td width="50"></td>
                      </tr>
                      <tr>
                        <td colspan="3" height="15"></td>
                      </tr>
                    </table></td>
                </tr>
              </table>
            </div>
            
            <!--fine azzurro-->
            
            <div class="movableContent">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                <tr>
                  <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center">
                      <tr>
                        <td height="30">&nbsp;</td>
                      </tr>
                      <tr>
                        <td style="border-bottom:1px solid #DDDDDD"></td>
                      </tr>
                      <tr>
                        <td height="10">&nbsp;</td>
                      </tr>
                    </table></td>
                </tr>
              </table>
            </div>
            <div class="movableContent">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                <tr>
                  <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                      <tr>
                        <td colspan="3" height="25"></td>
                      </tr>
                      <tr>
                        <td width="50"></td>
                        <td width="500"><table width="500" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                            <tr>
                              <td align="center"><div class="contentEditableContainer contentTextEditable">
                                  <div class="contentEditable">
                                    <h1 style="font-size:17px; color:#ffff"><strong>Ti ricordiamo i tuoi dati per loggarti sui nuovi portali di ProfessioneFinanza:</strong></h1>
                                    <h1 style="font-size:12px; color:#ffff">&nbsp;</h1>
                                    <h1 style="font-size:12px; color:#ffff"><strong>Email    :</strong> }
                                      append body $email 
                                      append body { </h1>
                                    <h1 style="font-size:12px; color:#ffff"><strong>Password::</strong>}
                                      append body $password 
                                      append body { </h1>
                                    <h1 style="font-size:12px; color:#ffff">&nbsp;</h1>
                                    <h1 style="font-size:12px; color:#ffff">&nbsp;</h1>
                                  </div>
                                </div></td>
                            </tr>
                          </table>
                          <div class="movableContent">
                            <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                              <tr>
                                <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center">
                                    <tr>
                                      <td height="10">&nbsp;</td>
                                    </tr>
                                    <tr>
                                      <td style="border-bottom:1px solid #DDDDDD"></td>
                                    </tr>
                                    <tr>
                                      <td height="30">&nbsp;</td>
                                    </tr>
                                  </table></td>
                              </tr>
                            </table>
                          </div>
                          <div class="movableContent">
                            <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                              <tr>
                                <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                                    <tr>
                                      <td colspan="3" height="15"></td>
                                    </tr>
                                    <tr>
                                      <td width="50"></td>
                                      <td width="500">&nbsp;</td>
                                      <td width="50"></td>
                                    </tr>
                                    <tr>
                                      <td colspan="3" height="5"></td>
                                    </tr>
                                  </table></td>
                              </tr>
                            </table>
                          </div></td>
                        <td width="50"></td>
                      </tr>
                      <tr>
                        <td colspan="3" height="15"></td>
                      </tr>
                    </table></td>
                </tr>
              </table>
            </div>
            <p>&nbsp;</p>
            <div class="movableContent">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                <tr>
                  <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                      <tr>
                        <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                            <tr>
                              <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center">
                                  <tr>
                                    <td height="10">&nbsp;</td>
                                  </tr>
                                </table></td>
                            </tr>
                            <tr>
                              <td height="18">&nbsp;</td>
                            </tr>
                            <tr>
                              <td valign="top" align="center"><div class="contentEditableContainer contentImageEditable">
                                  <div class="contentEditable"> <img src="https://gallery.mailchimp.com/3b436c6ce3392b2a4d195a80d/images/1f5b083d-e73b-4b87-9272-0e67ee2222c1.png"> </div>
                                </div></td>
                            </tr>
                            <tr>
                              <td height="28">&nbsp;</td>
                            </tr>
                            <tr>
                              <td valign="top" align="center"></td>
                            </tr>
                            <tr>
                              <td height="28">&nbsp;</td>
                            </tr>
                          </table></td>
                      </tr>
                    </table></td>
                </tr>
              </table>
            </div></td>
        </tr>
      </table></td>
  </tr>
</table>
<style type="text/css">
                    @media only screen and (max-width: 480px){
                        table[id="canspamBar"] td{font-size:14px !important;}
                        table[id="canspamBar"] td a{display:block !important; margin-top:10px !important;}
                    }
                </style>
</center>
</body>
</html>
    }
    acs_mail_lite::send -send_immediately \
        -to_addr $email \
        -from_addr "registrazione@professionefinanza.com" \
        -subject "Riepilgo dati di accesso - ProfessioneFinanza" \
        -body $body \
        -mime_type "text/html"



if {$return_url eq ""} {
    set next_url "http://pfawards.professionefinanza.com/iscriviti"
}
if { $next_url ne "" } {
    
    ad_returnredirect -allow_complete_url $next_url
    ad_script_abort
} 
    
    
    # User is registered and logged in
    if { (![info exists return_url] || $return_url eq "") } {
        # Redirect to subsite home page.
        set return_url "http://pfawards.professionefinanza.com/iscriviti"
    }
    
    # If the user is self registering, then try to set the preferred
    # locale (assuming the user has set it as a anonymous visitor
    # before registering).
    if { $self_register_p } {
	# We need to explicitly get the cookie and not use
	# lang::user::locale, as we are now a registered user,
	# but one without a valid locale setting.
	set locale [ad_get_cookie "ad_locale"]
	if { $locale ne "" } {
	    lang::user::set_locale $locale
	    ad_set_cookie -replace t -max_age 0 "ad_locale" ""
	}
    }
    
    # Handle account_message
    if { $creation_info(account_message) ne "" && $self_register_p } {
        # Only do this if user is self-registering
        # as opposed to creating an account for someone else
        ad_returnredirect [export_vars -base "[subsite::get_element -element url]register/account-message" { { message $creation_info(account_message) } return_url }]
        ad_script_abort
    } else {
        # No messages
        ad_returnredirect -allow_complete_url $return_url
        ad_script_abort
    }
}
