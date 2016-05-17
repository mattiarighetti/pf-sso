ad_page_contract {
    Prompt the user for email and password.
    @cvs-id $Id: index.tcl,v 1.13.10.1 2014/08/05 09:49:26 gustafn Exp $
} {
    {authority_id:naturalnum ""}
    {username ""}
    {email ""}
    {return_url ""}
    {logout ""}
}

if {$logout == true} {
    set logout_msg "<p style=\"color:#001489;\">Logout effettuato correttamente.</p>"
} else {
    set logout_msg ""
}

set subsite_id [ad_conn subsite_id]

# Present a login box
#
# Expects:
#   subsite_id - optional, defaults to nearest subsite
#   return_url - optional, defaults to Your Account
# Optional:
#   authority_id
#   username
#   email

# Redirect to HTTPS if so configured
if { [security::RestrictLoginToSSLP] } {
    security::require_secure_conn
}
# Richiama parametro per potersi auto registrare
set self_registration [parameter::get_from_package_key \
                                  -package_key acs-authentication \
			          -parameter AllowSelfRegister \
			          -default 1]

# Se sei in un subsite (di solito no, quindi entra e assegna il principale)
if { ![info exists subsite_id] || $subsite_id eq "" } {
    set subsite_id [subsite::get_element -element object_id]
}
#Possibilità di mandarsi la password dimenticata per mail
set email_forgotten_password_p [parameter::get \
                                    -parameter EmailForgottenPasswordP \
                                    -package_id $subsite_id \
                                    -default 1]
#Se non viene passato username, crea la variabile 
if { ![info exists username] } {
    set username {}
}
#Se non viene passata email, crea la variabile
if { ![info exists email] } {
    set email {}
}

#Se utente che ritorna dopo sessione scaduta, imposta la sua email
if { $email eq "" && $username eq "" && [ad_conn untrusted_user_id] != 0 } {
    acs_user::get -user_id [ad_conn untrusted_user_id] -array untrusted_user
    if { [auth::UseEmailForLoginP] } {
        set email $untrusted_user(email)
    } else {
        set authority_id $untrusted_user(authority_id)
        set username $untrusted_user(username)
    }
}

# Persistent login
# The logic is: 
#  1. Allowed if allowed both site-wide (on acs-kernel) and on the subsite
#  2. Default setting is in acs-kernel

set allow_persistent_login_p [parameter::get -parameter AllowPersistentLoginP -package_id [ad_acs_kernel_id] -default 1]
if { $allow_persistent_login_p } {
    set allow_persistent_login_p [parameter::get -package_id $subsite_id -parameter AllowPersistentLoginP -default 1]
}
if { $allow_persistent_login_p } {
    set default_persistent_login_p [parameter::get -parameter DefaultPersistentLoginP -package_id [ad_acs_kernel_id] -default 1]
} else {
    set default_persistent_login_p 0
}

set subsite_url [subsite::get_element -element url]
set system_name [ad_system_name]

# Se c'è url di ritorno, va, altrimenti va alla dashboard
if { [info exists return_url] && $return_url ne "" } {
} else {
    set return_url "http://sso.professionefinanza.com/"
}

#Imposta le authority quando più di una
set authority_options [auth::authority::get_authority_options]
ns_log notice pippo $authority_options
#set authority_options {ProfessioneFinanza 3669}
#set authority_id 3669
# Se non c'è authority la imposta di default
if { ![info exists authority_id] || $authority_id eq "" } {
    set authority_id [lindex $authority_options 0 1]
}
#Imposta URL per il recupero della password
set forgotten_pwd_url [auth::password::get_forgotten_url -authority_id $authority_id -username $username -email $email]
#Imposta URL per la registrazione nuovo utente
set register_url [export_vars -base "[subsite::get_url]register/user-new" {return_url}]
if { $authority_id eq [auth::get_register_authority] || [auth::UseEmailForLoginP] } {
    set register_url [export_vars -no_empty -base $register_url { username email }]
}
#Imposta bottone per login
set login_button [list [list [_ acs-subsite.Log_In] ok]]
#Comincia con il form per il login
ad_form -name login \
    -html {class "form-inline" style "width:100%;"} \
    -show_required_p 0 -edit_buttons $login_button \
    -action "http://sso.professionefinanza.com/register/" \
    -form {
	{return_url:text(hidden)}
	{time:text(hidden)}
	{token_id:text(hidden)}
	{hash:text(hidden)}
    } 
# Controlla se nascondere l'email come fosse password
set username_widget text
if { [parameter::get -parameter UsePasswordWidgetForUsername -package_id [ad_acs_kernel_id]] } {
    set username_widget password
}

