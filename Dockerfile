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
    zsh \
    git \
    clang-tools-extra \
    clang \
    policycoreutils

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
    graphviz

RUN sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" --unattended

COPY config /root/
COPY scripts /root/

# Clean system and reduce size
RUN dnf clean all && \
    rm -rf /var/cache/dnf
