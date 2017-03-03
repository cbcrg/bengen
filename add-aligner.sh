
#Read command line parameters

MAKE=NO
ADD=NO

for i in "$@"
do
case $i in
    -n=*|--name=*)
    NAME="${i#*=}"
    shift
    ;;
    -d=*|--dockerfile=*)
    DOCKERPATH="${i#*=}"
    shift 
    ;;
    -t=*|--template=*)
    TEMPLATEPATH="${i#*=}"
    shift
    ;;
    --add)
    ADD=YES
    
    ;;
    --make)
    MAKE=YES
    shift
    ;;
    *)
            
    ;;
esac

done


ALERT=" Please read the instruction on how to use this script on https://github.com/cbcrg/bengen/blob/master/README.md "


#Check if mandatory arguments are given
[[ ${NAME} == "" ]] && { echo "Name of your MSA is missing"; echo ${ALERT}; exit 0; }
[[ ${DOCKERPATH} == "" ]] && { echo "Path of Dockerfile is missing"; echo ${ALERT}; exit 0; }
[[ ${TEMPLATEPATH} == ""  ]] && { echo "Path of Templatefile is missing"; echo ${ALERT}; exit 0; }


#If MSA Dockerfile or templatefile with the same name already exist --> exit
[[ -d "boxes/${NAME}" ]] && { echo "Dockerfile of a MSA with same name already exist"; exit 0 ; }
[[ -f "templates/bengen/${NAME}" ]] && { echo "template file with same name already exist"; exit 0; }


#Move files in right directories
[[ -f ${DOCKERPATH} && -f ${TEMPLATEPATH} ]] && { mkdir boxes/${NAME} ; cp ${DOCKERPATH} boxes/${NAME}/ ; cp ${TEMPLATEPATH} templates/bengen/${NAME}; } || \
{ echo "Could not find Dockerfile or templatefile"; echo ${ALERT}; }


#add name of aligner in the aligners.txt ONLY IF it is not already there
[[ ${ADD} == "YES" ]] && { grep -q "bengen/${NAME}" "aligners.txt" || echo "bengen/${NAME}" >> aligners.txt; }

## call the make command if required
[[ ${MAKE} == "YES" ]] && { make;  }









