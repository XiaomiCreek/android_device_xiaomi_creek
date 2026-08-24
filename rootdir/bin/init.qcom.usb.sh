#!/vendor/bin/sh
# Copyright (c) 2012-2018, 2020-2021 The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of The Linux Foundation nor the names of its
#       contributors may be used to endorse or promote products derived
#      from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#

# Set platform variables
soc_hwplatform=`cat /sys/devices/soc0/hw_platform 2> /dev/null`
soc_machine=`cat /sys/devices/soc0/machine 2> /dev/null`
soc_machine=${soc_machine:0:2}
soc_id=`cat /sys/devices/soc0/soc_id 2> /dev/null`

#
# Check ESOC for external modem
#
# Note: currently only a single MDM/SDX is supported
#
esoc_name=`cat /sys/bus/esoc/devices/esoc0/esoc_name 2> /dev/null`

target=`getprop ro.board.platform`

#
# Override USB default composition
#
# If USB persist config not set, set default configuration
if [ "$(getprop persist.vendor.usb.config)" == "" -a "$(getprop ro.build.type)" != "user" ]; then
    setprop persist.vendor.usb.config adb
fi

# This check is needed for GKI 1.0 targets where QDSS is not available
if [ "$(getprop persist.vendor.usb.config)" == "diag,serial_cdev,rmnet,dpl,qdss,adb" -a \
     ! -d /config/usb_gadget/g1/functions/qdss.qdss ]; then
      setprop persist.vendor.usb.config diag,serial_cdev,rmnet,dpl,adb
fi

# Start peripheral mode on primary USB controllers for Automotive platforms
case "$soc_machine" in
    "SA")
	if [ -f /sys/bus/platform/devices/a600000.ssusb/mode ]; then
	    default_mode=`cat /sys/bus/platform/devices/a600000.ssusb/mode`
	    case "$default_mode" in
		"none")
		    echo peripheral > /sys/bus/platform/devices/a600000.ssusb/mode
		;;
	    esac
	fi
    ;;
esac

# check configfs is mounted or not
if [ -d /config/usb_gadget ]; then
	machine_type=`cat /sys/devices/soc0/machine`

	# Chip ID & serial are used for unique MSM identification in Product String
	# If not present, then omit them instead of using 0x00000000
	msm_chipid=`cat /sys/devices/soc0/nproduct_id`;
	if [ "$msm_chipid" != "" ]; then
		msm_chipid_hex=`printf _CID:%04X $msm_chipid`
	fi

	msm_serial=`cat /sys/devices/soc0/serial_number`;
	if [ "$msm_serial" != "" ]; then
		msm_serial_hex=`printf _SN:%08X $msm_serial`
	fi

	setprop vendor.usb.product_string "$machine_type-$soc_hwplatform$msm_chipid_hex$msm_serial_hex"

	# ADB requires valid iSerialNumber; if ro.serialno is missing, use dummy
	serialnumber=`cat /config/usb_gadget/g1/strings/0x409/serialnumber 2> /dev/null`
	if [ "$serialnumber" == "" ]; then
		serialno=1234567
		echo $serialno > /config/usb_gadget/g1/strings/0x409/serialnumber
	fi
	setprop vendor.usb.configfs 1
fi

#
# Initialize RNDIS Diag option. If unset, set it to 'none'.
#
diag_extra=`getprop persist.vendor.usb.config.extra`
if [ "$diag_extra" == "" ]; then
	setprop persist.vendor.usb.config.extra none
fi

# update product
if [ "$(getprop ro.boot.factorybuild)" != "1" ]; then
	marketname=`getprop ro.product.marketname`
	if [ "$marketname" != "" ]; then
	    setprop vendor.usb.product_string "$marketname"
	else
	    setprop vendor.usb.product_string "$(getprop ro.product.model)"
	fi
fi


# enable rps cpus on msm8937 target
setprop vendor.usb.rps_mask 0
case "$soc_id" in
	"294" | "295" | "353" | "354")
		setprop vendor.usb.rps_mask 40
	;;
esac

#
# Initialize UVC0 conifguration.
#
if [ -d /config/usb_gadget/g1/functions/uvc.0 ]; then
	setprop vendor.usb.uvc.function.init 1
fi

#
# Initialize multi uvc conifguration.
#
if [ "$(getprop persist.vendor.usb.multi.uvc)" == "true" ]; then
	for i in 1 2 3 4 5 6 7 8 9 10
	do
		if [ -d /config/usb_gadget/g1/functions/uvc.$i ]; then
			cd /config/usb_gadget/g1/functions/uvc.$i

			echo 1024 > streaming_maxpacket
			echo 0 > streaming_maxburst
			mkdir control/header/h
			ln -s control/header/h control/class/fs/
			ln -s control/header/h control/class/ss

			mkdir -p streaming/uncompressed/u/360p
			echo -e "166666\n333333\n666666\n1000000\n5000000\n" > streaming/uncompressed/u/360p/dwFrameInterval
			echo 333333 > streaming/uncompressed/u/360p/dwDefaultFrameInterval

			mkdir -p streaming/mjpeg/m/360p
			echo 640 > streaming/mjpeg/m/360p/wWidth
			echo 360 > streaming/mjpeg/m/360p/wHeight
			echo 460800   > streaming/mjpeg/m/360p/dwMaxVideoFrameBufferSize
			echo 18432000  > streaming/mjpeg/m/360p/dwMinBitRate
			echo 55296000 > streaming/mjpeg/m/360p/dwMaxBitRate
			echo -e "166666\n333333\n666666\n1000000\n5000000\n" > streaming/mjpeg/m/360p/dwFrameInterval
			echo 333333 > streaming/mjpeg/m/360p/dwDefaultFrameInterval

			echo 0x04 > /config/usb_gadget/g1/functions/uvc.$i/streaming/mjpeg/m/bmaControls

			mkdir -p streaming/h264/h/360p
			echo 640 > streaming/h264/h/360p/wWidth
			echo 360 > streaming/h264/h/360p/wHeight
			echo 12288000 > streaming/h264/h/360p/dwMinBitRate
			echo 36864000 > streaming/h264/h/360p/dwMaxBitRate
			echo 333333 > streaming/h264/h/360p/dwDefaultFrameInterval
			echo -e "166666\n333333\n666666\n1000000\n5000000\n" > streaming/h264/h/360p/dwFrameInterval

			mkdir streaming/header/h
			ln -s streaming/uncompressed/u streaming/header/h
			ln -s streaming/mjpeg/m streaming/header/h
			ln -s streaming/h264/h streaming/header/h
			ln -s streaming/header/h streaming/class/fs/
			ln -s streaming/header/h streaming/class/hs/
			ln -s streaming/header/h streaming/class/ss/
		fi
	done
fi

if [ -d /config/usb_gadget/g1/functions/uac2.0 ]; then
	setprop vendor.usb.uac2.function.init 1
fi