FROM stackbrew/ubuntu:12.04
MAINTAINER Markus Kienast <mark@trickkiste.at>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y git automake autoconf libtool intltool g++ yasm swig libmp3lame-dev libgavl-dev libsamplerate-dev libxml2-dev ladspa-sdk libjack-dev libsox-dev libsdl-dev libgtk2.0-dev liboil-dev libsoup2.4-dev libqt4-dev libexif-dev libtheora-dev libvdpau-dev libvorbis-dev python-dev

ENV HOME /tmp
RUN cd /tmp/ ; git clone https://github.com/mltframework/mlt-scripts.git

RUN echo "INSTALL_DIR=\"/usr\"" > /tmp/build-melted.conf
RUN echo "SOURCE_DIR=\"/tmp/melted\"" >> /tmp/build-melted.conf
RUN echo "AUTO_APPEND_DATE=0" >> /tmp/build-melted.conf
RUN echo "CREATE_STARTUP_SCRIPT=0" >> /tmp/build-melted.conf

RUN /tmp/mlt-scripts/build/build-melted.sh -c /tmp/build-melted.conf
RUN apt-get install -y libmp3lame0 libgavl1 libsox1b libexif12 libvdpau1 libqt4-gui
# if you need Rugen
# RUN apt-get install -y libqt4-gui

RUN apt-get install -y curl wget dkms linux-headers-`uname -r` linux-headers-generic
RUN wget --quiet -O /tmp/Blackmagic_Desktop_Video_Linux_10.0.tar.gz http://software.blackmagicdesign.com/DesktopVideo/Blackmagic_Desktop_Video_Linux_10.0.tar.gz
RUN cd /tmp ; tar xvfz /tmp/Blackmagic_Desktop_Video_Linux_10.0.tar.gz
RUN dpkg -i /tmp/DesktopVideo_10.0/deb/amd64/desktopvideo_10.0a7_amd64.deb

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
ENV	MLT_PROFILE atsc_1080i_50

EXPOSE 5250

CMD ["-test", "-c", "/etc/melted/melted.conf"]
ENTRYPOINT ["melted"]
