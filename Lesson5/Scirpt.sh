#!/bin/bash
#-------------------------------------------------------------

echo "=============================================="
echo "Task 1"
echo "=============================================="

zpool create otus1 mirror /dev/sdc /dev/sdd > /dev/null 2>&1
zpool create otus2 mirror /dev/sde /dev/sdf > /dev/null 2>&1
zpool create otus3 mirror /dev/sdg /dev/sdh > /dev/null 2>&1
zpool create otus4 mirror /dev/sdi /dev/sdj > /dev/null 2>&1


zfs set compression=lzjb otus1 > /dev/null 2>&1
zfs set compression=lz4 otus2 > /dev/null 2>&1
zfs set compression=gzip-9 otus3 > /dev/null 2>&1
zfs set compression=zle otus4 > /dev/null 2>&1


for i in {1..4}; do
    wget -P /otus$i https://gutenberg.org/cache/epub/2600/pg2600.converter.log > /dev/null 2>&1
done


echo "ZFS pools and datasets:"
zfs list

#-------------------------------------------------------------

echo "=============================================="
echo "Task 2"
echo "=============================================="

wget -O archive.tar.gz --no-check-certificate 'https://drive.usercontent.google.com/download?id=1MvrcEp-WgAQe57aDEzxSRalPAwbNN1Bb&export=download' > /dev/null 2>&1

tar -xzvf archive.tar.gz > /dev/null 2>&1

zpool import -d zpoolexport/ otus > /dev/null 2>&1

echo "ZFS properties for 'otus':"
zfs get available otus
zfs get readonly otus
zfs get recordsize otus
zfs get compression otus
zfs get checksum otus

#-------------------------------------------------------------

echo "=============================================="
echo "Task 3"
echo "=============================================="

wget -O otus_task2.file --no-check-certificate 'https://drive.usercontent.google.com/download?id=1wgxjih8YZ-cqLqaZVa0lA3h3Y029c3oI&export=download' > /dev/null 2>&1

zfs receive otus/test@today < otus_task2.file > /dev/null 2>&1

echo "Secret message from /otus/test/task1/file_mess/secret_message:"
cat /otus/test/task1/file_mess/secret_message
#-------------------------------------------------------------