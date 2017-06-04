# smokeping for DNS checks docker container

This cointainer helps detecting DNS resolution failures on a docker host.
It is based on smokeping, and uses the AnotherDNS probe.

## Usage

The container will automatically generate menu and checks based on the `LOOKUPS` environment variable.
Here are some examples:
* `<dns hostname or ip>:<domain name to check>`
* `<dns hostname or ip>:<domain name to check 1> <dns hostname or ip>:<domain name to check 2>`
* `<dns hostname or ip 1>:<domain name to check> <dns hostname or ip 1>:<same domain name to check>`
* `<dns hostname or ip 1>:<domain name to check 1> <dns hostname or ip 2>:<domain name to check 2>`

You can also fine tune the AnotherDNS probe through environment variables:
```
 STEP
 FORKS
 OFFSET
 IP_VERSION
 MIN_INTERVAL
 PINGS
 PORT
 PROTOCOL
 RECORD_TYPE
 REQUIRE_ANSWERS
 REQUIRE_NOERROR
 TIMEOUT
```

By default the container will run checks every 100 seconds, you can change it through the environment variable `STEP`.

## About Smokeping

SmokePing keeps track of your network latency:
* Best of breed latency visualisation.
* Interactive graph explorer.
* Wide range of latency measurement plugins.
* Master/Slave System for distributed measurement.
* Highly configurable alerting system.
* Live Latency Charts with the most 'interesting' graphs.
* Free and OpenSource Software written in Perl written by Tobi Oetiker, the creator of MRTG and RRDtool