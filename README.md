type1tv-docker-melted
=====================

Sources
* Ubuntu Trusty 14.04 - ubuntu:trusty
* [Melted](https://github.com/mltframework/melted)
* Blackmagic Driver - desktopvideo_10.1.1a26

Prerequisites
* If you have a blackmagic SDI card, you need to install the driver on your host system.
* The file /etc/blackmagic/BlackmagicPreferences.xml needs to be bound to the container for some reason.
* Comes with a default /etc/melted/melted.conf.
* Default melted.conf defines /srv/assets as melted root directory.
* Default melted.conf adds a Backmagic SDI output via "uadd blackmagic:0".
* Default melted.conf specifies mlt_profile=atsc_1080i_50,
* Blackmagic drivers are installed in the container, as this seems to be needed for the melted build to include blackmagic support.
* Privileged mode "--privileged" is not needed anymore.
* Use --net=host as melted tends to segfault in default network config. This is most likely not melteds fault, but dockers network proxy, which is used to redirect communication to localhost.

Overrule defaults
* You can bind your own melted.conf via docker volumes option
* You can bind your your assets somewhere else, if you specify a different location in melted.conf ... but why would you want this?

Questions you can help me solve
* I am currently specifying MLT_PROFILE both via "-e" docker env option and in melted.conf, as I do not know, if I can skip one. I would prefer, if I can simply specify the MLT_PROFILE via "-e", because this makes the docker image more versatile.
* Can I build blackmagic support without installing the drivers?
* Can I run with blackmagic consumer, if drivers are only installed on the host system?
* Can I run with different driver versions on host and in the docker image?

Notes
* If you want to run more than one unit on a given host, I recommend that you run several melted docker instances! You can map melted port 5250 to different host porst e.g. "-p 5251:5250" but you would not have to modify the docker image for that. I still need to test this part, but it seems you would then just map "--device /dev/blackmagic/dv1" and it would still work to do "uadd blackmagic:0", as melted does only see this one card. This is due to the fact, that a Decklink Quad for example shows up as 4 separate cards in your system, not as one with 4 outputs.


Create your container like this

sudo docker create --name melted -i -t --net=host --device /dev/blackmagic/dv0 -p <OUTSIDE_PORT>:5250 -e MLT_PROFILE=atsc_1080i_50 -v <DIR_WITH_MELTED_CONF>:/etc/melted -v <DIR_WITH_VIDEO_FILES>:/srv/assets -v /etc/blackmagic/BlackmagicPreferences.xml:/etc/blackmagic/BlackmagicPreferences.xml trickkiste/type1tv-docker-melted

Example

sudo docker create --name melted -i -t --net=host --device /dev/blackmagic/dv0 -p 5250:5250 -e MLT_PROFILE=atsc_1080i_50 /srv/elias/config/melted.conf:/etc/melted/melted.conf -v /srv/elias/assets:/srv/assets -v /etc/blackmagic/BlackmagicPreferences.xml:/etc/blackmagic/BlackmagicPreferences.xml trickkiste/type1tv-docker-melted

Then run with

sudo docker start melted