set focus {}
#Se si usa l'email per loggarsi, entra
if { [auth::UseEmailForLoginP] } {
    ad_form -extend \
	-name login \
	-form {
	    {email:text($username_widget),nospell
		{label "[_ acs-subsite.Email]"}
		{html {class "form-control" width "120%"}}
	    }
	}
    set user_id_widget_name email
    # Se email gia inserita perche passata per parametro, posiziona cursore su password
    if { $email ne "" } {
        set focus "password"
    } else {
        set focus "email"
    }
} else {
    if { [llength $authority_options] > 1 } {
        ad_form -extend -name login -form {
            {authority_id:integer(select) 
                {label "[_ acs-subsite.Authority]"} 
                {options $authority_options}
            }
        }
    }

    ad_form \
	-extend \
	-name login \
	-form [list [list username:text($username_widget),nospell [list label [_ acs-subsite.Username]] [list html [list style "width: 150px"]]]]
    set user_id_widget_name username
    if { $username ne "" } {
        set focus "password"
    } else {
        set focus "username"
    }
}
set focus "login.$focus"

#Aggiunge password al form
ad_form \
    -extend \
    -name login \
    -form {
	{password:text(password) 
	    {label "[_ acs-subsite.Password]"}
	    {html {class "form-control" width "120%"}}
	}
    }

set options_list [list [list [_ acs-subsite.Remember_my_login] "t"]]
if { $allow_persistent_login_p } {
    ad_form \
	-extend \
	-name login \
	-form {
	    {persistent_p:text(checkbox),optional
		{label ""}
		{options $options_list}
	    }
	}
}
#Finisce il form con script conseguenti
ad_form \
    -extend \
    -name login \
    -on_request {
	set persistent_p [ad_decode $default_persistent_login_p 1 "t" ""]
	
	# One common problem with login is that people can hit the back button
	# after a user logs out and relogin by using the cached password in
	# the browser. We generate a unique hashed timestamp so that users
	# cannot use the back button.
	
	set time [ns_time]
	set token_id [sec_get_random_cached_token_id]
	set token [sec_get_token $token_id]
	set hash [ns_sha1 "$time$token_id$token"]
	
    } -on_submit {
	# Check timestamp
	set token [sec_get_token $token_id]
	set computed_hash [ns_sha1 "$time$token_id$token"]
	
	set expiration_time [parameter::get -parameter LoginPageExpirationTime -package_id [ad_acs_kernel_id] -default 600]
	if { $expiration_time < 30 } { 
	    # If expiration_time is less than 30 seconds, it's practically impossible to login
	    # and you will have completely hosed login on your entire site
	    set expiration_time 30
	}
	
	if { $hash ne $computed_hash  || \
		 $time < [ns_time] - $expiration_time } {
	    ad_returnredirect -message [_ acs-subsite.Login_has_expired] -- [export_vars -base [ad_conn url] { return_url }]
	    ad_script_abort
	}
	# Authority id will be defaulted to local authority
     	if { ![info exists authority_id] || $authority_id eq "" } {
	    set authority_id {}
	}
	
	if { ![info exists persistent_p] || $persistent_p eq "" } {
	    set persistent_p "f"
	}
	if {![element exists login email]} {
	    set email [ns_queryget email ""]
	}
	set first_names [ns_queryget first_names ""]
	set last_name [ns_queryget last_name ""]
	
	array set auth_info [auth::authenticate \
				 -return_url $return_url \
				 -authority_id $authority_id \
				 -email [string trim $email] \
				 -first_names $first_names \
				 -last_name $last_name \
				 -username [string trim $username] \
				 -password $password \
				 -persistent=[expr {$allow_persistent_login_p && [template::util::is_true $persistent_p]}]]
    
	# Handle authentication problems
	switch $auth_info(auth_status) {
	    ok {
		# Continue below
	    }
	    bad_password {
		form set_error login password $auth_info(auth_message)
		break
	    }
	    default {
		form set_error login $user_id_widget_name $auth_info(auth_message)
		break
	    }
	}
	#Per esempio se deve cambiare la password
	if { [info exists auth_info(account_url)] && $auth_info(account_url) ne "" } {
	    ns_log notice ciano $auth_info(account_url)
	    ad_returnredirect $auth_info(account_url)
	    ad_script_abort
	}
	
	# Handle account status
	switch $auth_info(account_status) {
	    ok {
		# Continue below
	    }
	    default {
		# if element_messages exists we try to get the element info
		if {[info exists auth_info(element_messages)]
		    && [auth::authority::get_element \
			    -authority_id $authority_id \
			    -element allow_user_entered_info_p]} {
		    foreach message [lsort $auth_info(element_messages)] {
			ns_log notice "LOGIN $message"
			switch -glob -- $message {
			    *email* {
				if {[element exists login email]} {
				    set operation set_properties
				} else {
				    set operation create
				}
				element $operation login email -widget $username_widget -datatype text -label [_ acs-subsite.Email]
				if {[element error_p login email]} {
				    template::form::set_error login email [_ acs-subsite.Email_not_provided_by_authority]
				}
			    }
			    *first* {
				element create login first_names -widget text -datatype text -label [_ acs-subsite.First_names]
				template::form::set_error login email [_ acs-subsite.First_names_not_provided_by_authority]
			    }
			    *last* {
				element create login last_name -widget text -datatype text -label [_ acs-subsite.Last_name]
				template::form::set_error login last_name [_ acs-subsite.Last_name_not_provided_by_authority]
			    }
			}
		    }
		    set auth_info(account_message) ""
		    
		    ad_return_template
		    
		} else {
		    # Display the message on a separate page
		    ad_returnredirect \
			-allow_complete_url \
			-message $auth_info(account_message) \
			-html \
			[export_vars \
			     -base "[subsite::get_element \
                                -element url]register/account-closed"]
		    ad_script_abort
		}
	    }
	}
    } -after_submit {
	# We're logged in
	# Handle account_message
	if { [info exists auth_info(account_message)] && $auth_info(account_message) ne "" } {
	    ad_returnredirect [export_vars -base "[subsite::get_element -element url]register/account-message" { { message $auth_info(account_message) } return_url }]
	    ad_script_abort
	} else {
	    # No message
	    ad_returnredirect -allow_complete_url $return_url
  	    #ns_returnredirect $return_url
	    ad_script_abort
	}
    }

