# 

ad_page_contract {
    
    
    
    @author mattia (mattia.righetti@professionefinanza.com)
    @creation-date 2016-02-14
    @cvs-id $Id$
} {
    
} -properties {
} -validate {
} -errors {
}

ad_form -name "passwordchange" \
    -mode edit \
    -form {
	{current_password:text(password)
	    {html {placeholder "Inserisci la vecchia password" width "100%"}}
	}
	{new_password:text(password)
	    {html {placeholder "Inserisci una nuova password"}}
	}
	{confirm_password:text(password)
	    {html {placeholder "Reinserici la nuova password"}}
	}
    } -validate {
	{current_password
	    {[ad_check_password [ad_conn user_id] $current_password]}
	    "La password non è corretta."
	}
	{new_password
	    {[string length $new_password] > 5}
	    "La password scelta è troppo corta."
	}
	{new_password 
	    {$current_password != $new_password}
	    "La password scelta è uguale alla precedente."
	}
	{confirm_password
	    { $new_password == $confirm_password }
	    "Le due password non concidono."
	}
    } -on_submit {
	ad_change_password [ad_conn user_id] $new_password
	ad_returnredirect "/?pwd_changed=true"
	ad_script_abort
    }
