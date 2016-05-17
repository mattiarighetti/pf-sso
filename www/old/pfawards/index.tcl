ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 14 October 2015
} 
pf::user_must_login
set page_title "PFAwards - ProfessioneFinanza"
set context [list $page_title]
set dash_menu [pf::dash_menu "pfawards"]
template::head::add_css -href /dashboard.css
set persona_id [db_string query "select persona_id from crm_persone where user_id = [ad_conn user_id]"]
set exam_table "<table class=\"table table-striped\"><tr><th>#</th><th>Materia</th><th>Stato</th><th>Data</th><th>Tempo</th><th>Termine ultimo</th><th>Punti</th><th></th></tr>"
db_foreach query "select c.titolo, e.esame_id, e.pdf_doc, initcap(lower(e.stato)) as stato, to_char(e.start_time, 'DD/MM/YYYY') as data, to_char(e.end_time - e.start_time, 'MI') as minuti, e.punti, e.attivato, to_char(e.scadenza, 'DD/MM/YYYY') as scadenza from awards_esami e, awards_categorie c where e.persona_id = :persona_id and c.categoria_id = e.categoria_id order by e.award_id, e.stato desc, e.categoria_id, e.scadenza, e.start_time desc, e.esame_id" {
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
    append exam_table "<td>$stato</td><td>$data</td><td>$minuti</td><td>$scadenza</td><td>$punti</td>"
    if {$attivato == "t" && $stato == "Da svolgere"} {
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
set questionnaire [db_0or1row query "select * from awards_esami_2 where persona_id = :persona_id limit 1"]
set questionnaire_table "<table class=\"table table-striped\"><tr><th>#</th><th>Materia</th><th>Termine ultimo</th><th></th></tr>"
db_foreach query "select c.titolo, e.esame_id, e.pdf_doc, e.attivato, to_char(e.scadenza, 'DD/MM/YYYY') from awards_esami_2 e, awards_categorie c where e.persona_id = :persona_id and c.categoria_id = e.categoria_id order by e.scadenza, e.esame_id" {
    append questionnaire_table "<tr><td>$esame_id</td><td>$titolo</td><td>$scadenza</td><td>"
    if {[db_0or1row query "select * from awards_esami_2 where esame_id = :esame_id and stato is null and attivato is true"]} {
	append questionnaire_table "<a href=\"http://test.pfawards.professionefinanza.com/?esame_id=$esame_id\" class=\"btn btn-default\"><span class=\"glyphicon glyphicon-play-circle\"></span> Svolgi</a></td></tr>"
    } else {
	if {$pdf_doc ne ""} {
	    append questionnaire_table "<a href=\"$pdf_doc\" class=\"btn btn-default\"><span class=\"glyphicon glyphicon-download\"></span> Consulta</a></td></tr>"
	} else {
	    append questionnaire_table "<small>Non attivato</small></td></tr>"
	}
    }
}
append questionnaire_table "</table>"
ad_return_template
