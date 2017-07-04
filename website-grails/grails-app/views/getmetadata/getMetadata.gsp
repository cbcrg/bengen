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


  <g:form name="form" controller="getmetadata"  method="post" enctype="multipart/form-data" >
  <br>
  <h3>Insert the name of what you want to include</h3>
  <h5>Don't forget to put the version!!</h5>
	<h6>The format MUST BE "Projectname/nameofmethod-version" and the version mus have the format "number.number"</h6>
  <br>
  <div class="text-field" id="labelinput"><g:textField name="name" pattern=".*/.*-v\\d*.\\d*" placeholder="bengen/tcoffee-v1.0" /></div>
  <div class="row">
    <center>
        <div class="submit"><g:actionSubmit   action="first" value="Next" /></div>
    </center>
  </div>



  ${name}

<br>


</g:form>
</center>










</body>
</html>
