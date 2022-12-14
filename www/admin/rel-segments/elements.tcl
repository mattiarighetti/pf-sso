# /packages/mbryzek-subsite/www/admin/rel-segments/elements.tcl

ad_page_contract {

    Shows elements for one relational segment

    @author mbryzek@arsdigita.com
    @creation-date Tue Dec 12 17:52:03 2000
    @cvs-id $Id: elements.tcl,v 1.5.22.5 2014/07/29 11:23:57 gustafn Exp $

} {
    segment_id:naturalnum,notnull
} -properties {
    context:onevalue
    segment_id:onevalue
    segment_name:onevalue
    role_pretty_plural:onevalue
    elements:multirow
} -validate {
    segment_exists_p -requires {segment_id:notnull} {
	if { ![rel_segments_permission_p $segment_id] } {
	    ad_complain "The segment either does not exist or you do not have permission to view it"
	}
    }
}

db_1row select_segment_info {
    select s.segment_name, s.group_id,
           acs_rel_type.role_pretty_plural(r.role_two) as role_pretty_plural
      from rel_segments s, acs_rel_types r
     where s.segment_id = :segment_id
       and s.rel_type = r.rel_type
}

# The role pretty names can be message catalog keys that need
# to be localized before they are displayed
set role_pretty_plural [lang::util::localize $role_pretty_plural]    

set context [list [list "[ad_conn package_url]admin/rel-segments/" "Relational segments"] [list one?[export_vars {segment_id}] "One segment"] "Elements"]

# Expects segment_id, segment_name, group_id, role to be passed in 

ad_return_template
