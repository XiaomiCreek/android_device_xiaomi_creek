#
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from common AOSP 64-bit phone config
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from LineageOS common configuration
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit from creek device
$(call inherit-product, device/xiaomi/creek/device.mk)

# Include our private certificate
-include vendor/lineage-priv/keys/keys.mk

# Gapps
-include vendor/gapps/arm64/arm64-vendor.mk

# Basic identifiers
PRODUCT_NAME              := lineage_creek
PRODUCT_DEVICE            := creek
PRODUCT_MANUFACTURER      := Xiaomi
PRODUCT_BRAND             := POCO
PRODUCT_MODEL             := POCO M7 4G

# AudioFX
TARGET_EXCLUDES_AUDIOFX   := true

# Device configs
TARGET_BOOT_ANIMATION_RES = 1080
#WITH_GMS                 := true

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

# Custom System OTA Update URI
PRODUCT_SYSTEM_PROPERTIES += \
    lineage.updater.uri=$(LINEAGE_UPDATER_URI)

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="creek_p_global-user 16 BP2A.250605.031.A3 OS3.0.10.0.WBOMIXM release-keys" \
    BuildFingerprint="POCO/creek_p_global/creek:16/BP2A.250605.031.A3/OS3.0.10.0.WBOMIXM:user/release-keys"
