FROM pditommaso/dkrbase:1.2
MAINTAINER Paolo Di Tommaso <paolo.ditommaso@gmail.com>

ADD bb3_release/bali_score_src/ /root/bali_score_src

RUN cd /root/bali_score_src && \
  make clean && make -f makefile && \
  cp bali_score /usr/local/bin
  

ENTRYPOINT ["/usr/local/bin/bali_score"] 