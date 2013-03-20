#!/usr/bin/env bash

binary=/mnt/steve/qemu-heca/x86_64-softmmu/qemu-system-x86_64
debug=0


# bi 1 & 2
master_ip='192.168.1.1'
client_ip='192.168.1.2'

: '
# Autotest A and Autotest B
master_ip='192.168.0.6'
client_ip='192.168.0.7'
'

: '
# Heca A and Heca B
master_ip='192.168.4.1'
client_ip='192.168.4.2'
'

onegig='1073741824'
threegig='3221225472'
fourgig='4294967296'
sixgig='6442450944'
tengig='10737418240'
fourteengig='15032385536'
sixtyfourgig='68719476736'

#hda='-hda /mnt/steve/images/ubuntu64_copy.img'
hda='-drive file=/root/hana64.raw,if=virtio'

mem='-m 64G'
vnc='-display vnc=:1'
net='-net tap -net nic,macaddr=00:00:00:00:00:22'
#net=''

tm='-monitor telnet:'$master_ip':4446,server,nowait'
tc='-monitor telnet:'$client_ip':4446,server,nowait'

lm='-incoming tcp:'$master_ip':4447'
lc='-incoming tcp:'$client_ip':4447'

hm='-heca_master dsmid=1,vminfo=1:'$master_ip':4444:4445#2:'$client_ip':4444:4445#,mr=0:'$sixtyfourgig':2#'
hc='-heca_client dsmid=1,vmid=2,master='$master_ip':4444:4445'

command="$binary $hda $mem $vnc $net -smp 32"

for i in $*
do
    case "$i" in
        hm)
            command="$command $hm"
            ;;
        hc) 
            command="$command $hc"
            ;;
        tm)
            command="$command $tm"
            ;;
        lm)
            command="$command $lm"
            ;;
        tc)
            command="$command $tc"
            ;;
        lc)
            command="$command $lc"
            ;;
        -d)
            debug=1
            

    esac
done

echo "$command"
if [ $debug == 0 ]; then
    $command
fi
