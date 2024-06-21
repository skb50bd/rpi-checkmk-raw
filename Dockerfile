FROM ubuntu:22.04

# Download
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y curl
RUN curl -LO $(curl -s https://api.github.com/repos/chrisss404/check-mk-arm/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep jammy_arm64.deb)

# dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    lsb-release \
    apt-utils \
    libcap2-bin \
    cron \ 
    traceroute \ 
    dialog \
    time \
    dnsutils \
    graphviz \ 
    apache2 \
    apache2-utils \ 
    libevent-2.1-7 \ 
    libltdl7 \
    libnl-3-200 \ 
    libperl5.3 \ 
    libxml2 \ 
    logrotate \ 
    php-cli \ 
    php-cgi \ 
    php-gd \ 
    php-sqlite3 \ 
    php-json \ 
    php-pear \
    rsync \ 
    smbclient \ 
    rpcbind \ 
    unzip \ 
    xinetd \ 
    freeradius-utils \ 
    libpcap0.8 \ 
    rpm \ 
    binutils \
    lcab \ 
    libgsf-1-114 \
    libglib2.0-0 \
    cpio \ 
    libfl2 \ 
    poppler-utils \ 
    libpq5
    
# installation
RUN dpkg -i check-mk-raw-*.jammy_arm64.deb
  
# cleanup
RUN rm check-mk-raw-*.jammy_arm64.deb && \  
  DEBIAN_FRONTEND=noninteractive apt-get install -f --no-install-recommends && \
  DEBIAN_FRONTEND=noninteractive apt-get autoremove -y && \
  DEBIAN_FRONTEND=noninteractive apt-get clean -y && \
  rm -rf /var/lib/apt/lists/*

# publish
EXPOSE 5000/tcp
WORKDIR /app
COPY *.sh /app/
RUN chmod +x /app/*.sh
ENTRYPOINT ["/bin/bash"]
CMD ["/app/run.sh"]