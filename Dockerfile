FROM ubuntu:trusty
MAINTAINER Markus Kienast <mark@trickkiste.at>
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /tmp

# Update System
RUN apt-get update && apt-get -y dist-upgrade && rm -rf /var/lib/apt/lists/* && apt-get autoclean && apt-get clean && apt-get autoremove

# Install libs for Blackmagic driver
RUN apt-get update && apt-get install -y libjpeg62 libgl1-mesa-glx libxml2 && rm -rf /var/lib/apt/lists/* && apt-get autoclean && apt-get clean && apt-get autoremove

# Installing libs for melted
RUN apt-get update && apt-get install -y libmp3lame0 libgavl1 libsamplerate0 libsoxr-lsr0 libxml2 libjack0 libsox2 libsdl1.2debian libgtk2.0-0 liboil0.3 libsoup2.4-1 libqt4-opengl libqt4-svg libqtgui4 libexif12 libtheora0 libvdpau1 libvorbis0a libvorbisenc2 libvorbisfile3 libxcb-shm0 && rm -rf /var/lib/apt/lists/* && apt-get -y autoclean && apt-get -y clean && apt-get -y autoremove

# Generate config file for building melted
RUN echo "INSTALL_DIR=\"/usr\"" > /tmp/build-melted.conf && echo "SOURCE_DIR=\"/tmp/melted\"" >> /tmp/build-melted.conf && echo "SOURCES_CLEAN=1" >> /tmp/build-melted.conf && echo "AUTO_APPEND_DATE=0" >> /tmp/build-melted.conf && echo "CREATE_STARTUP_SCRIPT=0" >> /tmp/build-melted.conf

# Installing all build tools, download and build melted
RUN apt-get update && \
    apt-get install -y wget git automake autoconf libtool intltool g++ yasm swig \
    libmp3lame-dev libgavl-dev libsamplerate-dev libxml2-dev ladspa-sdk \
    libjack-dev libsox-dev libsdl-dev libgtk2.0-dev liboil-dev libsoup2.4-dev \
    libqt4-dev libexif-dev libtheora-dev libvdpau-dev libvorbis-dev python-dev && \
    \
    cd /tmp/ && git clone https://github.com/mltframework/mlt-scripts.git && \
    \
    wget --quiet -O /tmp/Blackmagic_Desktop_Video_Linux_10.1.1.tar.gz \
    http://software.blackmagicdesign.com/DesktopVideo/Blackmagic_Desktop_Video_Linux_10.1.1.tar.gz && \
    cd /tmp && tar xvfz /tmp/Blackmagic_Desktop_Video_Linux_10.1.1.tar.gz && \
    dpkg --force-depends -i /tmp/DesktopVideo_10.1.1/deb/amd64/desktopvideo_10.1.1a26_amd64.deb && \
    \
    /tmp/mlt-scripts/build/build-melted.sh -c /tmp/build-melted.conf && \
    \
    dpkg --force-depends -r desktopvideo && \
    rm -r /tmp/melted && \
    rm /tmp/build-melted.conf && \
    rm -r /tmp/mlt-scripts && \
    \
    apt-get remove -y automake autoconf libtool intltool g++ libmp3lame-dev \
    libgavl-dev libsamplerate-dev libxml2-dev libjack-dev libsox-dev libsdl-dev \
    libgtk2.0-dev liboil-dev libsoup2.4-dev libqt4-dev libexif-dev libtheora-dev \
    libvdpau-dev libvorbis-dev python-dev manpages manpages-dev g++ g++-4.6 git && \
    \
    apt-get -y autoclean && apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/apt/lists/* && \
    dpkg --force-depends -i /tmp/DesktopVideo_10.1.1/deb/amd64/desktopvideo_10.1.1a26_amd64.deb && \
    rm -rf /tmp


# Melted will be run as user default in userspace
RUN     useradd -m default
USER    default
WORKDIR /home/default
ENV     HOME /home/default

COPY melted.conf /etc/melted/melted.conf

# This is only mentioned here for documentation. 
# The desired MLT_PROFILE env should be set via "docker run -e MLT_PROFILE=atsc_1080i_50" and/or in melted.conf
# ENV	MLT_PROFILE atsc_1080i_50

# We start with the -nodetach flag, so docker does not daemonize
EXPOSE 5250
CMD ["-c", "/etc/melted/melted.conf","-nodetach"]
ENTRYPOINT ["melted"]
