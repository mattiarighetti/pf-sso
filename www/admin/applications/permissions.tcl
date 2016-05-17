ad_page_contract {
    Permissions for the subsite itself.
    
    @author Lars Pind (lars@collaboraid.biz)
    @creation-date 2003-06-13
    @cvs-id $Id: permissions.tcl,v 1.1.22.1 2014/08/05 09:49:23 gustafn Exp $
} {
    package_id:naturalnum,notnull
}

set page_title "[apm_instance_name_from_id $package_id] Permissions"

set context [list [list "." "Applications"] $page_title]

