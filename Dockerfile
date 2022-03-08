FROM debian:bookworm

RUN apt-get update && \
    apt-get -y install git curl \
    build-essential autoconf automake libtool pkg-config

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

RUN cd /tmp/libpostal && \
	libpostal_data download all /var/task/libpostal/data/libpostal
