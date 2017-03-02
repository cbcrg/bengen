for i in "$@"
do
case $i in
    -n=*|--name=*)
    NAME="${i#*=}"
    shift # past argument=value
    ;;
    -d=*|--dockerfile=*)
    DOCKERPATH="${i#*=}"
    shift # past argument=value
    ;;
    -t=*|--template=*)
    TEMPLATEPATH="${i#*=}"
    shift # past argument=value
    ;;
    --yes)
    DEFAULT=YES
    shift # past argument with no value
    ;;
    *)
            # unknown option
    ;;
esac
done
echo "FILE NAME  = ${NAME}"
echo "DOCKERFILE PATH     = ${DOCKERPATH}"
echo "TEMPLATE FILE PATH    = ${TEMPLATEPATH}"
echo "${DEFAULT}"
[[ -d "boxes/${NAME}" ]] && { echo "Dockerfile of a MSA with same name already exist"; exit 0 ; }
[[ -d "templates/bengen/${NAME}" ]] && { echo "template file with same name already exist"; exit 0; }
mkdir boxes/${NAME}
cp ${DOCKERPATH} boxes/${NAME}/
cp ${TEMPLATEPATH} templates/bengen/${NAME}
[[ ${DEFAULT}="YES" ]] && { echo "bengen/${NAME}" >> test-align.txt;}
make
