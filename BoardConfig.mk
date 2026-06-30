#
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#


# Inherit from the proprietary version
include vendor/xiaomi/creek/BoardConfigVendor.mk

DEVICE_PATH := device/xiaomi/creek
KERNEL_PATH := $(DEVICE_PATH)-kernel

# ==============================================
# Bring-up & Compiler Broken Rules Overrides
# ==============================================

BUILD_BROKEN_DUP_RULES                       := true
RELAX_USES_LIBRARY_CHECK                     := true
ALLOW_MISSING_DEPENDENCIES                   := true
SOONG_ALLOW_MISSING_DEPENDENCIES             := true
BUILD_BROKEN_INCORRECT_PARTITION_IMAGES      := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Global LTO
TARGET_GLOBAL_LTO                            := thin
TARGET_GLOBAL_OPTIMIZATION                   := O3
TARGET_GLOBAL_THINLTO                        := true

# Init
TARGET_RECOVERY_DEVICE_MODULES               := init_creek
TARGET_RECOVERY_DEVICE_MODULES               += init.recovery.qcom.rc


# ==============================================
# CPU & Hardware Architecture
# ==============================================

# Primary Architecture (64-bit)
TARGET_ARCH                        := arm64
TARGET_CPU_ABI                     := arm64-v8a
TARGET_ARCH_VARIANT                := armv8-a
TARGET_CPU_VARIANT_RUNTIME         := cortex-a73

# Secondary Architecture (32-bit)
TARGET_2ND_ARCH                    := arm
TARGET_2ND_CPU_ABI                 := armeabi-v7a
TARGET_2ND_CPU_ABI2                := armeabi
TARGET_2ND_ARCH_VARIANT            := armv8-a
TARGET_2ND_CPU_VARIANT_RUNTIME     := cortex-a53

# Platform
TARGET_BOARD_SUFFIX                := _515
TARGET_BOARD_PLATFORM              := bengal
BOARD_USES_QCOM_HARDWARE           := true
TARGET_BOOTLOADER_BOARD_NAME       := bengal


# ==============================================
# Kernel Configurations (Prebuilt & Modules)
# ==============================================

# Target Architecture
TARGET_KERNEL_ARCH                  := arm64
TARGET_KERNEL_VERSION               := 5.15
TARGET_KERNEL_HEADER_ARCH           := arm64

# Emulated Inline Prebuilt Structure
TARGET_FORCE_PREBUILT_KERNEL        := true
TARGET_NO_KERNEL_OVERRIDE           := true
INLINE_KERNEL_BUILDING              := true
TARGET_KERNEL_SOURCE                := $(KERNEL_PATH)/kernel-headers

# Prebuilt Binary Mapping
BOARD_KERNEL_IMAGE_NAME             := Image
TARGET_PREBUILT_KERNEL              := $(KERNEL_PATH)/kernel
PRODUCT_COPY_FILES                  += $(TARGET_PREBUILT_KERNEL):kernel

# DTB & DTBO Staging
BOARD_USES_DT                       := true
BOARD_INCLUDE_DTB_IN_BOOTIMG        := true
BOARD_KERNEL_SEPARATED_DTBO         := true
BOARD_PREBUILT_DTBIMAGE_DIR         := $(KERNEL_PATH)/dtbs
BOARD_PREBUILT_DTBOIMAGE            := $(KERNEL_PATH)/dtbs/dtbo.img

# Basic kernel cmdline
BOARD_KERNEL_CMDLINE := \
    console=ttyMSM0,115200n8 \
    androidboot.selinux=permissive \
    disable_dma32=on \
    rcu_nocbs=all \
    rcutree.enable_rcu_lazy=1 \
    rcu_normal=1 \
    rcu_expedited=1 \
    kasan=off
#    qcom_geni_serial.con_enabled=0 # uncomment when device boots successfully.

BOARD_BOOTCONFIG := \
    androidboot.hardware=qcom \
    androidboot.memcg=1 \
    androidboot.usbcontroller=4e00000.dwc3

# Modules for First Stage (Ramdisk) - Critical for mounting /system
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD           := $(strip $(shell cat  $(KERNEL_PATH)/vendor_ramdisk/modules.load))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_BLOCKLIST_FILE := $(KERNEL_PATH)/vendor_ramdisk/modules.blocklist

