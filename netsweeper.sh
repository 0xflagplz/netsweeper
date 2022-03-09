#!/bin/bash
if [[ "$1" == "" ]] ; then
echo "[*] - ERROR: Wrong Format\n**Only Scans /24**\n\tUsage: ./netsweeper 192.168.0"
else
for i in {1..255} ; do ping -c 1 $1.$i | grep "64 bytes" & done 2> /dev/null | awk '{print $4}' | cut -d ":" -f 1
fi
