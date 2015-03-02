docker-stackbrew-melted
=======================

docker-stackbrew-melted

A [Stackbrew/Ubuntu](https://github.com/tianon/docker-brew-ubuntu/tree/precise)-based image for [Docker](http://docker.io/), with [Melted](https://github.com/mltframework/melted) installed.

Currently using Ubuntu 12.04.

* docker-stackbrew-melted looks for melted.conf in /etc/melted. Therefore you need to mount a local dir containing melted conf to /etc/melted (see below).
* You can provide an MLT_PROFILE via "-e" argument or put it in melted.conf.
* If you need to run more than one melted instance on the same machine, just go ahead and map one of them to another outside port e.g. "-p 5251:5250", give it a different name and accomodate for that in upstart by providing an extra conf file referring to that name.
* melted needs to run in --privileged mode if it needs to access SDI hardware!

Example command line to create and run the container the first time:
sudo docker run -n melted-server -a stdout --privileged -p <OUTSIDE_PORT>:5250 -e MLT_PROFILE=atsc_1080i_50 -v <DIR_WITH_MELTED_CONF>:/etc/melted <CONTAINER_ID>

sudo docker --name melted -i -t -e MLT_PROFILE=atsc_1080i_50 --net=host --privileged --device /dev/blackmagic/dv0 -p 5250:5250 -v /srv/elias/config/melted.conf:/etc/melted/melted.conf -v /srv/elias/assets:/srv/assets -v /etc/blackmagic/BlackmagicPreferences.xml:/etc/blackmagic/BlackmagicPreferences.xml trickkiste/docker-stackbrew-melted-custom

docker run -d -t -i 

docker start
