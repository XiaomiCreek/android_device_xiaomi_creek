#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from AOSP product configuration
$(call inherit-product, $(DEVICE_PATH)/AOSP_creek.mk)

# Inherit from LineageOS common configuration
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit FastCharge configurations
$(call inherit-product, packages/apps/FastCharge/fastcharge.mk)

# Defaults for GApps
# (can be overridden via environment variables)
WITH_GAPPS := false

# Include MindTheGapps conditionally
ifeq ($(WITH_GAPPS),true)
$(call inherit-product, vendor/gapps/arm64/arm64-vendor.mk)
endif

# Include our private certificate
-include vendor/lineage-priv/keys/keys.mk

# Basic identifiers
PRODUCT_NAME:= lineage_creek