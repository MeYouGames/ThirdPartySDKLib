package com.meyougames.thirdpartysdklib.tango;

import org.json.JSONObject;

import android.app.NotificationManager;
import android.content.Context;
import android.util.Log;

import com.easyndk.classes.AndroidNDKHelper;
import com.soomla.store.StoreController;
import com.tango.sdk.SessionFactory;
/**
 * This bridge is used to let cocos2dx functions perform actions on StoreController (through JNI).
 *
 * You can see the documentation of every function in {@link StoreController}
 */
public class TangoManager {

	/** Singleton **/
	private static final String tag = "TangoManager";
    private static TangoManager sInstance = null;
    private Context context = null;

    public static TangoManager getInstance(){
        if (sInstance == null){
            sInstance = new TangoManager();
        }

        return sInstance;
    }

    public void  setContext(Context context)
    {
    	this.context = context;
    }
    private TangoManager() {
    }

    void  initSDK() {
        Log.d("TangoSDKBridge", "TangoSDK is init from java, all tango features should be implemented in this class !");
        //大坑！ 这里必须要为 一个activity 可以接受的参数却要求一个object就可以
       // AndroidNDKHelper.SetNDKReciever(context);
        
//        String ns = context.NOTIFICATION_SERVICE;
//        NotificationManager mNotificationManager = (NotificationManager)context.getSystemService(ns);
        //todo!
    }
    
  //  void  isAuthenticate(JSONObject prms) {
//    	Log.i(tag, "isAuthenticate");
//    	Log.i(tag, obj.toString());
//    	
//    	String CPPFunctionToBeCalled = prms.getString("simple_callback");
//    	String CPPFunctionToBeCalled_Error = prms.getString("is_authenticate_false_callback");
    	
//    	if (SessionFactory.getSession().is) {
//			
//		} else {
//
//		}
  //  }
    
    
     void authenticate(JSONObject prms){
    	 Log.i("tango", "auth~~~~!");
     }
//     void authenticate_inst_tango(JSONObject prms){
//    	 
//     }
//    // 如果自己的名字full_name为空，则在jason中组装“You”发出 // 获取自己信息
//     void getMyProfile(JSONObject prms) {
//    	 
//     }
//
//    // 获取朋友信息 并不直接调用
//     void getFriendProfile(JSONObject prms, boolean useCached, boolean hasTheApp) {
//    	 
//     }
//                   
//     void getFriendProfile_cached(JSONObject prms) {
//    	 
//     }
//     void getFriendProfile_current(JSONObject prms){}
//
//     void getProfileAvatar(JSONObject prms){} // 获取单独头像
//
//     void loadPossessions(JSONObject prms){} // 获得当前玩家财产
//     void savePossessions(JSONObject prms){} // 设置当前玩家财产
//
//    // void loadMetrics(JSONObject prms){} // 提取参数
//    // void saveMetrics(JSONObject prms){} // 保存参数
//     void saveScore(JSONObject prms){} // 保存成绩
//     void saveLevel(JSONObject prms){} // 保存等级
//
//    // 无法将自己的空名字变成“You”
//     void fetchLeaderBoard(JSONObject prms){} // 获取排行榜
//
//     void sendInventationMessageWithUrl(JSONObject prms){}
//     void sendHeartMessage(JSONObject prms){}
//     void sendBragMessage(JSONObject prms){}
//
//     void SampleSelector(JSONObject prms){}
    
    
}
