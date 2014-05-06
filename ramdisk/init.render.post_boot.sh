#!/system/bin/sh

############################
# various tweaks from CM
#
target=`getprop ro.board.platform`
debuggable=`getprop ro.debuggable`
emmc_boot=`getprop ro.boot.emmc`

echo 2 > /sys/module/lpm_levels/enable_low_power/l2
soc_revision=`cat /sys/devices/soc0/revision`
if [ "$soc_revision" != "1.0" ]; then
		echo 1 > /sys/module/lpm_resources/enable_low_power/pxo
fi

product=`getprop ro.boot.device`
if [ "$product" == "falcon" ]; then
	if [ "$soc_revision" == "1.0" ]; then
		echo 1 > /sys/kernel/debug/clk/cxo_lpm_clk/enable
	fi
fi

case "$emmc_boot"
    in "true")
        chown -h system /sys/devices/platform/rs300000a7.65536/force_sync
        chown -h system /sys/devices/platform/rs300000a7.65536/sync_sts
        chown -h system /sys/devices/platform/rs300100a7.65536/force_sync
        chown -h system /sys/devices/platform/rs300100a7.65536/sync_sts
    ;;
esac

echo 1 > /sys/module/msm_pm/modes/cpu0/power_collapse/suspend_enabled
echo 1 > /sys/module/msm_pm/modes/cpu1/power_collapse/suspend_enabled
echo 1 > /sys/module/msm_pm/modes/cpu2/power_collapse/suspend_enabled
echo 1 > /sys/module/msm_pm/modes/cpu3/power_collapse/suspend_enabled
echo 1 > /sys/module/msm_pm/modes/cpu0/standalone_power_collapse/suspend_enabled
echo 1 > /sys/module/msm_pm/modes/cpu1/standalone_power_collapse/suspend_enabled
echo 1 > /sys/module/msm_pm/modes/cpu2/standalone_power_collapse/suspend_enabled
echo 1 > /sys/module/msm_pm/modes/cpu3/standalone_power_collapse/suspend_enabled
echo 1 > /sys/module/msm_pm/modes/cpu0/standalone_power_collapse/idle_enabled
echo 1 > /sys/module/msm_pm/modes/cpu1/standalone_power_collapse/idle_enabled
echo 1 > /sys/module/msm_pm/modes/cpu2/standalone_power_collapse/idle_enabled
echo 1 > /sys/module/msm_pm/modes/cpu3/standalone_power_collapse/idle_enabled
echo 1 > /sys/module/msm_pm/modes/cpu0/power_collapse/idle_enabled
echo 1 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu2/online
echo 1 > /sys/devices/system/cpu/cpu3/online
echo 1 > /sys/kernel/power_suspend/power_suspend_mode
chmod 664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chown -h system /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
chown -h system /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chown -h root.system /sys/devices/system/cpu/cpu1/online
chown -h root.system /sys/devices/system/cpu/cpu2/online
chown -h root.system /sys/devices/system/cpu/cpu3/online
chmod -h 664 /sys/devices/system/cpu/cpu1/online
chmod -h 664 /sys/devices/system/cpu/cpu2/online
chmod -h 664 /sys/devices/system/cpu/cpu3/online


############################
# Showp's MPDEC activate
#
echo 1 > /sys/kernel/msm_mpdecision/conf/enabled

############################
# Disable Faux's Intelliplug
#
#echo 0 > /sys/module/intelli_plug_parameters/intelli_plug_active

############################
# mount debugfs
#
mount -t debugfs nodev /sys/kernel/debug

############################
# Tweak UKSM
#
chown root system /sys/kernel/mm/uksm/cpu_governor
chown root system /sys/kernel/mm/uksm/run
chown root system /sys/kernel/mm/uksm/sleep_millisecs
chown root system /sys/kernel/mm/uksm/max_cpu_percentage
chmod 644 /sys/kernel/mm/uksm/cpu_governor
chmod 664 /sys/kernel/mm/uksm/sleep_millisecs
chmod 664 /sys/kernel/mm/uksm/run
chmod 644 /sys/kernel/mm/uksm/max_cpu_percentage
echo 1 > /sys/kernel/mm/uksm/run
echo 100 > /sys/kernel/mm/uksm/sleep_millisecs
echo medium > /sys/kernel/mm/uksm/cpu_governor
echo 25 > /sys/kernel/mm/uksm/max_cpu_percentage

############################
# Tweak ZSWAP
#
echo 70 > /proc/sys/vm/swappiness

############################
# Init VNSWAP
#
#echo 402653184 > /sys/block/vnswap0/disksize
#mkswap /dev/block/vnswap0
#swapon /dev/block/vnswap0

############################
# render tweaks
#
echo 8 > /proc/sys/vm/page-cluster
echo 1 > /proc/sys/kernel/multi_threading


############################
# Script to launch frandom at boot by Ryuinferno @ XDA
#
chmod 644 /dev/frandom
chmod 644 /dev/erandom
mv /dev/random /dev/random.ori
mv /dev/urandom /dev/urandom.ori
ln /dev/frandom /dev/random
chmod 644 /dev/random
ln /dev/erandom /dev/urandom
chmod 644 /dev/urandom
