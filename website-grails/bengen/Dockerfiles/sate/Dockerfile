FROM pditommaso/dkrbase:1.2

MAINTAINER Luisa Santus <luisa.santus@hotmail.it>
RUN apt-get -m update && apt-get install -y wget unzip python python-dev python-distribute python-pip

RUN wget -q https://pypi.python.org/packages/43/22/69b7713b094697f8a432abe96c44a155519ef67b3c31221de32f4c3d5fa5/DendroPy-3.12.0.tar.gz &&\
 tar xf DendroPy-3.12.0.tar.gz &&\
 cd DendroPy-3.12.0 &&\
 python setup.py develop &&\
 python setup.py install &&\
 cd .. &&\ 
 cd /opt && \
 wget -q http://phylo.bio.ku.edu/software/sate/downloads2/src/satesrc-v2.2.7-2013Feb15.tar.gz -O- \
 | tar xz && \
 cd satesrc-v2.2.7-2013Feb15/sate-core/ && \
 python setup.py develop && \
 cd /opt && \
 ln -s /opt/satesrc-v2.2.7-2013Feb15 /opt/sate
 
