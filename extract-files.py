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

def blob_fixup_replace_bytes(
    ctx: BlobFixupCtx,
    file: File,
    file_path: str,
    search: bytes,
    replacement: bytes,
    *args,
    **kwargs,
):
    with open(file_path, 'rb+') as f:
        data = f.read()

        count = data.count(search)
        if count == 0 and data.count(replacement) == 1:
            return
        if count != 1:
            raise ValueError(
                f'Expected exactly one binary patch site in {file_path}, found {count}'
            )

        f.seek(0)
        f.write(data.replace(search, replacement, 1))
        f.truncate()

blob_fixups: blob_fixups_user_type = {

    # Android 16 currently drives both stock Qualcomm Codec2 services into a
    # seccomp SIGSYS while creating component interfaces. Keep this temporary
    # bring-up workaround reproducible until the blocked syscall can be
    # captured and replaced by a narrow policy addition.
    'vendor/bin/hw/vendor.qti.media.c2@1.0-service': blob_fixup()
        .call(
            blob_fixup_replace_bytes,
            b'\xe0\x83\x00\x91\xe1\x23\x00\x91\xbf\x03\x00\x94\xe8\x23\x40\x39',
            b'\xe0\x83\x00\x91\xe1\x23\x00\x91\x1f\x20\x03\xd5\xe8\x23\x40\x39',
        ),

    'vendor/bin/hw/vendor.qti.media.c2audio@1.0-service': blob_fixup()
        .call(
            blob_fixup_replace_bytes,
            b'\xe0\x83\x00\x91\xe1\x23\x00\x91\x42\x04\x00\x94\xe8\x23\x40\x39',
            b'\xe0\x83\x00\x91\xe1\x23\x00\x91\x1f\x20\x03\xd5\xe8\x23\x40\x39',
        ),

    # The stock vendor fragment advertises a Dolby Codec2 store (`default1`),
    # but the corresponding service is not included in proprietary-files.txt.
    # Do not let a future extraction reintroduce the phantom VINTF instance.
    'vendor/etc/vintf/manifest/c2_manifest_vendor.xml': blob_fixup()
        .regex_replace(r'\s*<fqname>@1\.0::IComponentStore/default1</fqname>[^\n]*\n', '\n'),

    ('vendor/lib/libqcodec2_core.so', 'vendor/lib64/libqcodec2_core.so'): blob_fixup()
        .add_needed('libcodec2_legacy_fence_shim.so'),

    ('vendor/bin/hw/android.hardware.security.keymint-service-qti', 'vendor/lib64/libqtikeymint.so'): blob_fixup()
        .add_needed('android.hardware.security.rkp-V3-ndk.so'),

    'vendor/etc/qcril_database/upgrade/config/6.0_config.sql': blob_fixup()
        .binary_regex_replace(rb'persist\.vendor\.radio\.poweron_opt', rb'persist.vendor.radio.poweron_ign'),
    
    ('vendor/lib64/libqcrilNr.so', 'vendor/lib64/libril-db.so'): blob_fixup()
        .binary_regex_replace(rb'persist\.vendor\.radio\.poweron_opt', rb'persist.vendor.radio.poweron_ign'),
    
    'vendor/lib64/vendor.libdpmframework.so': blob_fixup()
        .add_needed('libhidlbase_shim.so'),
    
    ('vendor/etc/seccomp_policy/c2audio.vendor.ext-arm64.policy',
    'vendor/etc/seccomp_policy/codec2.vendor.ext-arm64.policy',): blob_fixup()
        .add_line_if_missing('setsockopt: 1'),
    
    ('vendor/lib64/hw/com.qti.chi.override.so',
    'vendor/lib64/libcamxcommonutils.so',
    'vendor/lib64/libmialgoengine.so',
    'vendor/lib64/hw/camera.qcom.so',): blob_fixup()
        .add_needed('libprocessgroup_shim.so'),
    
    'vendor/etc/init/android.hardware.gnss-aidl-service-qti.rc': blob_fixup()
        .regex_replace('group system gps radio vendor_qti_diag vendor_ssgtzd', 'group system gps radio vendor_qti_diag'),
    
    'vendor/lib64/libwvhidl.so': blob_fixup()
        .add_needed('libcrypto_shim.so'),
    
    'system_ext/lib64/vendor.qti.hardware.qccsyshal@1.2-halimpl.so': blob_fixup()
        .replace_needed('libprotobuf-cpp-full.so', 'libprotobuf-cpp-full-fromvendor.so'),

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
