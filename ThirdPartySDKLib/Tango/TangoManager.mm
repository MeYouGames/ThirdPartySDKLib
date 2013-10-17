//
//  TangoManager.m
//  ThirdPartySDKLib
//
//  Created by MeYouGames on 13-10-13.
//  Copyright (c) 2013年 MeYouGames. All rights reserved.
//

#import "TangoManager.h"
#import <TangoSDK/TangoSDK.h>

@implementation TangoManager

static TangoManager *_tangoManager = nil;

+ (TangoManager *) sharedInstance{
	if (nil == _tangoManager) {
        _tangoManager = [[[self class] alloc] init];
    }
    return _tangoManager;
}

- (void)initSDK{
    NSLog(@"init tango sdk");
    [IOSNDKHelper SetNDKReciever:self];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactsChanged:) name:TangoSessionEventPostedTangoSessionNotification object:nil];
}

- (void)contactsChanged:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"contactsChanged");
    });
}

- (void)sessionInitialize {
    if(![TangoSession sessionInitialize]){
        NSLog(@"Error Initializing the session");
    }
}

- (void)sessionUnitialize {
    [TangoSession sessionUninitialize];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)requester {
    NSLog(@"application:openURL: %@ sourceApplication: %@", url.absoluteString, requester);
    
    NSString *userUrl = nil;
    // userUrl is marked as autorelease
    BOOL result = [TangoSession.sharedSession handleURL:url
                                  withSourceApplication:requester
                                                userUrl:&userUrl];
    return result;
}

- (void)authenticate:(NSObject *)prms {
    if (!TangoSession.sharedSession.isAuthenticated){
        NSLog(@"TangoSession.sharedSession.isAuthenticated = false");
        [TangoSession.sharedSession authenticateWithHandler:^(TangoSession *session, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (error.code) {
                    case TANGO_SDK_SUCCESS:
                        NSLog(@"TANGO_SDK_SUCCESS");
                        break;
                        
                    case TANGO_SDK_TANGO_APP_NOT_INSTALLED:
                        NSLog(@"TANGO_SDK_TANGO_APP_NOT_INSTALLED");
                    case TANGO_SDK_TANGO_APP_NO_SDK_SUPPORT:
                        NSLog(@"TANGO_SDK_TANGO_APP_NO_SDK_SUPPORT");
                        [session installTango];
                        break;
                        
                    default:
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication Error"
                                                                        message:error.localizedDescription
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                        [alert show];
                        break;
                }
            });
        }];
    } else {
        NSLog(@"TangoSession.sharedSession.isAuthenticated = true");
    }
}
//- (void)getMyProfile {
//    
//}

- (void)SampleSelector:(NSObject *)prms
{
    NSLog(@"purchase something called");
    NSDictionary *parameters = (NSDictionary*)prms;
    NSLog(@"Passed params are : %@", parameters);
    
    // Fetching the name of the method to be called from Native to C++
    // For a ease of use, i have passed the name of method from C++
    NSString* CPPFunctionToBeCalled = (NSString*)[parameters objectForKey:@"to_be_called"];
    
    // Show a bogus pop up here
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Hello World!"
                                                      message:@"This is a sample popup on iOS"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
    
    // Send C++ a message with paramerts
    // C++ will recieve this message, only if the selector list will have a method
    // with the string we are passing
    [IOSNDKHelper SendMessage:CPPFunctionToBeCalled WithParameters:nil];
}

@end
