FROM pditommaso/dkrbase:1.2
MAINTAINER Luisa Santus <luisa.santus@hotmail.it>

RUN apt-get update &&\
 apt-get -y install default-jre

RUN wget -q http://www.cs.utexas.edu/~phylo/software/fastsp/FastSP_1.6.0.jar 

ENV PATH "/fastsp/:$PATH"
