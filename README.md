ansible-pi: video-cluster
=========================

Quickly setup your Raspberry Pi to be part of a synchronized cluster of
video players.

PI Setup
--------

1. Image your SD cards. `script/image_card` helps with this.
2. Boot the new pis and go through initialization. Expand the
   filesystem, enable SSH, and optionally set the hostname to something
   unique.


Usage
-----

Ensure ansible is installed (see Requirements, below).

Clone and setup the ansible script.

    git clone https://github.com/heisters/node-omxplayer-sync-devops.git
    cd ansible-pi
    git checkout video-cluster
    cp hosts.example hosts

If you did not set the hostnames of the pis, you can use this script to
find pis on the local network:

    script/find_pis

Put the pi hosts or IPs in `hosts` under "players".

Optionally, copy your ssh id to the players:

    which ssh-copy-id || brew install ssh-copy-id
    ssh-copy-id pi@XXX.XXX.X.XXX # password is 'raspberry'

To check that the players are properly configured:

    script/ping

Provision the players:

    script/provision

If you didn't copy your ssh id previously, you'll need to run the
provision command directly with `--ask-pass`:

    ansible-playbook provision.yml --ask-pass -i hosts

Provisioning will automatically deploy the application for you. However,
once provisioning is done, you'll need copy your video file and any
custom configuration to the pis:

    script/copy <a video file> /home/pi/video.mov

or, if each pi gets a different video file:

    scp <video file 1> pi@raspberrypi-1.local:~/video.mov
    scp <video file 2> pi@raspberrypi-2.local:~/video.mov
    # ...

Then, optionally, copy the configuration:

    script/copy <path>/config.local.js /app/

See https://github.com/heisters/node-omxplayer-sync for more details on
configuration.

Deployment
----------

    script/deploy

Requirements
------------

[Ansible](http://www.ansibleworks.com/) is required.

    pip install ansible

Useful Commands
---------------

Run adhoc commands:

    script/run 'ls /'

Same, but with sudo privileges:

    script/srun 'halt'

Manage the system service for the video player:

    script/service restarted

Copy a local file to all players:

    script/copy ../my-local-file.txt /app/

Check whether you can connect to all players:

    script/ping