# Modules for the rest of the Hardware (Vendor DLKM)
BOARD_VENDOR_KERNEL_MODULES_LOAD                   := $(strip $(shell cat $(KERNEL_PATH)/vendor_dlkm/modules.load))
BOARD_VENDOR_KERNEL_MODULES_BLOCKLIST_FILE         :=  $(KERNEL_PATH)/vendor_dlkm/modules.blocklist

# Modules for the rest of the Hardware (System DLKM)
BOARD_SYSTEM_KERNEL_MODULES_LOAD                   := $(strip $(shell cat $(KERNEL_PATH)/system_dlkm/modules.load))
BOARD_SYSTEM_KERNEL_MODULES_BLOCKLIST_FILE         :=  $(KERNEL_PATH)/system_dlkm/modules.blocklist

# Modules for the rest of the Hardware (RECOVERY)
BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD  := $(strip $(shell cat $(KERNEL_PATH)/vendor_ramdisk/modules.load.recovery))

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(KERNEL_PATH)/system_dlkm/,$(TARGET_COPY_OUT_SYSTEM_DLKM)/lib/modules/5.15.178) \
    $(call find-copy-subdir-files,*,$(KERNEL_PATH)/vendor_dlkm/,$(TARGET_COPY_OUT_VENDOR_DLKM)/lib/modules) \
    $(call find-copy-subdir-files,*,$(KERNEL_PATH)/vendor_ramdisk/,$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules)


# ==============================================
# Boot Image Headers & Memory Offsets
# ==============================================

# Boot Header (GKI 2.0 Standards)
BOARD_USES_GENERIC_KERNEL_IMAGE    := true

BOARD_BOOT_HEADER_VERSION          := 4
BOARD_MKBOOTIMG_ARGS               += --header_version $(BOARD_BOOT_HEADER_VERSION)

BOARD_INIT_BOOT_HEADER_VERSION     := 4
BOARD_MKBOOTIMG_INIT_ARGS          += --header_version $(BOARD_INIT_BOOT_HEADER_VERSION)

# Partition Memory Offsets
BOARD_DTB_OFFSET                   := 0x01f00000
BOARD_KERNEL_BASE                  := 0x00000000
BOARD_TAGS_OFFSET                  := 0x00000100
BOARD_KERNEL_OFFSET                := 0x00008000
BOARD_RAMDISK_OFFSET               := 0x01000000
BOARD_KERNEL_PAGESIZE              := 4096


# ==============================================
# Dynamic & Physical Partition Layouts
# ==============================================

# Partition Target Maps
TARGET_COPY_OUT_ODM                            := odm
TARGET_COPY_OUT_VENDOR                         := vendor
TARGET_COPY_OUT_PRODUCT                        := product
TARGET_COPY_OUT_SYSTEM_EXT                     := system_ext
TARGET_COPY_OUT_VENDOR_DLKM                    := vendor_dlkm
TARGET_COPY_OUT_SYSTEM_DLKM                    := system_dlkm

# Physical Image Sizes
BOARD_FLASH_BLOCK_SIZE                         := 262144
BOARD_DTBOIMG_PARTITION_SIZE                   := 8388608
BOARD_BOOTIMAGE_PARTITION_SIZE                 := 100663296
BOARD_RECOVERYIMAGE_PARTITION_SIZE             := 104857600
BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE           := 8388608
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE          := 100663296

# Super & Dynamic Partition Framework Config
BOARD_SUPER_PARTITION_SIZE                     := 9126805504
BOARD_SUPER_PARTITION_GROUPS                   := xiaomi_dynamic_partitions
BOARD_XIAOMI_DYNAMIC_PARTITIONS_SIZE           := 9122611200
BOARD_SUPER_PARTITION_METADATA_DEVICE          := super
BOARD_XIAOMI_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    odm \
    product \
    system \
    system_dlkm \
    system_ext \
    vendor \
    vendor_dlkm


# ==============================================
# Filesystems & Storage Configuration
# ==============================================

TARGET_FS_CONFIG_GEN                    := $(DEVICE_PATH)/configs/config.fs
#BOARD_HAS_REMOVABLE_STORAGE             := true

# Filesystem Types Selection
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE         := erofs
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE      := erofs
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE      := erofs
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE     := erofs
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE    := f2fs
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE  := erofs
BOARD_SYSTEM_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs

# Host Tooling Fallback Targets
TARGET_USERIMAGES_USE_EXT4              := true
TARGET_USERIMAGES_USE_F2FS              := true

