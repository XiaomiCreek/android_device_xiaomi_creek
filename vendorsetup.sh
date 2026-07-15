# Clone HALs for SM6225
echo "Cloning HALs for SM6225..."

rm -rf hardware/qcom-caf/common
git clone --depth 1 -b lineage-23.2 https://github.com/sapphire-sm6225/android_hardware_qcom-caf_common.git hardware/qcom-caf/common

rm -rf hardware/qcom-caf/sm6225/audio/agm
git clone --depth 1 -b lineage-22.2-caf-sm6225 https://github.com/sapphire-sm6225/vendor_qcom_opensource_agm.git hardware/qcom-caf/sm6225/audio/agm

rm -rf hardware/qcom-caf/sm6225/audio/pal
git clone --depth 1 -b lineage-22.0-caf-sm6225 https://github.com/sapphire-sm6225/vendor_qcom_opensource_arpal-lx.git hardware/qcom-caf/sm6225/audio/pal

rm -rf hardware/qcom-caf/sm6225/data-ipa-cfg-mgr
git clone --depth 1 -b lineage-23.2-caf-sm6225 https://github.com/sapphire-sm6225/vendor_qcom_opensource_data-ipa-cfg-mgr.git hardware/qcom-caf/sm6225/data-ipa-cfg-mgr

rm -rf hardware/qcom-caf/sm6225/dataipa
git clone --depth 1 -b lineage-23.2-caf-sm6225 https://github.com/sapphire-sm6225/vendor_qcom_opensource_dataipa.git hardware/qcom-caf/sm6225/dataipa

rm -rf hardware/qcom-caf/sm6225/display
git clone --depth 1 -b lineage-22.0-caf-sm6225 https://github.com/sapphire-sm6225/hardware_qcom_display.git hardware/qcom-caf/sm6225/display

rm -rf hardware/qcom-caf/sm6225/media
git clone --depth 1 -b lineage-23.2-caf-sm6225 https://github.com/sapphire-sm6225/hardware_qcom_media.git hardware/qcom-caf/sm6225/media

rm -rf hardware/qcom-caf/sm6225/audio/primary-hal
git clone --depth 1 -b lineage-22.0-caf-sm6225 https://github.com/sapphire-sm6225/hardware_qcom_audio.git hardware/qcom-caf/sm6225/audio/primary-hal

rm -rf device/qcom/sepolicy_vndr/sm6225
git clone --depth 1 -b lineage-23.2-caf-sm6225 https://github.com/sapphire-sm6225/device_qcom_sepolicy_vndr.git device/qcom/sepolicy_vndr/sm6225

rm -rf vendor/lineage
git clone --depth 1 -b lineage-23.2 https://github.com/sapphire-sm6225/android_vendor_lineage.git vendor/lineage

rm -rf hardware/dolby
git clone --depth 1 -b 16 https://github.com/project-creek/hardware_dolby.git hardware/dolby

rm -rf packages/apps/FastCharge
git clone --depth 1 -b 16-qpr2 https://github.com/project-creek/packages_apps_FastCharge.git packages/apps/FastCharge

rm -rf device/xiaomi/sepolicy
git clone --depth 1 -b 16 https://github.com/sapphire-sm6225/device_xiaomi_sepolicy.git device/xiaomi/sepolicy

rm -rf hardware/xiaomi
git clone --depth 1 -b bka-no-dolby https://github.com/project-creek/hardware_xiaomi.git hardware/xiaomi

echo "============================"
echo "Cloning HALs completed"
echo "============================"
echo ""
