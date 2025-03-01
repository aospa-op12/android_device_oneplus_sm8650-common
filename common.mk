#
# Copyright (C) 2021-2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/vabc_features.mk)

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=erofs \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=erofs \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    checkpoint_gc \
    otapreopt_script

PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := lz4

# AAPT
PRODUCT_AAPT_CONFIG := xxxhdpi
PRODUCT_AAPT_PREF_CONFIG := xxxhdpi

# ANT+
PRODUCT_PACKAGES += \
    AntHalService-Soong \
    com.dsi.ant@1.0.vendor

# Alert slider
PRODUCT_PACKAGES += \
    KeyHandler \
    tri-state-key-calibrate

# Audio
SOONG_CONFIG_NAMESPACES += android_hardware_audio
SOONG_CONFIG_android_hardware_audio += \
    run_64bit
SOONG_CONFIG_android_hardware_audio_run_64bit := true

PRODUCT_PACKAGES += \
    android.hardware.audio.service \
    sound_trigger.primary.pineapple \
    vendor.qti.audio-adsprpc-service.rc

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_pineapple/audio_effects.xml \
    $(LOCAL_PATH)/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_pineapple_qssi/audio_policy_configuration.xml \
    $(LOCAL_PATH)/audio/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    $(LOCAL_PATH)/audio/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml

# Authsecret
PRODUCT_PACKAGES += \
    android.hardware.authsecret@1.0.vendor

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth.audio-V2-ndk.vendor

# Blur
TARGET_ENABLE_BLUR := true

# Boot control
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-impl-qti \
    android.hardware.boot@1.2-impl-qti.recovery \
    android.hardware.boot@1.2-service

# Camera
PRODUCT_PACKAGES += \
    android.frameworks.stats-V1-ndk.vendor \
    android.hardware.camera.common-V1-ndk.vendor \
    android.hardware.camera.device-V2-ndk.vendor \
    android.hardware.camera.metadata-V2-ndk.vendor \
    android.hardware.camera.provider-V2-ndk.vendor \
    libcamera_metadata.vendor \
    libexif.vendor \
    libutilscallstack.vendor \
    libyuv.vendor \
    vendor.qti.hardware.camera.postproc@1.0.vendor

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.concurrent.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.concurrent.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml

# Characteristics
PRODUCT_CHARACTERISTICS := nosdcard

# Configstore
PRODUCT_PACKAGES += \
    vendor.qti.hardware.capabilityconfigstore@1.0.vendor

# Context Hub
PRODUCT_PACKAGES += \
    android.hardware.contexthub-V2-ndk.vendor

# Dalvik
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)

# DebugFS
PRODUCT_SET_DEBUGFS_RESTRICTIONS := true

# Display
TARGET_COMPOSER_HAS_NO_EXTENSION := true

PRODUCT_PACKAGES += \
    vendor.qti.hardware.display.composer-service.rc \
    vendor.qti.hardware.display.composer-service.xml

PRODUCT_ODM_PROPERTIES += \
    persist.sys.sf.color_mode=0 \
    vendor.display.disable_hw_recovery_dump=1 \
    vendor.display.enable_hdr10_gpu_target=0 \
    vendor.display.enable_fb_scaling=1

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm-V1-ndk.vendor \
    android.hardware.drm-service.clearkey

# Enforce generic ramdisk allow list
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# Fastboot
PRODUCT_PACKAGES += \
    android.hardware.fastboot-service.example_recovery \
    fastbootd

# Fingerprint
PRODUCT_PACKAGES += \
    vendor.oplus.hardware.commondcs-service \

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml

# Gatekeeper
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper-V1-ndk.vendor \
    android.hardware.gatekeeper@1.0.vendor \
    libgatekeeper.vendor

# GPS
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/gps.conf:$(TARGET_COPY_OUT_ODM)/etc/gps.conf

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml

PRODUCT_PACKAGES += \
    android.hardware.gnss-V3-ndk.vendor

# Graphics
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute-0.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_3.xml \
    frameworks/native/data/etc/android.software.opengles.deqp.level-2023-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2023-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml

