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
    
    NSLog(@"authenticate");
    NSDictionary *parameters = (NSDictionary*)prms;
    NSLog(@"Passed params are : %@", parameters);
    NSString * CPPFunctionToBeCalled = (NSString*)[parameters objectForKey:@"simple_callback"];
    if (!TangoSession.sharedSession.isAuthenticated){
        NSLog(@"TangoSession.sharedSession.isAuthenticated = false");
        [TangoSession.sharedSession authenticateWithHandler:^(TangoSession *session, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (error.code) {
                    case TANGO_SDK_SUCCESS:
                        NSLog(@"TANGO_SDK_SUCCESS");
                        [IOSNDKHelper SendMessage:CPPFunctionToBeCalled
                                   WithParameters:nil];
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
        [IOSNDKHelper SendMessage:CPPFunctionToBeCalled
                   WithParameters:nil];
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
                    TangoProfileEntry * profile = [result objectAtIndex:0];
                    
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
                        /* jason:
                         {"my_profile":
                            {"first_name":"王",
                             "last_name":"一纯",
                             "full_name":"王 一纯",
                             "profile_id":"t2MNHKigKwH4GExRtSqMag",
                             "gender":"Male",
                             "picture_url":"http://cget.tango.me/contentserver/download/tAGzXTwDbvzwUMXcHOAR8WCLPlOmBNaydcQ1cf98U-KxndNrQsh-xc55Z9Vcl7yz/hOxpit4u/thumbnail"
                             "status":"正在准备接Tango的SDK"
                             "place_holder":"no"
                            }
                         }
                         */
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

- (void)getFriendProfile:(NSObject *)prms
               useCached:(BOOL)cached {
    NSLog(@"getFriendProfile");
    NSDictionary *parameters = (NSDictionary*)prms;
    NSLog(@"Passed params are : %@", parameters);
    NSString* CPPFunctionToBeCalled = (NSString*)[parameters objectForKey:@"simple_callback"];
    NSString* CPPFunctionToBeCalled_pic = (NSString*)[parameters objectForKey:@"picture_callback"];
    
    void (^processResult)(TangoProfileResult *, NSError *) =
    ^(TangoProfileResult *result, NSError*error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error.code == 0) {
                /* jason:
                 {"firend_profile":[
                    {*},{*}
                   ]
                 }
                 */
                NSString * jason_str = @"{\"firend_profile\":[";
                for (TangoProfileEntry * profile in result.profileEnumerator) {
//                for (int index = 0; index < result.count; index++) {
//                    TangoProfileEntry * profile = [result objectAtIndex:index];
//                    bool isLast = index = result.count - 1 ? true : false;
                
                    if (profile != nil) {
                        self.profile = profile;
                        NSLog(@"Friend (%@) profile is getted.", profile.fullName);
                        
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
                        /* jason:
                         
                         {"first_name":"王",
                         "last_name":"一纯",
                         "full_name":"王 一纯",
                         "profile_id":"t2MNHKigKwH4GExRtSqMag",
                         "gender":"Male",
                         "picture_url":"http://cget.tango.me/contentserver/download/tAGzXTwDbvzwUMXcHOAR8WCLPlOmBNaydcQ1cf98U-KxndNrQsh-xc55Z9Vcl7yz/hOxpit4u/thumbnail"
                         "status":"正在准备接Tango的SDK"
                         "place_holder":"no"
                         }
                         
                         */
                        NSString * jason_str_inner = [NSString stringWithFormat:@"{\"first_name\":\"%@\",\"last_name\":\"%@\",\"full_name\":\"%@\",\"profile_id\":\"%@\",\"gender\":\"%@\",\"picture_url\":\"%@\",\"status\":\"%@\",\"place_holder\":\"%@\"}",
                                                profile.firstName,
                                                profile.lastName,
                                                profile.fullName,
                                                profile.profileID,
                                                str_gender,
                                                profile.profilePictureURL,
                                                profile.status,
                                                str_place_holder
                                                ];
                        jason_str = [jason_str stringByAppendingString:jason_str_inner];
//                        if (isLast) { // 最后一个
//                            jason_str = [jason_str stringByAppendingString:@"]}"];
//                        } else {
                            jason_str = [jason_str stringByAppendingString:@","];
//                        }
                        
                        if (!profile.profilePictureIsPlaceholder) {
                            UIImage * picture = profile.cachedProfilePicture;
                            if (picture == nil) {
                                [profile fetchProfilePictureWithHandler:^(UIImage *image) {
                                    // Display the downloaded image.
                                    NSData * data_pic = UIImagePNGRepresentation(image);
                                    NSString * str_pic = [data_pic base64Encoding];
                                    NSString * jason_my_profile_pic = [NSString stringWithFormat:@"{\"friend_profile_pic\":{\"profile_id\":\"%@\",\"picture\":\"%@\"}}",
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
                                NSString * jason_my_profile_pic = [NSString stringWithFormat:@"{\"friend_profile_pic\":{\"profile_id\":\"%@\",\"picture\":\"%@\"}}",
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
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:@"Could not fetch profile."
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                        
                        [alert show];
                    }
                }
                
                jason_str = [jason_str substringToIndex:[jason_str length]-1];
                jason_str = [jason_str stringByAppendingString:@"]}"];
                
                NSLog(@"jason: %@", jason_str);
                
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
        TangoProfileResult * result;
        if (cached) {
            result = [TangoProfile fetchMyCachedFriends:&error];
        } else {
            result = [TangoProfile fetchMyFriendsProfiles:&error];
        }
        processResult(result, error);
    });
}

- (void)getFriendProfile_cached:(NSObject *)prms {
    [self getFriendProfile:prms useCached:YES];
}

- (void)getFriendProfile_current:(NSObject *)prms {
    [self getFriendProfile:prms useCached:NO];
}

- (void)loadPossessions:(NSObject *)prms {
    NSLog(@"loadPossessions");
    NSDictionary *parameters = (NSDictionary*)prms;
    NSLog(@"Passed params are : %@", parameters);
    NSString* CPPFunctionToBeCalled = (NSString*)[parameters objectForKey:@"simple_callback"];
    
    /* jason
     {"possessions":[
        {"last_modified":1366998173,
        "item_id":"gold",
        "value":"20000",
        "version":"1"},
        {"last_modified":1366998176,
        "item_id":"heart",
        "value":"5",
        "version":"1"}
       ]
     }
     */
    
    [TangoPossessions fetchWithHandler:^(NSArray *possessions, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error.code == 0) {
                NSString * jason_str = @"{\"possessions\":[";
                self.possessions = possessions;
                
                for (TangoPossession * possession in possessions) {
                    if (possession != nil) {
                        NSString * jason_str_inner = [NSString stringWithFormat:@"{\"last_modified\":\"%@\",\"item_id\":\"%@\",\"value\":\"%d\",\"version\":\"%d\"}",
                                                      possession.lastModified,
                                                      possession.name,
                                                      possession.value,
                                                      possession.version];
                        jason_str = [jason_str stringByAppendingString:jason_str_inner];
                        jason_str = [jason_str stringByAppendingString:@","];
                        
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:@"Could not fetch possession."
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                        
                        [alert show];
                    }
                }
                
                if (possessions.count != 0) {
                    jason_str = [jason_str substringToIndex:[jason_str length]-1];
                }
                
                jason_str = [jason_str stringByAppendingString:@"]}"];
                
                NSLog(@"jason: %@", jason_str);
                
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Get Possessions Error"
                                                                message:error.localizedDescription
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            
        });
    }];
}

- (void)savePossessions:(NSObject *)prms {
    NSLog(@"savePossessions");
    NSDictionary *parameters = (NSDictionary*)prms;
    NSLog(@"Passed params are : %@", parameters);
    NSString * CPPFunctionToBeCalled = (NSString*)[parameters objectForKey:@"simple_callback"];
    NSString * possession_name = (NSString*)[parameters objectForKey:@"possession_name"]; // 存储财产名
    NSString * possession_value = (NSString*)[parameters objectForKey:@"possession_value"]; // 存储财产值
    
    if (self.possessions == nil) {
        NSLog(@"please fetch possessions before.");
        return;
    }

    TangoPossession * possession = nil; // 放置原来已经有的possession
    BOOL isHave = NO;
    for (int i = 0; i < self.possessions.count; i++) {
        TangoPossession * inner_possession = self.possessions[i];
        if ([possession_name compare:possession_name] == NSOrderedSame) {
            possession = inner_possession; // 找到了
            isHave = YES;
            break;
        }
    }
    
    if (possession == nil) {
        possession = [[TangoPossession alloc] init];
    }
    
    if (possession.exists == NO) {
        possession.name = possession_name; // 写入名称
    }
    
    possession.value = [possession_value integerValue]; // 写入值
    
    [TangoPossessions save:@[possession] withHandler:^(TangoPossessionResult *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(result.successful) {
                // TODO: SUCCESSFUL
                
                NSString * jason_str = @"{\"possessions\":[";
                
                for (NSString * possessionName in result.possessions) {
                    TangoPossession * possession = result.possessions[possessionName];
                    if (possession != nil) {
                        NSString * jason_str_inner = [NSString stringWithFormat:@"{\"last_modified\":\"%@\",\"item_id\":\"%@\",\"value\":\"%d\",\"version\":\"%d\"}",
                                                      possession.lastModified,
                                                      possession.name,
                                                      possession.value,
                                                      possession.version];
                        jason_str = [jason_str stringByAppendingString:jason_str_inner];
                        jason_str = [jason_str stringByAppendingString:@","];
                        
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:@"Could not fetch possession."
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                        
                        [alert show];
                    }
                }
                
                if (result.possessions.count != 0) {
                    jason_str = [jason_str substringToIndex:[jason_str length]-1];
                }
                
                jason_str = [jason_str stringByAppendingString:@"]}"];
                
                NSLog(@"jason: %@", jason_str);
                
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
                NSString *message;
                
                // The possession we attempted to save was stale. This means that a newer version of the
                // possession exists on the server.
                if(result.isStale) {
                    // If the user was attempting to create a new possession, then that means the possession's
                    // name was already taken.
                    if(possession.exists == NO) {
                        message = [NSString stringWithFormat:@"Possession \"%@\" already exists.",
                                   possession.name];
                    } else {
                        message = @"Stale possession! Update your possessions and try again.";
                    }
                } else {
                    message = result.error.localizedDescription;
                }
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Set Possessions Error"
                                                                message:message
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                
                [alert show];
            }
        });
    }];
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
