
#Read command line parameters


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

esac

done

cd ${DOCKERPATH}

docker build -t bengen/${NAME} .

