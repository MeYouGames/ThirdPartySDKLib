//
//  TangoManager.m
//  ThirdPartySDKLib
//
//  Created by MeYouGames on 13-10-13.
//  Copyright (c) 2013年 MeYouGames. All rights reserved.
//

#import "TangoManager.h"

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
}

- (void) SampleSelector:(NSObject *)prms
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
