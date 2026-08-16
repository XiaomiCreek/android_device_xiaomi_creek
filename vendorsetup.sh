# ROM source patches

color="\033[0;32m"
end="\033[0m"

echo "----------------------------------------------------"
echo -e "${color}Applying patches for Hw/Common${end}"
echo ""

# Get the Android build top directory
if [ -z "$ANDROID_BUILD_TOP" ]; then
    ANDROID_BUILD_TOP="$(pwd)"
fi

# Apply bengal_515 platform support patch
QCOM_CAF_COMMON="$ANDROID_BUILD_TOP/hardware/qcom-caf/common"

if [ -d "$QCOM_CAF_COMMON" ]; then
    echo -e "${color}Applying bengal_515 platform support...${end}"
    
    # Check if patches are already applied
    if ! grep -q "_515" "$QCOM_CAF_COMMON/BoardConfigQcom.mk" 2>/dev/null; then
        
        # Use a temp file approach for cleaner patching
        TEMP_FILE=$(mktemp)
        
        # Patch BoardConfigQcom.mk
        cat "$QCOM_CAF_COMMON/BoardConfigQcom.mk" > "$TEMP_FILE"
        
        # Replace QCOM_HARDWARE_VARIANT for UM_5_15_FAMILY
        sed -i '/else ifneq ($(filter $(UM_5_15_FAMILY)/,/^else ifneq/ {
            /QCOM_HARDWARE_VARIANT := sm8550$/c\
    ifeq ($(TARGET_BOARD_SUFFIX),_515)\
        QCOM_HARDWARE_VARIANT := sm6225\
    else\
        QCOM_HARDWARE_VARIANT := sm8550\
    endif
        }' "$TEMP_FILE" 2>/dev/null
        
        # Replace data-ipa-cfg-mgr namespace
        sed -i '/else ifneq ($(filter $(UM_5_15_FAMILY)/,/^else ifneq/ {
            /PRODUCT_SOONG_NAMESPACES += hardware\/qcom-caf\/sm8550\/data-ipa-cfg-mgr$/c\
        ifeq ($(TARGET_BOARD_SUFFIX),_515)\
            PRODUCT_SOONG_NAMESPACES += hardware/qcom-caf/sm6225/data-ipa-cfg-mgr\
        else\
            PRODUCT_SOONG_NAMESPACES += hardware/qcom-caf/sm8550/data-ipa-cfg-mgr\
        endif
        }' "$TEMP_FILE" 2>/dev/null
        
        cp "$TEMP_FILE" "$QCOM_CAF_COMMON/BoardConfigQcom.mk"
        
        # Patch os_pickup_sepolicy_vndr.mk
        sed -i '/else ifneq ($(filter $(UM_5_15_FAMILY)/,/^else ifneq/ {
            /include device\/qcom\/sepolicy_vndr\/sm8550\/SEPolicy.mk$/c\
    ifeq ($(TARGET_BOARD_SUFFIX),_515)\
        include device/qcom/sepolicy_vndr/sm6225/SEPolicy.mk\
    else\
        include device/qcom/sepolicy_vndr/sm8550/SEPolicy.mk\
    endif
        }' "$QCOM_CAF_COMMON/os_pickup_sepolicy_vndr.mk" 2>/dev/null
        
        # Patch qcom_defs.mk
        sed -i 's/UM_4_19_FAMILY := kona lito bengal/UM_4_19_FAMILY := kona lito\nifneq ($(TARGET_BOARD_SUFFIX),_515)\n    UM_4_19_FAMILY += bengal\nendif/' "$QCOM_CAF_COMMON/qcom_defs.mk" 2>/dev/null
        
        sed -i '/UM_5_15_FAMILY := kalama crow/a ifeq ($(TARGET_BOARD_SUFFIX),_515)\n    UM_5_15_FAMILY += bengal\nendif' "$QCOM_CAF_COMMON/qcom_defs.mk" 2>/dev/null
        
        rm -f "$TEMP_FILE"
    fi
    
    echo -e "${color}✓ bengal_515 patches applied${end}"
else
    echo "Warning: $QCOM_CAF_COMMON not found. Skipping patches."
fi
echo ""

# Setup sm6225 soong_namespace in hardware/qcom-caf/sm6225/Android.bp
SM6225_DIR="$ANDROID_BUILD_TOP/hardware/qcom-caf/sm6225"
BP_FILE="$SM6225_DIR/Android.bp"

if [ -d "$SM6225_DIR" ]; then
    if [ ! -f "$BP_FILE" ] || ! grep -q "soong_namespace" "$BP_FILE" 2>/dev/null; then
        echo -e "${color}Adding soong_namespace to $BP_FILE...${end}"
        cat << 'EOF' > "$BP_FILE"
soong_namespace {
    imports: [
        "vendor/qcom/opensource/commonsys-intf/display",
        "vendor/qcom/opensource/display",
    ],
}
EOF
        echo -e "${color}✓ Android.bp configured for sm6225${end}"
    else
        echo -e "${color}✓ soong_namespace already present in Android.bp${end}"
    fi
else
    echo "Warning: $SM6225_DIR not found. Skipping Android.bp creation."
fi
echo ""
