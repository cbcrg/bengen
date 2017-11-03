FROM pditommaso/dkrbase:1.2
MAINTAINER Paolo Di Tommaso <paolo.ditommaso@gmail.com>

RUN wget -q http://www.tcoffee.org/Packages/Stable/Version_11.00.8cbe486/linux/T-COFFEE_installer_Version_11.00.8cbe486_linux_x64.tar.gz && \
  tar xf T-COFFEE_installer_Version_11.00.8cbe486_linux_x64.tar.gz && \
  mv T-COFFEE_installer_Version_11.00.8cbe486_linux_x64 /opt/tcoffee && \
  rm -rf T-COFFEE_installer_Version_11.00.8cbe486_linux_x64.tar.gz
  
ENV SATE_HOME=/opt/sate/ TEMP=/tmp DIR_4_TCOFFEE=/opt/tcoffee EMAIL_4_TCOFFEE=tcoffee.msa@gmail.com CACHE_4_TCOFFEE=/tmp/cache/ LOCKDIR_4_TCOFFEE=/tmp/lck/ TMP_4_TCOFFEE=/tmp/tmp/  
ENV PATH=$PATH:/opt/blast/bin:/opt/sate/sate-core/bin:/opt/tcoffee/bin:/opt/tcoffee/plugins/linux/

COPY bali_score_src /bali_score_src

RUN cd /bali_score_src \
 && make -f makefile \
 && mv bali_score /usr/local/bin