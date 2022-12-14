# /packages/mbryzek-subsite/www/admin/rel-segments/delete.tcl

ad_page_contract {

    Confirms delete of relational segment

    @author mbryzek@arsdigita.com
    @creation-date Tue Dec 12 11:23:12 2000
    @cvs-id $Id: delete.tcl,v 1.3.26.6 2014/07/29 11:23:57 gustafn Exp $

} {
    segment_id:naturalnum,notnull
    { return_url "" }
} -properties {
    export_vars:onevalue
    segment_name:onevalue
} -validate {
    segment_exists_p -requires {segment_id:notnull} {
	if { ![rel_segments_permission_p -privilege delete $segment_id] } {
	    ad_complain "The segment either does not exist or you do not have permission to delete it"
	}
    }
}

db_1row select_segment_info {
    select s.segment_name 
      from rel_segments s
     where s.segment_id = :segment_id
}

set export_vars [export_vars -form {segment_id}]
set context [list \
     [list "[ad_conn package_url]admin/rel-segments/" "Relational segments"] \
     [list one?[export_vars segment_id] "One segment"] \
     "Remove segment"]

ad_return_template
