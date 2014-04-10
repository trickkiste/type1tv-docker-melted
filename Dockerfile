FROM stackbrew/ubuntu:12.04
MAINTAINER Markus Kienast <mark@trickkiste.at>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y git automake autoconf libtool intltool g++ yasm swig libmp3lame-dev libgavl-dev libsamplerate-dev libxml2-dev ladspa-sdk libjack-dev libsox-dev libsdl-dev libgtk2.0-dev liboil-dev libsoup2.4-dev libqt4-dev libexif-dev libtheora-dev libvdpau-dev libvorbis-dev python-dev

ENV HOME /tmp
RUN cd /tmp/ ; git clone https://github.com/trickkiste/mlt-scripts.git

#RUN apt-get install -y curl wget dkms linux-headers-`uname -r` linux-headers-generic libjpeg62
RUN apt-get install -y curl wget dkms linux-headers-generic libjpeg62
#RUN wget --quiet -O /tmp/Blackmagic_Desktop_Video_Linux_10.0.tar.gz http://software.blackmagicdesign.com/DesktopVideo/Blackmagic_Desktop_Video_Linux_10.0.tar.gz
#RUN cd /tmp ; tar xvfz /tmp/Blackmagic_Desktop_Video_Linux_10.0.tar.gz
#RUN dpkg -i /tmp/DesktopVideo_10.0/deb/amd64/desktopvideo_10.0a7_amd64.deb
RUN wget --quiet -O /tmp/Blackmagic_Desktop_Video_Linux_9.8.tar.gz http://software.blackmagicdesign.com/DesktopVideo/Blackmagic_Desktop_Video_Linux_9.8.tar.gz
RUN cd /tmp ; tar xvfz /tmp/Blackmagic_Desktop_Video_Linux_9.8.tar.gz
RUN dpkg -i /tmp/desktopvideo-9.8-amd64.deb

RUN echo "INSTALL_DIR=\"/usr\"" > /tmp/build-melted.conf
RUN echo "SOURCE_DIR=\"/tmp/melted\"" >> /tmp/build-melted.conf
RUN echo "AUTO_APPEND_DATE=0" >> /tmp/build-melted.conf
RUN echo "CREATE_STARTUP_SCRIPT=0" >> /tmp/build-melted.conf

RUN /tmp/mlt-scripts/build/build-melted.sh -c /tmp/build-melted.conf
RUN apt-get install -y libmp3lame0 libgavl1 libsox1b libexif12 libvdpau1 libqt4-gui
# if you need Rugen
# RUN apt-get install -y libqt4-gui

# Remove things for building modules
RUN rm -r /tmp/melted
RUN rm /tmp/build-melted.conf
RUN rm -r /tmp/mlt-scripts

RUN apt-get remove -y git automake autoconf libtool intltool g++ libmp3lame-dev libgavl-dev libsamplerate-dev libxml2-dev libjack-dev libsox-dev libsdl-dev libgtk2.0-dev liboil-dev libsoup2.4-dev libqt4-dev libexif-dev libtheora-dev libvdpau-dev libvorbis-dev python-dev
RUN apt-get remove -y manpages manpages-dev g++ g++-4.6
RUN apt-get autoclean -y
RUN apt-get clean -y

RUN     useradd -m default

WORKDIR /home/default

USER    default
ENV     HOME /home/default
# As we want this to be universal, we do not set MLT_PROFILE here, or via the docker run command, but through melted.conf
# ENV	MLT_PROFILE atsc_1080i_50

EXPOSE 5250
# We use -test so melted does not detach from the terminal
# And we discard all stdout and stderr, so we do not bloat dockers log file and run into trouble that way
# Unfortunately it does not work to append these arguments to CMD, so we have to make use of a wrapper script
#RUN echo '#!/bin/sh' >> /tmp/melted-wrapper ; echo 'melted -test "$@" > /dev/null 2>&1' >> /tmp/melted-wrapper 
#RUN mv /tmp/melted-wrapper /usr/local/bin/melted-wrapper 
#RUN chmod +x /usr/local/bin/melted-wrapper

CMD ["-c", "/etc/melted/melted.conf","-nodetach"]
ENTRYPOINT ["melted"]
