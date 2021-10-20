#
# Regular cron jobs for the rampiot package
#
0 4	* * *	root	[ -x /usr/bin/rampiot_maintenance ] && /usr/bin/rampiot_maintenance
