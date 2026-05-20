#include <android-base/properties.h>

#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

#include "property_service.h"
#include "vendor_init.h"

using android::base::GetProperty;

void property_override(char const prop[], char const value[], bool add = true)
{
    auto pi = (prop_info *)__system_property_find(prop);
    if (pi != nullptr) {
        __system_property_update(pi, value, strlen(value));
    } else if (add) {
        __system_property_add(prop, strlen(prop), value, strlen(value));
    }
}

void vendor_load_properties()
{
    property_override("ro.product.model", "POCO M7 4G");
    property_override("ro.product.brand", "POCO");
    property_override("ro.product.name", "creek_p_global");
    property_override("ro.product.device", "creek");
    property_override("ro.product.manufacturer", "Xiaomi");
    property_override("ro.build.fingerprint",
        "POCO/creek_p_global/creek:16/BP2A.250605.031.A3/OS3.0.10.0.WBOMIXM:user/release-keys");
}
