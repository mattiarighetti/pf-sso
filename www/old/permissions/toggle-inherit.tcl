# packages/acs-subsite/www/permissions/toggle-inherit.tcl

ad_page_contract {

    Toggles the security_inherit_p flag.

    @author rhs@mit.edu
    @creation-date 2000-09-30
    @cvs-id $Id: toggle-inherit.tcl,v 1.5.12.2 2014/07/29 11:23:59 gustafn Exp $
} {
    object_id:naturalnum,notnull
    {application_url ""}
    {return_url {[export_vars -base "one" {application_url object_id}]}}
}

permission::require_permission -object_id $object_id -privilege admin

permission::toggle_inherit -object_id $object_id

# this prevents administrators from deselecting inheritance and then
# discovering that they no longer have admin rights
set group_id [application_group::group_id_from_package_id -package_id [ad_conn subsite_id]]
set rel_id [group::get_rel_segment -group_id $group_id -type admin_rel]
permission::grant -object_id $object_id -party_id $rel_id -privilege admin
if { ![permission::permission_p -object_id $object_id -privilege admin] } {
    permission::grant \
        -object_id $object_id -party_id [ad_conn user_id] -privilege admin
}

ad_returnredirect $return_url
