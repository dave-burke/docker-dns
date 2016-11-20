# Docker DNS

Based on `andyshinn/dnsmasq`.

The included script will start a dnsmasq container that maps `$HOST.lan` to the host machine.

To provide DNS for local machines, just add extra lines in this format:

	--address /[machine name]/[machine IP] \

