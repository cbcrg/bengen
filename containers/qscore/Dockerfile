FROM pditommaso/dkrbase:1.2

MAINTAINER Luisa Santus <luisa.santus@hotmail.it>


RUN mkdir qscore &&\
 cd qscore &&\
 wget -q http://drive5.com/qscore/qscore_src.tar.gz &&\
 tar xf qscore_src.tar.gz &&\
 sed -i '1s;^;#include <climits>;' qscore.h &&\
 make &&\
 mv qscore /usr/local/bin/ &&\
 cd ..
 
 
