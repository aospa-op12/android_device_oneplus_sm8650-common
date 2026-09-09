#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

import json
from Crypto.Cipher import AES

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixups,
    lib_fixup_remove,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/oneplus/oneplus12',
    'hardware/oplus',
    'vendor/oneplus/oneplus12',
    'vendor/qcom/common/vendor/perf',
]

# Oplus camera config decryption & patching
KEY = bytes.fromhex("6f2170406c247525535e4326412a4d28")
MAGIC = b"\x01\x01"
HEADER_LEN = 4
FOOTER_LEN = 4

def decrypt_oplus_config(blob: bytes) -> bytes:
    """Decrypt an encrypted Oplus camera config blob (must start with 01 01)."""
    ct = blob[HEADER_LEN:len(blob) - FOOTER_LEN]
    pt = AES.new(KEY, AES.MODE_ECB).decrypt(ct)
    pad_len = pt[-1]
    if 1 <= pad_len <= 16:
        pt = pt[:-pad_len]
    return pt

def get_plain_config_bytes(file_path: str) -> bytes:
    """
    Read the config file from disk. If it starts with the encryption magic,
    decrypt it; otherwise return the raw bytes (already plaintext).
    """
    with open(file_path, 'rb') as f:
        raw = f.read()
    if raw[:2] == MAGIC:
        return decrypt_oplus_config(raw)
    return raw

def update_vendor_tag(ctx, file, file_path, vendor_tag, new_value, type_str="Byte", count="1"):
    """
    Generic helper: get plaintext config, find or add a vendor tag, set its Value,
    and write back as plaintext JSON.
    """
    plain_bytes = get_plain_config_bytes(file_path)
    config = json.loads(plain_bytes.decode('utf-8'))

    found = False
    for entry in config["file_data"]:
        if entry.get("VendorTag") == vendor_tag:
            entry["Value"] = new_value
            entry["Type"] = type_str
            entry["Count"] = count
            found = True
            break

    if not found:
        config["file_data"].append({
            "VendorTag": vendor_tag,
            "Type": type_str,
            "Count": count,
            "Value": new_value
        })

    with open(file_path, 'w') as f:
        json.dump(config, f, indent=2, separators=(',', ': '))

# Disable "Liquid Glass" design
def set_cross_window_blur_zero(ctx, file, file_path, *args, **kwargs):
    update_vendor_tag(ctx, file, file_path, "com.oplus.camera.support.cross.window.blur", "0")

# Unlock 120fps
def set_120fps_guide_support(ctx, file, file_path, *args, **kwargs):
    update_vendor_tag(ctx, file, file_path, "com.oplus.feature.120fps.guide.support", "1")

def set_slowvideo_wide_120fps_not_support(ctx, file, file_path, *args, **kwargs):
    update_vendor_tag(ctx, file, file_path, "com.oplus.feature.slowvideo.wide.120fps.not.support", "1")

def set_video_1080p_120fps_support(ctx, file, file_path, *args, **kwargs):
    update_vendor_tag(ctx, file, file_path, "com.oplus.feature.video.1080p.120fps.support", "1")

def set_video_1080p_120fps_zoom_range(ctx, file, file_path, *args, **kwargs):
    update_vendor_tag(ctx, file, file_path, "com.oplus.feature.video.1080p.120fps.zoom.range", "1,20", "Float", "2")

def set_video_1080p120fps_max_zoom_list(ctx, file, file_path, *args, **kwargs):
    update_vendor_tag(ctx, file, file_path, "com.oplus.feature.video.1080p120fps.max.zoom.list", "4,6,18", "Float", "3")

def set_video_120fps_camera_main_only_support(ctx, file, file_path, *args, **kwargs):
    update_vendor_tag(ctx, file, file_path, "com.oplus.feature.video.120fps.camera.main.only.support", "0")

def set_video_4k_120fps_support(ctx, file, file_path, *args, **kwargs):
    update_vendor_tag(ctx, file, file_path, "com.oplus.feature.video.4k.120fps.support", "1")

def set_video_4k_120fps_zoom_range(ctx, file, file_path, *args, **kwargs):
    update_vendor_tag(ctx, file, file_path, "com.oplus.feature.video.4k.120fps.zoom.range", "1,20", "Float", "2")

def set_video_4k120fps_max_zoom_list(ctx, file, file_path, *args, **kwargs):
    update_vendor_tag(ctx, file, file_path, "com.oplus.feature.video.4k120fps.max.zoom.list", "4,6,18", "Float", "3")

