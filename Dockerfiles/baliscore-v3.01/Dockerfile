FROM pditommaso/dkrbase:1.2
MAINTAINER Luisa Santus <luisa.santus@hotmail.it>

#Install MView for file-format conversion

RUN apt-get install unzip 

RUN cd usr/local/ &&\
 wget -q https://github.com/desmid/mview/archive/master.zip &&\
 unzip master.zip &&\
 rm -rf master.zip &&\
 cd mview-master &&\
 sed -i -- 's/#\!\/usr\/bin\/env perl/\#\!\/usr\/bin\/perl/g' bin/mview &&\
 sed -i -- 's/\/home\/brown\/HOME\/work\/MView\/dev\/lib/\/usr\/local\/mview-master\/lib/g' bin/mview 
 

ENV PATH /usr/local/mview-master/bin:$PATH 

#Install bali_score

RUN wget -q http://www.lbgi.fr/balibase/BalibaseDownload/BAliBASE_R1-5.tar.gz &&\
 tar xf BAliBASE_R1-5.tar.gz &&\
 rm -rf BAliBASE_R1-5.tar.gz &&\
 cd bb3_release/bali_score_src && \
 rm -rf expat-1.95.2 &&\
 wget -q https://sourceforge.net/projects/expat/files/expat/2.0.1/expat-2.0.1.tar.gz &&\
 gunzip expat-2.0.1.tar.gz &&\
 tar xf expat-2.0.1.tar &&\
 sed -i -- 's/expat-1.95.2/expat-2.0.1/g' makefile &&\
 make &&\
 cp bali_score /usr/local/bin &&\
 cd ../.. &&\
 rm -rf bb3_release
