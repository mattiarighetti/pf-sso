  <property name="page_title">@page_title;noquote@</property>
  <property name="context">@context;noquote@</property>
  <property name="focus">@focus;noquote@</property>	
  
  <form>
    <formtemplate id="cerca">
      <center>
	<input class="form-control" type="text" name="q" id="q" style="width:75%;"></input><br></br>
	<button class="btn btn-primary" type="submit"><span class="glyphicon glyphicon-search"></span> Cerca</button>
      </center>
    </formtemplate>
  </form><br></br>
  <table align="center" border="0" width="75%">
    <tr>
      <td width="50%" valign="top">
	<center>
	  <ul class="list-group">
	    <li class="list-group-item disabled">MENU</li>
	    <li class="list-group-item"><a href="?module=crm&template=modules%2Fcrm%2Fpersone-gest">Aggiungi persona</a></li>
	    <li class="list-group-item"><a href="?module=crm&template=modules%2Fcrm%2Fpersone-list">Consulta</a></li>
	    <li class="list-group-item"><a href="?module=crm&template=modules%2Fcrm%2Fsocieta-list">Societ&agrave;</a></li>
	    <li class="list-group-item"><a href="?module=crm&template=modules%2Fcrm%2Feventi-list">Eventi</a></li>
	    <li class="list-group-item"><a href="?module=crm&template=modules%2Fcrm%2Fdocenti-list">Docenti</a></li>
	  </ul>
	</center>
      </td>
      <td width="50%" valign="top">
	<center>
	  <ul class="list-group">
	    <li class="list-group-item disabled">UTILITY</li>
	    <li class="list-group-item"><a href="?module=crm&template=modules%2Fcrm%2Ftipocontatto-list">Tipi contatto</a></li>
	    <li class="list-group-item"><a href="?module=crm&template=modules%2Fcrm%2Fcariche-list">Cariche e gerarchie</a></li>
	    <li class="list-group-item"><a href="?module=crm&template=modules%2Fcrm%2Fcomuni-list">Comuni</a> | <a href="?module=crm&template=modules%2Fcrm%2Fprovincie-list">Provincie</a> | <a href="?module=crm&template=modules%2Fcrm%2Fpaesi-list">Paesi</a></li>
	  </ul>
	</center>
      </td>
    </tr>
  </table>