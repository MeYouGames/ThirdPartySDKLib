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


static NSString * const kLeaderboardFunction = @"MAX_THIS_WEEK";

static const MessageHandler resultHandler = ^(NSError *error) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *message = nil;
        
        if(error.code == 0) {
            message = @"Message is delivered";
        }
        else {
            message = @"Message failed to send.";
        }
        
        NSLog(@"%@", message);
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status"
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:@"Ok"
//                                              otherButtonTitles:nil];
//        [alert show];
    });
};


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

- (void)isAuthenticate:(NSObject *)prms {
    NSLog(@"isAuthenticate");
    NSDictionary *parameters = (NSDictionary*)prms;
    NSLog(@"Passed params are : %@", parameters);
    NSString * CPPFunctionToBeCalled = (NSString*)[parameters objectForKey:@"simple_callback"];
    NSString * CPPFunctionToBeCalled_Error = (NSString*)[parameters objectForKey:@"error_callback"];
    if (TangoSession.sharedSession.isAuthenticated) {
        // 已经授权
        [IOSNDKHelper SendMessage:CPPFunctionToBeCalled
                   WithParameters:nil];
    } else {
        // 没有授权
        [IOSNDKHelper SendMessage:CPPFunctionToBeCalled_Error
                   WithParameters:nil];
    }
}

- (void)authenticate:(NSObject *)prms {
    
    NSLog(@"authenticate");
    NSDictionary *parameters = (NSDictionary*)prms;
    NSLog(@"Passed params are : %@", parameters);
    NSString * CPPFunctionToBeCalled = (NSString*)[parameters objectForKey:@"simple_callback"];
    NSString * CPPFunctionToBeCalled_Error = (NSString*)[parameters objectForKey:@"error_callback"];
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
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication Error"
//                                                                        message:error.localizedDescription
//                                                                       delegate:nil
//                                                              cancelButtonTitle:@"Ok"
//                                                              otherButtonTitles:nil];
//                        [alert show];
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
    NSString * CPPFunctionToBeCalled_Error = (NSString*)[parameters objectForKey:@"error_callback"];
    
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
                    
                    if ([CPPFunctionToBeCalled_pic compare:@"NO"] != NSOrderedSame) {
                        
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
                    }
                    
                } else {
                    [IOSNDKHelper SendMessage:CPPFunctionToBeCalled_Error
                               WithParameters:nil];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Could not fetch profile."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                    
                    [alert show];
                }
            } else {
                [IOSNDKHelper SendMessage:CPPFunctionToBeCalled_Error
                           WithParameters:nil];
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

//- (void)loadMetrics:(NSObject *)prms {
//    NSLog(@"loadMetrics");
//    NSDictionary *parameters = (NSDictionary*)prms;
//    NSLog(@"Passed params are : %@", parameters);
//    NSString * CPPFunctionToBeCalled = (NSString*)[parameters objectForKey:@"simple_callback"];
//    NSString * metrics_profile_id = (NSString*)[parameters objectForKey:@"metrics_profile_id"]; // 账户id
//    NSString * metrics_name = (NSString*)[parameters objectForKey:@"metrics_name"]; // 存储财产名
//    NSString * metrics_value = (NSString*)[parameters objectForKey:@"metrics_value"]; // 存储财产值
//
//    TangoMetricsGetRequest * request = [[TangoMetricsGetRequest alloc] init];
//    
//    [request setMetric:metrics_name withFunction:metrics_name];
//}

//- (void)saveMetrics:(NSObject *)prms {
//    NSLog(@"saveMetrics");
//}

- (void)saveScore:(NSObject *)prms; {
    NSLog(@"saveScore");
    NSDictionary *parameters = (NSDictionary*)prms;
    NSLog(@"Passed params are : %@", parameters);
    NSString * CPPFunctionToBeCalled = (NSString*)[parameters objectForKey:@"simple_callback"];
    NSString * score_value = (NSString*)[parameters objectForKey:@"score_value"]; // 存储分数
    NSString * CPPFunctionToBeCalled_Error = (NSString*)[parameters objectForKey:@"error_callback"];
    
    NSMutableSet * functions = [NSMutableSet set];
    [functions addObject:@"MAX"];
    [functions addObject:@"MAX_THIS_WEEK"];
    [functions addObject:@"MAX_LAST_WEEK"];
    [functions addObject:@"MAX_THIS_DAY"];
    [functions addObject:@"MAX_LAST_DAY"];
    [functions addObject:@"MAX_THIS_HOUR"];
    [functions addObject:@"MAX_LAST_HOUR"];
    [functions addObject:@"MIN"];
    [functions addObject:@"SUM"];
    [functions addObject:@"COUNT"];
    [functions addObject:@"AVE"];
    
    TangoMetricsSetRequest *request = [[TangoMetricsSetRequest alloc ] init];
    [request setMetric:@"score"
             withValue:[score_value integerValue]
          withFunctions:functions.allObjects];
    
    [TangoMetrics send :request withHandler:^( NSArray *metrics , NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error.code == 0) {
                for (TangoMetric *metric in metrics) {
                    NSLog( @"Saved Metric Name: %@" , metric.name);
                    NSLog( @"Saved Metric Value: %d" , metric.value);
                    NSLog( @"Saved Metric Function Type: %@" , metric.function);
                    NSLog( @"Saved Metric Last Modified Date: %@" , metric.lastModified);
                }
                [IOSNDKHelper SendMessage:CPPFunctionToBeCalled
                           WithParameters:nil];
            } else {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Score Error"
//                                                                message:error.localizedDescription
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"Ok"
//                                                      otherButtonTitles:nil];
//                
//                [alert show];
                if ([CPPFunctionToBeCalled_Error compare:@"NO"] != NSOrderedSame) {
                    [IOSNDKHelper SendMessage:CPPFunctionToBeCalled_Error
                               WithParameters:nil];
                }
            }
        });
    }];   
                       
}

