#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from AOSP product configuration
$(call inherit-product, device/xiaomi/creek/AOSP_creek.mk)

# Inherit from LineageOS common configuration
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Include our private certificate
-include vendor/lineage-priv/keys/keys.mk

# Basic identifiers
PRODUCT_NAME:= lineage_creek