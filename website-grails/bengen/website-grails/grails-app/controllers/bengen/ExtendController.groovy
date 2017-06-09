package bengen
import java.util.zip.ZipOutputStream
import java.util.zip.ZipEntry
import java.nio.channels.FileChannel

class ExtendController {

    def index() {
	     render view: "/extend/extendBenGen", model: []
    }

    def collect(){

      //define currentpath
      def currentpath_temp = "pwd".execute().text
      def currentpath= currentpath_temp.substring(0, currentpath_temp.length() - 1)

      //Save the name
      def name = params.name

      //Save Metadatafile
      def metadata_file_multipart = request.getFile('metadata')
      def metadata_path="${currentpath}/res/metadata.txt"
      File metadata_file = new File (metadata_path)
      metadata_file_multipart.transferTo(metadata_file)

      //Save Template File
      def template_file_multipart = request.getFile('template')
      def template_path="${currentpath}/res/template.txt"
      File template_file = new File ( template_path)
      template_file_multipart.transferTo(template_file)

      "${currentpath}/bin/myScript.sh".execute()
      def p1 = "git stash  && git pull bengen".execute()
      p1.waitFor()


      def p2 = "sh ${currentpath}/bengen/bin/add.sh -m ${metadata_path} -n ${name} -t ${template_path}".execute()
      p2.waitFor()


      def p3 = "zip -r bengen.zip ${currentpath}/bengen ".execute()
      //p3.waitFor()


      name = params.name
      def meta = metadata_path
      def templ = template_path
      def error = "Believe in it!"
      render(view: "/extendResult", model: [ name:name , meta: meta , templ:templ , error: error] )

    }



    def download(){
      
      //define currentpath
      def currentpath_temp = "pwd".execute().text
      def currentpath= currentpath_temp.substring(0, currentpath_temp.length() - 1)

      def file = new File("${currentpath}/bengen.zip")

      if (file.exists()) {
         response.setContentType("application/octet-stream")
         response.setHeader("Content-disposition", "filename=${file.name}")
         response.outputStream << file.bytes
         return
      }




    }
}