# EROFS & Ramdisk Compression Tunables
BOARD_EROFS_PAGESIZE                    := 4096
BOARD_RAMDISK_USE_LZ4                   := true
BOARD_EROFS_COMPRESSOR                  := lz4
BOARD_EROFS_PCLUSTER_SIZE               := 262144
BOARD_EROFS_COMMAND_LINE                := -zlz4hc,9


# ==============================================
# A/B Updates Architecture
# ==============================================

# A/B & Metadata
AB_OTA_UPDATER                       := true
BOARD_USES_METADATA_PARTITION        := true

# Virtual A/B block-based OTA Config
BOARD_VIRTUAL_AB_OTAPREOPT           := true
BOARD_VIRTUAL_AB_COMPRESSION         := true
BOARD_VIRTUAL_AB_COMPRESSION_METHOD  := lz4
BOARD_VIRTUAL_AB_COW_VERSION         := 3

# AB OTA Targets Build List
AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    init_boot \
    odm \
    product \
    recovery \
    system \
    system_dlkm \
    system_ext \
    vbmeta \
    vbmeta_system \
    vendor \
    vendor_boot \
    vendor_dlkm


# ==============================================
# Android Verified Boot (AVB) & Security
# ==============================================

BOOT_SECURITY_PATCH                               := 2026-01-05
VENDOR_SECURITY_PATCH                             := $(BOOT_SECURITY_PATCH)

BOARD_AVB_ENABLE                                  := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS                  += --flags 3
BOARD_MOVE_GSI_AVB_KEYS_TO_VENDOR_BOOT            := true

# Signing Key Mapping
BOARD_AVB_RECOVERY_ALGORITHM                      := SHA256_RSA4096
BOARD_AVB_RECOVERY_KEY_PATH                       := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ROLLBACK_INDEX                 := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION        := 1

BOARD_AVB_DTBO_ALGORITHM                          := SHA256_RSA4096
BOARD_AVB_DTBO_KEY_PATH                           := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_DTBO_ROLLBACK_INDEX                     := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_DTBO_ROLLBACK_INDEX_LOCATION            := 3

BOARD_AVB_BOOT_ALGORITHM                          := SHA256_RSA4096
BOARD_AVB_BOOT_KEY_PATH                           := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_BOOT_ROLLBACK_INDEX                     := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_BOOT_ROLLBACK_INDEX_LOCATION            := 4

BOARD_AVB_VENDOR_BOOT_ALGORITHM                   := SHA256_RSA4096
BOARD_AVB_VENDOR_BOOT_KEY_PATH                    := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_VENDOR_BOOT_ROLLBACK_INDEX              := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VENDOR_BOOT_ROLLBACK_INDEX_LOCATION     := 5

# VBMETA System Configuration
BOARD_AVB_VBMETA_SYSTEM                           := product system system_dlkm system_ext
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM                 := SHA256_RSA4096
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH                  := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX            := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION   := 2

# Hashtree Arguments
BOARD_AVB_SYSTEM_DLKM_ADD_HASHTREE_FOOTER_ARGS    += --hash_algorithm sha256
BOARD_AVB_VENDOR_ADD_HASHTREE_FOOTER_ARGS         += --hash_algorithm sha256
BOARD_AVB_VENDOR_DLKM_ADD_HASHTREE_FOOTER_ARGS    += --hash_algorithm sha256
BOARD_AVB_ODM_ADD_HASHTREE_FOOTER_ARGS            += --hash_algorithm sha256


# ==============================================
# SELinux & Security Policies
# ==============================================

# Inherit Qualcomm and Xiaomi common policies
include device/qcom/sepolicy_vndr/sm6225/SEPolicy.mk
include device/xiaomi/sepolicy/SEPolicy.mk
include device/lineage/sepolicy/libperfmgr/sepolicy.mk

BOARD_VENDOR_SEPOLICY_DIRS                        += $(DEVICE_PATH)/sepolicy/vendor
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS                  += $(DEVICE_PATH)/sepolicy/private


# ==============================================
# System Parameters, Build Contexts, Overrides
# ==============================================

# Boot control
$(call soong_config_set, ufsbsg, ufsframework, bsg)

$(call soong_config_set_bool, camera, override_format_from_reserved, true)

# Enable PD locater/notifier
TARGET_PD_SERVICE_ENABLED                  := true

