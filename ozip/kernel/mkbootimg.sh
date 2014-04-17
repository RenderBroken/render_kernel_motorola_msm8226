#!/sbin/sh
sed 's/zswap.enabled=1 zswap.compressor=snappy/zswap.enabled=1 zswap.compressor=lz4/g' -i /tmp/boot.img-cmdline
sed 's/zcache/zswap.enabled=1 zswap.compressor=lz4/g' -i /tmp/boot.img-cmdline
echo \#!/sbin/sh > /tmp/createnewboot.sh
echo /tmp/mkbootimg --kernel /tmp/zImage-dtb --ramdisk /tmp/newramdisk.cpio.gz --cmdline \"$(cat /tmp/boot.img-cmdline)\" --base 0x$(cat /tmp/boot.img-base) --pagesize 2048 --output /tmp/newboot.img >> /tmp/createnewboot.sh
chmod 777 /tmp/createnewboot.sh
/tmp/createnewboot.sh
return $?
