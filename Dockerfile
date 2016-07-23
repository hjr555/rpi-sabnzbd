FROM hypriot/rpi-alpine-scratch:latest
MAINTAINER Hywel Rees <hjr555@gmail.com>

RUN apk --update add \
    gcc \
    g++ \
    git \
    python \
    py-openssl \
    openssl-dev \
    py-pip \
    python-dev \
    libffi-dev \
    musl-dev \
    unrar \
    mercurial \
    openssl \
    make \
    automake \
    autoconf \
&& pip install --upgrade pip --no-cache-dir\
&& pip install pyopenssl cheetah --no-cache-dir \ 
&& git clone https://github.com/Parchive/par2cmdline.git \
&& cd /par2cmdline \
&& aclocal \
&& automake --add-missing \
&& autoconf \
&& ./configure \
&& make \
&& make install \
&& cd / \
&& rm -rf par2cmdline \
&& git clone https://github.com/sabnzbd/sabnzbd.git \
&& cd /sabnzbd \
&& git checkout tags/1.1.0RC2 \
&& cd / \
&& hg clone https://bitbucket.org/dual75/yenc \
&& cd /yenc \
&& python setup.py build \
&& python setup.py install \
&& cd / \
&& rm -rf /yenc \
&& apk del \
    gcc \
    g++ \
    git \
    mercurial \
    make \
    automake \
    autoconf \
    python-dev \
    libffi-dev \
    openssl-dev \
    musl-dev \
&& rm -rf \ 
    /var/cache/apk \
    /par2cmdline \
    /yenc \
    /sabnzbd/.git \
    /tmp/*

EXPOSE 8080

VOLUME ["/datadir", "/download"]

WORKDIR /sabnzbd

CMD su -pc "./SABnzbd.py -b 0 -f /datadir/config.ini -s 0.0.0.0:8080"