# Enable peripheral manager
TARGET_PER_MGR_ENABLED                     := true

# Safe Recovery / Fastbootd
TARGET_RECOVERY_FSTAB                      := $(DEVICE_PATH)/rootdir/etc/fstab.default
TARGET_RECOVERY_PIXEL_FORMAT               := RGBX_8888
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE   := true

# Properties
TARGET_ODM_PROP                            += $(DEVICE_PATH)/configs/properties/odm.prop
TARGET_SYSTEM_PROP                         += $(DEVICE_PATH)/configs/properties/system.prop
TARGET_VENDOR_PROP                         += $(DEVICE_PATH)/configs/properties/vendor.prop
TARGET_PRODUCT_PROP                        += $(DEVICE_PATH)/configs/properties/product.prop
TARGET_SYSTEM_EXT_PROP                     += $(DEVICE_PATH)/configs/properties/system_ext.prop

# VINTF Compatibility Matrices & Interface Verification
DEVICE_MANIFEST_FILE += \
    $(DEVICE_PATH)/configs/vintf/manifest.xml \
    $(DEVICE_PATH)/configs/vintf/network_manifest.xml

DEVICE_FRAMEWORK_MANIFEST_FILE += \
    $(DEVICE_PATH)/configs/vintf/framework_manifest.xml

DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    $(DEVICE_PATH)/configs/vintf/framework_compatibility_matrix.xml \
    hardware/qcom-caf/common/vendor_framework_compatibility_matrix.xml

DEVICE_MATRIX_FILE += \
    hardware/qcom-caf/common/compatibility_matrix.xml


# ==========================================================
# Hardware Peripheral Frameworks (Display, Audio, RIL, WiFi)
# ==========================================================

# Display Graphics
TARGET_SCREEN_DENSITY                          := 450
TARGET_HAS_HDR_DISPLAY                         := false
TARGET_HAS_WIDE_COLOR_DISPLAY                  := true
TARGET_GRALLOC_HANDLE_HAS_RESERVED_SIZE        := true

# Audio Configuration Interface
TARGET_USES_QCOM_MM_AUDIO                      := true
TARGET_PROVIDES_AUDIO_HAL                      := true
AUDIO_FEATURE_ENABLED_DLKM                     := true
AUDIO_FEATURE_ENABLED_AGM_HIDL                 := true
AUDIO_FEATURE_ENABLED_PAL_HIDL                 := true
AUDIO_FEATURE_ENABLED_DTS_EAGLE                := false
AUDIO_FEATURE_ENABLED_GEF_SUPPORT              := true
AUDIO_FEATURE_ENABLED_INSTANCE_ID              := true
AUDIO_FEATURE_ENABLED_PROXY_DEVICE             := true
AUDIO_FEATURE_ENABLED_HW_ACCELERATED_EFFECTS   := true
AUDIO_FEATURE_ENABLED_EXTENDED_COMPRESS_FORMAT := false

# Audio
$(call soong_config_set, android_hardware_audio, run_64bit, true)

# Power
TARGET_POWERHAL_MODE_EXT := $(DEVICE_PATH)/power/power-mode.cpp

# Radio Interface Layer (RIL)
ENABLE_VENDOR_RIL_SERVICE                      := true

# Wireless Network Stack (WiFi)
BOARD_WLAN_DEVICE                              := qcwcn
BOARD_HOSTAPD_DRIVER                           := NL80211
CONFIG_IEEE80211AX                             := true
WIFI_DRIVER_STATE_OFF                          := "OFF"
WIFI_DRIVER_STATE_ON                           := "ON"
WPA_SUPPLICANT_VERSION                         := VER_0_8_X
BOARD_HOSTAPD_PRIVATE_LIB                      := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_DRIVER                    := $(BOARD_HOSTAPD_DRIVER)
WIFI_DRIVER_STATE_CTRL_PARAM                   := "/dev/wlan"
WIFI_HIDL_FEATURE_DUAL_INTERFACE               := true
BOARD_WPA_SUPPLICANT_PRIVATE_LIB               := $(BOARD_HOSTAPD_PRIVATE_LIB)
BOARD_WPA_SUPPLICANT_PRIVATE_LIB_EVENT         := "ON"
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY  := true

# Fix: Create directory KERNEL_OBJ/usr for some modules
$(shell mkdir -p $(OUT_DIR)/target/product/$(TARGET_DEVICE)/obj/KERNEL_OBJ/usr)
