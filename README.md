ansible-pi: video-cluster
=========================

![](https://raw.github.com/scottmotte/ansible-pi/master/ansible-pi.jpg)

Quickly setup your Raspberry Pi to be part of a synchronized cluster of
video players.

Based on this [complete guide to setting up your raspberry pi without a keyboard and mouse](http://sendgrid.com/blog/complete-guide-set-raspberry-pi-without-keyboard-mouse/).

PI Setup
--------

1. Image your pis. `script/image_card` helps with this.
2. Boot the new pis and go through initialization. Expand the
   filesystem, enable SSH, and optionally set the hostname to something
   unique.


Usage
-----

Ensure ansible is installed (see Requirements, below).

Clone and setup the ansible script.

    git clone https://github.com/heisters/ansible-pi.git
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

    ansible all -m ping -i hosts

Provision the players:

    ansible-playbook provision.yml -i hosts

If you didn't copy your ssh id previously, you'll need to pass
--ask-pass to that command.

Deployment
----------

    ansible-playbook deploy.yml -i hosts

Requirements
------------

[Ansible](http://www.ansibleworks.com/) is required.

    pip install ansible

Useful Commands
---------------

Run adhoc commands:

    ansible -i hosts players -a "<bash command>"
