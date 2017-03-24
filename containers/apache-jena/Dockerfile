FROM pditommaso/dkrbase:1.2
MAINTAINER Luisa Santus <luisa.santus@hotmail.it>

RUN wget -q http://apache.rediris.es/jena/binaries/apache-jena-3.2.0.tar.gz &&\
  tar xf apache-jena-3.2.0.tar.gz &&\
  rm apache-jena-3.2.0.tar.gz &&\
  mkdir /opt/java && cd /opt/java &&\
  wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.tar.gz"&&\
  tar -zxvf jdk-8u45-linux-x64.tar.gz &&\
  cd jdk1.8.0_45/ &&\
  update-alternatives --install /usr/bin/java java /opt/java/jdk1.8.0_45/bin/java 100  &&\
  update-alternatives --config java  

ENV PATH "apache-jena-3.2.0/bin:$PATH"
