# vim:set ft=dockerfile:
FROM rockylinux:8

# Timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' >/etc/timezone

# Prepare image
RUN dnf -y install epel-release && \
    dnf -y upgrade --refresh

# Install some basic dependencies
RUN dnf -y install bind-utils \
    dnf-utils \
    net-tools \
    openssl \
    procps-ng \
    python3 \
    zsh \
    git \
    policycoreutils

RUN yum -y groupinstall "Development Tools" && \
    yum config-manager --set-enabled powertools && \
    yum install -y checkpolicy cmake && \
    yum -y install bison ncurses-devel readline-devel perl-devel openssl-devel libxml2-devel gperf libaio-devel libevent-devel tree pam-devel snappy-devel libicu && \
    yum -y install vim wget strace ltrace gdb rsyslog net-tools openssh-server expect boost perl-DBI libicu boost-devel initscripts && \
    yum -y install jemalloc-devel libcurl-devel gtest-devel cppunit-devel systemd-devel lzo-devel xz-devel lz4-devel bzip2-devel && \
    yum -y install pcre2-devel flex graphviz && \
    yum -y install gcc-toolset-12



RUN sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

COPY config/.vimrc \
    config/.zshrc \
    scripts/install_deps.sh \ 
    scripts/mcs.sh \ 
    scripts/fixup.sh \
    /root/

# Clean system and reduce size
RUN dnf clean all && \
    rm -rf /var/cache/dnf
