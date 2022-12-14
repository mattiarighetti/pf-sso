# /packages/mbryzek-subsite/www/admin/groups/constraints-create-2.tcl

ad_page_contract {

    Optionally directs the user to create a relational segment (based
    on the value of operation)
    
    @author mbryzek@arsdigita.com
    @creation-date Thu Jan  4 11:02:15 2001
    @cvs-id $Id: constraints-create-2.tcl,v 1.2.10.5 2014/08/05 09:49:23 gustafn Exp $

} {
    group_id:notnull,naturalnum
    rel_type:notnull
    { operation "" }
    { return_url "" }
}

set operation [string trim [string tolower $operation]]

if {$operation eq "yes"} {
    if { $return_url eq "" } {
	# Setup return_url to send up back to the group admin page
	# when we're all done
	set return_url "[ad_conn package_url]/admin/groups/one?[export_vars group_id]"
    }
    ad_returnredirect "../rel-segments/new?[export_vars {group_id rel_type return_url}]"
} else {
    if { $return_url eq "" } {
	set return_url "one?[export_vars group_id]"
    }
    ad_returnredirect $return_url
}

