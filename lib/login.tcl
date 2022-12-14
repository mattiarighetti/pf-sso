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
#Possibilit√† di mandarsi la password dimenticata per mail
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

# Se c'√® url di ritorno, va, altrimenti va alla dashboard
if { [info exists return_url] && $return_url ne "" } {
} else {
    set return_url "http://sso.professionefinanza.com/"
}

#Imposta le authority quando pi√Ļ di una
set authority_options [auth::authority::get_authority_options]
ns_log notice pippo $authority_options
#set authority_options {ProfessioneFinanza 3669}
#set authority_id 3669
# Se non c'√® authority la imposta di default
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
		{html {class "form-control" placeholder "Email" width "120%"}}
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
	    {html {class "form-control" placeholder "Password" width "120%"}}
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
