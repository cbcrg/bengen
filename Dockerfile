FROM bengen/grails


ADD website-grails /usr/local/


RUN cd ../usr/local/ && \
 rm -rf ./build

ENTRYPOINT [ "grails" , "run-app"]
