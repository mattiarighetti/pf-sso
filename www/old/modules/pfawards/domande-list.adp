<!DOCTYPE html>
<html> 
  <head>
    <meta name="author" content="Mattia Righetti (mattia.righetti@mail.polimi.it)" />
    <title>@page_title;noquote@ &rsaquo; ProfessioneFinanza Awards</title>
    <script language="JavaScript" src="header.js"></script>
  </head>
  <body onload="document.getElementById('ricerca').focus()">
    <br>
    <div id="context">
      <ol id="sezione">
	<li class="home"><a href="/pfawards/">Home</a></li>
	<li>Domande</li>
      </ol>
    </div>
    <br>
    <h1>Lista domande</h1>
    <table class="tabella"> 
      <tr> 	 
	<td class="list-filter-pane" width="100%" valign="top">
	  <form action="@base_url@">	 
	    <table width="100%">
	      <tr class="ricerca">
		<td colspan="2" class="list-filter-header">
		  <img src="images/search-green.gif" width="20" height="20" />Ricerca	    
		</td>
	      </tr>
	      <tr>
		<td>
		  <input class="input" type="text" value="@q;noquote@" name="q" id="ricerca" />
		</td>
	      </tr>
              <tr>
                <td align="left" class="list-filter-header">
		  <img src="images/tipo_ico.jpeg" width="20" height="20" />Categoria<br>
                  <select name="q_categoria_id" id="q_categoria_id">@categoria_id_options;noquote@</select>
                </td>
              </tr>
              <tr>
                <td>
                  <center>
                    <input class="bot" type="submit" value="Cerca" />
                    <input class="bot" type="button" value="Reset" onClick="location.href='domande-list';" />
                  </center>
                </td>
              </tr>
	      <tr>
		<listfilters name="domande"></listfilters>
		<td class="list-list-pane" valign="top">
		  <listtemplate name="domande"></listtemplate>
		</td>
	      </tr>
	    </table>
	  </form>
	</td>
      </tr>
    </table><br><br>
  </body>
</html>
