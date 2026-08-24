#!/vendor/bin/sh
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# creek: enable ZRAM sized at RUNTIME from actual RAM size.
#
# Stock enabled compressed swap via perfservice.rc ("swapon_all
# /vendor/etc/fstab.default"), a chain lost in Lineage (no Xiaomi
# system_ext); the QTI fallback (configure_zarm_parameters in
# init.kernel.post_boot*.sh) races with module loading and only runs
# at sys.boot_completed, leaving Total swap = 0kB (see dmesg).
#
# Sizing follows the QTI rule for non-Go targets:
#   <= 2GB RAM -> 75% of RAM, otherwise 50% of RAM, capped at 4096MB.
# This covers every shipping variant (4GB/6GB/8GB) automatically.

MEM_LINE=$(grep MemTotal /proc/meminfo)
set -- ${MEM_LINE}
MemTotalKB=$2
[ -n "${MemTotalKB}" ] || exit 1

RamSizeMB=$(( MemTotalKB / 1024 ))
if [ "${RamSizeMB}" -le 2048 ]; then
    ZRAM_MB=$(( RamSizeMB * 3 / 4 ))
else
    ZRAM_MB=$(( RamSizeMB / 2 ))
fi

# Cap at 4GB (32-bit safe math above keeps values in MB)
if [ "${ZRAM_MB}" -gt 4096 ]; then
    ZRAM_MB=4096
fi

# Wait for the zram block device (module may still be probing)
tries=0
while [ ! -e /sys/block/zram0/disksize ] && [ "${tries}" -lt 50 ]; do
    sleep 0.2
    tries=$(( tries + 1 ))
done
[ -e /sys/block/zram0/disksize ] || exit 1

# Prefer lz4 latency over the kernel default; fall back silently
echo lz4 > /sys/block/zram0/comp_algorithm 2>/dev/null

# ZRAM may use more memory than it saves if SLAB_STORE_USER debug is on
if [ -e /sys/kernel/slab/zs_handle ]; then
    echo 0 > /sys/kernel/slab/zs_handle/store_user
fi
if [ -e /sys/kernel/slab/zspage ]; then
    echo 0 > /sys/kernel/slab/zspage/store_user
fi
if [ -e /sys/block/zram0/use_dedup ]; then
    echo 1 > /sys/block/zram0/use_dedup
fi

echo "${ZRAM_MB}M" > /sys/block/zram0/disksize
mkswap /dev/block/zram0
swapon /dev/block/zram0 -p 32758
