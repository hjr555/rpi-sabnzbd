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
&& pip install --upgrade pip \
&& pip install pyopenssl cheetah \ 
&& git clone https://github.com/Parchive/par2cmdline.git \
&& git clone https://github.com/sabnzbd/sabnzbd.git \
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
RUN rm -rf \ 
	/par2cmdline \ 
	/yenc

RUN apk del \
	gcc \
	git \
	mercurial \
	make \
	automake \
	autoconf \
&& apk cache clean

CMD /sabnzbd/SABnzbd.py
