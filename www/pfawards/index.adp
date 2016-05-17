  <master>
    <property name="page_title">@page_title;noquote@</property>	
    <property name="context">@context;noquote@</property>

    <div class="container-fluid">
      <div class="row">
	<div class="col-sm-3 col-md-2 sidebar">
	  @dash_menu;noquote@
	  </div>
	<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
	  <h1 class="page-header">PFAwards</h1>
	  <a class="btn btn-default" href="http://pfawards.professionefinanza.com/iscriviti" role="button">Iscriviti</a>
	  <h3 class="sub-header">Esami</h3>
	  @exam_table;noquote@
	  <if @questionnaire@ eq 1>
	    <h3 class="sub-header">Questionari <small>(seconda fase)</small></h3>
	    @questionnaire_table;noquote@
					</if>
	  <div class="alert alert-info" role="alert">
	    <b>Per problemi tecnici</b> rivolgersi a <a href="mailto:supporto@professionefinanza.com?subject=Richiesta di assistenza PFAwards&body=Buongiorno, in riferimento all'esame numero ... ">supporto@professionefinanza.com</a>.
  </div>
				    </div>
			  </div>
		  </div>
