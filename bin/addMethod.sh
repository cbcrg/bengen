path=`pwd`/`echo $0`;
file=$(basename "$path");
bengen=`echo $path | sed "s/\/bin\/$file//g"`;


echo $bengen; 

operations="$bengen/metadata/operations.ttl"

#Read command line parameters
MAKE=NO

while getopts ":n:m:t:" opt; do
  case $opt in
    n) NAME="$OPTARG"
    ;;
    m) METADATAPATH="$OPTARG"
    ;;
    t) TEMPLATEPATH="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done


ALERT=" Please read the instruction on how to use this script on https://github.com/cbcrg/bengen/blob/master/README.md "



#Check if mandatory arguments are given
[[ ${NAME} == "" ]] && { echo "Name of your MSA is missing"; echo ${ALERT}; exit 0; }
[[ ${METADATAPATH} == "" ]] && { echo "Path of Metadatafile is missing"; echo ${ALERT}; exit 0; }
[[ ${TEMPLATEPATH} == ""  ]] && { echo "Path of Templatefile is missing"; echo ${ALERT}; exit 0; }

IFS='/'; array=($NAME);
DockerHubRepo=${array[0]}
MethodName=${array[1]}


#If templatefile with the same name already exist --> exit
[[ -f "${bengen}/templates/${DockerHubRepo}/${MethodName}" ]] && { echo "WARNING : template file with same name already exist. NOT OVERWRITTEN!!!";}


#If image name does not already exist in images_docker --> add it
lookForName=`grep -c "${DockerHubRepo}/${MethodName}" "${bengen}/images_docker"`
[[ $lookForName -gt  0 ]] || echo "${DockerHubRepo}/${MethodName}" >> "${bengen}/images_docker" && echo "WARNING : the name of the image was already included in the project."




[[ -f ${METADATAPATH} && -f ${TEMPLATEPATH} ]] && { cat "${METADATAPATH}" >> "$operations"; 
	[[ -d "$bengen/templates/$DockerHubRepo" ]] || mkdir "$bengen/templates/$DockerHubRepo" ; 
	cp "${TEMPLATEPATH}" "$bengen/templates/${DockerHubRepo}/${MethodName}"; } || \
{ echo "Could not find Metadatafile or templatefile"; echo ${ALERT}; exit 0 ; }

echo "hola"

## call the make command if required
[[ ${MAKE} == "YES" ]] && { ${bengen}/make ;  }













