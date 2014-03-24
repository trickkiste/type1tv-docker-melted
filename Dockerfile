FROM stackbrew/ubuntu:12.04
MAINTAINER Markus Kienast <mark@trickkiste.at>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y git automake autoconf libtool intltool g++ yasm swig libmp3lame-dev libgavl-dev libsamplerate-dev libxml2-dev ladspa-sdk libjack-dev libsox-dev libsdl-dev libgtk2.0-dev liboil-dev libsoup2.4-dev libqt4-dev libexif-dev libtheora-dev libvdpau-dev libvorbis-dev python-dev
#RUN apt-get install -y python-software-properties python g++ make
#RUN add-apt-repository -y ppa:chris-lea/node.js
#RUN apt-get update
#RUN apt-get install -y nodejs
#RUN npm -g install socket.io
#RUN npm -g install forever
#RUN npm -g install coffee-script
#RUN npm -g install express
#RUN npm -g install underscore
#RUN npm -g install faye
#RUN npm -g install faye-websocket
#RUN npm -g install redis
#RUN npm -g install faye-redis
#RUN npm -g install request
#RUN npm -g install mysql
#RUN npm -g install ldapjs
#RUN npm -g install winston
#RUN npm -g install winston-elasticsearch
#RUN npm -g install primus --save

RUN mkdir /tmp/mlt-scripts
RUN git clone https://github.com/mltframework/mlt-scripts.git /tmp/mlt-scripts
RUN /tmp/mlt-scripts/build/build-melted.sh

# Remove things for building modules
#RUN apt-get remove -y manpages manpages-dev g++ gcc cpp make python-software-properties unattended-upgrades ucf g++-4.6 gcc-4.6 cpp-4.6
#RUN rm -r /tmp/mlt-scripts/

RUN     useradd -m default

WORKDIR /home/default

USER    default
ENV     HOME /home/default
ENV     NODE_PATH /usr/lib/node_modules
RUN     touch /home/default/.foreverignore

#ENTRYPOINT ["forever"]
