ad_page_contract {
    Pagina index per i menu di PFAwards.
    
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 14 October 2015
} 
set user_id [auth::require_login]
set dash_html [pf::dash_menu "pfawards"]
set page_title "PFAwards - ProfessioneFinanza"
template::head::add_style -style ".tab-pane {border-left: 1px solid #ddd; border-right: 1px solid #ddd; border-bottom: 1px solid #ddd; border-radius: 0px 0px 5px 5px; padding: 10px;} .nav-tabs {margin-bottom: 0;}" -type "text/css"
acs_user::get -user_id $user_id -array user_info
set username $user_info(first_names)
append username $user_info(last_name)
set persona_id [db_string query "select persona_id from crm_persone where user_id = [ad_conn user_id]"]
set award_id [db_string query "select award_id from awards_edizioni where attivo is true"]
set exam_table "<ul class=\"nav nav-tabs\" role=\"tablist\">"
db_foreach query "select award_id as id, case when attivo is true then 'active' else '' end as class, anno from awards_edizioni order by anno desc" {
    append exam_table "<li class=\"" $class "\" role=\"presentation\"><a href=\"#" $id "\" data-toggle=\"tab\" aria-controls=\"" $award_id "\" role=\"tab\">" $anno "</a></li>"
}
append exam_table "</ul><div class=\"tab-content\">"
db_foreach query "select award_id as id, case when attivo is true then 'active' else '' end as class from awards_edizioni order by anno desc" {
    append exam_table "<div class=\"tab-pane " $class "\" id=\"" $id "\" role=\"tabpanel\"><h3 class=\"sub-header\">Esami <small>(prima fase)</small></h3><table class=\"table table-striped\"><tr><th>Codice esame</th><th>Materia</th><th>Stato</th><th>Data</th><th>Tempo</th><th>Decorrenza</th><th>Scadenza</th><th>Punti</th><th></th></tr>"
    db_foreach query "select c.titolo, e.esame_id, e.pdf_doc, initcap(lower(e.stato)) as stato, to_char(e.start_time, 'DD/MM/YYYY HH24:MI') as data, to_char(e.end_time - e.start_time, 'MI') as minuti, e.punti, e.attivato, e.decorrenza as datadec, to_char(e.decorrenza, 'DD/MM/YYYY HH24:MI') as decorrenza, to_char(e.scadenza, 'DD/MM/YYYY HH24:MI') as scadenza from awards_esami e, awards_categorie c where e.persona_id = :persona_id and e.award_id = :id and c.categoria_id = e.categoria_id order by e.stato desc, e.categoria_id, e.scadenza, e.start_time desc, e.esame_id" {
	append exam_table "<tr><td>$esame_id</td><td>$titolo</td>"
	if {$stato == ""} {
	    set stato "Da svolgere"
	}
	if {[db_0or1row query "select * from awards_bonus where esame_id = :esame_id limit 1"]} {
	    append punti "<small> di cui</small>"
	    db_foreach query "select descrizione as causale, punti from awards_bonus where esame_id = :esame_id" {
	    append punti "<br><small>$causale ($punti)</small>"
	    }
	}
	if {$minuti ne ""} {
	    append minuti " <small>minuti</small>"
	}
	append exam_table "<td>$stato</td><td>$data</td><td>$minuti</td><td>$decorrenza</td><td>$scadenza</td><td>$punti</td>"
	if {$attivato == "t" && [db_string query "select case when current_timestamp > :datadec then 1 else 0 end"] && $stato ne "Svolto" && $stato ne "Rifiutato"} {
	    append exam_table "<td><a class=\"btn btn-default\" href=\"http://test.pfawards.professionefinanza.com/?esame_id=$esame_id\" role=\"button\"><span class=\"glyphicon glyphicon-play-circle\"></span> Svolgi</a></td>"
	} else {
	    if {$stato == "Svolto" || $stato == "Rifiutato"} {
		append exam_table "<td><a class=\"btn btn-default\" href=\"$pdf_doc\" role=\"button\"><span class=\"glyphicon glyphicon-download\"> Consulta</a></td>"
	    } else {
		append exam_table "<td><p><small>Non attivato</small></p></td>"
	    }
	}
	append exam_table "</tr>"
    }
    append exam_table "</table>"
    if {[db_0or1row query "select * from awards_esami_2 where award_id = :id and persona_id = :persona_id limit 1"]} {
	append exam_table "<h3 class=\"sub-header\">Questionari <small>(seconda fase)</small></h3>"
	append exam_table "<table class=\"table table-striped\"><tr><th>Codice esame</th><th>Riferimento</th><th>Categoria</th><th>Decorrenza</th><th>Scadenza</th><th></th></tr>"
	db_foreach query "select e.esame_id, c.titolo, to_char(e.start_time, 'DD MONTH YYYY - HH24:MI') as start_time, to_char(e.end_time, 'DD MONTH YYYY') as end_time, to_char(e.decorrenza, 'DD/MM/YYYY HH24:MI') as decorrenza, e.decorrenza as date_dec, to_char(e.scadenza, 'DD/MM/YYYY HH24:MI') as scadenza, e.rif_id from awards_esami_2 e, awards_categorie c where award_id = :id and c.categoria_id = e.categoria_id and persona_id = :persona_id order by e.esame_id" {
	    append exam_table "<tr><td>$esame_id</td><td>$rif_id</td><td>$titolo</td><td>$decorrenza</td><td>$scadenza</td>"
	    if {[db_string query "select case when current_timestamp > :date_dec then 1 else 0 end"] && $end_time eq ""} {
		append exam_table "<td><a class=\"btn btn-default\" href=\"http://test.pfawards.professionefinanza.com/?esame_id=$esame_id\" role=\"button\"><span class=\"glyphicon glyphicon-play-circle\"></span> Svolgi</a></td>"
	    } else {
		append exam_table "<td></td></tr>"
	    }
	}
    }
    append exam_table "</table></div>"
}
append exam_table "</div>"
if {[db_0or1row query "select * from awards_esami where persona_id = :persona_id and award_id = :award_id limit 1"] && [db_0or1row query "select * from awards_edizioni where award_id = :award_id and demo is true"]} {
    set demo_button "<a class=\"btn btn-default\" href=\"http://sso.professionefinanza.com/pfawards/demo\">Demo</a>"
} else {
    set demo_button ""
}
ad_return_template
