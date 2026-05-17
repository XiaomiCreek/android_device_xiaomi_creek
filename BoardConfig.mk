#
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/xiaomi/creek
KERNEL_PATH := $(DEVICE_PATH)-kernel

# Broken Rules (Required for blob compatibility)
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_VINTF_PRODUCT_COPY_FILES := true
BUILD_BROKEN_PREBUILT_UI_HAL := true
BUILD_BROKEN_MISSING_PGO_STATS := true

# Tell the build system to ignore missing dexpreopt artifacts
DISABLE_DEXPREOPT_CHECK := true
WITH_DEXPREOPT := false

# Allow SOONG missing dependencies
SOONG_ALLOW_MISSING_DEPENDENCIES := true

# Primary Architecture (64-bit)
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT_RUNTIME := cortex-a73

# Secondary Architecture (32-bit)
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a53

# Boot control
$(call soong_config_set, ufsbsg, ufsframework, bsg)

# Camera
$(call soong_config_set_bool, camera, override_format_from_reserved, true)

# Platform
TARGET_BOARD_PLATFORM := bengal
TARGET_BOARD_SUFFIX := _515
TARGET_BOOTLOADER_BOARD_NAME := bengal
BOARD_USES_QCOM_HARDWARE := true

# Partition Mapping
TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
TARGET_COPY_OUT_ODM := odm
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm
TARGET_COPY_OUT_SYSTEM_DLKM := system_dlkm

# Device tree blobs formating
BOARD_KERNEL_SEPARATED_DTBO := true
BOARD_INCLUDE_DTB_IN_BOOTIMG := false
BOARD_INCLUDE_DTB_IN_VENDOR_BOOT := true

# GKI 2.0 Standards
BOARD_USES_GENERIC_KERNEL_IMAGE := true
BOARD_COPY_BOOT_IMAGE_TO_INIT_BOOT := true

# Kernel (TEMP PREBUILT FOR BRING-UP ONLY)
BOARD_KERNEL_IMAGE_NAME := Image
TARGET_PREBUILT_KERNEL := $(KERNEL_PATH)/kernel
TARGET_FORCE_PREBUILT_KERNEL := true

# DTB & DTBO (FOR BRING-UP ONLY)
BOARD_PREBUILT_DTBOIMAGE := $(KERNEL_PATH)/dtbs/dtbo.img
BOARD_PREBUILT_DTBIMAGE_FILE := $(KERNEL_PATH)/dtbs/dtb.img

PRODUCT_COPY_FILES += \
    $(BOARD_PREBUILT_DTBIMAGE_FILE):dtb.img

# Basic kernel cmdline
BOARD_KERNEL_CMDLINE := \
    console=ttyMSM0,115200n8 \
    androidboot.hardware=qcom \
    androidboot.selinux=permissive \
    rcu_nocbs=all \
    rcu_normal=1 \
    rcu_expedited=1 \
    kasan=off \
    mtdoops.fingerprint=creek:13/OS3.0.10.0.WBOMIXM:user
#    qcom_geni_serial.con_enabled=0 # uncomment when device boots successfully.


BOARD_BOOTCONFIG := \
    androidboot.hardware=qcom \
    androidboot.memcg=1 \
    androidboot.usbcontroller=4e00000.dwc3