def set_video_dv_120fps_support(ctx, file, file_path, *args, **kwargs):
    update_vendor_tag(ctx, file, file_path, "com.oplus.feature.video.dv.120fps.support", "1")

def lib_fixup_odm_suffix(lib: str, partition: str, *args, **kwargs):
    return f'{lib}_{partition}' if partition == 'odm' else None


def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs):
    return f'{lib}_{partition}' if partition == 'vendor' else None


lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    (
        'com.qti.sensor.lyt808',
        'com.qualcomm.qti.dpm.api@1.0',
        'libarcsoft_triple_sat',
        'libarcsoft_triple_zoomtranslator',
        'libdualcam_optical_zoom_control',
        'libdualcam_video_optical_zoom',
        'libhwconfigurationutil',
        'libosensenativeproxy_client',
        'libpwirisfeature',
        'libpwirishalwrapper',
        'libtriplecam_optical_zoom_control',
        'libtriplecam_video_optical_zoom',
        'vendor.pixelworks.hardware.display@1.0',
        'vendor.pixelworks.hardware.display@1.1',
        'vendor.pixelworks.hardware.display@1.2',
        'vendor.pixelworks.hardware.display-V2-ndk',
        'vendor.pixelworks.hardware.feature@1.0',
        'vendor.pixelworks.hardware.feature@1.1',
        'vendor.pixelworks.hardware.feature-V1-ndk',
        'vendor.qti.diaghal@1.0',
        'vendor.qti.hardware.dpmaidlservice-V1-ndk',
        'vendor.qti.hardware.dpmservice@1.0',
        'vendor.qti.hardware.qccsyshal@1.0',
        'vendor.qti.hardware.qccsyshal@1.1',
        'vendor.qti.hardware.qccsyshal@1.2',
        'vendor.qti.hardware.wifidisplaysession@1.0',
        'vendor.qti.imsrtpservice@3.0',
        'vendor.qti.imsrtpservice@3.1',
        'vendor.qti.ImsRtpService-V1-ndk',
        'vendor.qti.qccvndhal_aidl-V1-ndk',
        'com.qualcomm.qti.imscmservice@1.0',
        'com.qualcomm.qti.imscmservice@2.0',
        'com.qualcomm.qti.imscmservice@2.1',
        'com.qualcomm.qti.imscmservice@2.2',
        'com.qualcomm.qti.uceservice@2.0',
        'com.qualcomm.qti.uceservice@2.1',
        'com.qualcomm.qti.uceservice@2.2',
        'com.qualcomm.qti.uceservice@2.3',
        'vendor.display.color@1.0',
        'vendor.display.color@1.1',
        'vendor.display.color@1.2',
        'vendor.display.color@1.3',
        'vendor.display.color@1.4',
        'vendor.display.color@1.5',
        'vendor.display.postproc@1.0',
        'vendor.qti.data.factoryservice-V1-ndk',
        'vendor.qti.data.mwqem@1.0',
        'vendor.qti.data.mwqemaidlservice-V1-ndk',
        'vendor.qti.data.slm@1.0',
        'vendor.qti.hardware.data.cneaidlservice.internal.api-V1-ndk',
        'vendor.qti.hardware.data.cneaidlservice.internal.constants-V1-ndk',
        'vendor.qti.hardware.data.cneaidlservice.internal.server-V1-ndk',
        'vendor.qti.hardware.data.connection@1.0',
        'vendor.qti.hardware.data.connection@1.1',
        'vendor.qti.hardware.data.connectionfactory-V1-ndk',
        'vendor.qti.hardware.data.dataactivity-V1-ndk',
        'vendor.qti.hardware.data.dynamicdds@1.0',
        'vendor.qti.hardware.data.dynamicdds@1.1',
        'vendor.qti.hardware.data.dynamicddsaidlservice-V1-ndk',
        'vendor.qti.hardware.data.flow@1.0',
        'vendor.qti.hardware.data.flow@1.1',
        'vendor.qti.hardware.data.flowaidlservice-V1-ndk',
        'vendor.qti.hardware.data.iwlandata-V1-ndk',
        'vendor.qti.hardware.data.ka-V1-ndk',
        'vendor.qti.hardware.data.latency@1.0',
        'vendor.qti.hardware.data.lce@1.0',
        'vendor.qti.hardware.data.lceaidlservice-V1-ndk',
        'vendor.qti.hardware.data.qmiaidlservice-V1-ndk',
        'vendor.qti.hardware.dpmservice@1.1',
        'vendor.qti.hardware.embmssl@1.0',
        'vendor.qti.hardware.embmssl@1.1',
        'vendor.qti.hardware.factory-V1-ndk',
        'vendor.qti.hardware.limits@1.0',
        'vendor.qti.hardware.limits@1.1',
        'vendor.qti.hardware.limits@1.2',
        'vendor.qti.hardware.mwqemadapter@1.0',
        'vendor.qti.hardware.mwqemadapteraidlservice-V1-ndk',
        'vendor.qti.hardware.radio.am@1.0',
        'vendor.qti.hardware.radio.ims@1.0',
        'vendor.qti.hardware.radio.ims@1.1',
        'vendor.qti.hardware.radio.ims@1.2',
        'vendor.qti.hardware.radio.ims@1.3',
        'vendor.qti.hardware.radio.ims@1.4',
        'vendor.qti.hardware.radio.ims@1.5',
        'vendor.qti.hardware.radio.ims@1.6',
        'vendor.qti.hardware.radio.ims@1.7',
        'vendor.qti.hardware.radio.ims@1.8',
        'vendor.qti.hardware.radio.lpa@1.0',
        'vendor.qti.hardware.radio.lpa@1.1',
        'vendor.qti.hardware.radio.lpa@1.2',
        'vendor.qti.hardware.radio.qcrilhook@1.0',
        'vendor.qti.hardware.radio.qtiradio@1.0',
        'vendor.qti.hardware.radio.qtiradio@2.0',
        'vendor.qti.hardware.radio.qtiradio@2.1',
        'vendor.qti.hardware.radio.qtiradio@2.2',
        'vendor.qti.hardware.radio.qtiradio@2.3',
        'vendor.qti.hardware.radio.qtiradio@2.4',
        'vendor.qti.hardware.radio.qtiradio@2.5',
        'vendor.qti.hardware.radio.qtiradio@2.6',
        'vendor.qti.hardware.radio.uim@1.0',
        'vendor.qti.hardware.radio.uim@1.1',
        'vendor.qti.hardware.radio.uim@1.2',
        'vendor.qti.hardware.radio.uim_remote_client@1.0',
        'vendor.qti.hardware.radio.uim_remote_client@1.1',
        'vendor.qti.hardware.radio.uim_remote_client@1.2',
        'vendor.qti.hardware.radio.uim_remote_server@1.0',
        'vendor.qti.hardware.slmadapter@1.0',
        'vendor.qti.ims.callcapability@1.0',
        'vendor.qti.ims.callcapabilityaidlservice-V1-ndk',
        'vendor.qti.ims.callinfo@1.0',
        'vendor.qti.ims.configaidlservice-V1-ndk',
        'vendor.qti.ims.connectionaidlservice-V1-ndk',
        'vendor.qti.ims.factory@1.0',
        'vendor.qti.ims.factory@1.1',
        'vendor.qti.ims.factoryaidlservice-V1-ndk',
        'vendor.qti.ims.rcsconfig@1.0',
        'vendor.qti.ims.rcsconfig@1.1',
        'vendor.qti.ims.rcsconfig@2.0',
        'vendor.qti.ims.rcsconfig@2.1',
        'vendor.qti.ims.rcssipaidlservice-V1-ndk',
        'vendor.qti.ims.rcsuceaidlservice-V1-ndk',
        'vendor.qti.latency@2.0',
        'vendor.qti.latency@2.1',
        'vendor.qti.latency@2.2',
        'vendor.qti.qspmhal@1.0',
        'vendor.qti.qspmhal-V1-ndk',
        'vendor.qti.latencyaidlservice-V1-ndk',
        'vendor.qti.hardware.cacert@1.0',
        'vendor.qti.hardware.embmsslaidl-V1-ndk',
        'vendor.qti.hardware.qxr-V1-ndk',
        'vendor.qti.hardware.vpp-V1-ndk',
    ): lib_fixup_vendor_suffix,
}

