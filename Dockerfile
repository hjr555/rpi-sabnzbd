FROM hypriot/rpi-alpine-scratch:latest
MAINTAINER Hywel Rees <hjr555@gmail.com>

RUN apk --update add \
	gcc \
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
&& pip install --upgrade pip \
&& pip install pyopenssl cheetah \ 
&& git clone https://github.com/Parchive/par2cmdline.git \
&& hg clone https://bitbucket.org/dual75/yenc \
&& git clone https://github.com/sabnzbd/sabnzbd.git

WORKDIR /par2cmdline
RUN aclocal && \
	automake --add-missing && \
	autoconf && \
	./configure && \
	make && \
	make install

WORKDIR /yenc
RUN python setup.py build
RUN python setup.py install

WORKDIR /
RUN rm -rf /par2cmdline
RUN rm -rf /yenc

CMD /sabnzbd/SABnzbd.py
