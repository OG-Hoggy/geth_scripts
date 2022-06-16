#!/bin/bash

sudo apt update && apt install lvm2 -y

sudo lvm

pvcreate /dev/sdb

pvcreate /dev/sdc

vgcreate vg2 /dev/sdb /dev/sdc

#18GB is placeholder for 1% of 2TB drive used for cache (practical size 1.8TB)
lvm> lvcreate -n meta -L 18GB vg2 /dev/sdc 

#99%PVS uses the rest as a cache for writeback
lvcreate -n cache -l 99%PVS vg2 /dev/sdc

lvconvert --type cache-pool --cachemode writeback --poolmetadata vg2/meta vg2/cache

lvcreate -L 99.9G -n lv vg2 /dev/sdb

lvconvert --type cache --cachepool vg2/cache vg2/lv

exit

sudo mkfs.ext4 /dev/vg2/lv

mkdir /mnt/lv

mount /dev/vg2/lv /mnt/lv

cd /mnt/lv

#Below commands will install sysbench and cache functionality

# sudo apt install sysbench -y

# sysbench --test=fileio --file-test-mode=seqwr run

# sysbench --test=fileio --file-test-mode=rndwr prepare

# sysbench --test=fileio --file-test-mode=rndwr run

# lvs -a -o lv_name,cachedirtyblocks