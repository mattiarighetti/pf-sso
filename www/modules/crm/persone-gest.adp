  <property name="page_title">@page_title;noquote@</property>
  <property name="context">@context;noquote@</property>
  
  <formtemplate id="persone">
    <fieldset>
      <legend>Informazioni personali</legend>
      <div data-row-span="2">
	<div data-field-span="1" style="height: 59px;">
	  <label>Nome</label>
	  <formwidget id="nome">  
	</div>
	<div data-field-span="1" style="height: 59px;">
	  <label>Cognome</label>
	  <formwidget id="cognome">  
	</div>
      </div>
      <div data-row-span="2"> 
	<div data-field-span="1" style="height: 59px;">
	  <label>Luogo di nascita</label>
	  <input type="text" name="luogo_na" id="luogo_na" list="comuni">
	    @comuni_datalist;noquote@
	</div>
	 <div data-field-span="1" style="height: 59px;">
	  <label>Data di nascita</label>
	  <formwidget id="data_na">
	</div> 
      </div>
    </fieldset>
  </formtemplate>