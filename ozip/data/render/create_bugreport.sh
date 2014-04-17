#!/system/bin/sh

###
# ATTENTION:
###
##
# This script should be ALMOST an exact copy of the script
# "create_bugreport_delayed.sh". Make sure to keep BOTH UP TO DATE.
#
# The difference is that the other script execution is delayed by
# X seconds. Why? Because some information can only be obtained after
# certain phases of the boot process have occurred.
##


# Copyright (c) 2013, lioux
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#  - Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#  - Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
# THE POSSIBILITY OF SUCH DAMAGE.


# You require ROOT and BUSYBOX to use this script


###
## Variables
###

# Timestamp
DATE_FORMAT="%Y%m%d_%Hh_%Mm_%Ss"
TIMESTAMP=$(busybox date +${DATE_FORMAT})

# Some file/directory locations
LAST_KMSG="/proc/last_kmsg"
REPORT_DIR="/cache/bugreport_${TIMESTAMP}/"
REPORT_FILE="/sdcard/bugreport_${TIMESTAMP}.tar.bz2"

###
## Functions
###

obtain_dmesg() {
  FILE_OUTPUT="dmesg.txt"

  ${DEBUG} busybox dmesg > "${REPORT_DIR}/${FILE_OUTPUT}"
}

obtain_dumpstate() {
  FILE_OUTPUT="dumpstate.txt"

  ${DEBUG} dumpstate -q > "${REPORT_DIR}/${FILE_OUTPUT}"
}

obtain_dumpsys_specific() {
  DUMP_SERVICE="${1}"

  ${DEBUG} dumpsys ${DUMP_SERVICE} > "${REPORT_DIR}/dumpsys_${DUMP_SERVICE}.txt" 2>/dev/null
}

obtain_dumpsys() {
  obtain_dumpsys_specific activity
  obtain_dumpsys_specific alarm
  obtain_dumpsys_specific battery
  obtain_dumpsys_specific batteryinfo
  obtain_dumpsys_specific connectivity
  obtain_dumpsys_specific cpuinfo
  obtain_dumpsys_specific diskstats
  obtain_dumpsys_specific display
  obtain_dumpsys_specific entropy
  obtain_dumpsys_specific gfxinfo
  obtain_dumpsys_specific hardware
  obtain_dumpsys_specific input
  obtain_dumpsys_specific input_method
  obtain_dumpsys_specific meminfo
  obtain_dumpsys_specific mount
  obtain_dumpsys_specific netpolicy
  obtain_dumpsys_specific netstats
  obtain_dumpsys_specific phone
  obtain_dumpsys_specific power
  obtain_dumpsys_specific samplingprofiler
  obtain_dumpsys_specific scheduling_policy
  obtain_dumpsys_specific uimode
  obtain_dumpsys_specific updatelock
  obtain_dumpsys_specific usagestats
  obtain_dumpsys_specific usb
# wifi gives TOO MUCH information about your network
# enable it at your own discretion
#  obtain_dumpsys_specific wifi
  obtain_dumpsys_specific wifip2p
}

obtain_last_kmsg() {
  if [ -f "${LAST_KMSG}" ]; then 
    ${DEBUG} cp "${LAST_KMSG}" "${REPORT_DIR}"
  fi
}

obtain_logcat() {
  FILE_OUTPUT="logcat_last_10000_lines.txt"

  ${DEBUG} logcat -d -f "${REPORT_DIR}/${FILE_OUTPUT}" -t 10000 
}

obtain_uname() {
  FILE_OUTPUT="uname.txt"

  ${DEBUG} busybox uname -a > "${REPORT_DIR}/${FILE_OUTPUT}"
} 

create_report_directory() {
  remove_report_directory

  ${DEBUG} busybox mkdir -p "${REPORT_DIR}"
}

remove_report_directory() {
  if [ -d "${REPORT_DIR}" ]; then
    ${DEBUG} busybox rm -Rf "${REPORT_DIR}"
  fi
}

create_bugreport() {
  ${DEBUG} busybox tar -C "${REPORT_DIR}" -c -f - . | \
    busybox bzip2 -c -9 > "${REPORT_FILE}"
}

###
## Execute
###

create_report_directory

obtain_dmesg

# dumpstate takes a while and generates about 7MiB of information
# only uncomment if necessary
#obtain_dumpstate

obtain_dumpsys

obtain_last_kmsg

obtain_logcat

obtain_uname

create_bugreport

remove_report_directory