# Health
PRODUCT_PACKAGES += \
    android.hardware.health-service.qti \
    android.hardware.health-service.qti_recovery \
    android.hardware.health-V1-ndk.vendor \
    android.hardware.health-V2-ndk.vendor \
    android.hardware.health@1.0.vendor \
    android.hardware.health@2.1.vendor

# Hotword enrollment
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/privapp-permissions-hotword.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-hotword.xml

# IR Blaster
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.consumerir.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/android.hardware.consumerir.xml

PRODUCT_PACKAGES += \
    android.hardware.ir-service.oplus \
    consumerir.default

# Init
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init/fstab.qcom:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.qcom \
    $(LOCAL_PATH)/init/vendor_modprobe.sh:$(TARGET_COPY_OUT_VENDOR)/bin/vendor_modprobe.sh

PRODUCT_PACKAGES += \
    fstab.qcom \
    init.oplus.rc \
    init.target.rc \
    ueventd.oplus.rc

# Identity
PRODUCT_PACKAGES += \
    android.hardware.identity-V5-ndk.vendor

# Keymaster
PRODUCT_PACKAGES += \
    android.hardware.hardware_keystore.xml \
    android.hardware.keymaster-V3-ndk.vendor \
    android.hardware.keymaster@4.1.vendor \
    libkeymaster_messages.vendor

# Keymint
PRODUCT_PACKAGES += \
    android.hardware.security.keymint-V1-ndk.vendor \
    android.hardware.security.keymint-V2-ndk.vendor \
    android.hardware.security.keymint-V3-ndk.vendor \
    android.hardware.security.rkp-V3-ndk.vendor \
    android.hardware.security.secureclock-V1-ndk.vendor \
    android.hardware.security.sharedsecret-V1-ndk.vendor

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.keystore.app_attest_key.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.keystore.app_attest_key.xml \
    frameworks/native/data/etc/android.software.device_id_attestation.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_id_attestation.xml

# Logging
SPAMMY_LOG_TAGS := \
    OplusTouchDaemon \
    vendor.qti.bluetooth@1.1-wake_lock \
    vendor.qti.bluetooth@1.1-ibs_handler \
    IRIS_LOG_SERV_I7 \
    SDM \
    synaLib \
    CwbService \
    occe_create \
    DisplayModeController

ifneq ($(TARGET_BUILD_VARIANT),eng)
PRODUCT_VENDOR_PROPERTIES += \
    $(foreach tag,$(SPAMMY_LOG_TAGS),log.tag.$(tag)=S)
endif

# Media
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/media_profiles_vendor.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_vendor.xml

# Media (Dolby)
PRODUCT_PACKAGES += \
    libcodec2_soft_common.vendor \
    libsfplugin_ccodec_utils.vendor \
    libstagefright_foundation-v33 \
    OplusDolby

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/dolby/dax-default.xml:$(TARGET_COPY_OUT_VENDOR)/etc/dolby/dax-default.xml

# Memtrack
PRODUCT_PACKAGES += \
    vendor.qti.hardware.memtrack-service

# Net
PRODUCT_PACKAGES += \
    android.system.net.netd-V1-ndk.vendor

# NFC
PRODUCT_PACKAGES += \
    android.hardware.nfc-service.nxp \
    android.hardware.secure_element-V1-ndk.vendor \
    android.hardware.secure_element@1.0.vendor \
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

# OSENSE
PRODUCT_PACKAGES += \
    vendor.oplus.hardware.osense.client-service

# Overlays
$(call inherit-product, hardware/oplus/overlay/overlay.mk)

DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay-yaap

PRODUCT_ENFORCE_RRO_TARGETS := *
PRODUCT_PACKAGES += \
    CarrierConfigResCommon \
    FrameworksResTarget \
    OPlusFrameworksResCommon \
    OPlusSettingsResCommon \
    OPlusSystemUIResCommon \
    WifiResTarget

# Partitions
PRODUCT_PACKAGES += \
    vendor_bt_firmware_mountpoint \
    vendor_dsp_mountpoint \
    vendor_firmware_mnt_mountpoint

PRODUCT_USE_DYNAMIC_PARTITIONS := true

# PowerShare
PRODUCT_PACKAGES += \
    vendor.aospa.powershare-service

