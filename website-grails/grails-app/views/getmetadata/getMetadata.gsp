<!DOCTYPE html>
<html>
<head>
<title>BenGen</title>
    <meta name="layout" content="main"/>
</head>

<body>
<div id="header"></div>
<center>
<h1>Get your metadata</h1>

<h4>Name</h4>
<input type="text" name="name" placeholder="bengen/tcoffee">



<h4>Version</h4>
<input type="text" name="version" placeholder="1.0">


<h4>What is it ?</h4>
<form>
  <input type="radio" name="what" value="msa" > Multiple Sequence Aligner<br>
  <input type="radio" name="what" value="sf"> Scoring Function<br>
</form>


<br>



<input type="submit" value="GO" >

<g:form name="form" controller="getmetadata" id="hola">

            <div class="text-field"><label>First Name: </label><g:textField name="firstName" value="${firstName}" /></div>

            <div class="text-field"><label>Last Name: </label><g:textField name="lastName" value="${lastName}" /></div>

            <div class="submit"><g:actionSubmit value="Submit" action="collect"/></div>

        </g:form>


</center>

</body>
</html>
