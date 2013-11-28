package com.meyougames.thirdpartysdklib.tango;

import android.util.Log;

/**
 * This bridge is used to let cocos2dx functions perform actions on StoreController (through JNI).
 *
 * You can see the documentation of every function in {@link StoreController}
 */
public class TangoManager {

	/** Singleton **/

    private static TangoManager sInstance = null;

    public static TangoManager getInstance(){
        if (sInstance == null){
            sInstance = new TangoManager();
        }

        return sInstance;
    }

    private TangoManager() {
    }

    void initSDK() {
        Log.d("TangoSDKBridge", "TangoSDK is init from java, all tango features should be implemented in this class !");
    }
}