blob_fixups: blob_fixups_user_type = {
    'odm/bin/hw/vendor.oplus.hardware.biometrics.fingerprint@2.1-service_uff': blob_fixup()
        .add_needed('libshims_aidl_fingerprint_v3.oplus.so'),
    'odm/etc/camera/config/oplus_camera_config': blob_fixup()
        .call(set_cross_window_blur_zero)
        .call(set_120fps_guide_support)
        .call(set_slowvideo_wide_120fps_not_support)
        .call(set_video_1080p_120fps_support)
        .call(set_video_1080p_120fps_zoom_range)
        .call(set_video_1080p120fps_max_zoom_list)
        .call(set_video_120fps_camera_main_only_support)
        .call(set_video_4k_120fps_support)
        .call(set_video_4k_120fps_zoom_range)
        .call(set_video_4k120fps_max_zoom_list)
        .call(set_video_dv_120fps_support),
    'odm/etc/gps.conf': blob_fixup()
        .binary_regex_replace(b'com.oplus.locationproxy', b'com.google.android.carrierlocation')
        .binary_regex_replace(b'DEBUG_LEVEL = 3', b'DEBUG_LEVEL = 2'),
    (
        'odm/etc/libnfc-mtp-SN220.conf_22825',
        'odm/etc/libnfc-mtp-SN220.conf_22877',
    ): blob_fixup()
        .regex_replace('(NXPLOG_.*_LOGLEVEL)=0x03', '\\1=0x02')
        .regex_replace('NFC_DEBUG_ENABLED=1', 'NFC_DEBUG_ENABLED=0'),
    'odm/lib64/libAlgoProcess.so': blob_fixup()
        .replace_needed('android.hardware.graphics.common-V3-ndk.so', 'android.hardware.graphics.common-V7-ndk.so')
        .replace_needed('android.hardware.graphics.common-V4-ndk.so', 'android.hardware.graphics.common-V7-ndk.so'),
    'odm/lib64/libarcsoft_high_dynamic_range_v4.so': blob_fixup()
        .clear_symbol_version('remote_handle_close')
        .clear_symbol_version('remote_handle_invoke')
        .clear_symbol_version('remote_handle_open')
        .clear_symbol_version('remote_register_buf')
        .clear_symbol_version('remote_register_buf_attr'),
    'odm/lib64/libBasicTonePhoto.so': blob_fixup()
        # Master/Pro-mode photos come out with RED/BLUE swapped. Pro mode captures RAW10 and the
        # OnePlus OCCE tone-mapper (libBasicTonePhoto.so) runs an OpenGL shader whose body contains a
        # U/V (Cb/Cr) reorder `dstYuv = vec4(dstYuv.r, dstYuv.b, dstYuv.g, 1.0)`. On this port the net
        # result is a single uncompensated chroma swap -> R/B swapped JPEG. Undo the swap in the
        # embedded GLSL (length-preserving). Normal/Photo mode does NOT use BasicTone, so this only
        # affects the (otherwise crisp) Master/Pro path..
        .binary_regex_replace(
            b'vec4\\(dstYuv\\.r, dstYuv\\.b, dstYuv\\.g, 1\\.0\\)',
            b'vec4(dstYuv.r, dstYuv.g, dstYuv.b, 1.0)',
        ),
    (
        'odm/lib64/libCOppLceTonemapAPI.so',
        'odm/lib64/libSuperRaw.so',
        'odm/lib64/libYTCommon.so',
        'odm/lib64/libyuv2.so',
    ): blob_fixup()
        .replace_needed('libstdc++.so', 'libstdc++_vendor.so'),
    (
        'odm/lib64/libdisplaycolorfeature.so',
        'odm/lib64/libdisplayfossfeature_nature.so',
        'vendor/lib64/libdpps.so',
        'vendor/lib64/libsnapdragoncolor-manager.so',
    ): blob_fixup()
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v34.so'),
    (
        'odm/lib64/libEIS.so',
        'odm/lib64/libEISLive.so',
        'odm/lib64/libHIS.so',
        'odm/lib64/libOGLManager.so',
        'odm/lib64/libOPAlgoCamFaceBeautyCap.so',
    ): blob_fixup()
        .clear_symbol_version('AHardwareBuffer_allocate')
        .clear_symbol_version('AHardwareBuffer_describe')
        .clear_symbol_version('AHardwareBuffer_lock')
        .clear_symbol_version('AHardwareBuffer_release')
        .clear_symbol_version('AHardwareBuffer_unlock'),
    'product/etc/sysconfig/com.android.hotwordenrollment.common.util.xml': blob_fixup()
        .regex_replace('/my_product', '/product'),
    'system_ext/bin/horae': blob_fixup()
        .replace_needed('libprotobuf-cpp-lite.so', 'libprotobuf-cpp-lite-21.7.so'),
    'vendor/etc/seccomp_policy/atfwd@2.0.policy': blob_fixup()
        .add_line_if_missing('lseek: 1'),
    'vendor/bin/init.kernel.post_boot-memory.sh': blob_fixup()
        .regex_replace('# echo always', 'echo always'),
    'vendor/bin/system_dlkm_modprobe.sh': blob_fixup()
        .regex_replace(r'.*\bzram or zsmalloc\b.*\n', '')
        .regex_replace(r'-e "zram" -e "zsmalloc"', ''),
    'vendor/bin/vendor_modprobe.sh': blob_fixup()
        .regex_replace(r'\n.*OPLUS_BUG_STABILITY[\s\S]*?OPLUS_BUG_STABILITY.*\n', ''),
    (
        'vendor/bin/qcc-vendor',
        'vendor/bin/qms',
        'vendor/bin/xtra-daemon',
        'vendor/lib64/libcne.so',
        'vendor/lib64/libqcc_sdk.so',
        'vendor/lib64/libqms_client.so',
        'vendor/lib64/vendor.libdpmframework.so',
    ): blob_fixup()
        .add_needed('libbinder_shim.so'),
    (
        'vendor/etc/media_codecs_cliffs_v0.xml',
        'vendor/etc/media_codecs_cliffs_v1.xml',
        'vendor/etc/media_codecs_pineapple.xml',
    ): blob_fixup()
        .regex_replace('.*media_codecs_(google_audio|google_c2|google_telephony|google_video|vendor_audio).*\n', ''),
    'vendor/etc/init/nicmd.rc': blob_fixup()
        .regex_replace(
            r'(service\s+vendor\.nicmd\s+/system/vendor/bin/nicmd\s*\n\s*class\s+main)',
            r'\1\n    user root\n    group root'
        ),
    'vendor/etc/init/vendor.dpmd.rc': blob_fixup()
        .regex_replace(
            r'(service\s+vendor\.dpmd\s+/vendor/bin/vendor\.dpmd\s*\n)',
            r'\1    user root\n'
        ),
    'vendor/etc/libnfc-nci.conf': blob_fixup()
        .regex_replace('NFC_DEBUG_ENABLED=1', 'NFC_DEBUG_ENABLED=0'),
    'vendor/etc/pwr/PowerFeatureConfig.xml': blob_fixup()
        .regex_replace(r'(<Name>GamePowerOptFeature</Name>\s*<Enable>)0(<\/Enable>)', r'\g<1>1\g<2>'),
    'vendor/etc/seccomp_policy/gnss@2.0-qsap-location.policy': blob_fixup()
        .add_line_if_missing('sched_get_priority_min: 1')
        .add_line_if_missing('sched_get_priority_max: 1'),
    'vendor/etc/sensors/hals.conf': blob_fixup()
        .add_line_if_missing('sensors.oplus.so')
        .regex_replace('sensors.qsh.so', 'sensors.wrapper.so'),
    'vendor/lib64/libcwb_qcom_aidl.so': blob_fixup()
        .add_needed('libui_shim.so'),
    (
        'vendor/lib64/libcwb_qcom_aidl.so',
        'vendor/lib64/libpwirishalwrapper.so',
        'odm/lib64/libpwirishalwrapper.so'
    ): blob_fixup()
        .replace_needed('android.hardware.graphics.composer3-V2-ndk.so', 'android.hardware.graphics.composer3-V3-ndk.so'),
    'vendor/lib64/libqcodec2_core.so': blob_fixup()
        .add_needed('libcodec2_shim.so'),
    (
        'vendor/lib64/libVoiceSdk.so',
        'vendor/lib64/libcapiv2uvvendor.so',
        'vendor/lib64/liblistensoundmodel2vendor.so',
    ): blob_fixup()
        .replace_needed('libtensorflowlite_c.so', 'libtensorflowlite_c_vendor.so'),
    'vendor/lib64/vendor.libdpmframework.so': blob_fixup()
        .add_needed('libhidlbase_shim.so'),
    (
        'odm/lib64/camera/components/com.oplus.node.mvgsat.so',
        'odm/lib64/camera/components/com.oplus.node.sstabphoto.so',
        'odm/lib64/hw/camera.oemlayer.so',
        'odm/lib64/libmvgcommon.so',
        'odm/lib64/libsharebuffer_impl.so',
        'vendor/lib64/camera/components/com.qti.node.dewarp.so',
    ): blob_fixup()
        .replace_needed('libui.so', 'libui-oplus.so'),
    'vendor/lib64/libui-oplus.so': blob_fixup()
        .replace_needed('android.hardware.graphics.common-V4-ndk.so', 'android.hardware.graphics.common-V7-ndk.so'),
}  # fmt: skip

module = ExtractUtilsModule(
    'oneplus12',
    'oneplus',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
    add_firmware_proprietary_file=False,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
