ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")";

bengen=`sed s-/bin/add.sh--g <<< $ABSOLUTE_PATH`;


operations="$bengen/metadata/operations.ttl"

#Read command line parameters

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


OIFS=$IFS
IFS='/'; array=($NAME);
DockerHubRepo=${array[0]}
MethodName=${array[1]}
IFS=$OIFS


#If templatefile with the same name already exist --> exit
[[ -f "${bengen}/templates/${DockerHubRepo}/${MethodName}" ]] && { echo "WARNING : template file with same name already exist. NOT OVERWRITTEN!!!";}


#If image name does not already exist in images_docker --> add it

lookForName=`grep -cx "\(^${DockerHubRepo}/${MethodName}$\)\|\(^${DockerHubRepo}/${MethodName}@.*\)" "${bengen}/images_docker"`



if [ $lookForName -gt  0 ]; then
    echo "WARNING : the name of the image was already included in the project."
else
    echo "${DockerHubRepo}/${MethodName}" >> "${bengen}/images_docker";

fi



if [[ -f ${METADATAPATH} && -f ${TEMPLATEPATH} ]]; then
    cat "${METADATAPATH}" >> "$operations";
    if [  ! -d "$bengen/templates/$DockerHubRepo" ]; then
        mkdir "$bengen/templates/$DockerHubRepo"
    fi
  	cp "${TEMPLATEPATH}" "$bengen/templates/${DockerHubRepo}/${MethodName}";

else
    echo "Could not find Metadatafile or templatefile"; echo ${ALERT}; exit 0 ;
fi
