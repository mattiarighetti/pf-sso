ad_page_contract {
    Page for users to register themselves on the site.

    @cvs-id $Id: user-new.tcl,v 1.22 2007/05/06 06:58:40 maltes Exp $
} {
    {email ""}
    {return_url "http://sso.professionefinanza.com/"}
}
set page_title "Registrati ai portali PF"
set context [list $page_title]
ad_form -name register \
    -mode edit \
    -export {return_url} \
    -has_edit 1 \
    -has_submit 0 \
    -form {
	user_id:key
	{nome:text
	    {label "Nome"}
	}
	{cognome:text
	    {label "Cognome"}
	}
	{email:text
	    {label "Email"}
	}
	{password:text(password)
	    {label "Password"}
	}
	{password_confirm:text(password)
	    {label "Conferma password"}
	}
	{societa_man:text
	    {label "Società"}
	}
	{indirizzo:text,optional 
	    {label "Indirizzo"}
	}
	{provincia_id:search
	    {label "Provincia"}
	    {search_query "select denominazione, provincia_id from province where lower(denominazione)||provincia_id like '%'||lower(:value)||'%'"}
	    {result_datatype integer}
	}
    } -validate {
	{password
	    { [string length $password] > 5 }
	    {La password è troppo corta.}
	}
	{password_confirm
	    { $password eq $password_confirm }
	    {Le password non coincidono.}
	}
	{email 
	    { ![db_0or1row query "select * from parties where lower(email) like '%'||lower(:email)||'%'"] }
	    {Questa email è gia collegata ad un account.}
	}
    } -new_data {
	set nome [string totitle $nome]
	set cognome [string totitle $cognome]
	set user_id [db_string query "select max(user_id) + trunc(random() * 99 +1) from users"]	 
	#set creation_status [auth::create_user -username $email 
	set creation_status [auth::create_local_account_helper \
				 -user_id $user_id \
				 -email $email \
				 -first_names $nome \
				 -last_name $cognome \
				 -screen_name $email \
				 -password $password ]
	#      -password_confirm $password_confirm]
        #if {[lindex $creation_status 3] ne "ok"} {
        #    ns_log notice pippa creation_status $creation_status cs_18 [lindex $creation_status 5]
        #    ad_script_abort
        #}
	if {$creation_status eq 0} {
	    ns_log notice 321 $creation_status
	    ad_script_abort
	}
        #set user_id [lindex $creation_status 17]
	#auth::registration::Register -authority_id 3669 \
	    #   -username $email \
	    #  -user_id $user_id \
	    # -email $email \
	    #-first_names $nome \
	    #   -last_name $cognome \
	  #  -screen_name $email \
	   # -password $password
	if {![db_0or1row query "select * from crm_contatti where lower(valore) like '%'||lower(:email)||'%' limit 1"]} {
	    set persona_id [db_string query "select max(persona_id) + trunc(random() *99 + 1) from crm_persone"]
	    db_dml query "insert into crm_persone (persona_id, user_id, nome, cognome, societa_man) values (:persona_id, :user_id, :nome, :cognome, :societa_man)"
	    set contatto_id [db_string query "select max(contatto_id) + trunc(random() *99 + 1) from crm_contatti"]
	    db_dml query "insert into crm_contatti (contatto_id, tipo_id, persona_id, valore, preferito) values (:contatto_id, 6, :persona_id, :email, true)" 
	} else {
	    set persona_id [db_string query "select persona_id from crm_contatti where lower(email) like '%'||:email||'%' limit 1"]
	    db_dml query "update crm_contatti set user_id = :user_id where persona_id = :persona_id"
	}
	set indirizzo_id [db_string query "select max(indirizzo_id) + trunc(random() *99 + 1) from crm_indirizzi"]
	db_dml query "insert into crm_indirizzi (indirizzo_id, via, provincia_id, persona_id, tipo_id) values (:indirizzo_id, :indirizzo, :provincia_id, :persona_id, 2)"
    } -after_submit {
	ad_user_login -forever $user_id
	set body {
	    
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>[SUBJECT]</title>
  <style type="text/css">
    body {
	padding-top: 0 !important;
	padding-bottom: 0 !important;
	padding-top: 0 !important;
	padding-bottom: 0 !important;
	margin:0 !important;
	width: 100% !important;
	-webkit-text-size-adjust: 100% !important;
	-ms-text-size-adjust: 100% !important;
	-webkit-font-smoothing: antialiased !important;
    }
    .tableContent img {
	border: 0 !important;
	display: block !important;
	outline: none !important;
    }
    a{
	color:#382F2E;
    }

    p, h1{
	color:#382F2E;
	margin:0;
    }

    div,p,ul,h1{
	margin:0;
    }
    p{
	font-size:13px;
	color:#99A1A6;
	line-height:19px;
    }
    h2,h1{
	color:#444444;
	font-weight:normal;
	font-size: 22px;
	margin:0;
    }
    a.link2{
	padding:15px;
	font-size:13px;
	text-decoration:none;
	background:#2D94DF;
	color:#ffffff;
	border-radius:6px;
	-moz-border-radius:6px;
	-webkit-border-radius:6px;
    }
    .bgBody{
	background: #f6f6f6;
    }
    .bgItem{
	background: #2C94E0;
    }


</style>



</head>
    <body paddingwidth="0" paddingheight="0" bgcolor="#d1d3d4" style="padding-top: 0; padding-bottom: 0; padding-top: 0; padding-bottom: 0; background-repeat: repeat; width: 100% !important; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; -webkit-font-smoothing: antialiased;" offset="0" toppadding="0" leftpadding="0">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tableContent bgBody" align="center" style="font-family:Helvetica, Arial,serif;">

    <!-- =============================== Header ====================================== -->

    <tr>
      <td>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
          <tr>
            <td class="movableContentContainer">


              <div class="movableContent">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                   <tr><td height="25" colspan="3"></td></tr>

                    <tr>
                      <td valign="top" colspan="3">
                        <table width="600" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                          <tr>
                            <td align="left" valign="middle">
                              <div class="contentEditableContainer contentImageEditable">
                                <div class="contentEditable"><center><img src="https://gallery.mailchimp.com/3b436c6ce3392b2a4d195a80d/images/2555aba7-5114-4003-bce4-2d3b7fb58275.png" alt="Compagnie logo" data-default="placeholder" data-max-width="300" width="274" height="91"></center>
                                </div>
                              </div>
                            </td>

                           
                          </tr>
                        </table>
                      </td>
                    </tr>
                </table>
              </div>
              
              <div class="movableContent">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top"><tr><td>
              <table width="600" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr><td height="50">&nbsp;</td></tr>
               
                
              </table>
              </td></tr></table>
          </div>



          
          



              
           
          
                <!--icone 2--><!--fine icone2-->
           
<!--icone--><!--fine icone-->
           <!---azzurro-->
              <div class="movableContent">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top"><tr><td>
                <table width="600" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="27567E" valign="top">
                  <tr><td colspan="3" height="15"></td></tr>
                  <tr>
                    <td width="50"></td>
                    <td width="500">
                      <table width="549" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                        <tr>
                          <td align="center">
                            <div class="contentEditableContainer contentTextEditable">
                              <div class="contentEditable">
    <h1 style="font-size:22px; color:#FFF">Grazie per esserti registrato su ProfessioneFinanza!</h1>
                              </div>
                            </div>
                          </td>
                        </tr>
                       
                        <tr>
                          <td align="center">
                            
                        </td>
                      </tr>
                    </table>
                  </td>
                  <td width="50"></td>
                </tr>
                <tr><td colspan="3" height="15"></td></tr>
              </table>
              </td></tr></table>
            </div>

<!--fine azzurro-->
     
           <div class="movableContent">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top"><tr><td>
              <table width="600" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr><td height="30">&nbsp;</td></tr>
                <tr><td style="border-bottom:1px solid #DDDDDD"></td></tr>
    <tr><td height="10">&nbsp;</td></tr>
              </table>
              </td></tr></table>
          </div>
           
           <div class="movableContent">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top"><tr><td>
                <table width="600" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                  <tr><td colspan="3" height="25"></td></tr>
                  <tr>
                    <td width="50"></td>
                    <td width="500">
                      <table width="500" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                        <tr>
                          <td align="center">
                            <div class="contentEditableContainer contentTextEditable">
                              <div class="contentEditable">
    <h1 style="font-size:17px; color:#ffff"><strong>Ecco i dati per loggarti su <a href="http://pfexpo.professionefinanza.com/">pfexpo.professionefinanza.com</a>:</strong></h1>
    <h1 style="font-size:12px; color:#ffff">&nbsp;</h1>
    <h1 style="font-size:12px; color:#ffff"><strong>Email    :</strong>
}
append body $email 
	append body { </h1>
	    <h1 style="font-size:12px; color:#ffff"><strong>Password::</strong>}
append body $password 
	append body { </h1>
    <h1 style="font-size:12px; color:#ffff">&nbsp;</h1>
    <h1 style="font-size:12px; color:#ffff">&nbsp;</h1>
                              </div>
                            </div></td>
                        </tr>
                        
                      
                    </table>
                    
                    
                       <div class="movableContent">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top"><tr><td>
              <table width="600" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr><td height="10">&nbsp;</td></tr>
                <tr><td style="border-bottom:1px solid #DDDDDD"></td></tr>
    <tr><td height="30">&nbsp;</td></tr>
              </table>
              </td></tr></table>
          </div>
          
          
                    <div class="movableContent">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top"><tr><td>
                <table width="600" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                  <tr><td colspan="3" height="15"></td></tr>
                  <tr>
                    <td width="50"></td>
                    <td width="500">
                      <table width="549" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                        <tr>
                          <td align="center">
                            <div class="contentEditableContainer contentTextEditable">
                              <div class="contentEditable">
    <h1 style="font-size:36px; color:#F93">23 SETTEMBRE 2015
                                - <strong>ROMA </strong></h1>
    <h1 style="font-size:16px; color:#999">CENTRO CONGRESSI FONTANA DI TREVI</h1>
                              </div>
                            </div>
                          </td>
                        </tr>
                        <tr><td height="10"></td></tr>
                        <tr>
                          <td align="center">
                            <div class="contentEditableContainer contentTextEditable">
                             <div class="contentEditable">
    <h1 style="font-size:32px; color: #27567E;"><strong>Ti aspettiamo!</strong>
                                </h1>
                            </div>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </td>
                  <td width="50"></td>
                </tr>
                <tr><td colspan="3" height="5"></td></tr>
              </table>
              </td></tr></table>
            </div>
            
            
                  </td>
                  <td width="50"></td>
                </tr>
                <tr><td colspan="3" height="15"></td></tr>
              </table>
              </td></tr></table>
            </div>
    <p>&nbsp;</p>
           <div class="movableContent">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                  <tr>
                    <td>
                      <table width="600" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                        <tr>
                          <td>
                            <table width="600" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">

                              <tr>
                                <td>
                                  <table width="600" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr><td height="10">&nbsp;</td></tr>
                                    <tr><td style="border-bottom:1px solid #DDDDDD"></td></tr>
    <tr><td height="10">&nbsp;</td></tr>
                                  </table>
                                </td>
                              </tr>

    <tr><td height="18">&nbsp;</td></tr>

                              <tr>
                                <td valign="top" align="center">
                                
                                 <div class="contentEditableContainer contentImageEditable">
                                      <div class="contentEditable">
                                        <img src="https://gallery.mailchimp.com/3b436c6ce3392b2a4d195a80d/images/94a0736b-c52c-48c1-a39b-3f5c5cbdc8ab.png">
                                      </div>
                                  </div>
                                    
                                    
                                  
                                </td>
                              </tr>

    <tr><td height="28">&nbsp;</td></tr>
                              
                              <tr>
                                <td valign="top" align="center">
                                 
                                </td>
                              </tr>

    <tr><td height="28">&nbsp;</td></tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </div>


         </td>
       </tr>
    </table>
  </td>
</tr>




</table>

<!--Default Zone

      <div class="customZone" data-type="image">
          <div class="movableContent">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center"><tr><td>
            <table width="560" border="0" cellspacing="0" cellpadding="0" align="center">
              <tr>
    <td height='42'>&nbsp;</td>
              </tr>
              <tr>
                <td>
                  <div class="contentEditableContainer contentImageEditable">
                      <div class="contentEditable">
                          <img src="/applications/Mail_Interface/3_3/modules/User_Interface/core/v31_campaigns/images/neweditor/default/temp_img_1.png" data-default="placeholder" data-max-width="540">
                      </div>
                  </div>
                </td>
              </tr>
            </table>
            </td></tr></table>
          </div>
      </div>
      
      <div class="customZone" data-type="text">
          <div class='movableContent'>
          <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center"><tr><td>
                          <table width="560" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr><td height='10'>&nbsp;</td></tr>
                            <tr>
                              <td align='left' valign='top'>
                                <div class="contentEditableContainer contentTextEditable">
                        <div class="contentEditable" >
                                <h2>We're going to blow your mind.</h2>
                                </div>
                      </div>
                              </td>
                            </tr>
    <tr><td height='15'>&nbsp;</td></tr>
                            <tr>
                              <td align='left' valign='top'>
                                <div class="contentEditableContainer contentTextEditable">
                        <div class="contentEditable" >
                                <p >Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.
                                <br><br>
                                Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</p>
                                </div>
                      </div>
                              </td>
                            </tr>
    <tr><td height='25'>&nbsp;</td></tr>
                            <tr>
                              <td align='right' valign='top'>
                                <div class="contentEditableContainer contentTextEditable">
                        <div class="contentEditable" >
    <a target='_blank' href="#" class='link2' style='color:#ffffff;'>Read more →</a>
                                </div>
                      </div>
                              </td>
                            </tr>
                          </table>
                          </td></tr></table>
                    </div>
      </div>
      
      <div class="customZone" data-type="imageText">
          <div class='movableContent'>
          <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center"><tr><td>
                      <table width="560" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr><td height='10'>&nbsp;</td></tr>
                        <tr>
                          <td valign='top'>
                            <div class="contentEditableContainer contentImageEditable">
                              <div class="contentEditable" >
                                <img src="images/macCat.jpg" alt='product image' data-default="placeholder" data-max-width="255" width='255' height='154'>
                              </div>
                            </div>
                          </td>

                          <td valign='top'>
                            <div class="contentEditableContainer contentTextEditable">
                              <div class="contentEditable" >
                                <table width="255" border="0" cellspacing="0" cellpadding="0" align="center">
                                  <tr>
                                    <td valign='top'>
                                      <div class="contentEditableContainer contentTextEditable">
                              <div class="contentEditable" >
                                      <h2>Chresmographion</h2>
                                      </div>
                            </div>
                                    </td>
                                  </tr>

                                  <tr><td height='12'></td></tr>

                                  <tr>
    <td valign='top' style='padding-right:30px;'>
                                      <div class="contentEditableContainer contentTextEditable">
                              <div class="contentEditable" >
                                      <p >Chamber between the pronaos and the cella in Greek temples where oracles were delivered.</p>
                                      </div>
                            </div>
                                    </td>
                                  </tr>

                                  <tr><td height='25'></td></tr>

                                  <tr>
    <td valign='top' style='padding-bottom:15px;'>
                                      <div class="contentEditableContainer contentTextEditable">
                              <div class="contentEditable" >
    <a target='_blank' href="#" class='link2' style='color:#ffffff;'>Find out more →</a>
                                      </div>
                            </div>
                                    </td>
                                  </tr>
                                </table>
                          </td>
                        </tr>
                      </table>
                      </td></tr></table>
                    </div>
      </div>
      
      <div class="customZone" data-type="Textimage">
          <div class='movableContent'>
          <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center"><tr><td>
                      <table width="560" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr><td height='10'>&nbsp;</td></tr>
                        <tr>
                          <td valign='top'>
                                <table width="255" border="0" cellspacing="0" cellpadding="0" align="center">
                                  <tr>
                                    <td valign='top'>
                                      <div class="contentEditableContainer contentTextEditable">
                              <div class="contentEditable" >
                                      <h2>Chresmographion</h2>
                                      </div>
                            </div>
                                    </td>
                                  </tr>

                                  <tr><td height='12'></td></tr>

                                  <tr>
    <td valign='top' style='padding-right:30px;'>
                                      <div class="contentEditableContainer contentTextEditable">
                              <div class="contentEditable" >
                                      <p >Chamber between the pronaos and the cella in Greek temples where oracles were delivered.</p>
                                      </div>
                            </div>
                                    </td>
                                  </tr>

                                  <tr><td height='25'></td></tr>

                                  <tr>
    <td valign='top' style='padding-bottom:15px;'>
                                      <div class="contentEditableContainer contentTextEditable">
                              <div class="contentEditable" >
    <a target='_blank' href="#" class='link2' style='color:#ffffff;'>Find out more →</a>
                                      </div>
                            </div>
                                    </td>
                                  </tr>
                                </table>
                          </td>

                          <td valign='top'>
                            <div class="contentEditableContainer contentImageEditable">
                              <div class="contentEditable" >
                                <img src="images/macCat.jpg" alt='product image' data-default="placeholder" data-max-width="255" width='255' height='154'>
                              </div>
                            </div>
                          </td>
                        </tr>
                      </table>
                      </td></tr></table>
                    </div>
      </div>

      <div class="customZone" data-type="textText">
          <div class='movableContent'>
          <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center"><tr><td>
                      <table width="560" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr><td height='10'>&nbsp;</td></tr>
                        <tr>
                          <td valign='top'>
                                <table width="255" border="0" cellspacing="0" cellpadding="0" align="center">
                                  <tr>
                                    <td valign='top'>
                                       <div class="contentEditableContainer contentTextEditable">
                              <div class="contentEditable" >
                                      <h2>Barrel Vault</h2>
                                      </div>
                            </div>
                                    </td>
                                  </tr>

                                  <tr><td height='12'></td></tr>

                                  <tr>
    <td valign='top' style='padding-right:30px;'>
                                       <div class="contentEditableContainer contentTextEditable">
                              <div class="contentEditable" >
                                      <p >An architectural element formed by the extrusion of a single curve (or pair of curves, in the case of a pointed barrel vault) along a given distance.</p>
                                      </div>
                            </div>
                                    </td>
                                  </tr>

                                  <tr><td height='25'></td></tr>

                                  <tr>
    <td valign='top' style='padding-bottom:15px;'>
                                       <div class="contentEditableContainer contentTextEditable">
                              <div class="contentEditable" >
    <a target='_blank' href="#" class='link2' style='color:#ffffff;'>Find out more →</a>
                                      </div>
                            </div>
                                    </td>
                                  </tr>
                                </table>
                          </td>

                          <td valign='top'>
                                <table width="255" border="0" cellspacing="0" cellpadding="0" align="center">
                                  <tr>
                                    <td valign='top'>
                                      <div class="contentEditableContainer contentTextEditable">
                              <div class="contentEditable" >
                                      <h2>Chresmographion</h2>
                                      </div>
                            </div>
                                    </td>
                                  </tr>

                                  <tr><td height='12'></td></tr>

                                  <tr>
    <td valign='top' style='padding-right:30px;'>
                                      <div class="contentEditableContainer contentTextEditable">
                              <div class="contentEditable" >
                                      <p >Chamber between the pronaos and the cella in Greek temples where oracles were delivered.</p>
                                      </div>
                            </div>
                                    </td>
                                  </tr>

                                  <tr><td height='25'></td></tr>

                                  <tr>
    <td valign='top' style='padding-bottom:15px;'>
                                      <div class="contentEditableContainer contentTextEditable">
                              <div class="contentEditable" >
    <a target='_blank' href="#" class='link2' style='color:#ffffff;'>Find out more →</a>
                                      </div>
                            </div>
                                    </td>
                                  </tr>
                                </table>
                          </td>
                        </tr>
                      </table>
                      </td></tr></table>
                    </div>
      </div>

      <div class="customZone" data-type="qrcode">
          <div class="movableContent">
          <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center"><tr><td>
    <table width='560' cellpadding="0" cellspacing="0" border="0" align="center" style="margin-top:10px;">
                    <tr>
    <td height='42'>&nbsp;</td>
    <td height='42'>&nbsp;</td>
              </tr>
                      <tr>
    <td valign='top' valign="top" width="75" style='padding:0 20px;'>
                              <div class="contentQrcodeEditable contentEditableContainer">
                                  <div class="contentEditable">
                                      <img src="/applications/Mail_Interface/3_3/modules/User_Interface/core/v31_campaigns/images/neweditor/default/qr_code.png" width="75" height="75">
                                  </div>
                              </div>
                          </td>
    <td valign='top' valign="top" style="padding:0 20px 0 20px;">
                              <div class="contentTextEditable contentEditableContainer">
                                  <div class="contentEditable">
    <br>
                                      <br>
                                  </div>
                              </div>
                          </td>
                      </tr>
                  </table>
              </td></tr></table>
          </div>
      </div>
      
      <div class="customZone" data-type="gmap">
          <div class="movableContent">
          <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center"><tr><td>

    <table cellpadding="0" width='560' cellspacing="0" border="0" align="center" style="margin-top:10px;">
                    <tr>
    <td height='42'>&nbsp;</td>
    <td height='42'>&nbsp;</td>
              </tr>
                      <tr>
    <td valign='top' style='padding:0 20px;'>
                              <div class="contentEditableContainer contentGmapEditable">
                                  <div class="contentEditable">
                                      <img src="/applications/Mail_Interface/3_3/modules/User_Interface/core/v31_campaigns/images/neweditor/default/gmap_example.png" width="175" data-default="placeholder">
                                  </div>
                              </div>
                          </td>
    <td valign='top' style="padding:0 20px 0 20px;">
                              <div class="contentEditableContainer contentTextEditable">
                                  <div class="contentEditable">
                                      <h2>This is a subtitle</h2>
                                      <p >Etiam bibendum nunc in lacus bibendum porta. Vestibulum nec nulla et eros ornare condimentum. Proin facilisis, dui in mollis blandit. Sed non dui magna, quis tincidunt enim. Morbi vehicula pharetra lacinia. Cras tincidunt, justo at fermentum feugiat, eros orci accumsan dolor, eu ultricies eros dolor quis sapien.</p>
                                      <p >Integer in elit in tortor posuere molestie non a velit. Pellentesque consectetur, nisi a euismod scelerisque.</p>
    <p style='text-align:right;margin:0;'><a target='_blank' href="#" class='link2' style='color:#ffffff;'>Read more →</a></p>
                                      <br>
                                      <br>
                                  </div>
                              </div>
                          </td>
                      </tr>
                  </table>
              </td></tr></table>
          </div>
      </div>

      <div class="customZone" data-type="social">
          <div class="movableContent">
          <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center"><tr><td>
                  <table width='560' cellpadding="0" cellspacing="0" border="0" align="center">
                    <tr>
    <td height='42' colspan='4'>&nbsp;</td>
              </tr>
                      <tr>
    <td valign='top' colspan="4" style='padding:0 20px;'>
                              <div class="contentTextEditable contentEditableContainer">
                                  <div class="contentEditable">
                                      <h2 >This is a subtitle</h2>
                                  </div>
                              </div>
                          </td>
                      </tr>
                      <tr>
    <td width='62' valign='top' valign="top" width="62" style='padding:0 0 0 20px;'>
                              <div class="contentEditableContainer contentTwitterEditable">
                                  <div class="contentEditable">
                                      <img src="/applications/Mail_Interface/3_3/modules/User_Interface/core/v31_campaigns/images/neweditor/default/icon_twitter.png" width="42" height="42" data-customIcon="true" data-max-width='42' data-noText="false">
                                  </div>
                              </div>
                          </td>
                          <td width='216' valign='top' >
                              <div class="contentEditableContainer contentTextEditable">
                                  <div class="contentEditable">
                                      <p >Follow us on twitter to stay up to date with company news and other information.</p>
                                  </div>
                              </div>
                          </td>
                          <td width='62' valign='top' valign="top" width="62">
                              <div class="contentEditableContainer contentFacebookEditable">
                                  <div class="contentEditable">
                                      <img src="/applications/Mail_Interface/3_3/modules/User_Interface/core/v31_campaigns/images/neweditor/default/icon_facebook.png" width="42" height="42" data-customIcon="true" data-max-width='42' data-noText="false">
                                  </div>
                              </div>
                          </td>
    <td width='216' valign='top' style='padding:0 20px 0 0;'>
                              <div class="contentEditableContainer contentTextEditable">
                                  <div class="contentEditable">
                                      <p >Like us on Facebook to keep up with our news, updates and other discussions.</p>
                                  </div>
                              </div>
                          </td>
                      </tr>
                  </table>
              </td></tr></table>
          </div>
      </div>

      <div class="customZone" data-type="twitter">
          <div class="movableContent">
          <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center"><tr><td>
                  <table width='560' cellpadding="0" cellspacing="0" border="0" align="center">
                    <tr>
    <td height='42'>&nbsp;</td>
    <td height='42'>&nbsp;</td>
              </tr>
                      <tr>
    <td valign='top' valign="top" width="62" style='padding:0 0 0 20px;'>
                              <div class="contentEditableContainer contentTwitterEditable">
                                  <div class="contentEditable">
                                      <img src="/applications/Mail_Interface/3_3/modules/User_Interface/core/v31_campaigns/images/neweditor/default/icon_twitter.png" width="42" height="42" data-customIcon="true" data-max-width='42' data-noText="false">
                                  </div>
                              </div>
                          </td>
    <td valign='top' style='padding:0 20px 0 0;'>
                              <div class="contentEditableContainer contentTextEditable">
                                  <div class="contentEditable">
                                      <p >Follow us on twitter to stay up to date with company news and other information.</p>
                                  </div>
                              </div>
                          </td>
                      </tr>
                  </table>
              </td></tr></table>
          </div>
      </div>
      
      <div class="customZone" data-type="facebook">
          <div class="movableContent">
          <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center"><tr><td>
                  <table width='560' cellpadding="0" cellspacing="0" border="0" align="center">
                    <tr>
    <td height='42'>&nbsp;</td>
    <td height='42'>&nbsp;</td>
              </tr>
                      <tr>
    <td valign='top' valign="top" width="62" style='padding:0 0 0 20px;'>
                              <div class="contentEditableContainer contentFacebookEditable">
                                  <div class="contentEditable">
                                      <img src="/applications/Mail_Interface/3_3/modules/User_Interface/core/v31_campaigns/images/neweditor/default/icon_facebook.png" width="42" height="42" data-customIcon="true" data-max-width='42' data-noText="false">
                                  </div>
                              </div>
                          </td>
    <td valign='top' style='padding:0 20px 0 0;'>
                              <div class="contentEditableContainer contentTextEditable">
                                  <div class="contentEditable">
                                      <p>Like us on Facebook to keep up with our news, updates and other discussions.</p>
                                  </div>
                              </div>
                          </td>
                      </tr>
                  </table>
              </td></tr></table>
          </div>
      </div>

      <div class="customZone" data-type="line">
          <div class='movableContent'>
          <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center"><tr><td>
              <table width="600" border="0" cellspacing="0" cellpadding="0" align="center" >
                <tr><td height='10'>&nbsp;</td></tr>
                <tr><td style='border-bottom:1px solid #DDDDDD'></td></tr>
                <tr><td height='10'>&nbsp;</td></tr>
              </table>
              </td></tr></table>
            </div>
      </div>

      
      <div class="customZone" data-type="colums1v2"><div class='movableContent'>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center"><tr><td>
                          <table width="600" border="0" cellspacing="0" cellpadding="0" align="center" >
                            <tr><td height="10">&nbsp;</td></tr>
                            <tr>
                              <td align="left" valign="top">
                                <table width='100%'  border="0" cellspacing="0" cellpadding="0" align="center" valign='top'  >
                                  <tr><td colspan='3' height='25'>&nbsp;</td></tr>
                                  <tr>
                                    <td width='25'>&nbsp;</td>
                                    <td class="newcontent">
                                  
                                    </td>
                                    <td width='25'>&nbsp;</td>
                                  </tr>
                                  <tr><td colspan='3' height='25'>&nbsp;</td></tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                          </td></tr></table>
                    </div>
      </div>

      <div class="customZone" data-type="colums2v2"><div class='movableContent'>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center"><tr><td>
                      <table width="600" border="0" cellspacing="0" cellpadding="0" align="center" valign='top'>
                        <tr><td height="10" colspan='3'>&nbsp;</td></tr>
                        <tr>
                          <td width='295'  valign='top' >
                            <table width='100%' border="0" cellspacing="0" cellpadding="0" align="center" valign='top'  >
                              <tr><td colspan='3' height='25'>&nbsp;</td></tr>
                              <tr>
                                <td width='25'>&nbsp;</td>
                                <td class="newcontent">
                              
                                </td>
                                <td width='25'>&nbsp;</td>
                              </tr>
                              <tr><td colspan='3' height='25'>&nbsp;</td></tr>
                            </table>
                          </td>

                          <td width='10'>&nbsp;</td>
                          
                          <td width='295' valign='top' >
                            <table width='100%' border="0" cellspacing="0" cellpadding="0" align="center" valign='top'  >
                              <tr><td colspan='3' height='25'>&nbsp;</td></tr>
                              <tr>
                                <td width='25'>&nbsp;</td>
                                <td class="newcontent">
                              
                                </td>
                                <td width='25'>&nbsp;</td>
                              </tr>
                              <tr><td colspan='3' height='25'>&nbsp;</td></tr>
                            </table>
                          </td>
                        </tr>
                        
                      </table>
                      </td></tr></table>
                    </div>
      </div>

      <div class="customZone" data-type="colums3v2"><div class='movableContent'>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center"><tr><td>
                      <table width="600" border="0" cellspacing="0" cellpadding="0" align="center" valign='top'>
                        <tr><td height="10" colspan='5'>&nbsp;</td></tr>
                        <tr>
                          <td width='194'  valign='top' >
                            <table width='100%' border="0" cellspacing="0" cellpadding="0" align="center" valign='top'  >
                              <tr><td colspan='3' height='25'>&nbsp;</td></tr>
                              <tr>
                                <td width='25'>&nbsp;</td>
                                <td class="newcontent">
                              
                                </td>
                                <td width='25'>&nbsp;</td>
                              </tr>
                              <tr><td colspan='3' height='25'>&nbsp;</td></tr>
                            </table>
                          </td>

                          <td width='9'>&nbsp;</td>
                          
                          <td width='194'  valign='top' >
                            <table width='100%' border="0" cellspacing="0" cellpadding="0" align="center" valign='top'  >
                              <tr><td colspan='3' height='25'>&nbsp;</td></tr>
                              <tr>
                                <td width='25'>&nbsp;</td>
                                <td class="newcontent">
                              
                                </td>
                                <td width='25'>&nbsp;</td>
                              </tr>
                              <tr><td colspan='3' height='25'>&nbsp;</td></tr>
                            </table>
                          </td>

                          <td width='9'>&nbsp;</td>
                          
                          <td width='194'  valign='top' >
                            <table width='100%' border="0" cellspacing="0" cellpadding="0" align="center" valign='top'  >
                              <tr><td colspan='3' height='25'>&nbsp;</td></tr>
                              <tr>
                                <td width='25'>&nbsp;</td>
                                <td class="newcontent">
                              
                                </td>
                                <td width='25'>&nbsp;</td>
                              </tr>
                              <tr><td colspan='3' height='25'>&nbsp;</td></tr>
                            </table>
                          </td>
                        </tr>
                        
                      </table>
                      </td></tr></table>
                    </div>
      </div>

      <div class="customZone" data-type="textv2">
        <table border="0" cellspacing="0" cellpadding="0" align="center">
                            <tr><td height='10'>&nbsp;</td></tr>
                            <tr>
                              <td align='left' valign='top'>
                                <div class="contentEditableContainer contentTextEditable">
                        <div class="contentEditable" >
                                <h2>We're going to blow your mind.</h2>
                                </div>
                      </div>
                              </td>
                            </tr>
                            <tr><td height='15'>&nbsp;</td></tr>
                            <tr>
                              <td align='left' valign='top'>
                                <div class="contentEditableContainer contentTextEditable">
                        <div class="contentEditable" >
                                <p >Lorem Ipsum is simply dummy text of the printing and typesetting industry. </p>
                                </div>
                      </div>
                              </td>
                            </tr>
                            <tr><td height='25'>&nbsp;</td></tr>
                            <tr>
                              <td align='right' valign='top'>
                                <div class="contentEditableContainer contentTextEditable">
                        <div class="contentEditable" >
                                <a target='_blank' href="#" class='link2' style='color:#ffffff;'>Read more →</a>
                                </div>
                      </div>
                              </td>
                            </tr>
                          </table>
      </div>



    -->
    <!--Default Zone End-->
<style type="text/css">
                    @media only screen and (max-width: 480px){
                        table[id="canspamBar"] td{font-size:14px !important;}
                        table[id="canspamBar"] td a{display:block !important; margin-top:10px !important;}
                    }
                </style>
            </center>
</body>
  </html>
	}
	acs_mail_lite::send -send_immediately \
	    -to_addr $email \
	    -from_addr "registrazione@professionefinanza.com" \
	    -subject "Riepilgo dati di accesso - ProfessioneFinanza" \
	    -body $body \
	    -mime_type "text/html"
	ad_returnredirect \
	    -allow_complete_url \
	    $return_url
    }
