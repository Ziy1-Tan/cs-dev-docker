# vim:set ft=dockerfile:
FROM rockylinux

# Prepare Image
RUN dnf -y install wget && \
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
    tini \
    tzdata \
    zsh \
    git \
    vim \
    htop \
    policycoreutils \
    mariadb-gssapi-server && \
    ln -s /usr/lib/lsb/init-functions /etc/init.d/functions && \
    rm -rf /usr/share/zoneinfo/tzdata.zi /usr/share/zoneinfo/leapseconds

COPY scripts/columnstore-init \
    scripts/columnstore-start \
    scripts/columnstore-stop \
    scripts/columnstore-restart /usr/bin/

# Chmod some files
RUN chmod +x /usr/bin/columnstore-init \
    /usr/bin/columnstore-start \
    /usr/bin/columnstore-stop \
    /usr/bin/columnstore-restart

# Expose MariaDB port
EXPOSE 3306

# Clean system and reduce size
RUN dnf clean all && \
    rm -rf /var/cache/dnf
