#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.file import File
from extract_utils.fixups_blob import (
    BlobFixupCtx,
    blob_fixup,
    blob_fixups_user_type,
)

from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

def blob_fixup_test_flag(
    ctx: BlobFixupCtx,
    file: File,
    file_path: str,
    *args,
    **kargs,
):
    with open(file_path, 'rb+') as f:
        f.seek(1337)
        f.write(b'\x01')

blob_fixups: blob_fixups_user_type = {
    'vendor/etc/init/android.hardware.gnss-aidl-service-qti.rc': blob_fixup()
        .regex_replace('group system gps radio vendor_qti_diag vendor_ssgtzd', 'group system gps radio vendor_qti_diag'),
}

module = ExtractUtilsModule(
    'creek',
    'xiaomi',
    blob_fixups=blob_fixups,
    check_elf = False,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
