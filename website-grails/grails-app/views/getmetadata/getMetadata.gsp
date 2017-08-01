<!DOCTYPE html>
<html>
<head>
<title>BenGen</title>
	 <asset:javascript src="dec.tree.js"/>
    <meta name="layout" content="main"/>
</head>

<body>
<div id="header"></div>

<center>

	<h1>Get your Metadata</h1>
	<hr>


	  <g:form name="form" controller="getmetadata"  method="post" enctype="multipart/form-data" >
	  <br><br>

	  <h3 style="color=darkgrey;">Type the name of the component you want to extend BenGen with</h3>
		<h6>The format MUST BE "Projectname/nameofmethod-version"</h6>
		<h6>the version must have the format "number.number".</h6>
		<h6>For example: bengen/tcoffee-v11.00</h6>

	  <br>

		 <div class="col-md-4"></div>
		 <div class="col-md-4" id="steps" title="step1">
			 <div  id="stepMetadata" >
				 <br> <br>

			  <div class="text-field" id="labelinput">
					<g:textField name="name" required="required" pattern=".*/.*-v\\d*.\\{d,\\.}*" placeholder="bengen/tcoffee-v1.0" />
				</div>

			  <div class="row">
			    <center>
			        <div class="submit"><g:actionSubmit   action="first" value="Next" /></div>
			    </center>
				</div>

		  </div>
	  </div>

	  ${name}

	<br>


	</g:form>
</center>

</body>
</html>
