FROM pditommaso/dkrbase:1.2
MAINTAINER Luisa Santus <luisa.santus@hotmail.it>

RUN mkdir ka &&\
 cd ka &&\
 wget -q http://msa.sbc.su.se/downloads/kalign/current.tar.gz &&\
 tar xf current.tar.gz &&\
 ./configure &&\
 make &&\
 mv kalign /usr/local/bin/kalign &&\
 rm -rf ../ka

