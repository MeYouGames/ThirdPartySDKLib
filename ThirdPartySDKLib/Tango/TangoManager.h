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

@property (nonatomic, strong) TangoProfileEntry * profile;
@property (nonatomic, strong) NSArray * possessions;

+ (TangoManager *) sharedInstance;

- (void)initSDK;

- (void)sessionInitialize;
- (void)sessionUnitialize;
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *) url
  sourceApplication:(NSString *) requester;

- (void)isAuthenticate:(NSObject *)prms; // 获取是否已经授权
- (void)authenticate:(NSObject *)prms;
- (void)getMyProfile:(NSObject *)prms; // 获取自己信息
- (void)getFriendProfile:(NSObject *)prms // 获取朋友信息 (并不直接调用)
               useCached:(BOOL)cached; 
- (void)getFriendProfile_cached:(NSObject *)prms;
- (void)getFriendProfile_current:(NSObject *)prms;

- (void)loadPossessions:(NSObject *)prms; // 获得当前玩家财产
- (void)savePossessions:(NSObject *)prms; // 设置当前玩家财产

//- (void)loadMetrics:(NSObject *)prms; // 提取参数
//- (void)saveMetrics:(NSObject *)prms; // 保存参数
- (void)saveScore:(NSObject *)prms; // 保存成绩
- (void)fetchLeaderBoard:(NSObject *)prms; // 获取排行榜

- (void)sendInventationMessageWithUrl:(NSObject *)prms;
- (void)sendHeartMessage:(NSString *)profileID;

- (void)SampleSelector:(NSObject *)prms;

//+ (NSString*)base64forData:(NSData*)theData;

@end
