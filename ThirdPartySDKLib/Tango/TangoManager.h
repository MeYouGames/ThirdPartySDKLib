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

@interface TangoManager : NSObject{
    
}

+ (TangoManager *) sharedInstance;

- (void)initSDK;

- (void) SampleSelector:(NSObject *)prms;

@end
