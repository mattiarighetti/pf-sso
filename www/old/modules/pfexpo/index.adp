<html>
  <property name="page_title">@page_title;noquote@</property>
  <property name="context">@context;noquote@</property>
  
  <form action="http://sso.professionefinanza.com/?module=pfexpo" class="form-inline">
    <div class="form-group">
      <div class="input-group">
	<div class="input-group-addon">PFEXPO</div>
	<select class="form-control" name="expo_id" type="text" id="cerca_expo_id" style="width:150px;" width="150px">@expo_id_options;noquote@</select>
      </div>      
      <input type="hidden" name="module" value="pfexpo" />
	<input class="btn btn-primary" type="button" value="Vai" />
	  <input class="btn btn-success" type="button" value="Nuovo" onClick="location.href='expo-gest'" />
    </div>
  </form></br>
  <ul class="list-group">
    <li class="list-group-item">Giorni all'evento: <span class="badge">@giorni;noquote@</span></li>
    <li class="list-group-item">Iscritti totali: <span class="badge">@tot_iscr;noquote@</span></li>
    <li class="list-group-item">Iscritti oggi: <span class="badge">@oggi_iscr;noquote@</span></li>
    <li class="list-group-item">Iscritti agli eventi: <span class="badge">@iscr_eventi;noquote@</span></li>
  </ul>

  <div class="table-responsive">
    <table align="center" border="0" width="100%">
      <tr>
	<td width="50%" valign="top">
	  <center>
	    <ul class="list-group">
	      <li class="list-group-item disabled">MENU</li>
	      <li class="list-group-item"><a href="?module=pfexpo&expo_id=@expo_id;noquote@&template=modules%2Fpfexpo%2Feventi-list">Eventi</a></li>
	      <li class="list-group-item"><a href="?module=pfexpo&expo_id=@expo_id;noquote@&template=modules%2Fpfexpo%2Fiscritti-list">Iscritti</a></li>
	    </ul>
	  </center>
	</td>
	<td width="50%" valign="top">
	  <center>
	    <ul class="list-group">
	      <li class="list-group-item disabled">UTILITY</li>
	      <li class="list-group-item"><a href="?module=pfexpo&expo_id=@expo_id;noquote@&template=modules%2Fpfexpo%2Feventi-list">Eventi</a> | <a href="categoriaevento-list">Percorsi evento</a></li>
	      <li class="list-group-item"><a href="?module=pfexpo&template=modules%2Fpfexpo%2Fpartners-list&expo_id=@expo_id;noquote@">Partners espositori</a></li>
	      <li class="list-group-item"><a href="?module=pfexpo&expo_id=@expo_id;noquote@&template=modules%2Fpfexpo%2Frelatori-list">Relatori</a></li>
	      <li class="list-group-item"><a href="?module=pfexpo&expo_id=@expo_id;noquote@&template=modules%2Fpfexpo%2Fsale-list">Sale</a> | <a href="?module=pfexpo&template=modules%2Fpfexpo%2Fluoghi-list">Luoghi</a></li>
	    </ul>
	  </center>
	</td>
      </tr>
    </table>
  </div>
  