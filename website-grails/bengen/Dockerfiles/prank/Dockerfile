FROM pditommaso/dkrbase:1.2
MAINTAINER Luisa Santus <luisa.santus@hotmail.it>

RUN wget -q http://www.ebi.ac.uk/goldman-srv/prank/src/prank/prank.src.100802.tgz &&\
 tar xf prank.src.100802.tgz &&\
 cd prank &&\
 make &&\
 mv prank /usr/local/bin/prank &&\
 rm -rf ../prank ../prank.src.100802.tgz
