  <master>
    <property name="page_title">@page_title;noquote@</property>
    <property name="context">@context;noquote@</property>
    
    <div class="container"></br>
      <table border="0" width="100%">
	<tr>
	  <td>
	    <formtemplate id="persone"></formtemplate></br>
	  </td>
	  <td>
	    <if @form_new@ ne 1>	
	      <span class="glyphicon glyphicon-phone-alt">&nbsp;</span>
	      <a class="btn btn-default" href="contatti-gest?persona_id=@persona_id;noquote@" role="button">Aggiungi contatto</a>
	      <listtemplate name="contatti"></listtemplate>
	      <span class="glyphicon glyphicon-calendar"></span>
	      <listtemplate name="eventi"></listtemplate>
	      <span class="glyphicon glyphicon-home">&nbsp;</span>
	      <a class="btn btn-default" href="indirizzi-gest?persona_id=@persona_id;noquote@" role="button">Aggiungi indirizzo</a>
	      <listtemplate name="indirizzi"></listtemplate>
	      <span class="glyphicon glyphicon-transfer">&nbsp;</span>
	      <a class="btn btn-default" href="telefonate-gest?persona_id=@persona_id;noquote@" role="button">Aggiungi telefonata</a>
	      <listtemplate name="telefonate"></listtemplate>
	      <span class="glyphicon glyphicon-floppy-remove">&nbsp;</span>
	      <a class="btn btn-default" href="persone-canc-cascade?persona_id=@persona_id;noquote@" role="button">Cancella scheda</a>
	    </if>
	  </td>
	</tr>
      </table>
    </div>