  <property name="focus">@focus;noquote@</property>
  
  <div class="container">
    <table>
      <tr>
	<td>
	  <center>
	  <div id="register-login">
	    <h2 style="text-align:center;">Entra nel mondo PF</h2>
	    <formtemplate id="login">
	      <center>
		<formwidget id="email">&nbsp;
		  <formwidget id="password"><br></br>
		    <formerror id="email"></formerror>
		    <formerror id="password"></formerror>
	      </center>
	      <div class="well well-sm">		  
		<div class="checkbox">
		      <label>
			<formwidget id="persistent_p"></formgroup>
			  #acs-subsite.Remember_my_login#
		      </label>
		    </div>&nbsp;&nbsp;&ensp;&nbsp;&nbsp;&ensp;&nbsp;&nbsp;&emsp;
		    <if @forgotten_pwd_url@ not nil>
		      <if @email_forgotten_password_p@ true>
			<button type="button" class="btn btn-default">
			  <a href="@forgotten_pwd_url@">#acs-subsite.Forgot_your_password#</a>
			</button>
		      </if>
		    </if>
		  </div>
		    <button class="btn btn-lg btn-primary btn-block" type="submit">Login</button>
	    </formtemplate>
	      <if @self_registration@ true>
		<if @register_url@ not nil>
		<br>		
		    <button type="button" class="btn btn-success btn-lg btn-block" onClick="window.location.href='http://sso.professionefinanza.com/register/user-new?return_url=@return_url;noquote@'">
		      #acs-subsite.Register#
		    </button>
		</if>
	      </if>
	    </div>
  </center>
	  </td>
      </tr>
    </table>
  </div>
