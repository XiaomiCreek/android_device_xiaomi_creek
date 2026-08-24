/*
 * SPDX-License-Identifier: Apache-2.0
 */

#include <C2FenceFactory.h>

/*
 * Qualcomm's Android 13 component store still imports the one-argument C++
 * symbol. Android 16 only provides CreateSyncFence(int, bool), with a default
 * argument in the header; a C++ default argument does not create the legacy
 * ABI symbol. Give the forwarding function the exact old mangled name without
 * changing frameworks/av.
 */
__attribute__((visibility("default"))) C2Fence CreateSyncFenceLegacy(int fenceFd)
        __asm__("_ZN15_C2FenceFactory15CreateSyncFenceEi");

C2Fence CreateSyncFenceLegacy(int fenceFd) {
    return _C2FenceFactory::CreateSyncFence(fenceFd, true);
}
