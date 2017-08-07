package bengen

class GetmetadataController {

    def completeNameGlobal="";
    def  mapTranslation=[ 'scoring function':'edam:operation_0259' ,
    'sequence alignment (nucleic acid)': 'edam:data_1384' ,
     'xmlNA' :'edam:format_2555',
     'TBMsa' :'edam:operation_0499',
     'SMsa':'edam:operation_0294',
     'GeneralMsa':'edam:operation_0492',
     'proteinTBMSA-small' : 'edam:data_2976,edam:data_1384',
     'proteinSMSA-small' : 'edam:data_2976,edam:data_1384',
     'proteinGMSA-small' : 'edam:data_2976,edam:data_1384',
     'proteinTBMSA-big' : 'edam:data_2976,edam:data_1384',
     'proteinSMSA-big' : 'edam:data_2976,edam:data_1384',
     'proteinGMSA-big' : 'edam:data_2976,edam:data_1384',
     'NATBMSA-small' : 'edam:data_2977,edam:data_1383',
      'NASMSA-small' : 'edam:data_2977,edam:data_1383',
      'NAGMSA-small' : 'edam:data_2977,edam:data_1383',
      'NATBMSA-big' : 'edam:data_2977,edam:data_1383',
      'NASMSA-big' : 'edam:data_2977,edam:data_1383',
      'NAGMSA-big' : 'edam:data_2977,edam:data_1383',
      'bothTBMSA-small' : 'edam:data_2976,edam:data_1384',
      'bothSMSA-small' : 'edam:data_2976,edam:data_1384',
      'bothGMSA-small' : 'edam:data_2976,edam:data_1384',
      'bothTBMSA-big' : 'edam:data_2976,edam:data_1384',
      'bothSMSA-big' : 'edam:data_2976,edam:data_1384',
      'bothGMSA-big' : 'edam:data_2976,edam:data_1384',






     ];




    def index() {
	     render view: "/getmetadata/getMetadata", model: []

     }


    def first(){

      def name= params.name
      completeNameGlobal=params.name
      render (view: "/getmetadata/getMetadata2", model: [ name:name ])
    }

   def collect(){

     def map= [id:'missing', version:'missing', label:"missing", type:"missing",input:"missing",output:"missing",input_format:"missing",output_format:"missing",topic:"Bioinformatics",max_count:"missing" ]

     //define current path
    def currentpath_temp = "pwd".execute().text
    def currentpath= currentpath_temp.substring(0, currentpath_temp.length() - 1)

     //define the headers
     def firstLinemsa="id,version,label,type,input,output,input_format,output_format,topic,max_count"
     def firstLinesf="id,version,label,type,input,input_format,topic"

     //get label and version Separated
     def (label, version) = completeNameGlobal.tokenize( '-v' )
     def (project, method) = label.tokenize('/');
     //get other values
     def (typeMain,others) = params.ret.tokenize(',') ;


     //append in right order! ( There is no standard one --> depends on the mapping sparql file's first line)
     def translated="";

    if ("$typeMain" == "scoring function"){
     def (type,input,input_format) = params.ret.tokenize(',') ;
     translated = label+","+version+","+label+",";
     translated =translated+mapTranslation[type];
     translated =translated+ ","+mapTranslation[input];
     translated =translated+ ","+mapTranslation[input_format];
     translated =translated+ ",edam:topic_0091";
   }
   else if ("$typeMain" == "method"){
    def (type,input,max_count) = params.ret.tokenize(',') ;
    translated = params.ret ;
    translated = label+","+version+","+label;
    translated =translated+ ","+mapTranslation[input];
    translated =translated+ ","+mapTranslation[max_count];
  //  translated =translated+ ","+mapTranslation[outputHERE];
    translated =translated+ ",edam:format_1929";
    translated =translated+ ",edam:format_1984";
    translated =translated+ ",edam:topic_0091";
    translated =translated+ ","+getMaxCount(max_count);

  }

  def identifierSparql="";
  if ("$typeMain" == "scoring function"){
    identifierSparql="sf";

  }else if ("$typeMain" == "method"){
    identifierSparql="msa";


  }






    //save into file
    def fileToModel = new File("${currentpath}/toModel.csv")

    PrintWriter writer = new PrintWriter(fileToModel);


    if ("$typeMain" == "scoring function"){
      writer.print(firstLinesf);

    }else if ("$typeMain" == "method"){
        writer.print(firstLinemsa);


    }
    writer.print("\n");
    writer.print(translated);
    writer.close();



    //now transfer file

    File fileDest = new File("${currentpath}/toModel.csv")
    fileToModel.renameTo(fileDest)



     //MODEL FILE

     def p2 = "tarql ${currentpath}/bin/mapping-${identifierSparql}.sparql ${currentpath}/toModel.csv ".execute()

     p2.waitFor()



     def file2 = new File("${currentpath}/temp.csv")

     PrintWriter writer3 = new PrintWriter(file2);
     writer3.print("\n");
     writer3.print(p2.text);
     writer3.close();

     File fileDest2 = new File("metadata-${method}.txt")
     file2.renameTo(fileDest2)


     def temp = "das";
     def p3 ="bash ${currentpath}/bin/filter.sh ${currentpath}/metadata-${method}.txt" .execute()


     p3.waitFor()
    //PREPARE FILE FOR DOWNLOAD
     def file = new File("${currentpath}/metadata-${method}.txt")

     PrintWriter writer2 = new PrintWriter(file);
     writer2.print("");
     writer2.print(p3.text);
     writer2.close();


     if (fileToModel.exists()) {
        response.setContentType("application/octet-stream")
        response.setHeader("Content-disposition", "filename=${file.name}")
        response.outputStream << file.bytes
        return
     }








   }


   def getMaxCount(String string){

    if(string.contains("big")){
      return 10000;
    }
    else{
      return 200;
    }



   }
}
