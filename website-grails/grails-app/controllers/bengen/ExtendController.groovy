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
      def p1 = "git pull bengen".execute()
      p1.waitFor()

      "${currentpath}/bengen/bin/add.sh -n ${name} -m ${metadata_path} -t ${template_path}".execute()
      render(view: "/extendResult", model: [ name:name ] )

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
