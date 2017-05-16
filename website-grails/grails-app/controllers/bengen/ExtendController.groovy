package bengen

class ExtendController {

    def index() {
      flash.message = 'file cannot be empty'
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




      name = params.name
      def meta = metadata_path
      def templ = template_path
      def error = p1.text
      render(view: "/extendResult", model: [ name:name , meta: meta , templ:templ , error: error] )

    }



    def showMessage(){

    }


    def download(){
      File file = File.createTempFile("temp",".txt")
      file.write("hello world!")
      response.setHeader "Content-disposition", "attachment; filename=${file.name}.txt"
      response.contentType = 'text-plain'
      response.outputStream << file.text
      response.outputStream.flush()
    }
}
