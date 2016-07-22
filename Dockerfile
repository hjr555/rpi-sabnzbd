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
&& git clone https://github.com/sabnzbd/sabnzbd.git \
&& cd sabnzbd \
&& git checkout tags/1.1.0RC2 \
&& hg clone https://bitbucket.org/dual75/yenc

# Par2 support
WORKDIR /par2cmdline
RUN aclocal && \
    automake --add-missing && \
    autoconf && \
    ./configure && \
    make && \
    make install

# Yenc support
WORKDIR /yenc
RUN python setup.py build
RUN python setup.py install

# Cleanup
WORKDIR /
RUN apk del \
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

EXPOSE 8080

VOLUME ["/config", "/downloads"]

CMD /sabnzbd/SABnzbd.py
