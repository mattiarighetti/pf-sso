# packages/acs-core-ui/www/admin/site-nodes/unmount.tcl

ad_page_contract {

    @author rhs@mit.edu
    @creation-date 2000-09-12
    @cvs-id $Id: unmount.tcl,v 1.3.26.3 2014/07/29 11:23:58 gustafn Exp $

} {
    node_id:naturalnum,notnull
    {expand:integer,multiple ""}
    root_id:naturalnum,optional
}

site_node::unmount -node_id $node_id

ad_returnredirect ".?[export_vars -url {expand:multiple root_id}]"
