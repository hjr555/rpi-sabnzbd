FROM hypriot/rpi-alpine-scratch:v3.4
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
    p7zip \
&& pip install --upgrade pip --no-cache-dir \
&& pip install pyopenssl cheetah --no-cache-dir \ 
&& git clone --depth 1 https://github.com/Parchive/par2cmdline.git \
&& cd /par2cmdline \
&& aclocal \
&& automake --add-missing \
&& autoconf \
&& ./configure \
&& make \
&& make install \
&& cd / \
&& rm -rf par2cmdline \
&& git clone --depth 1 --branch 1.1.1 https://github.com/sabnzbd/sabnzbd.git \
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
