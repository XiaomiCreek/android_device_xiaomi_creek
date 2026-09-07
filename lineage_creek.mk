#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from LineageOS common configuration
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit the hardware configuration for the actual device
$(call inherit-product, device/xiaomi/creek/device.mk)

# Inherit FastCharge configurations
$(call inherit-product, packages/apps/FastCharge/fastcharge.mk)

# Defaults for File System & GApps
# (can be overridden via environment variables)
WITH_EROFS := true
WITH_GAPPS := false

# Include MindTheGapps conditionally
ifeq ($(WITH_GAPPS),true)
$(call inherit-product, vendor/gapps/arm64/arm64-vendor.mk)
endif

# Include our private certificate
-include vendor/lineage-priv/keys/keys.mk

# Basic identifiers
PRODUCT_NAME              := lineage_creek
PRODUCT_DEVICE            := creek
PRODUCT_MANUFACTURER      := Xiaomi
PRODUCT_BRAND             := Xiaomi
PRODUCT_MODEL             := POCO M7 4G

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="creek-user 16 BP2A.250605.031.A3 OS3.0.302.0.WBOMIXM release-keys" \
    BuildFingerprint=Redmi/creek_global/creek:16/BP2A.250605.031.A3/OS3.0.302.0.WBOMIXM:user/release-keys
