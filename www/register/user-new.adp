  <!DOCTYPE html>
<html dir="ltr" lang="en-US">
<head>

  <meta http-equiv="content-type" content="text/html; charset=utf-8" />
  <meta name="author" content="PF Holding" />

  <!-- Stylesheets
  ============================================= -->
  <link href="http://fonts.googleapis.com/css?family=Lato:300,400,400italic,600,700|Raleway:300,400,500,600,700|Crete+Round:400italic" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" href="http://pfawards.it/css/bootstrap.css" type="text/css" />
  <link rel="stylesheet" href="http://pfawards.it/style.css" type="text/css" />
  <link rel="stylesheet" href="http://pfawards.it/css/dark.css" type="text/css" />
  <link rel="stylesheet" href="http://www13.professionefinanza.com/resources/acs-templating/forms.css" type="text/css">
  <!-- Agency Demo Specific Stylesheet -->
  <link rel="stylesheet" href="http://pfawards.it/demos/agency/agency.css" type="text/css" />
  <!-- / -->

  <link rel="stylesheet" href="http://pfawards.it/css/font-icons.css" type="text/css" />
  <link rel="stylesheet" href="http://pfawards.it/css/animate.css" type="text/css" />
  <link rel="stylesheet" href="http://pfawards.it/css/magnific-popup.css" type="text/css" />

  <link rel="stylesheet" href="http://pfawards.it/css/responsive.css" type="text/css" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <!--[if lt IE 9]>
    <script src="http://css3-mediaqueries-js.googlecode.com/svn/trunk/css3-mediaqueries.js"></script>
  <![endif]-->

  <link rel="stylesheet" href="http://pfawards.it/css/colors.php?color=c0bb62" type="text/css" />

  <!-- Document Title
  ============================================= -->
  <title>Registrazione - PFAwards</title>

</head>

<body class="stretched">

  <!-- Document Wrapper
  ============================================= -->
  <div id="wrapper" class="clearfix">

    <!-- Header
    ============================================= -->
    <header id="header" class="sticky-style-2">

      <div class="container clearfix">

        <!-- Logo
        ============================================= -->
        <div id="logo" class="divcenter">
          <a href="http://www.pfawards.it/" class="standard-logo"><img class="divcenter" src="@logo_url@" alt="Canvas Logo"></a>
          <a href="http://www.pfawards.it/" class="retina-logo"><img class="divcenter" src="@logo_url@" alt="Canvas Logo"></a>
        </div><!-- #logo end -->

      </div>

      <div id="header-wrap">

        <!-- Primary Navigation
        ============================================= -->
        <nav id="primary-menu" class="style-2 center">

          <div class="container clearfix">

            <div id="primary-menu-trigger"><i class="icon-reorder"></i></div>

            <ul>
                  <li><a href="http://pfawards.it"><div>Home</div></a></li>
                  <li><a href="http://pfawards.it/iscriviti"><div>Iscriviti</div></a></li>
                  <li><a href="http://pfawards.it/categorie"><div>Categorie</div></a></li>
                  <li><a href="http://pfawards.it/regolamento"><div>Regolamento</div></a></li>
                  <li><a href="http://pfawards.it/calendario"><div>Calendario</div></a></li>
                  <li><a href="http://pfawards.it/commissione"><div>Commissione</div></a></li>
            </ul>

          </div>

        </nav><!-- #primary-menu end -->

      </div>

    </header><!-- #header end -->

    <!-- Content
    ============================================= -->
    <section id="content">

      <div class="content-wrap">
        <div class="container clearfix">
      <include src="@user_new_template@" email="@email@" return_url="@return_url;noquote@" />
    </div>
      </div>

    </section><!-- #content end -->

    <!-- Footer
    ============================================= -->
    <footer id="footer">

      <!-- Copyrights
      ============================================= -->
      <div id="copyrights">

        <div class="container clearfix">

          <div class="col_half">
            <img class="footer-logo" src="http://images.professionefinanza.com/logos/professionefinanza.png" width="250px"><br>
            <!--<div class="copyright-links"><a href="#">Terms of Use</a> / <a href="#">Privacy Policy</a></div>-->
          </div>

          <div class="col_half col_last tright">
            <div class="fright clearfix">
              <a href="https://www.facebook.com/ProfessioneFinanza" class="social-icon si-small si-light si-rounded si-facebook">
                <i class="icon-facebook"></i>
                <i class="icon-facebook"></i>
              </a>

              <a href="https://twitter.com/PFHolding" class="social-icon si-small si-light si-rounded si-twitter">
                <i class="icon-twitter"></i>
                <i class="icon-twitter"></i>
              </a>

            </div>

            <div class="clear"></div>

          </div>

        </div>

      </div><!-- #copyrights end -->

    </footer><!-- #footer end -->

  </div><!-- #wrapper end -->

  <!-- Go To Top
  ============================================= -->
  <div id="gotoTop" class="icon-angle-up"></div>

  <!-- External JavaScripts
  ============================================= -->
  <script type="text/javascript" src="http://pfawards.it/js/jquery.js"></script>
  <script type="text/javascript" src="http://pfawards.it/js/plugins.js"></script>

  <!-- Footer Scripts
  ============================================= -->
  <script type="text/javascript" src="http://pfawards.it/js/functions.js"></script>

</body>
</html>
