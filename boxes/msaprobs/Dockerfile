FROM pditommaso/dkrbase:1.2
MAINTAINER Luisa Santus <luisa.santus@hotmail.it>

RUN wget -q 'https://downloads.sourceforge.net/project/msaprobs/MSAProbs-0.9.7.tar.gz' &&\
 tar xf MSAProbs-0.9.7.tar.gz &&\
 cd MSAProbs-0.9.7/MSAProbs &&\
 make &&\
 mv msaprobs /usr/local/bin/msaprobs &&\
 cd .. &&\
 cd .. &&\
 rm -rf MSAProbs-0.9.7 MSAProbs-0.9.7.tar.gz
 




