ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
}
set user_id [ad_conn user_id]
set html "<html>"
set dataelaborazione [db_string query "SELECT TO_CHAR(CURRENT_DATE, 'DD/MM/YYYY')"] 
set intestazione "Stampa inventario"
append html "<table width=\"100%\" cellspacing=\"1\" cellpadding=\"1\">
                <tr>
                    <td align=\"left\"><img src=\"http://85.32.63.43:8000/applicazioni/spiaggia/righetti/images/negretti_logo.jpg\" width=\"181px\" height=\"30px\"></img></td>
                    <td align=\"right\">$dataelaborazione</td> 
                </tr>
                <tr>     
               <td colspan=\"2\" align=\"center\"><font face=\"Helvetica\"><b>INVENTARIO</b></font></td>
                 </tr>
              </table> 
              <br>
              <table width=100% border='0.2' cellspacing=3 cellpadding=3 bordercolor=grey>
               <tr> 
                  <td align=center><font face=Helvetica><b>Marca</b></font></td>
                  <td align=center><font face=Helvetica><b>Tipologia</b></font></td>
                  <td align=center><font face=Helvetica><b>Modello</b></font></td>
                  <td align=center><font face=Helvetica><b>Descrizione</b></font></td>
                  <td align=center><font face=Helvetica><b>Dimensione</b></font></td>
                  <td align=center><font face=Helvetica><b>Q.tà</b></font></td>
                </tr>"
db_foreach query "SELECT m.denominazione AS marca,  
                         o.descrizione, 
                         o.quantita,
                         o.modello,
                         o.dimensione,
                         t.descrizione AS tipologia
                    FROM neg_oggetto o
         LEFT OUTER JOIN neg_marca m ON o.marca_id = m.marca_id
         LEFT OUTER JOIN neg_tipo t ON o.tipo_id = t.tipo_id
                   WHERE 1 = 1
                ORDER BY m.denominazione " {
		     append html "</tr>
                                  <td align=center><font size='2px'>$marca</font></td>
                                  <td align=center><font size=2px>$tipologia</font></td>
                                  <td align=center><font size='2px'>$modello</font></td>
                                  <td align=center><font size='2px'>$descrizione</font></td>
                                  <td align=center><font size='2px'>$dimensione</font></td>
                                  <td align=center><font size='2px'>$quantita</font></td>"
		 }
append html "</table>"
set filenamehtml "/tmp/stampa-inventario.html"
set filenamepdf  "/tmp/stampa-inventario.pdf"
set file_html [open $filenamehtml w]
puts $file_html $html
close $file_html
with_catch error_msg {
    exec htmldoc --portrait --webpage --header ... --footer ... --quiet --left 0.5cm --right 0.5cm --top 0.5cm --bottom 0.5cm --fontsize 12 -f $filenamepdf $filenamehtml
} {
    ns_log notice "errore htmldoc  <code>$error_msg </code>"
}
ns_returnfile 200 application/pdf $filenamepdf
ns_unlink $filenamepdf
ns_unlink $filenamehtml
ad_script_abort
