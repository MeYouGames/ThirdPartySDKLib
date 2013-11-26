LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := TangoSDK_static

LOCAL_MODULE_FILENAME := libTangoSDKStatic

LOCAL_SRC_FILES := JniHelpers.cpp \
                   TangoSDKBridge.cpp
                   

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)

LOCAL_C_INCLUDES := $(LOCAL_PATH)

LOCAL_CFLAGS := -fexceptions

LOCAL_WHOLE_STATIC_LIBRARIES += cocos2dx_static
            
include $(BUILD_STATIC_LIBRARY)