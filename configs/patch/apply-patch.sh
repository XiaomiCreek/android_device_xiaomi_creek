#!/bin/bash
set -e
TOP="$(pwd)"
PATCH_DIR="$TOP/device/xiaomi/creek/configs/patch/frameworks_native"

cd "$TOP/frameworks/native"
for p in "$PATCH_DIR"/*.patch; do
    if git apply --reverse --check "$p" &>/dev/null; then
        echo "[creek] already applied: $(basename "$p")"
    else
        echo "[creek] applying: $(basename "$p")"
        git apply "$p"
    fi
done
cd "$TOP"