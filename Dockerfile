FROM gocd/gocd-agent

MAINTAINER Abdulkadir Yaman <abdulkadiryaman@gmail.com>

RUN apt-add-repository ppa:brightbox/ruby-ng -y

RUN apt-get update 

RUN DEBIAN_FRONTEND=noninteractive \
	apt-get install -y \
	ca-certificates \
	fonts-takao \
	gconf-service \
	gksu \
	libappindicator1 \
	libasound2 \
	libcurl3 \
	libgconf-2-4 \
	libnspr4 \
	libnss3 \
    libxss1 \
	libpango1.0-0 \
	pulseaudio \
	python-psutil \
	supervisor \
	wget \
	xbase-clients \
	xdg-utils \
	xvfb \
    firefox \
    ruby1.9.3 \
    freetds-dev \
    cowsay \
    zlib1g-dev \
    unzip \
    phantomjs \
    qt5-default \
    qt5-qmake \
    libqt5webkit5-dev

RUN rm -rf /var/lib/apt/lists/*

ADD https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb /chrome.deb

RUN dpkg -i /chrome.deb && rm /chrome.deb

RUN ln -s /lib/x86_64-linux-gnu/libudev.so.1 /lib/x86_64-linux-gnu/libudev.so.0

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME ["/home/chrome"]

RUN useradd -m -G pulse-access chrome

RUN ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

RUN wget -N https://chromedriver.storage.googleapis.com/2.15/chromedriver_linux64.zip -P /tmp/
RUN unzip /tmp/chromedriver_linux64.zip
RUN chmod +x /tmp/chromedriver
RUN mv /tmp/chromedriver /usr/bin/

RUN ln -sf /usr/share/zoneinfo/Turkey /etc/localtime

RUN echo "%go ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
COPY autoregister.properties /var/lib/go-agent/config/autoregister.properties

ENV LANG en_US.UTF-8
RUN locale-gen $LANG

