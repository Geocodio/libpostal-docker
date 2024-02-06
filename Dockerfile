FROM debian:bullseye

RUN apt-get update && \
    apt-get -y install git curl \
    build-essential autoconf automake libtool pkg-config

# libpostal
RUN cd /tmp && \
	git clone https://github.com/openvenues/libpostal && \
	cd libpostal && \
    ./bootstrap.sh && \
    mkdir -p /usr/lib/libpostal /var/task/libpostal/data && \
    ./configure --disable-data-download --datadir=/var/task/libpostal/data

RUN cd /tmp/libpostal && \
	make -j4 && \
	make install && \
	ldconfig

# Note: We're disabling all chunking since the download seems to fail everytime we're trying to download in chunks
RUN cd /tmp/libpostal && \
	sed -i -E 's/_CHUNKS=[0-9]+/_CHUNKS=1/g' /usr/local/bin/libpostal_data && \
	libpostal_data download all /var/task/libpostal/data/libpostal

# postal-php
RUN apt-get update && \
    apt-get -y install libreadline-dev libsnappy-dev \
    php-cli php-dev php-curl php-mbstring php-zip php-dom php-gd php-sqlite3 php-geos

RUN cd /tmp && \
	git clone https://github.com/openvenues/php-postal && \
	cd php-postal && \
	phpize && \
	pkg-config libpostal && \
	./configure && \
	make && \
	make install && \
	cp modules/postal.so /usr/lib/php/postal.so