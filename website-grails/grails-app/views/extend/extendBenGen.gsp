<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>BenGen</title>


</head>

<body>
<div id="header"></div>
<center>
<h1>Extend BenGen</h1>
<h3> ( If you did not create yet your metadata file you can easily do it
  <a href="getMetadata.html">here</a>) </h3>

<g:form name="form" controller="extend" id="collecting" method="post" enctype="multipart/form-data" >
  <div class="row">
      <div class="steps-wrapper">


        <div class="col-md-4" id="steps" title="step1">
         <h4>Step 1.</h4>
         <div  id="step1" >
           <br>

           <h4>Type here the name </h4>
           <br>
           <div class="text-field"><g:textField name="name"  placeholder="bengen/tcoffee" /></div>
         </div>
        </div>


        <div class="col-md-4" id="steps" title="step1">
         <h4>Step 2.</h4>
         <div  id="step2" >
           <br>

           <h4>Upload here your template file</h4>
           <br>

           			<input  type="file" size="50"  name="template">
         </div>
        </div>


        <div class="col-md-4" id="steps" title="step1">
         <h4>Step 3.</h4>
         <div  id="step3" >
           <br>

           <h4>Upload here your metadata file</h4>
           <br>

           			<input  type="file" size="50"  name="metadata">
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
