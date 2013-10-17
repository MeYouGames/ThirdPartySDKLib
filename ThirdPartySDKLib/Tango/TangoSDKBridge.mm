//
//  TangoSDKBridge.m
//  ThirdPartySDKLib
//
//  Created by MeYouGames on 13-10-13.
//  Copyright (c) 2013年 MeYouGames. All rights reserved.
//

#import "TangoSDKBridge.h"
#import "TangoManager.h"

TangoSDKBridge::TangoSDKBridge() {
    
}

TangoSDKBridge::~TangoSDKBridge() {
    
}

void TangoSDKBridge::initSDK() {
    [[TangoManager sharedInstance] initSDK];
}

void TangoSDKBridge::Authenticate() {
    [[TangoManager sharedInstance] authenticate:nil];
}
