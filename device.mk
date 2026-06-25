#
# Copyright (C) 2021-2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=erofs \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    checkpoint_gc \
    otapreopt_script

# AAPT
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxxhdpi

# Alert slider
PRODUCT_PACKAGES += \
    KeyHandler \
    tri-state-key-calibrate

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio.service \
    sound_trigger.primary.pineapple

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_pineapple/audio_policy_configuration.xml \
    $(LOCAL_PATH)/configs/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_pineapple_qssi/audio_policy_configuration.xml \
    $(LOCAL_PATH)/configs/audio/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    $(LOCAL_PATH)/configs/audio/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml

$(call soong_config_set_bool,android_hardware_audio,run_64bit,true)
$(call soong_config_set_bool,android_hardware_audio,skip_speaker_layout_channel_mask_field,true)
$(call soong_config_set,qtiaudio,feature_agm_hidl,true)
$(call soong_config_set,qtiaudio,feature_gef_support,true)
$(call soong_config_set,qtiaudio,feature_instance_id,true)
$(call soong_config_set,qtiaudio,feature_pal_hidl,true)

# Boot animation
TARGET_SCREEN_HEIGHT := 3216
TARGET_SCREEN_WIDTH := 1440

# Boot control
PRODUCT_PACKAGES += \
    android.hardware.boot-service.qti \
    android.hardware.boot-service.qti.recovery

# Camera
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.concurrent.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.concurrent.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml

# Context Hub
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.context_hub.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/android.hardware.context_hub.xml

# Dalvik
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)

# DebugFS
PRODUCT_SET_DEBUGFS_RESTRICTIONS := true

# Display
PRODUCT_ODM_PROPERTIES += \
    persist.sys.sf.color_mode=0 \
    vendor.display.disable_hw_recovery_dump=1 \
    vendor.display.enable_hdr10_gpu_target=0

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/display/displayconfig.xml:$(TARGET_COPY_OUT_VENDOR)/etc/displayconfig/display_id_4630946450791512195.xml

$(call soong_config_set,qtidisplay,pxlw_hw_iris7,true)
$(call soong_config_set,qtidisplay,pxlw_vendor_namespace,vendor/oneplus/oneplus12)

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm-service.clearkey

# Enforce generic ramdisk allow list
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# Fastboot
PRODUCT_PACKAGES += \
    android.hardware.fastboot-service.example_recovery \
    fastbootd

# Fingerprint
PRODUCT_PACKAGES += \
    IFAAService

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml

