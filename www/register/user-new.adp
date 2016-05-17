  <master>
    <property name="doc(title)">#acs-subsite.Register#</property>
    <property name="context">{#acs-subsite.Register#}</property>
    <property name="focus">register.email</property>
    
    <div class="container">
    @menu;noquote@
    <br>
      <center><img height="100px" width="auto" src="@logo;noquote@" /></center>
    </br>
      <include src="@user_new_template@" email="@email@" return_url="@return_url;noquote@" />
    </div>