# QCOM
TARGET_BOARD_PLATFORM := pineapple

# QTI components
TARGET_COMMON_QTI_COMPONENTS := \
    audio \
    av \
    bt \
    display \
    init \
    media \
    overlay \
    perf \
    telephony \
    usb \
    wfd \
    wlan

include $(LOCAL_PATH)/qti.mk

TARGET_USE_AIDL_QTI_BT_AUDIO := true

# QTI service tracker
PRODUCT_PACKAGES += \
    vendor.qti.hardware.servicetracker@1.2.vendor

# RIL
# The default value of this variable is false and should only be set to true when
# the device allows users to retain eSIM profiles after factory reset of user data.
PRODUCT_PRODUCT_PROPERTIES += \
    masterclear.allow_retain_esim_profiles_after_fdr=true

# QSPA
PRODUCT_PACKAGES += \
    vendor.qti.qspa-service

# Sensors
PRODUCT_PACKAGES += \
    android.frameworks.sensorservice-V1-ndk.vendor \
    android.frameworks.sensorservice@1.0.vendor \
    android.hardware.sensors-V2-ndk.vendor \
    android.hardware.sensors-service.oplus-multihal \
    libdumpstateutil.vendor \
    libsensorndkbridge \
    sensors.dynamic_sensor_hal \
    sensors.oplus

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf

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

# Shims
PRODUCT_PACKAGES += \
    libshim_ui \
    libcodec2_shim \
    libgui_shim \
    libhidlbase_shim

# Shipping API
BOARD_SHIPPING_API_LEVEL := 34
PRODUCT_SHIPPING_API_LEVEL := $(BOARD_SHIPPING_API_LEVEL)

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/oplus

# Storage
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Telephony
PRODUCT_PACKAGES += \
    OplusEuicc

PRODUCT_PACKAGES += \
    qcrilNrDb_vendor

ifeq ($(TARGET_DISABLES_GMS),true)
PRODUCT_PACKAGES += \
    OpenEUICC
endif

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.euicc.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.hardware.telephony.euicc.xml \
    frameworks/native/data/etc/android.hardware.telephony.mbms.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.mbms.xml

# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal-service.qti \
    android.hardware.thermal-V1-ndk.vendor \
    android.hardware.thermal@2.0.vendor

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/thermal-engine.conf:$(TARGET_COPY_OUT_VENDOR)/etc/thermal-engine.conf

$(call soong_config_set,qti_thermal,netlink,true)

# Touch
PRODUCT_PACKAGES += \
    TouchGestures \
    vendor.lineage.touch@1.0-service.oplus

$(call soong_config_set,OPLUS_LINEAGE_TOUCH_HAL,INCLUDE_DIR,$(LOCAL_PATH)/touch/include)

# Trusted User Interface
PRODUCT_PACKAGES += \
    android.hidl.memory.block@1.0.vendor \
    vendor.qti.hardware.systemhelper@1.0.vendor

# Virtualization service
$(call inherit-product, packages/modules/Virtualization/apex/product_packages.mk)

# Update engine
PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

PRODUCT_PACKAGES_DEBUG += \
    update_engine_client

# USB
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/usb/usb_compositions.conf:$(TARGET_COPY_OUT_ODM)/etc/usb_compositions.conf

# Verified Boot
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml

# Vibrator
PRODUCT_PACKAGES += \
    vendor.qti.hardware.vibrator.service.oplus

PRODUCT_COPY_FILES += \
    vendor/qcom/opensource/vibrator/excluded-input-devices.xml:$(TARGET_COPY_OUT_VENDOR)/etc/excluded-input-devices.xml

# WiFi firmware symlinks
PRODUCT_PACKAGES += \
    firmware_wlanmdsp.otaupdate_symlink \
    firmware_wlan_mac.bin_symlink \
    firmware_WCNSS_qcom_cfg.ini_symlink

# WiFi Display
PRODUCT_PACKAGES += \
    libnl \
    libpng.vendor \
    libwfdaac_vendor

# Inherit from the proprietary files makefile.
$(call inherit-product, vendor/oneplus/sm8650-common/sm8650-common-vendor.mk)
