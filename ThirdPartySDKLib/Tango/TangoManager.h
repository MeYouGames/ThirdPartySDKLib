//
//  TangoManager.h
//  ThirdPartySDKLib
//
//  Created by MeYouGames on 13-10-13.
//  Copyright (c) 2013年 MeYouGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SynthesizeSingleton.h"
#include "IOSNDKHelper.h"
#import <TangoSDK/TangoSDK.h>

@interface TangoManager : NSObject{
    
}

@property (nonatomic, strong) TangoProfileEntry *profile;

+ (TangoManager *) sharedInstance;

- (void)initSDK;

- (void)sessionInitialize;
- (void)sessionUnitialize;
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *) url
  sourceApplication:(NSString *) requester;

- (void)authenticate:(NSObject *)prms;
- (void)getMyProfile:(NSObject *)prms; // 获取自己信息
- (void)getFriendProfile:(NSObject *)prms // 获取朋友信息 (并不直接调用)
               useCached:(BOOL)cached; 
- (void)getFriendProfile_cached:(NSObject *)prms;
- (void)getFriendProfile_current:(NSObject *)prms;

- (void)SampleSelector:(NSObject *)prms;

//+ (NSString*)base64forData:(NSData*)theData;

@end
