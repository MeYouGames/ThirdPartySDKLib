//
//  TangoActionMap.h
//  TangoSDK
//
// -*- ObjC -*-
// Copyright 2012-2013, TangoMe Inc ("Tango").  The SDK provided herein includes 
// software and other technology provided by Tango that is subject to copyright and 
// other intellectual property protections. All rights reserved.  Use only in 
// accordance with the Evaluation License Agreement provided to you by Tango.
// 
// Please read Tango_SDK_Evaluation_License_agreement_v1-2.docx
//

#import <Foundation/Foundation.h>
#import "TangoTypes.h"

/** TangoActionMap is an Objective-C wrapper around tango_sdk::PlatformToActionMap. Use this
 to specify actions that occur when the user taps on a message. Actions for a specific
 platform will override those set for PLATFORM_ANY. actionURL and mimeType are required.
 Returns YES if the action was added to the map successfully, and NO on failure. Inspect
 your logs for details about the error.
 */
@interface TangoActionMap : NSObject

- (BOOL)setActionForPlatform:(TangoSdkPlatform)platform
                     withURL:(NSURL *)actionURL
                actionPrompt:(NSString *)actionPromptOrNil
                    mimeType:(NSString *)mimeType;

- (void)removeActionForPlatform:(TangoSdkPlatform)platform;

@end