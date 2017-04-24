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


<div class="row">
  <form name="form" id="aliform" action="./cgi-bin/extendBenGen.pl" method="POST" enctype="multipart/form-data">
    <div class="steps-wrapper">


      <div class="col-md-4" id="steps" title="step1">
       <h4>Step 1.</h4>
       <div  id="step1" >
         <br>

         <h4>Type here the name </h4>
         <br>
         <textarea name="name" form="extendform" class="getname" placeholder="bengen/tcoffee"></textarea>
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

  </form>
</div>

<br>

<div class="row">
  <center>
    <input type="submit" value="Download the modified BenGen >>" >
  </center>
</div>


</center>

</body>
</html>
