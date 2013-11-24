//
//  TangoProfile.h
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

/* Forward reference */
@class TangoProfile;
@class TangoProfileResult;

/**
 Profile handler. This block is called with Tango API Profile results.
 */
typedef void (^TangoProfileResponseHandler)(
  TangoProfileResult* profileResult,
  NSError* error
);


/**
  Profile handler. This block is called with Tango API Profile results.
*/
typedef void (^ProfileHandler)(
          TangoProfile* profile,
          TangoProfileResult* profileResult,
          NSError* error
        );


@interface TangoProfile : NSObject

#pragma mark Tango Profile API

#pragma mark Asynchronous calls
/**
 Retrieves the user's profile.
 The SDK calls the handler block with a TangoProfileResult that contains the user's profile.
 */
+ (void)fetchMyProfileWithHandler:(TangoProfileResponseHandler) handler;

/**
 Retrieves an array containing profiles for the user's friends.
 The SDK calls the handler block with a TangoProfileResult object with an array of the friends' profiles.
 */
+ (void)fetchMyFriendsProfilesWithHandler:(TangoProfileResponseHandler) handler;

/**
 Retrieves an array containing profiles for the cached user's friends.
 The SDK calls the handler block with a TangoProfileResult object with an array of the friends' profiles.
 */
+ (void)fetchMyCachedFriendsWithHandler:(TangoProfileResponseHandler) handler;

/**
  Retrieves the user's profile.
  The SDK calls the handler block with a TangoProfileResult that contains the user's profile.
 
  DEPRECATED
*/
- (void)getMyProfileWithHandler:(ProfileHandler) handler;

/**
  Retrieves an array containing profiles for the user's friends.
  The SDK calls the handler block with a TangoProfileResult object with an array of the friends' profiles.

  DEPRECATED
 */
- (void)getMyFriendsProfilesWithHandler:(ProfileHandler) handler;

/**
 Retrieves an array containing cached profiles for the user's friends.
 The SDK calls the handler block with a TangoProfileResult object with an array of the cached friends' profiles.
 
 DEPRECATED
 */
- (void)getMyCachedFriendsWithHandler:(ProfileHandler) handler;

#pragma mark Synchronous calls

/**
 Retrieves the user's profile.
 The SDK returns a TangoProfileResult object that contains the user's profile.
 This is the synchronous version of getMyProfileWithHandler.
 NOTE: This function will block the current thread until completion.
 */
+ (TangoProfileResult*)fetchMyProfile:(NSError**)error;

/**
 Retrieves an array containing profiles for the user's friends.
 The SDK returns a TangoProfileResult object with an array of the friends' profiles.
 This is the synchronous versoin of getMyFriendsProfilesWithHandler.
 NOTE: This function will block the current thread until completion.
 */
+ (TangoProfileResult*)fetchMyFriendsProfiles:(NSError**)error;

/**
 Retrieves an array containing profiles for the user's friends.
 The SDK returns a TangoProfileResult object with an array of the friends' profiles.
 This is the synchronous versoin of getMyCachedFriendsWithHandler.
 NOTE: This function will block the current thread until completion.
 */
+ (TangoProfileResult*)fetchMyCachedFriends:(NSError**)error;

/**
  Retrieves the user's profile.
  The SDK returns a TangoProfileResult object that contains the user's profile.
  This is the synchronous version of getMyProfileWithHandler.
  NOTE: This function will block the current thread until completion.

  DEPRECATED
*/
- (TangoProfileResult*)getMyProfile:(NSError**)error;

/**
  Retrieves an array containing profiles for the user's friends.
  The SDK returns a TangoProfileResult object with an array of the friends' profiles.
  This is the synchronous versoin of getMyFriendsProfilesWithHandler.
  NOTE: This function will block the current thread until completion.
 
  DEPRECATED
*/
- (TangoProfileResult*)getMyFriendsProfiles:(NSError**)error;

/**
 Retrieves an array containing profiles for the user's cached friends.
 The SDK returns a TangoProfileResult object with an array of the friends' profiles.
 This is the synchronous versoin of getMyCachedFriendsWithHandler.
 NOTE: This function will block the current thread until completion.
 
 DEPRECATED
 */
- (TangoProfileResult*)getMyCachedFriends:(NSError**)error;
@end
