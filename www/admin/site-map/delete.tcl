# packages/acs-core-ui/www/admin/site-nodes/delete.tcl

ad_page_contract {

    @author rhs@mit.edu
    @creation-date 2000-09-09
    @cvs-id $Id: delete.tcl,v 1.4.26.3 2014/08/05 09:49:24 gustafn Exp $

} {
    expand:integer,multiple
    node_id:naturalnum,notnull
    {root_id:naturalnum ""}
}

if {$root_id == $node_id} {
    set root_id [site_node::get_parent_id -node_id $node_id]
}

site_node::delete -node_id $node_id

ad_returnredirect ".?[export_vars -url {expand:multiple root_id}]"
