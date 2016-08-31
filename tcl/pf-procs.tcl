ad_library {
    PFHolding Procedures
    @author mattia.righetti@professionefinanza.com
}

namespace eval pf {}

ad_proc -public pf::user_must_admin  { 
} { 
    { -return_url ""}
} {
    if {[info exist return_url] eq 0} {
	set return_url [ad_return_url -qualified]
    }
    if {[ad_conn user_id] == 0} {
	ad_returnredirect -allow_complete_url \
	    -message "Effettuare l'accesso per continuare la navigazione." \
	    "http://sso.professionefinanza.com/register/?return_url=$return_url"
	ad_script_abort
    }
    if {![db_0or1row query "SELECT * FROM registered_users WHERE user_id = [ad_conn user_id] AND email LIKE '%professionefinanza.com'"]} {
	ad_returnredirect -allow_complete_url \
	    [ad_url]
	ad_script_abort
    }
}

ad_proc -public pf::fe_html_menu {
    {-id} 
} {
    Funzione per creare i menu dei siti Front-End.
} {
    set menu_id [db_string query "select menu_id from fe_menu_items where item_id = :id"]
    set fe_html_menu "<nav class=\"\">\n<ul class=\"nav nav-justified\">"
    db_foreach query "select item_id, label, href from fe_menu_items where menu_id = :menu_id order by item_order" {
	if {$item_id == $id} {
	    append fe_html_menu "<li class=\"active\">\n<a href=\"$href\">$label</a>\n</li>"
	} else {
	    append fe_html_menu "<li>\n<a href=\"$href\">$label</a>\n</li>"
	}
    }
    append fe_html_menu "</ul>\n</nav>"
    return $fe_html_menu
}

ad_proc -public pf::user_must_login {
} {
} {
    if {[ad_conn user_id] eq "" || [ad_conn user_id] eq 0} {
	set return_url [ad_return_url -qualified]
	ad_returnredirect -allow_complete_url [export_vars -base "http://sso.professionefinanza.com/register/" {return_url}]
	ad_script_abort
    }
}

ad_proc -public pf::dash_menu {
    modulo
} {
    set dash_menu "<ul class=\"nav navbar-nav side-nav\">"
    if {[db_0or1row query "select * from crm_persone where user_id = [ad_conn user_id]"]} {
	set persona_id [db_string query "select persona_id from crm_persone where user_id = [ad_conn user_id]"]

	# Utenza
	if {$modulo == "profilo"} {
	    append dash_menu "<li class=\"active\"><a href=\"/\"><i class=\"fa fa-fw fa-dashboard\"></i> Account</a></li>"
	} else {
	    append dash_menu "<li><a href=\"/\"><i class=\"fa fa-fw fa-dashboard\"></i> Account</a></li>"
	}

	# PFEXPO
	if {$modulo == "pfexpo"} {
	    append dash_menu "<li><a href=\"pfexpo\" class=\"active\"><i class=\"fa fa-fw fa-globe\"></i> PFEXPO</a></li>"
	} else {
	    append dash_menu "<li><a target=\"_blank\" href=\"http://pfexpo.it\"><i class=\"fa fa-fw fa-globe\"></i> PFEXPO</a></li>"
	}

	# PFAwards
	if {[db_0or1row query "select * from awards_esami where persona_id = :persona_id limit 1"]} {
	    if {$modulo == "pfawards"} {
		append dash_menu "<li class=\"active\"><i class=\"glyphicon glyphicon-bookmark\"></i> PFAwards</li>"
	    } else {
		append dash_menu "<li><a href=\"/pfawards\"><i class=\"glyphicon glyphicon-bookmark\"></i> PFAwards</a></li>"
	    }
	}
	append dash_menu "</ul>"
    } else {
	ad_returnredirect -allow_complete_url "http://admin.professionefinanza.com/"
	ad_script_abort
    }
    return $dash_menu
}

ad_proc -public pf::admin_menu {
    modulo
} {
    set admin_menu "<ul class=\"nav nav-sidebar\">"
    if {$modulo == "utenza"} {
	append admin_menu "<li class=\"active\"><span class=\"glyphicon glyphicon-user\"></span> Utenza</li>"
    } else {
	append admin_menu "<li><a href=\"/index\"><span class=\"glyphicon glyphicon-user\"></span> Utenza</a></li>"
    }
    db_foreach query "select lower(m.descrizione) as descrizione_low, m.descrizione, m.glyphicon from sso_modules m, sso_module_user u where u.module_id = m.module_id and u.user_id = [ad_conn user_id]" {
	if {$modulo == $descrizione_low} {
	    append admin_menu "<li class=\"active\"><span class=\"$glyphicon\"></span> $descrizione</li>"
	} else {
	    append admin_menu "<li><a href=\"/$descrizione_low\"><span class=\"$glyphicon\"></span> $descrizione</a></li>"
	}
    }
    return $admin_menu
}
