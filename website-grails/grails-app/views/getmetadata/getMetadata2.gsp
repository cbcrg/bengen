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


	<div id="decisiontree">
	<br>
	<h1 class="tree"></h1>
	<br><br>

	<div id="choices" ></div>
	<br><br>

	<button id="back">Back</button>

	<g:form name="jftForm" controller="Getmetadata" action="collect">
	    <g:hiddenField name="ret"/>
	    <g:submitButton name="submit" value="Submit" id='hideshow' style="display: none;"/>
	</g:form>

</center>


</div>


</body>
</html>
