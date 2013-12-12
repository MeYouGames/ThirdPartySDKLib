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
        //��ӣ� �������ҪΪ һ��activity ���Խ��ܵĲ���ȴҪ��һ��object�Ϳ���
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
//    // ����Լ�������full_nameΪ�գ�����jason����װ��You������ // ��ȡ�Լ���Ϣ
//     void getMyProfile(JSONObject prms) {
//    	 
//     }
//
//    // ��ȡ������Ϣ ����ֱ�ӵ���
//     void getFriendProfile(JSONObject prms, boolean useCached, boolean hasTheApp) {
//    	 
//     }
//                   
//     void getFriendProfile_cached(JSONObject prms) {
//    	 
//     }
//     void getFriendProfile_current(JSONObject prms){}
//
//     void getProfileAvatar(JSONObject prms){} // ��ȡ����ͷ��
//
//     void loadPossessions(JSONObject prms){} // ��õ�ǰ��ҲƲ�
//     void savePossessions(JSONObject prms){} // ���õ�ǰ��ҲƲ�
//
//    // void loadMetrics(JSONObject prms){} // ��ȡ����
//    // void saveMetrics(JSONObject prms){} // �������
//     void saveScore(JSONObject prms){} // ����ɼ�
//     void saveLevel(JSONObject prms){} // ����ȼ�
//
//    // �޷����Լ��Ŀ����ֱ�ɡ�You��
//     void fetchLeaderBoard(JSONObject prms){} // ��ȡ���а�
//
//     void sendInventationMessageWithUrl(JSONObject prms){}
//     void sendHeartMessage(JSONObject prms){}
//     void sendBragMessage(JSONObject prms){}
//
//     void SampleSelector(JSONObject prms){}
    
    
}
