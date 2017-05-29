package bengen

class GetmetadataController {

    def index() {
	     render view: "/getmetadata/getMetadata", model: []

     }


   def collect(){

     def map= [id:'missing', version:'missing', label:"missing", type:"missing",input:"missing",output:"missing",input_format:"missing",output_format:"missing",topic:"Bioinformatics",max_count:"missing" ]

     def firstLineMSA="id,version,label,type,input,output,input_format,output_format,topic,max_count"
     def firstLineSF="id,version,label,type,input,input_format,topic"

     def (type, input , output, input_format,output_format,max_count ) =  params.ret.split('-')



     def currentpath_temp = "pwd".execute().text
     def currentpath= currentpath_temp.substring(0, currentpath_temp.length() - 1)


     def file = new File("${currentpath}/file.txt")
     PrintWriter writer = new PrintWriter(file);
     writer.print("");
     writer.print(params.ret);
     writer.close();


     if (file.exists()) {
        response.setContentType("application/octet-stream")
        response.setHeader("Content-disposition", "filename=${file.name}")
        response.outputStream << file.bytes
        return
     }












   }
}
