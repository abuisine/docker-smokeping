#!/usr/bin/env bash

set -eo pipefail

mkdir -p /run/smokeping
[[ -p /tmp/log ]] || mkfifo -m 0660 /tmp/log
chown -Rh smokeping:www-data /var/cache/smokeping /var/lib/smokeping \
            /run/smokeping /tmp/log 2>&1 | grep -iv 'Read-only' || :
chmod -R g+ws /var/cache/smokeping /var/lib/smokeping /run/smokeping 2>&1 |
            grep -iv 'Read-only' || :

PROBES_FILE=/etc/smokeping/config.d/Probes
/usr/local/bin/ep -v ${PROBES_FILE}

TARGETS_FILE=/var/run/smokeping/Targets

rm /var/run/smokeping/Targets || true

last_dns=""
target_count=0
for LOOKUP in $LOOKUPS
do
    IFS=: read dns target <<< ${LOOKUP}

    if [[ "${last_dns}x" != "${dns}x" ]]
    then
        last_dns=${dns}
        section=`echo "${dns}" | tr . _`
        echo "Adding ${section} DNS section ..."
        echo -e "+ ${section}\nmenu = ${dns}\ntitle = request sent to ${dns}\n" >> $TARGETS_FILE
    fi

    echo -e "++ target${target_count}\nprobe = AnotherDNS\nmenu = ${target}\ntitle = ${target}\nhost = ${dns}\nlookup = ${target}\n" >> $TARGETS_FILE
    target_count=$((target_count + 1))
done

if [[ $# -ge 1 && -x $(which $1 2>&-) ]]; then
    exec "$@"
elif [[ $# -ge 1 ]]; then
    echo "ERROR: command not found: $1"
    exit 13
elif ps -ef | egrep -v 'grep|smokeping.sh' | grep -q smokeping; then
    echo "Service already running, please restart container to apply changes"
else
    tail -F /tmp/log &
    su -l ${SPUSER:-smokeping} -s /bin/bash -c \
            "exec /usr/sbin/smokeping --logfile=/tmp/log ${DEBUG:+--debug}"
    exec lighttpd -D -f /etc/lighttpd/lighttpd.conf
fi