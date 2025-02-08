#!/bin/bash
#
# SPDX-FileCopyrightText: 2016 The CyanogenMod Project
# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

set -e

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

export TARGET_ENABLE_CHECKELF=true

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

function vendor_imports() {
    cat <<EOF >>"$1"
		"device/oneplus/sm8650-common",
		"hardware/qcom/wlan",
		"hardware/oplus",
		"vendor/qcom/opensource/commonsys/display",
		"vendor/qcom/opensource/commonsys-intf/display",
		"vendor/qcom/opensource/dataservices",
EOF
}

function lib_to_package_fixup_vendor_variants() {
    if [ "$2" != "vendor" ]; then
        return 1
    fi

    case "$1" in
        com.qualcomm.qti.dpm.api@1.0 | \
            com.qualcomm.qti.imscmservice@1.0 | \
            com.qualcomm.qti.imscmservice@2.0 | \
            com.qualcomm.qti.imscmservice@2.1 | \
            com.qualcomm.qti.imscmservice@2.2 | \
            com.qualcomm.qti.uceservice@2.0 | \
            com.qualcomm.qti.uceservice@2.1 | \
            com.qualcomm.qti.uceservice@2.2 | \
            com.qualcomm.qti.uceservice@2.3 | \
            com.qti.sensor.lyt808 | \
            libarcsoft_triple_sat | \
            libarcsoft_triple_zoomtranslator | \
            libdualcam_optical_zoom_control | \
            libdualcam_video_optical_zoom | \
            libhwconfigurationutil | \
            libtriplecam_optical_zoom_control | \
            libtriplecam_video_optical_zoom | \
            vendor.display.color@1.0 | \
            vendor.display.color@1.1 | \
            vendor.display.color@1.2 | \
            vendor.display.color@1.3 | \
            vendor.display.color@1.4 | \
            vendor.display.color@1.5 | \
            vendor.display.postproc@1.0 | \
            vendor.oplus.hardware.camera_rfi-V1-ndk | \
            vendor.oplus.hardware.cammidasservice-V1-ndk | \
            vendor.oplus.hardware.displaycolorfeature-V1-ndk | \
            vendor.oplus.hardware.displaypanelfeature-V1-ndk | \
            vendor.pixelworks.hardware.display@1.0 | \
            vendor.pixelworks.hardware.display@1.1 | \
            vendor.pixelworks.hardware.display@1.2 | \
            vendor.pixelworks.hardware.feature@1.0 | \
            vendor.pixelworks.hardware.feature@1.1 | \
            vendor.pixelworks.hardware.feature-V1-ndk | \
            vendor.qti.data.factoryservice-V1-ndk | \
            vendor.qti.data.mwqem@1.0 | \
            vendor.qti.data.mwqemaidlservice-V1-ndk | \
            vendor.qti.data.slm@1.0 | \
            vendor.qti.diaghal@1.0 | \
            vendor.qti.hardware.data.cneaidlservice.internal.api-V1-ndk | \
            vendor.qti.hardware.data.cneaidlservice.internal.constants-V1-ndk | \
            vendor.qti.hardware.data.cneaidlservice.internal.server-V1-ndk | \
            vendor.qti.hardware.data.connection@1.0 | \
            vendor.qti.hardware.data.connection@1.1 | \
            vendor.qti.hardware.data.connectionfactory-V1-ndk | \
            vendor.qti.hardware.data.dataactivity-V1-ndk | \
            vendor.qti.hardware.data.dynamicdds@1.0 | \
            vendor.qti.hardware.data.dynamicdds@1.1 | \
            vendor.qti.hardware.data.dynamicddsaidlservice-V1-ndk | \
            vendor.qti.hardware.data.flow@1.0 | \
            vendor.qti.hardware.data.flow@1.1 | \
            vendor.qti.hardware.data.flowaidlservice-V1-ndk | \
            vendor.qti.hardware.data.iwlandata-V1-ndk | \
            vendor.qti.hardware.data.ka-V1-ndk | \
            vendor.qti.hardware.data.latency@1.0 | \
            vendor.qti.hardware.data.lce@1.0 | \
            vendor.qti.hardware.data.lceaidlservice-V1-ndk | \
            vendor.qti.hardware.data.qmiaidlservice-V1-ndk | \
            vendor.qti.hardware.dpmservice@1.0 | \
            vendor.qti.hardware.dpmservice@1.1 | \
            vendor.qti.hardware.dpmaidlservice-V1-ndk | \
            vendor.qti.hardware.embmssl@1.0 | \
            vendor.qti.hardware.embmssl@1.1 | \
            vendor.qti.hardware.factory-V1-ndk | \
            vendor.qti.hardware.fm@1.0 | \
            vendor.qti.hardware.iop@1.0 | \
            vendor.qti.hardware.iop@2.0 | \
            vendor.qti.hardware.limits@1.0 | \
            vendor.qti.hardware.limits@1.1 | \
            vendor.qti.hardware.limits@1.2 | \
            vendor.qti.hardware.ListenSoundModel@1.0 | \
            vendor.qti.hardware.mwqemadapter@1.0 | \
            vendor.qti.hardware.mwqemadapteraidlservice-V1-ndk | \
            vendor.qti.hardware.perf2-V1-ndk | \
            vendor.qti.hardware.qccsyshal@1.0 | \
            vendor.qti.hardware.qccsyshal@1.1 | \
            vendor.qti.hardware.qccsyshal@1.2 | \
            vendor.qti.hardware.radio.am@1.0 | \
            vendor.qti.hardware.radio.ims@1.0 | \
            vendor.qti.hardware.radio.ims@1.1 | \
            vendor.qti.hardware.radio.ims@1.2 | \
            vendor.qti.hardware.radio.ims@1.3 | \
            vendor.qti.hardware.radio.ims@1.4 | \
            vendor.qti.hardware.radio.ims@1.5 | \
            vendor.qti.hardware.radio.ims@1.6 | \
            vendor.qti.hardware.radio.ims@1.7 | \
            vendor.qti.hardware.radio.ims@1.8 | \
            vendor.qti.hardware.radio.lpa@1.0 | \
            vendor.qti.hardware.radio.lpa@1.1 | \
            vendor.qti.hardware.radio.lpa@1.2 | \
            vendor.qti.hardware.radio.qcrilhook@1.0 | \
            vendor.qti.hardware.radio.qtiradio@1.0 | \
            vendor.qti.hardware.radio.qtiradio@2.0 | \
            vendor.qti.hardware.radio.qtiradio@2.1 | \
            vendor.qti.hardware.radio.qtiradio@2.2 | \
            vendor.qti.hardware.radio.qtiradio@2.3 | \
            vendor.qti.hardware.radio.qtiradio@2.4 | \
            vendor.qti.hardware.radio.qtiradio@2.5 | \
            vendor.qti.hardware.radio.qtiradio@2.6 | \
            vendor.qti.hardware.radio.uim@1.0 | \
            vendor.qti.hardware.radio.uim@1.1 | \
            vendor.qti.hardware.radio.uim@1.2 | \
            vendor.qti.hardware.radio.uim_remote_client@1.0 | \
            vendor.qti.hardware.radio.uim_remote_client@1.1 | \
            vendor.qti.hardware.radio.uim_remote_client@1.2 | \
            vendor.qti.hardware.radio.uim_remote_server@1.0 | \
            vendor.qti.hardware.servicetrackeraidl-V1-ndk | \
            vendor.qti.hardware.slmadapter@1.0 | \
            vendor.qti.hardware.wifidisplaysession@1.0 | \
            vendor.qti.ims.callcapability@1.0 | \
            vendor.qti.ims.callcapabilityaidlservice-V1-ndk | \
            vendor.qti.ims.callinfo@1.0 | \
            vendor.qti.ims.configaidlservice-V1-ndk | \
            vendor.qti.ims.connectionaidlservice-V1-ndk | \
            vendor.qti.ims.factory@1.0 | \
            vendor.qti.ims.factory@1.1 | \
            vendor.qti.ims.factoryaidlservice-V1-ndk | \
            vendor.qti.ims.rcsconfig@1.0 | \
            vendor.qti.ims.rcsconfig@1.1 | \
            vendor.qti.ims.rcsconfig@2.0 | \
            vendor.qti.ims.rcsconfig@2.1 | \
            vendor.qti.ims.rcssipaidlservice-V1-ndk | \
            vendor.qti.ims.rcsuceaidlservice-V1-ndk | \
            vendor.qti.imsrtpservice@3.0 | \
            vendor.qti.imsrtpservice@3.1 | \
            vendor.qti.ImsRtpService-V1-ndk | \
            vendor.qti.latency@2.0 | \
            vendor.qti.latency@2.1 | \
            vendor.qti.latency@2.2 | \
            vendor.qti.latencyaidlservice-V1-ndk | \
            vendor.qti.qccvndhal_aidl-V1-ndk | \
            vendor.qti.qspmhal@1.0 | \
            vendor.qti.qspmhal-V1-ndk)
            echo "$1_vendor"
            ;;
        libagmclient | \
            libpalclient | \
            libwpa_client) ;;
        *)
            return 1
            ;;
    esac
}

