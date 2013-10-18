//
//  TangoManager.m
//  ThirdPartySDKLib
//
//  Created by MeYouGames on 13-10-13.
//  Copyright (c) 2013年 MeYouGames. All rights reserved.
//

#import "TangoManager.h"
#import <TangoSDK/TangoSDK.h>
#import "NSData+MBBase64.h"

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

- (void)getMyProfile:(NSObject *)prms {
    
    NSLog(@"getMyProfile");
    NSDictionary *parameters = (NSDictionary*)prms;
    NSLog(@"Passed params are : %@", parameters);
    NSString* CPPFunctionToBeCalled = (NSString*)[parameters objectForKey:@"simple_callback"];
    NSString* CPPFunctionToBeCalled_pic = (NSString*)[parameters objectForKey:@"picture_callback"];
    
        void (^processResult)(TangoProfileResult *, NSError *) =
        ^(TangoProfileResult *result, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(error.code == 0) {
                    TangoProfileEntry *profile = [result objectAtIndex:0];
                    
                    if (profile != nil) {
                        self.profile = profile;
                        NSLog(@"My profile is getted.");
                        
                        // jason
                        NSString * str_gender;
                        switch (profile.gender) {
                            case TangoSdkGenderMale:
                                str_gender = @"Male";
                                break;
                            case TangoSdkGenderFemale:
                                str_gender = @"Female";
                                break;
                            default:
                                case TangoSdkGenderUnknown:
                                str_gender = @"Unknown";
                                break;
                        }
                        NSString * str_place_holder;
                        if (profile.profilePictureIsPlaceholder) {
                            str_place_holder = @"yes";
                        } else {
                            str_place_holder = @"no";
                        }
                        
                        NSString * jason_str = [NSString stringWithFormat:@"{\"my_profile\":{\"first_name\":\"%@\",\"last_name\":\"%@\",\"full_name\":\"%@\",\"profile_id\":\"%@\",\"gender\":\"%@\",\"picture_url\":\"%@\",\"status\":\"%@\",\"place_holder\":\"%@\"}}",
                                                profile.firstName,
                                                profile.lastName,
                                                profile.fullName,
                                                profile.profileID,
                                                str_gender,
                                                profile.profilePictureURL,
                                                profile.status,
                                                str_place_holder
                                                ];
                        
                        if (!profile.profilePictureIsPlaceholder) {
                            UIImage * picture = profile.cachedProfilePicture;
                            if (picture == nil) {
                                [profile fetchProfilePictureWithHandler:^(UIImage *image) {
                                    // Display the downloaded image.
                                    NSData * data_pic = UIImagePNGRepresentation(image);
                                    NSString * str_pic = [data_pic base64Encoding];
                                    NSString * jason_my_profile_pic = [NSString stringWithFormat:@"{\"my_profile_pic\":{\"profile_id\":\"%@\",\"picture\":\"%@\"}}",
                                                                       profile.profileID,
                                                                       str_pic];
                                    NSData * jason_pic_data = [jason_my_profile_pic dataUsingEncoding:NSUTF8StringEncoding];
                                    NSError * err_pic = nil;
                                    NSDictionary * dict_pic = [NSJSONSerialization JSONObjectWithData:jason_pic_data
                                                                                          options:nil
                                                                                            error:&err_pic];
                                    
                                    [IOSNDKHelper SendMessage:CPPFunctionToBeCalled_pic WithParameters:dict_pic];
                                }];
                            } else {
                                // Display the cached image.
                                NSData * data_pic = UIImagePNGRepresentation(picture);
                                NSString * str_pic = [data_pic base64Encoding];
                                NSString * jason_my_profile_pic = [NSString stringWithFormat:@"{\"my_profile_pic\":{\"profile_id\":\"%@\",\"picture\":\"%@\"}}",
                                                                   profile.profileID,
                                                                   str_pic];
                                NSData * jason_pic_data = [jason_my_profile_pic dataUsingEncoding:NSUTF8StringEncoding];
                                NSError * err_pic = nil;
                                NSDictionary * dict_pic = [NSJSONSerialization JSONObjectWithData:jason_pic_data
                                                                                          options:nil
                                                                                            error:&err_pic];
                                
                                [IOSNDKHelper SendMessage:CPPFunctionToBeCalled_pic WithParameters:dict_pic];
                            }
                        }
                        
                        NSData * jason_data = [jason_str dataUsingEncoding:NSUTF8StringEncoding];
                        NSError * err = nil;
                        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:jason_data
                                                                              options:nil
                                                                                error:&err];
                        if (err != nil) { // 有错误
                            [IOSNDKHelper SendMessage:CPPFunctionToBeCalled
                                       WithParameters:nil]; 
                        } else {
                            [IOSNDKHelper SendMessage:CPPFunctionToBeCalled
                                       WithParameters:dict];
                        }
            
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:@"Could not fetch profile."
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                        
                        [alert show];
                    }
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:error.localizedDescription
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                    
                    [alert show];
                }
            });
        };
        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        TangoProfileResult *result = [TangoProfile fetchMyProfile:&error];
        processResult(result, error);
    });
}

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
