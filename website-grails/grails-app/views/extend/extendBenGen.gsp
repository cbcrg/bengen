<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>BenGen</title>


</head>

<body>
<div id="header"></div>
<center>
  <br>
<h1>Extend BenGen</h1>
<h3> ( If you did not create yet your metadata file you can easily do it
  <g:link controller="getmetadata">here</g:link>) </h3>


  <g:if test="${flash.error}">
    <div class="alert alert-error" style="display: block">${flash.error}</div>
  </g:if>
  <g:if test="${flash.message}">
    <div class="message" style="display: block">${flash.message}</div>
</g:if>





<g:form name="form" controller="extend" id="collecting" method="post" enctype="multipart/form-data" >
  <div class="row">
      <div class="steps-wrapper">


        <div class="col-md-4" id="steps" title="step1">
         <h4>Step 1.</h4>
         <div  id="step1" >
           <br>

           <h4>Type here the name </h4>
           <h6>The format MUST BE "Projectname/nameofmethod-version" and the version must have the format "number.number".</h6>
           <br>
           <div class="text-field"><g:textField name="name" required="required"  pattern=".*/.*-v\\d*.\\d*" placeholder="bengen/tcoffee-v11.00" /></div>
         </div>
        </div>


        <div class="col-md-4" id="steps" title="step1">
         <h4>Step 2.</h4>
         <div  id="step2" >
           <br>

           <h4>Upload here your template file</h4>
           <br>

           			<input  type="file" size="50"  required="required" name="template">
         </div>
        </div>


        <div class="col-md-4" id="steps" title="step1">
         <h4>Step 3.</h4>
         <div  id="step3" >
           <br>

           <h4>Upload here your metadata file</h4>
           <br>

           			<input  type="file" size="50" required="required" name="metadata">
         </div>
       </div>

     </div>

  </div>

  <br>

  <div class="row">
    <center>
        <div class="submit"><g:actionSubmit value="Submit" action="collect"/></div>
    </center>
  </div>
  </center>

</g:form>

</body>
</html>
