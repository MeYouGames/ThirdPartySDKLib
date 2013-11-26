package com.meyougames.thirdpartysdklib.tango;

import android.util.Log;

/**
 * This bridge is used to let cocos2dx functions perform actions on StoreController (through JNI).
 *
 * You can see the documentation of every function in {@link StoreController}
 */
public class TangoSDKBridge {

    static void initSDK() {
        Log.d("TangoSDKBridge", "TangoSDK is init from java !");
    }
}