#REGISTRAZIONE


# Set default parameter values
array set parameter_defaults {
    self_register_p 1
    next_url {}
    return_url {}
}
foreach parameter [array names parameter_defaults] { 
    if { (![info exists $parameter] || $parameter eq "") } { 
        set $parameter $parameter_defaults($parameter)
    }
}

# Redirect to HTTPS if so configured
if { [security::RestrictLoginToSSLP] } {
    security::require_secure_conn
}

# Redirect to the registration assessment if there is one, if not, continue with the regular
# registration form.

set implName [parameter::get -parameter "RegistrationImplName" -package_id [subsite::main_site_id]]

set callback_url [callback -catch -impl "$implName" user::registration]

if { $callback_url ne "" } {
    ad_returnredirect [export_vars -base $callback_url { return_url }]
    ad_script_abort
}


# Pre-generate user_id for double-click protection
set user_id [db_nextval acs_object_id_seq]

ad_form -name register -export {next_url user_id return_url} -form {
    {email:text(text)
	{label Email}
	{html {size 30}}
    }
    {username:text(hidden),optional
	value {}
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
    {screen_name:text(hidden),optional 
	{label {Nome schermo}} 
	{html {size 30}}
	{value ""}
    } 
    {url:text(hidden),optional 
	{label {Indirzzo della Home Page personale:}}
	{html {size 50 value "http://"}}
	{value ""}
    } 
    {secret_question:text(hidden),optional 
	{value ""}
    } 
    {secret_answer:text(hidden),optional 
	{value ""}
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
}

if { ([info exists rel_group_id] && $rel_group_id ne "") } {
    ad_form -extend -name register -form {
        {rel_group_id:integer(hidden),optional}
    }
    
    if { [permission::permission_p -object_id $rel_group_id -privilege "admin"] } {
        ad_form -extend -name register -form {
            {rel_type:text(select)
                {label "Role"}
                {options {[group::get_rel_types_options -group_id $rel_group_id]}}
            }
        }
    } else {
        ad_form -extend -name register -form {
            {rel_type:text(hidden)
                {value "membership_rel"}
            }
        }
    }
}

ad_form -extend -name register -on_request {
    # Populate elements from local variables
    
} -on_submit {
    
    db_transaction {
        array set creation_info [auth::create_user \
                                     -user_id $user_id \
                                     -verify_password_confirm \
                                     -username $username \
                                     -email $email \
                                     -first_names $first_names \
                                     -last_name $last_name \
                                     -screen_name $screen_name \
                                     -password $password \
                                     -password_confirm $password_confirm \
                                     -url $url \
                                     -secret_question $secret_question \
                                     -secret_answer $secret_answer]
	
        if { $creation_info(creation_status) eq "ok" && ([info exists rel_group_id] && $rel_group_id ne "") } {
            group::add_member \
                -group_id $rel_group_id \
                -user_id $user_id \
                -rel_type $rel_type
        }
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
    set next_url "conferma_iscrizione"
}
if { $next_url ne "" } {
    
    ad_returnredirect [export_vars -base $next_url {return_url}]
    ad_script_abort
} 
    
    
    # User is registered and logged in
    if { (![info exists return_url] || $return_url eq "") } {
        # Redirect to subsite home page.
        set return_url [subsite::get_element -element url]
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
        ad_returnredirect $return_url
        ad_script_abort
    }
}
