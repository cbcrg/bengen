FROM bengen/grails


ADD website-grails /usr/local/


RUN cd ../usr/local/ && \
 rm -rf ./build

RUN grails run-app

