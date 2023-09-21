FROM rockylinux:8

# Timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' > /etc/timezone


# Install some basic dependencies
RUN dnf -y install epel-release && \
    dnf -y upgrade --refresh && \
    dnf -y install bind-utils \
    wget \
    dnf-utils \
    net-tools \
    openssl \
    procps-ng \
    python3 \
    git \
    clang-tools-extra \
    clang \
    policycoreutils

# Install Columnstor build dependencies
RUN yum -y groupinstall "Development Tools" \
    && yum config-manager --set-enabled powertools \
    && yum install -y checkpolicy \
    cmake \
    epel-release \
    bison \
    ncurses-devel \
    readline-devel \
    perl-devel \
    openssl-devel \
    libxml2-devel \
    gperf \
    libaio-devel \
    libevent-devel \
    tree \
    wget \
    pam-devel \
    snappy-devel \
    libicu \
    vim \
    wget \
    strace \
    ltrace \
    gdb \
    rsyslog \
    net-tools \
    openssh-server \
    expect \
    boost \
    perl-DBI \
    libicu \
    boost-devel \
    initscripts \
    jemalloc-devel \
    libcurl-devel \
    gtest-devel \
    cppunit-devel \
    systemd-devel \
    lzo-devel \
    xz-devel \
    lz4-devel \
    bzip2-devel \
    pcre2-devel \
    flex \
    graphviz \
    gcc-toolset-12

# Copy config files & scripts
COPY config /root/

COPY scripts/install_deps \
    scripts/mcs-status \
    scripts/mcs-start \
    scripts/mcs-stop \
    scripts/mcs-restart /usr/bin/

# Make scripts executable
RUN chmod +x /usr/bin/install_deps \
    /usr/bin/mcs-status \
    /usr/bin/mcs-start \
    /usr/bin/mcs-stop \
    /usr/bin/mcs-restart


# Clean system and reduce size
RUN dnf clean all && \
    rm -rf /var/cache/dnf
