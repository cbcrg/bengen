FROM pditommaso/dkrbase
MAINTAINER Maria Chatzou <mxatzou@gmail.com>

RUN apt-get update && \
    apt-get install -y default-jdk && \
    apt-get install -y git && \
    apt-get install -y python

RUN git clone https://github.com/smirarab/sate-tools-linux.git 

RUN git clone https://github.com/smirarab/pasta.git && \
    cd pasta && \
    python setup.py develop &&\
    cd ..

#   export PATH="/pasta/:$PATH"
ENV PATH "/pasta/:$PATH"


 
