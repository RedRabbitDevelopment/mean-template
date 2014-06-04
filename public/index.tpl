<!doctype html>
<html lang="en" ng-app="meanTemplate" ng-controller="Base">
	<head>
		<meta charset="UTF-8" />
		<meta name="viewport" content="width=1240 initial-scale=1">
		<link rel="stylesheet" type="text/css" href="/components/app.css" />
		<title ng-bind="pageTitle"></title>
	</head>
	<body>
    <header>
    </header>
      
    <!-- Feedback module -->
    <div class="feedback">
      <a href>Submit Feedback</a>
    </div>
      
    <div class="container">
      <div  ng-hide="auth.loading">
        <div ui-view></div>
      </div>
    </div>
              
    <!-- Footer -->
    <footer class="site-footer">
      <ul class="list-unstyled list-inline centered">
        <li><a href="/#/about">About</a></li>
        <li><a href="/#/privacy">Privacy</a></li>
        <li><a href="/#/terms">Terms</a></li>
        <li><a href="/#/help">Help</a></li>
        <li class="txt-primary">&copy; 2014 ExampleProject</li>
      </ul>
    </footer>
      
    <% if(environment === 'production') { %>

      <!-- Template content -->
      <% /* templates.forEach(function(tpl) { %>
        <script id="<%- tpl.name %>" type="text/ng-template">
          <%= tpl.content %>
        </script>
      <% });*/ %>

      <!-- Assets -->
      <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js" type="text/javascript"></script>
      <script src="//ajax.googleapis.com/ajax/libs/angularjs/1.2.16/angular.min.js" type="text/javascript"></script>
      <script src="/js/app.min.js" type="text/javascript"></script>

      <!-- Google Analytics -->

      <script type="text/javascript">
        (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
        (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
        m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
        })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

        ga('create', 'xxxx', 'xxxxx');
      </script>

    <% } else { %>

      <!-- inject:js -->
      <!-- endinject -->
    <% } %>
	</body>
</html>
