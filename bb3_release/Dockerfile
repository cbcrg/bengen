FROM bengen/tcoffee
MAINTAINER Paolo Di Tommaso <paolo.ditommaso@gmail.com>

ADD bali_score_src/ /root/bali_score_src

RUN cd /root/bali_score_src && \
  make clean; make -f makefile && \
  cp bali_score /usr/local/bin

