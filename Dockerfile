# vim:set ft=dockerfile:
FROM rockylinux/rockylinux:8

# Prepare Image
RUN dnf -y install wget && \
    wget -O /tmp/mariadb_repo_setup https://downloads.mariadb.com/MariaDB/mariadb_repo_setup && \
    chmod +x /tmp/mariadb_repo_setup && \
    ./tmp/mariadb_repo_setup --mariadb-server-version=mariadb-10.6 && \
    dnf -y install epel-release && \
    dnf -y upgrade --refresh

# Install some basic dependencies
RUN dnf -y install bind-utils \
    bc \
    boost \
    expect \
    glibc-langpack-en \
    jemalloc \
    jq \
    less \
    libaio \
    monit \
    nano \
    net-tools \
    openssl \
    perl \
    perl-DBI \
    procps-ng \
    redhat-lsb-core \
    rsyslog \
    snappy \
    tcl \
    tzdata \
    vim && \
    ln -s /usr/lib/lsb/init-functions /etc/init.d/functions && \
    rm -rf /usr/share/zoneinfo/tzdata.zi /usr/share/zoneinfo/leapseconds

# Default env variables
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV TINI_VERSION=v0.18.0

# Add Tini Init Process
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini

# Install MariaDB packages
RUN dnf -y install \
    MariaDB-server && \
    cp /usr/share/mysql/mysql.server /etc/init.d/mariadb && \
    /etc/init.d/mariadb start && \
    mysql_tzinfo_to_sql /usr/share/zoneinfo | mariadb mysql && \
    /etc/init.d/mariadb stop && \
    dnf -y install MariaDB-columnstore-engine

# Copy files to image
COPY config/monit.d/ /etc/monit.d/

COPY scripts/columnstore-init \
    scripts/columnstore-start \
    scripts/columnstore-stop \
    scripts/columnstore-restart /usr/bin/

# Chmod some files
RUN chmod +x /usr/bin/tini \
    /usr/bin/columnstore-init \
    /usr/bin/columnstore-start \
    /usr/bin/columnstore-stop \
    /usr/bin/columnstore-restart && \
    touch /etc/columnstore/cmapi_server.conf && \
    sed -i 's|set daemon\s.30|set daemon 5|g' /etc/monitrc && \
    sed -i 's|#.*with start delay\s.*240|  with start delay 60|g' /etc/monitrc

# Expose MariaDB port
EXPOSE 3306

# Create persistent volumes
VOLUME ["/etc/columnstore", "/var/lib/columnstore", "/var/lib/mysql"]

# Copy entrypoint to image
COPY scripts/docker-entrypoint.sh /usr/bin/

# Make entrypoint executable & create legacy symlink
RUN chmod +x /usr/bin/docker-entrypoint.sh && \
    ln -s /usr/bin/docker-entrypoint.sh /docker-entrypoint.sh

# Clean system and reduce size
RUN dnf clean all && \
    rm -rf /var/cache/dnf && \
    find /var/log -type f -exec cp /dev/null {} \; && \
    rm -rf /var/lib/mysql/*.err && \
    cat /dev/null > ~/.bash_history && \
    history -c && \
    sed -i 's|SysSock.Use="off"|SysSock.Use="on"|' /etc/rsyslog.conf && \
    sed -i 's|^.*module(load="imjournal"|#module(load="imjournal"|g' /etc/rsyslog.conf && \
    sed -i 's|^.*StateFile="imjournal.state")|#  StateFile="imjournal.state"\)|g' /etc/rsyslog.conf

# Bootstrap
ENTRYPOINT ["/usr/bin/tini","--","docker-entrypoint.sh"]
CMD columnstore-start && monit -I