- (void)fetchLeaderBoard:(NSObject *)prms {
    NSLog(@"fetchLeaderBoard");
    NSDictionary *parameters = (NSDictionary*)prms;
    NSLog(@"Passed params are : %@", parameters);
    NSString * CPPFunctionToBeCalled = (NSString*)[parameters objectForKey:@"simple_callback"];
    NSString * CPPFunctionToBeCalled_pic = (NSString*)[parameters objectForKey:@"picture_callback"];
    NSString * CPPFunctionToBeCalled_Error = (NSString*)[parameters objectForKey:@"error_callback"];
    
    TangoLeaderboardRequest * request = [[TangoLeaderboardRequest alloc] init];
    [request setMetric:@"score" withFunction:kLeaderboardFunction ascending:YES];
    
    /* jason:
     {"leaderboard":[
     {*},{*}
     ]
     }
     */
    
    [TangoLeaderboard fetch:request withHandler:^(NSArray *entries, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error.code == 0) {
                
                /* jason:
                 
                 {
                 "profile_id":"t2MNHKigKwH4GExRtSqMag",
                 "full_name":"王 一纯",
                 "metrics":{
                    "*":"*",
                    "*":"*"
                 }
                 }
                 */
                
                NSString * jason_str = @"{\"leaderboard\":[";
                
                for(TangoLeaderboardEntry * entry in entries) {
                    
                    if ([CPPFunctionToBeCalled_pic compare:@"NO"] != NSOrderedSame) {
                        if (!entry.profile.profilePictureIsPlaceholder) {
                            UIImage * picture = entry.profile.cachedProfilePicture;
                            if (picture == nil) {
                                [entry.profile fetchProfilePictureWithHandler:^(UIImage *image) {
                                    // Display the downloaded image.
                                    NSData * data_pic = UIImagePNGRepresentation(image);
                                    NSString * str_pic = [data_pic base64Encoding];
                                    NSString * jason_my_profile_pic = [NSString stringWithFormat:@"{\"leader_profile_pic\":{\"profile_id\":\"%@\",\"picture\":\"%@\"}}",
                                                                       entry.profile.profileID,
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
                                NSString * jason_my_profile_pic = [NSString stringWithFormat:@"{\"leader_profile_pic\":{\"profile_id\":\"%@\",\"picture\":\"%@\"}}",
                                                                   entry.profile.profileID,
                                                                   str_pic];
                                NSData * jason_pic_data = [jason_my_profile_pic dataUsingEncoding:NSUTF8StringEncoding];
                                NSError * err_pic = nil;
                                NSDictionary * dict_pic = [NSJSONSerialization JSONObjectWithData:jason_pic_data
                                                                                          options:nil
                                                                                            error:&err_pic];
                                
                                [IOSNDKHelper SendMessage:CPPFunctionToBeCalled_pic WithParameters:dict_pic];
                            }
                        }
                    }
                    NSString * jason_str_inner = [NSString stringWithFormat:@"{\"profile_id\":\"%@\",\"full_name\":\"%@\",\"metrics\":{",
                                                  entry.profile.profileID,
                                                  entry.profile.fullName
                                                  ];
                    
                    NSLog(@"User name: %@", entry.profile.fullName);
                    
                    for (TangoMetric * metric in entry.metrics) {
                        NSString * jason_str_metrics = [NSString stringWithFormat:@"\"%@\":\"%d\",", metric.name, metric.value];
                        jason_str_inner = [jason_str_inner stringByAppendingString:jason_str_metrics];
                        
                        NSLog( @"Metric name: %@" , metric.name);
                        NSLog( @"Metric value: %d" , metric.value);
                    }
                    
                    jason_str_inner = [jason_str_inner substringToIndex:[jason_str_inner length]-1];
                    jason_str_inner = [jason_str_inner stringByAppendingString:@"}},"];
                    
                    jason_str = [jason_str stringByAppendingString:jason_str_inner];
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
                
                if ([CPPFunctionToBeCalled_Error compare:@"NO"] != NSOrderedSame) {
                    [IOSNDKHelper SendMessage:CPPFunctionToBeCalled_Error
                               WithParameters:nil];
                }
                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fetch Leader Board Error"
//                                                                message:error.localizedDescription
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"Ok"
//                                                      otherButtonTitles:nil];
//                [alert show];
                
            }
        });
    }];
}

- (void)sendInventationMessageWithUrl:(NSObject *)prms
{
    NSLog(@"sendInventationMessageWithUrl");
    NSDictionary *parameters = (NSDictionary*)prms;
    NSLog(@"Passed params are : %@", parameters);
//    NSString * CPPFunctionToBeCalled = (NSString*)[parameters objectForKey:@"simple_callback"];
    NSString * profile_id = (NSString*)[parameters objectForKey:@"profile_id"]; // id
    
    NSURL * actionURL = [NSURL URLWithString:@"bigbangrabbit4t://invitation"];
    
    TangoActionMap *actions = [[TangoActionMap alloc] init];
    [actions setActionForPlatform:TangoSdkPlatformFallback
                          withURL:[NSURL URLWithString:@"http://www.tango.me"]
                     actionPrompt:@"Check it out!"
                         mimeType:@"text/url"];
    
    // LAUNCH_CONTEXT is a placeholder. It will be used by Tango to pass launch context
    // (e.g. conversation id and participants)
    // Note that uri string must be RFC3986 compliant.
    [actions setActionForPlatform:TangoSdkPlatformIOS
                          withURL:actionURL
                     actionPrompt:@"Tap to play!"
                         mimeType:@"text/url"];
    
    [actions setActionForPlatform:TangoSdkPlatformAndroid
                          withURL:actionURL
                     actionPrompt:@"Tap to Play"
                         mimeType:@"text/url"];
    TangoMessage *message = [[TangoMessage alloc] init];
    
    message.messageText = @"This is awesome!";
    message.descriptionText = @"Join me in BigBangRabbit! (@meyougames)";
    message.actionMap = actions;
    message.resultHandler = resultHandler;
    
    [TangoMessaging sendMessage:message toRecipients:@[profile_id]];
}

- (void)sendHeartMessage:(NSObject *)prms {
    NSLog(@"sendHeartMessage");
    NSDictionary *parameters = (NSDictionary*)prms;
    NSLog(@"Passed params are : %@", parameters);
    //    NSString * CPPFunctionToBeCalled = (NSString*)[parameters objectForKey:@"simple_callback"];
    NSString * profile_id = (NSString*)[parameters objectForKey:@"profile_id"]; // id
    NSString * gift_id = (NSString*)[parameters objectForKey:@"gift_id"];
    NSString * my_profile_id = (NSString*)[parameters objectForKey:@"my_profile_id"]; // my profile id
    
    NSString * urlStr = [NSString stringWithFormat:@"bigbangrabbit4t://gifting?gift_id=%d&gift_value=heart_x1&sender_id=%@", [gift_id intValue], my_profile_id];
    
    NSURL * actionURL = [NSURL URLWithString:urlStr];
    
    TangoActionMap *actions = [[TangoActionMap alloc] init];
    [actions setActionForPlatform:TangoSdkPlatformFallback
                          withURL:[NSURL URLWithString:@"http://www.tango.me"]
                     actionPrompt:@"Check it out!"
                         mimeType:@"text/url"];
    
    // LAUNCH_CONTEXT is a placeholder. It will be used by Tango to pass launch context
    // (e.g. conversation id and participants)
    // Note that uri string must be RFC3986 compliant.
    [actions setActionForPlatform:TangoSdkPlatformIOS
                          withURL:actionURL
                     actionPrompt:@"Tap to play!"
                         mimeType:@"text/url"];
    
    [actions setActionForPlatform:TangoSdkPlatformAndroid
                          withURL:actionURL
                     actionPrompt:@"Tap to Play"
                         mimeType:@"text/url"];
    TangoMessage *message = [[TangoMessage alloc] init];
    
    message.messageText = @"This is awesome!";
    message.descriptionText = @"Join me in BigBangRabbit! (@meyougames)";
    message.actionMap = actions;
    message.resultHandler = resultHandler;
    
    [TangoMessaging sendMessage:message toRecipients:@[profile_id]];
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
