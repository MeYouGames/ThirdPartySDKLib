//
//  TangoSDKBridge.h
//  ThirdPartySDKLib
//
//  Created by MeYouGames on 13-10-13.
//  Copyright (c) 2013年 MeYouGames. All rights reserved.
//

#ifndef __ThirdPartySDKLib__TangoSDKBridge__
#define __ThirdPartySDKLib__TangoSDKBridge__


#include "cocos2d.h"
using namespace cocos2d;

class TangoSDKBridge {
public:
    TangoSDKBridge();
    ~TangoSDKBridge();
    
    static void initSDK();
    
    static void Authenticate();
    
    static CCTexture2D * CCString2CCTexture2D(CCString * str);
};

#endif /* defined(__ThirdPartySDKLib__TangoSDKBridge__) */
