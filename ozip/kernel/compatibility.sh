#!/sbin/sh

# clean init.d scripts
INITD_DIR=/system/etc/init.d

# slim
rm -rf $INITD_DIR/01mpdecision

# pink
rm -rf $INITD_DIR/98pink
rm -rf /system/etc/init.pink.post_boot.sh
rm -rf /system/etc/thermal-engine-pink.conf
rm -rf /system/addon.d/98-pink.sh
rm -rf /init.pink.post_boot.sh

# remove the binaries as they are no longer needed. (kernel handled)
if [ -e /system/bin/mpdecision ] ; then
	busybox mv /system/bin/mpdecision /system/bin/mpdecision_bck
fi
#if [ -e /system/bin/thermald ] ; then
#	busybox mv /system/bin/thermald /system/bin/thermald_bck
#fi

# remove dalvik cache
#rm -rf /data/dalvik-cache
#rm -rf /cache/dalvik-cache

# copy old kernel to sdcard
if [ ! -e /sdcard/pre_render_boot ]; then
	cp /tmp/boot.img /sdcard/pre_render_boot.img
fi