function lib_to_package_fixup() {
    lib_to_package_fixup_clang_rt_ubsan_standalone "$1" ||
        lib_to_package_fixup_proto_3_9_1 "$1" ||
        lib_to_package_fixup_vendor_variants "$@"
}

# Initialize the helper for common
setup_vendor "${DEVICE_COMMON}" "${VENDOR_COMMON:-$VENDOR}" "${ANDROID_ROOT}" true

# Warning headers and guards
write_headers "oneplus12"

# The standard common blobs
write_makefiles "${MY_DIR}/proprietary-files.txt"

# Finish
write_footers

if [ -s "${MY_DIR}/../../${VENDOR}/${DEVICE}/proprietary-files.txt" ]; then
    # Reinitialize the helper for device
    source "${MY_DIR}/../../${VENDOR}/${DEVICE}/setup-makefiles.sh"
    setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false

    # Warning headers and guards
    write_headers

    # The standard device blobs
    write_makefiles "${MY_DIR}/../../${VENDOR}/${DEVICE}/proprietary-files.txt"

    if [ -f "${MY_DIR}/../../${VENDOR}/${DEVICE}/proprietary-firmware.txt" ]; then
        append_firmware_calls_to_makefiles "${MY_DIR}/../../${VENDOR}/${DEVICE}/proprietary-firmware.txt"
    fi

    # Finish
    write_footers
fi
