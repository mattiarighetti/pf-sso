# /packages/acs-subsite/www/admin/relations/one.tcl

ad_page_contract {

    Shows information about one relation

    @author mbryzek@arsdigita.com
    @creation-date Wed Dec 13 20:11:27 2000
    @cvs-id $Id: change-member-state.tcl,v 1.2.10.1 2014/07/29 11:23:57 gustafn Exp $

} {
    rel_id:naturalnum,notnull
    member_state:notnull
    {return_url ""}
} -validate {
    permission_p -requires {rel_id:notnull} {
	if { ![relation_permission_p -privilege admin $rel_id] } {
	    ad_complain "The relation either does not exist or you do not have permission to administer it"
	}
    }
    relation_in_scope_p -requires {rel_id:notnull permission_p} {
	if { ![application_group::contains_relation_p -rel_id $rel_id]} {
	    ad_complain "The relation either does not exist or does not belong to this subsite."
	}
    }
}

db_dml update_member_state {
    update membership_rels
    set member_state = :member_state
    where rel_id = :rel_id
}


if {$return_url eq ""} {
    set return_url "one?rel_id=$rel_id"
}
ad_returnredirect $return_url