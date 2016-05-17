<!DOCTYPE html>
<html> 
  <head>
    <meta name="author" content="Mattia Righetti (mattia.righetti@mail.polimi.it)" />
      <title>@page_title;noquote@ &rsaquo; ProfessioneFinanza Awards</title>
      <script language="JavaScript" src="header.js"></script>
  </head>
  <br>
    <div id="context">
      <ol id="sezione">
	<li class="home"><a href="/pfawards/">Home</a></li>
	<li>Utenti</li>
      </ol>
    </div>
    <br>
      <h1>Utenti</h1>
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
		  <td>
		    <center>
		      <input class="bot" type="submit" value="Cerca" />
			<input class="bot" type="button" value="Reset" onClick="location.href='utenti-list';" />
		    </center>
		  </td>
		  <tr>
		    <listfilters name="utenti"></listfilters>
		    <td class="list-list-pane" valign="top">
		      <listtemplate name="utenti"></listtemplate>
		    </td>
		  </tr>
	      </table>
	    </form>
	  </td>
	</tr>
      </table><br><br>
	</body>
</html>