# /packages/mbryzek-subsite/www/admin/rel-type/add-2.tcl

ad_page_contract {

    Adds relation type

    @author mbryzek@arsdigita.com
    @creation-date Sun Nov 12 18:05:09 2000
    @cvs-id $Id: add-2.tcl,v 1.1.1.1.28.1 2014/07/29 11:23:57 gustafn Exp $

} {
    constraint_id:naturalnum,notnull
    rel_type:notnull
    object_type:notnull
    { return_url "" }
}

db_dml update_rel_type_mapping {
    insert into group_type_allowed_rels
    (constraint_id, group_type, rel_type)
    values
    (:constraint_id, :object_type, :rel_type)
}

ad_returnredirect $return_url
