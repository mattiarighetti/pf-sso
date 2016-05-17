<master>
  <property name="doc(title)">#acs-subsite.Register#</property>
  <property name="context">{#acs-subsite.Register#}</property>
  <property name="focus">register.nome</property>

  <formtemplate id="register">
		<fieldset>
			<legend>Iscriviti al nuovo portale di ProfessioneFinanza</legend>
			<div data-row-span="4">
				<div data-field-span="2" class="" style="height: 55px;">
					<label>Nome</label>
					<formwidget id="nome">
				</div>
				<div data-field-span="2" style="height: 55px;" class="">
					<label>Cognome</label>
					<formwidget id="cognome">					
				</div>
			</div>
			<div data-row-span="4">
				<div data-field-span="4" style="height: 55px;" class="">
					<formwidget id="email">
				</div>
			</div>
			<div data-row-span="2">
				<div data-field-span="1" style="height: 55px;" class="">
					<formwidget id="password">
				</div>
				<div data-field-span="1" style="height: 55px;" class="">
					<formwidget id="password_confirm">
				</div>
			</div>
			<div data-row-span="8">
				<div data-field-span="5" style="height: 59px;" class="">
					<formwidget id="indirizzo">
				</div>
				<div data-field-span="3" style="height: 59px;" class="">
					<formwidget id="provincia_id">
				</div>
			</div>
		</fieldset>

  </formtemplate>
