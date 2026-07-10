#
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from common AOSP 64-bit phone config
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from LineageOS common configuration
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit the hardware configuration for the actual device
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

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

BUILD_FINGERPRINT := Redmi/creek_global/creek:16/BP2A.250605.031.A3/OS3.0.302.0.WBOMIXM:user/release-keys
