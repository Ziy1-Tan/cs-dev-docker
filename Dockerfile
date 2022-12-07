# vim:set ft=dockerfile:
FROM rockylinux:8

# Timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' >/etc/timezone

# Prepare image
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
    python3 \
    zsh \
    git \
    vim \
    policycoreutils \
    mariadb-gssapi-server && \
    ln -s /usr/lib/lsb/init-functions /etc/init.d/functions && \
    rm -rf /usr/share/zoneinfo/tzdata.zi /usr/share/zoneinfo/leapseconds && \
    git config --global user.name "qggcs" && \                      
    git config --global user.email "ajb459684460@gmail.com"

# If systemd is not supported
COPY scripts/columnstore-init \
    scripts/columnstore-start \
    scripts/columnstore-stop \
    scripts/columnstore-restart /usr/bin/

COPY scripts/pre.sh \
    scripts/mcs.sh \
    config/.vimrc \
    scripts/fn.sh \
    scripts/install.sh /root/

# Chmod some files
RUN chmod +x /usr/bin/columnstore-init \
    /usr/bin/columnstore-start \
    /usr/bin/columnstore-stop \
    /usr/bin/columnstore-restart \
    /root/pre.sh \
    /root/mcs.sh \
    /root/fn.sh \
    /root/install.sh && \
    ln -s /root/mcs.sh /usr/bin/mcs && \
    ln -s /root/fn.sh /usr/bin/fn && \
    sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" && \
    source /etc/profile

# Clean system and reduce size
RUN dnf clean all && \
    rm -rf /var/cache/dnf
