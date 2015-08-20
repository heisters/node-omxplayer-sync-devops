#!/bin/bash
### BEGIN INIT INFO
# If you wish the Daemon to be lauched at boot / stopped at shutdown :
#
#    On Debian-based distributions:
#      INSTALL : update-rc.d scriptname defaults
#      (UNINSTALL : update-rc.d -f  scriptname remove)
#
#    On RedHat-based distributions (CentOS, OpenSUSE...):
#      INSTALL : chkconfig --level 35 scriptname on
#      (UNINSTALL : chkconfig --level 35 scriptname off)
#
# chkconfig:         2345 90 60
# Provides:          video-player
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: forever running main.js
# Description:       main.js
### END INIT INFO
#
# initd a node app
# Based on a script posted by https://gist.github.com/jinze at https://gist.github.com/3748766
#

if [ -e /lib/lsb/init-functions ]; then
	# LSB source function library.
	. /lib/lsb/init-functions
fi;

pidFile="{{ app_dir }}/pid"
logFile="{{ app_dir }}/stdout.log"

app="{{ app_dir }}/main.js"
user={{ ansible_ssh_user }}
forever="sudo -u ${user} /usr/bin/forever"

export MIN_UPTIME="5000"
export SPIN_SLEEP_TIME="2000"

start() {
	echo "Starting $app"

	# Notice that we change the PATH because on reboot
  # the PATH does not include the path to node.
  # Launching forever with a full path
  # does not work unless we set the PATH.
  PATH=/usr/local/bin:$PATH
	export NODE_ENV=production
  $forever start --pidFile $pidFile -l $logFile --minUptime=$MIN_UPTIME --spinSleepTime=SPIN_SLEEP_TIME -a -d $app
  RETVAL=$?
}

restart() {
	echo -n "Restarting $app"
	$forever restart $app
	RETVAL=$?
}

stop() {
	echo -n "Shutting down $app"
  $forever stop $app
  RETVAL=$?
}

status() {
  echo -n "Status $app"
  $forever list
  RETVAL=$?
}

case "$1" in
   start)
        start
        ;;
    stop)
        stop
        ;;
   status)
        status
        ;;
   restart)
        restart
        ;;
	*)
        echo "Usage:  {start|stop|status|restart}"
        exit 1
        ;;
esac
exit $RETVAL