# Modules for First Stage (Ramdisk) - Critical for mounting /system
BOARD_VENDOR_RAMDISK_KERNEL_MODULES := $(wildcard $(KERNEL_PATH)/modules/vendor_ramdisk/*.ko)

# Modules for the rest of the Hardware (Vendor/System DLKM)
BOARD_VENDOR_KERNEL_MODULES := $(wildcard $(KERNEL_PATH)/modules/vendor_dlkm/*.ko)
BOARD_SYSTEM_KERNEL_MODULES := $(wildcard $(KERNEL_PATH)/modules/system_dlkm/*.ko)

# Boot Image Headers
BOARD_KERNEL_PAGESIZE := 4096
BOARD_BOOT_HEADER_VERSION := 4
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_INIT_BOOT_HEADER_VERSION := 4
BOARD_MKBOOTIMG_INIT_ARGS += --header_version $(BOARD_INIT_BOOT_HEADER_VERSION)
BOARD_RECOVERY_HEADER_VERSION := 4
BOARD_RECOVERY_MKBOOTIMG_ARGS := --header_version $(BOARD_RECOVERY_HEADER_VERSION)

# Offsets
BOARD_KERNEL_BASE := 0x00000000
BOARD_VENDOR_BASE := 0x00000000
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x01000000
BOARD_TAGS_OFFSET := 0x00000100
BOARD_DTB_OFFSET := 0x01f00000

# A/B & Metadata
AB_OTA_UPDATER := true
BOARD_USES_METADATA_PARTITION := true
BOARD_SUPER_PARTITION_METADATA_DEVICE := super

# Virtual A/B block-based OTA Config
BOARD_VIRTUAL_AB_OTAPREOPT := true
BOARD_VIRTUAL_AB_COMPRESSION := true
BOARD_VIRTUAL_AB_COMPRESSION_METHOD := lz4
BOARD_VIRTUAL_AB_COW_VERSION := 3

# AB OTA partitions list
AB_OTA_PARTITIONS += \
    boot dtbo init_boot odm product system system_dlkm system_ext vbmeta vbmeta_system vendor vendor_boot vendor_dlkm

# Filesystem Types
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_SYSTEM_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
TARGET_USERIMAGES_USE_EXT4 := true  # Support for fallback / tooling
TARGET_USERIMAGES_USE_F2FS := true

# Filesystem
TARGET_FS_CONFIG_GEN := $(DEVICE_PATH)/configs/config.fs

# EROFS Config
BOARD_EROFS_PAGESIZE := 4096
BOARD_EROFS_PCLUSTER_SIZE := 262144
BOARD_EROFS_COMPRESSOR := lz4
BOARD_EROFS_COMMAND_LINE := -zlz4hc,9
BOARD_RAMDISK_USE_LZ4 := true

# Dynamic Partitions
BOARD_SUPER_PARTITION_SIZE := 9126805504
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := odm product system system_dlkm system_ext vendor vendor_dlkm
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 9122611200

# Partition Sizes
BOARD_BOOTIMAGE_PARTITION_SIZE := 0x06000000
BOARD_DTBOIMG_PARTITION_SIZE := 0x01800000
BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE := 0x00800000
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 0x06000000
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x06400000
BOARD_FLASH_BLOCK_SIZE := 262144

# Global LTO
TARGET_GLOBAL_LTO := thin
TARGET_GLOBAL_OPTIMIZATION := O3
TARGET_GLOBAL_THINLTO := true

# Enable PD locater/notifier
TARGET_PD_SERVICE_ENABLED := true

# Enable peripheral manager
TARGET_PER_MGR_ENABLED := true

# Security
BOOT_SECURITY_PATCH := 2026-01-05
VENDOR_SECURITY_PATCH := $(BOOT_SECURITY_PATCH)

# Android Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
BOARD_MOVE_GSI_AVB_KEYS_TO_VENDOR_BOOT := true

# AVB Algorithms & Keys
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1

BOARD_AVB_DTBO_ALGORITHM := SHA256_RSA4096
BOARD_AVB_DTBO_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_DTBO_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_DTBO_ROLLBACK_INDEX_LOCATION := 3

BOARD_AVB_BOOT_ALGORITHM := SHA256_RSA4096
BOARD_AVB_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_BOOT_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_BOOT_ROLLBACK_INDEX_LOCATION := 4

BOARD_AVB_VENDOR_BOOT_ALGORITHM := SHA256_RSA4096
BOARD_AVB_VENDOR_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_VENDOR_BOOT_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VENDOR_BOOT_ROLLBACK_INDEX_LOCATION := 5

BOARD_AVB_INIT_BOOT_ALGORITHM := SHA256_RSA4096
BOARD_AVB_INIT_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_INIT_BOOT_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_INIT_BOOT_ROLLBACK_INDEX_LOCATION := 6

# VBMETA System Configuration
BOARD_AVB_VBMETA_SYSTEM := product system system_dlkm system_ext
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA4096
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 2

# Use sha256 hash algorithm for system_dlkm partition
BOARD_AVB_SYSTEM_DLKM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_VENDOR_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_VENDOR_DLKM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_ODM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256

# Safe Recovery / Fastbootd
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.default
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888

# Properties
TARGET_ODM_PROP = $(DEVICE_PATH)/configs/properties/odm.prop
TARGET_PRODUCT_PROP = $(DEVICE_PATH)/configs/properties/product.prop
TARGET_SYSTEM_PROP := $(DEVICE_PATH)/configs/properties/system.prop
TARGET_SYSTEM_EXT_PROP = $(DEVICE_PATH)/configs/properties/system_ext.prop
TARGET_VENDOR_PROP = $(DEVICE_PATH)/configs/properties/vendor.prop

# VINTF Manifests & Compatibility
DEVICE_MANIFEST_FILE += \
    $(DEVICE_PATH)/configs/vintf/manifest.xml \
    $(DEVICE_PATH)/configs/vintf/network_manifest.xml
DEVICE_FRAMEWORK_MANIFEST_FILE += \
    $(DEVICE_PATH)/configs/vintf/framework_manifest.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := \
    $(DEVICE_PATH)/configs/vintf/framework_compatibility_matrix.xml \
    hardware/lineage/interfaces/compatibility_matrices/compatibility_matrix.lineage.xml
DEVICE_MATRIX_FILE += \
    $(DEVICE_PATH)/configs/vintf/compatibility_matrix.xml \
    hardware/qcom-caf/common/compatibility_matrix.xml

# Inherit Qualcomm and Xiaomi common policies
include device/qcom/sepolicy_vndr/sm6225/SEPolicy.mk
include device/xiaomi/sepolicy/SEPolicy.mk
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/private
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/public

# Ignore neverallow violations for initial bring-up on creek
SELINUX_IGNORE_NEVERALLOWS := true

# Display
TARGET_SCREEN_DENSITY := 420
TARGET_GRALLOC_HANDLE_HAS_RESERVED_SIZE := true

# Add removable storage support
BOARD_HAS_REMOVABLE_STORAGE := true

# RIL
ENABLE_VENDOR_RIL_SERVICE := true

# WiFi
BOARD_WLAN_DEVICE := qcwcn
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_DRIVER := $(BOARD_HOSTAPD_DRIVER)
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := $(BOARD_HOSTAPD_PRIVATE_LIB)
BOARD_WPA_SUPPLICANT_PRIVATE_LIB_EVENT := "ON"
CONFIG_IEEE80211AX := true
WIFI_DRIVER_STATE_CTRL_PARAM := "/dev/wlan"
WIFI_DRIVER_STATE_OFF := "OFF"
WIFI_DRIVER_STATE_ON := "ON"
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
WPA_SUPPLICANT_VERSION := VER_0_8_X
