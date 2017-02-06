FROM pditommaso/dkrbase:1.2
MAINTAINER Paolo Di Tommaso <paolo.ditommaso@gmail.com>

RUN wget -q http://www.tcoffee.org/Packages/Stable/Version_11.00.8cbe486/linux/T-COFFEE_installer_Version_11.00.8cbe486_linux_x64.tar.gz && \
  tar xf T-COFFEE_installer_Version_11.00.8cbe486_linux_x64.tar.gz && \
  mv T-COFFEE_installer_Version_11.00.8cbe486_linux_x64 /opt/tcoffee && \
  rm -rf T-COFFEE_installer_Version_11.00.8cbe486_linux_x64.tar.gz
  
ENV SATE_HOME /opt/sate/  
ENV PATH=$PATH:/opt/tcoffee/bin:/opt/tcoffee/plugins/linux/
ENV TEMP /tmp
ENV DIR_4_TCOFFEE /opt/tcoffee
ENV EMAIL_4_TCOFFEE tcoffee.msa@gmail.com
ENV CACHE_4_TCOFFEE /tmp/cache/
ENV LOCKDIR_4_TCOFFEE /tmp/lck/
ENV TMP_4_TCOFFEE /tmp/tmp/  