$(call soong_config_set,surfaceflinger,udfps_lib,//hardware/oplus:libudfps_extension.oplus)

# Graphics
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute-0.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_3.xml \
    frameworks/native/data/etc/android.software.opengles.deqp.level-2023-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2023-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml

# GPS
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml

# Health
PRODUCT_PACKAGES += \
    android.hardware.health-service.qti \
    android.hardware.health-service.qti_recovery

# Hotword enrollment
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/permissions/privapp-permissions-hotword.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-hotword.xml

# HWUI
TARGET_USES_VULKAN := true

# Init
PRODUCT_PACKAGES += \
    fstab.qcom \
    fstab.qcom.vendor_ramdisk \
    init.class_main.sh \
    init.kernel.post_boot.sh \
    init.kernel.post_boot-cliffs_default_3_4_1.sh \
    init.kernel.post_boot-pineapple.sh \
    init.kernel.post_boot-pineapple_default_2_3_2_1.sh \
    init.oplus.rc \
    init.qcom.early_boot.sh \
    init.qcom.post_boot.sh \
    init.qcom.rc \
    init.qcom.recovery.rc \
    init.qcom.sh \
    init.qti.kernel.rc \
    init.target.rc \
    ueventd.oplus.rc \
    ueventd.qcom.rc

$(call soong_config_set,libinit,vendor_init_lib,//$(LOCAL_PATH):libinit_oplus)

# IR
PRODUCT_PACKAGES += \
    android.hardware.ir-service.oplus

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.consumerir.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/android.hardware.consumerir.xml

# Kernel
TARGET_USES_KERNEL_PLATFORM := false

# Keymint
PRODUCT_PACKAGES += \
    android.hardware.hardware_keystore_V3.xml \
    android.hardware.security.keymint3-service.strongbox.nxp \
    android.hardware.weaver-service.nxp

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.keystore.app_attest_key.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.keystore.app_attest_key.xml \
    frameworks/native/data/etc/android.software.device_id_attestation.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_id_attestation.xml

# Lineage Health
PRODUCT_PACKAGES += \
    vendor.lineage.health-service.default

$(call soong_config_set,lineage_health,charging_control_charging_path,/sys/class/oplus_chg/battery/mmi_charging_enable)

# Memtrack
PRODUCT_PACKAGES += \
    vendor.qti.hardware.memtrack-service

# NFC
PRODUCT_PACKAGES += \
    android.hardware.nfc-service.nxp \
    com.android.nfc_extras \
    Tag

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.nfc.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.ese.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hcef.xml \
    frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml \
    frameworks/native/data/etc/android.hardware.se.omapi.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.ese.xml \
    frameworks/native/data/etc/android.hardware.se.omapi.uicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.uicc.xml \
    frameworks/native/data/etc/com.android.nfc_extras.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.android.nfc_extras.xml \
    frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nxp.mifare.xml

# OPlus dummy services
PRODUCT_PACKAGES += \
    vendor.oplus.hardware.commondcs-service \
    vendor.oplus.hardware.osense.client-service \
    vendor.oplus.hardware.performance-service

# Overlays
$(call inherit-product, hardware/oplus/overlay/overlay.mk)

PRODUCT_ENFORCE_RRO_TARGETS := *
PRODUCT_PACKAGES += \
    ApertureResTarget \
    CarrierConfigResCommon \
    FrameworksResEuicc_EU \
    FrameworksResEuicc_NA \
    FrameworksResTargetCommon \
    KeyHandlerResTarget \
    OPlusFrameworksResCommon \
    OPlusFrameworksResTarget \
    OPlusSettingsProviderResTarget \
    OPlusSettingsResCommon \
    OPlusSettingsResTarget \
    OPlusSystemUIResCommon \
    OPlusSystemUIResTarget \
    OPlusWifiResTarget \
    WifiResTarget

# Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Platform
TARGET_BOARD_PLATFORM := pineapple

# Power
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/profiles/task_profiles.json:$(TARGET_COPY_OUT_VENDOR)/etc/task_profiles.json

# QTI components
TARGET_COMMON_QTI_COMPONENTS := \
    audio \
    av \
    bt \
    display \
    media \
    overlay \
    perf \
    telephony \
    usb \
    vibrator \
    wfd \
    wlan

include $(LOCAL_PATH)/qti.mk

# QSPA
PRODUCT_PACKAGES += \
    qspa_vendor.rc \
    vendor.qti.qspa-service

# Regional properties
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/root/vendor/odm/etc/22825/build.default.prop:$(TARGET_COPY_OUT_ODM)/etc/22825/build.default.prop \
    $(LOCAL_PATH)/recovery/root/vendor/odm/etc/22877/build.EU.prop:$(TARGET_COPY_OUT_ODM)/etc/22877/build.EU.prop \
    $(LOCAL_PATH)/recovery/root/vendor/odm/etc/22877/build.IN.prop:$(TARGET_COPY_OUT_ODM)/etc/22877/build.IN.prop \
    $(LOCAL_PATH)/recovery/root/vendor/odm/etc/22877/build.NA.prop:$(TARGET_COPY_OUT_ODM)/etc/22877/build.NA.prop \
    $(LOCAL_PATH)/recovery/root/vendor/odm/etc/22877/build.default.prop:$(TARGET_COPY_OUT_ODM)/etc/22877/build.default.prop

# SecureElement
PRODUCT_PACKAGES += \
    SecureElementResTarget_Vendor

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/permissions/com.android.se.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.android.se.xml

# Sensors
PRODUCT_PACKAGES += \
    android.hardware.sensors-service.oplus-multihal \
    sensors.dynamic_sensor_hal \
    sensors.oplus \
    sensors.wrapper

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.ambient_temperature.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.ambient_temperature.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.dynamic.head_tracker.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.dynamic.head_tracker.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.hifi_sensors.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.hifi_sensors.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.relative_humidity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.relative_humidity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml

$(call soong_config_set,oplus_sensors,uses_tap_sensor,true)
$(call soong_config_set,oplus_sensors,uses_double_tap_sensor,true)

# Shipping API
BOARD_SHIPPING_API_LEVEL := 34
PRODUCT_SHIPPING_API_LEVEL += $(BOARD_SHIPPING_API_LEVEL)

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/oplus

# Storage
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Telephony
PRODUCT_PACKAGES += \
    OplusEuicc

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.euicc.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.hardware.telephony.euicc.xml

# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal-service.qti

# Update engine
PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

# USB
PRODUCT_PACKAGES += \
    oplus_usb_compositions.conf

# Verified Boot
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml

# Vibrator
$(call soong_config_set_bool,qti_vibrator,use_effect_stream,true)
$(call soong_config_set,qti_vibrator,effect_lib,libqtivibratoreffect.oneplus12)

# VINTF
AUDIO_HAL_DIR := vendor/qcom/opensource/audio-hal/primary-hal

DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    hardware/oplus/vintf/device_framework_matrix.xml

DEVICE_MANIFEST_FILE := \
    $(LOCAL_PATH)/vintf/manifest_pineapple.xml \
    $(LOCAL_PATH)/vintf/network_manifest.xml \
    vendor/qcom/opensource/audio-hal/primary-hal/configs/common/manifest_non_qmaa.xml \
    vendor/qcom/opensource/audio-hal/primary-hal/configs/common/manifest_non_qmaa_extn.xml

# Virtualization service
$(call inherit-product, packages/modules/Virtualization/apex/product_packages.mk)

# WiFi firmware symlinks
PRODUCT_PACKAGES += \
    firmware_wlanmdsp.otaupdate_symlink \
    firmware_wlan_mac.bin_symlink \
    firmware_WCNSS_qcom_cfg.ini_symlink

# Inherit from the proprietary files makefile.
$(call inherit-product, vendor/oneplus/oneplus12/oneplus12-vendor.mk)
