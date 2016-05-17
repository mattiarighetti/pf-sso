<!DOCTYPE html>
<html >
  <head>
    <meta charset="UTF-8">
    <title>Accedi a ProfessioneFinanza</title>
    <link href='http://fonts.googleapis.com/css?family=Titillium+Web:400,300,600' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" href="normalize.css">
        <link rel="stylesheet" href="style.css">    
    
  </head>

  <body>
    <center>@logout_msg;noquote@</center>
    <center><br></br>
  <img src="http://images.professionefinanza.com/logos/professionefinanza.png" width="20%">
  </center>

    <div class="form">
      
      <ul class="tab-group">
        <li class="tab active"><a href="#login">Log In</a></li>
        <li class="tab"><a href="#signup">Sign Up</a></li>
	  </ul>
      
      <div class="tab-content">
	
        
        <div id="login">   
          <h1>Accedi al tuo account PF</h1>
          
          <formtemplate id="login">
            <font color="red"><center><br><formerror id="email"></formerror>
	    		<formerror id="password"></formerror></br></center></font>
            <div class="field-wrap">
	      <label>
              Email<span class="req">*</span>
            </label>
              <formwidget id="email">
<!-- <input type="email"required autocomplete="off"/> -->
          </div>
          
          <div class="field-wrap">
            <label>
              Password<span class="req">*</span>
              </label>
	    <formwidget id="password">
            <!-- <input type="password"required autocomplete="off"/> -->
          </div>
          
          <p class="forgot"><a href="#">Hai dimenticato la password?</a></p>
          
          <button class="button button-block"/>Log In</button>
          
          </formtemplate>

        </div>
        <div id="signup">   
          <h1>Registrati ai nostri portali</h1>
          
          <formtemplate id="register">
          
          <div class="top-row">
            <div class="field-wrap">
              <label>
                Nome<span class="req">*</span><formerror id="first_names"></formerror>
		</label>
              <!--    <input type="text" required autocomplete="off" /> -->
	      <formwidget id="first_names">
	    </div>
            
            <div class="field-wrap">
              <label>
                Cognome<span class="req">*</span><formerror id="last_name"></formerror>
		  </label>
	      <formwidget id="last_name">
              <!-- <input type="text"required autocomplete="off"/> -->
            </div>
          </div>

          <div class="field-wrap">
            <label>
              Email<span class="req">*</span><formerror id="email"></formerror>
              </label>
	    <formwidget id="email">
            <!-- <input type="email"required autocomplete="off"/>-->
          </div>
          
          <div class="field-wrap">
            <label>
              Password<span class="req">*</span><formerror id="password"></formerror>
		</label>
	    <formwidget id="password">
              <!-- <input type="password"required autocomplete="off"/>-->
          </div>
          
          <button type="submit" class="button button-block"/>Registrati</button>
          
          </formtemplate>

        </div>
      </div><!-- tab-content -->
      
</div> <!-- /form -->

<script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>

        <script src="index.js"></script>

    
    
    
  </body>
</html>
