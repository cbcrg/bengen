<!doctype html>
<html lang="en" class="no-js">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>

    <title>
        <g:layoutTitle default="BenGen"/>
    </title>


  <asset:link rel="icon" href="icon_BG.png" type="image/x-ico" />
  <asset:stylesheet src="bootstrap.css"/>
	<asset:stylesheet src="layout.css"/>
  <asset:stylesheet src="style.min.css"/>
  <asset:stylesheet src="style.css"/>
	<asset:javascript src="bootstrap.min.js"/>
	<asset:javascript src="jquery-3.2.0.min.js"/>
  <asset:javascript src="jstree.min.js" />


    <g:layoutHead/>
</head>
<body>

<div class="navbar navbar-default navbar-static-top" role="navigation">
        <div class="container">
            <div class="navbar-collapse collapse" aria-expanded="false" style="height: 0.8px;">
                <ul class="nav navbar-nav navbar-right">
			<li><a href="/">Home</a></li>
			<li><g:link controller="tutorial">About</g:link></li>

			<li class="dropdown">
			    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Benchmarks <span class="caret"></span></a>
			    <ul class="dropdown-menu">
				<li><g:link controller="msabenchmark">MSAs</g:link></li>


			    </ul>
			</li>
			<li class="dropdown">
			    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Help <span class="caret"></span></a>
			    <ul class="dropdown-menu">
				<li><g:link controller="extend">Extend</g:link></li>
				<li><g:link controller="getmetadata">Create Metadata</g:link></li>

			    </ul>
			</li>


			<li><g:link controller="contacts">Contacts</g:link></li>



                </ul>

            </div>

        </div>

    </div>
	<a href="https://github.com/cbcrg/bengen"><img style="position: absolute; top: 0; right: 0; border: 0;z-index: 1000; " src="https://camo.githubusercontent.com/38ef81f8aca64bb9a64448d0d70f1308ef5341ab/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f6461726b626c75655f3132313632312e706e67" alt="Fork me on GitHub" data-canonical-src="https://s3.amazonaws.com/github/ribbons/forkme_right_darkblue_121621.png"></a>
    <g:layoutBody/>

    <div class="footer" role="contentinfo"></div>

    <div id="spinner" class="spinner" style="display:none;">
        <g:message code="spinner.alt" default="Loading&hellip;"/>
    </div>

    <asset:javascript src="application.js"/>

</body>
</html>
