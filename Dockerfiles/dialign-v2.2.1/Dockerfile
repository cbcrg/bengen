FROM pditommaso/dkrbase:1.2
MAINTAINER Luisa Santus <luisa.santus@hotmail.it>

RUN wget -q http://dialign.gobics.de/download/dialign_package.tgz &&\
 tar xf dialign_package.tgz &&\
 cd dialign_package/src &&\
 make &&\
 mv dialign2-2 /usr/local/bin/dialign &&\
 cd .. &&\
 mv dialign2_dir /usr/local/ &&\
 rm -rf ../dialign_package.tgz ../dialign_package

ENV DIALIGN2_DIR /usr/local/dialign2_dir
