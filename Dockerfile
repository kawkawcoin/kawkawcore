FROM amd64/ubuntu:18.04 AS base

EXPOSE 9090/tcp
EXPOSE 9099/tcp

ENV DEBIAN_FRONTEND=noninteractive

#Add ppa:bitcoin/bitcoin repository so we can install libdb4.8 libdb4.8++
RUN apt-get update && \
	apt-get install -y software-properties-common && \
	add-apt-repository ppa:bitcoin/bitcoin

#Install runtime dependencies
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	bash net-tools libminiupnpc10 \
	libevent-2.1 libevent-pthreads-2.1 \
	libdb4.8 libdb4.8++ \
	libboost-system1.65 libboost-filesystem1.65 libboost-chrono1.65 \
	libboost-program-options1.65 libboost-thread1.65 \
	libzmq5 && \
	apt-get clean

FROM base AS build

#Install build dependencies
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	bash net-tools build-essential libtool autotools-dev automake git \
	pkg-config libssl-dev libevent-dev bsdmainutils python3 \
	libboost-system1.65-dev libboost-filesystem1.65-dev libboost-chrono1.65-dev \
	libboost-program-options1.65-dev libboost-test1.65-dev libboost-thread1.65-dev \
	libzmq3-dev libminiupnpc-dev libdb4.8-dev libdb4.8++-dev && \
	apt-get clean


#Build Kawkaw from source
COPY . /home/kawkaw/build/Kawkaw/
WORKDIR /home/kawkaw/build/Kawkaw
RUN ./autogen.sh && ./configure --disable-tests --with-gui=no && make

FROM base AS final

#Add our service account user
RUN useradd -ms /bin/bash kawkaw && \
	mkdir /var/lib/kawkaw && \
	chown kawkaw:kawkaw /var/lib/kawkaw && \
	ln -s /var/lib/kawkaw /home/kawkaw/.kawkaw && \
	chown -h kawkaw:kawkaw /home/kawkaw/.kawkaw

VOLUME /var/lib/kawkaw

#Copy the compiled binaries from the build
COPY --from=build /home/kawkaw/build/Kawkaw/src/kawkawd /usr/local/bin/kawkawd
COPY --from=build /home/kawkaw/build/Kawkaw/src/kawkaw-cli /usr/local/bin/kawkaw-cli

WORKDIR /home/kawkaw
USER kawkaw

CMD /usr/local/bin/kawkawd -datadir=/var/lib/kawkaw -printtoconsole -onlynet=ipv4
