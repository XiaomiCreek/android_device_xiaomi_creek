#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from AOSP product configuration
$(call inherit-product, device/xiaomi/creek/AOSP_creek.mk)

# Inherit from LineageOS common configuration
$(call inherit-product, vendor/custom/config/common_full_phone.mk)

# Inherit FastCharge configurations
$(call inherit-product, packages/apps/FastCharge/fastcharge.mk)

# Include our private certificate
-include vendor/lineage-priv/keys/keys.mk

# Basic identifiers
PRODUCT_NAME:= custom_creek