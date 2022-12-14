# packages/acs-core-ui/www/admin/site-nodes/mount-2.tcl

ad_page_contract {

  @author rhs@mit.edu
  @creation-date 2000-09-12
  @cvs-id $Id: mount-2.tcl,v 1.2.26.4 2014/07/29 11:23:58 gustafn Exp $
} {
  node_id:naturalnum,notnull
  package_id:naturalnum,notnull
  {expand:integer,multiple {}}
  root_id:naturalnum,optional
}

permission::require_permission -object_id $package_id -privilege read

site_node::mount -node_id $node_id -object_id $package_id

ad_returnredirect ".?[export_vars -url {expand:multiple root_id}]"
