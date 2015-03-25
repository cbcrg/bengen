FROM pditommaso/dkrbase:1.2
MAINTAINER Maria Chatzou <mxatzou@gmail.com>

RUN wget -q http://mafft.cbrc.jp/alignment/software/mafft-7.130-with-extensions-src.tgz && \
  tar xf mafft-7.130-with-extensions-src.tgz && \
  cd mafft-7.130-with-extensions/core && \
  make && \
  make install && \
  cd / && \
  rm -rf mafft-7.130-with-extensions && \
  rm mafft-7.130-with-extensions-src.tgz 
  
  
ADD runmsa.sh /root/runmsa.sh
RUN chmod +x /root/runmsa.sh

ENTRYPOINT ["/root/runmsa.sh"]  