//
//  TangoSession.h
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


//Forward reference
@class TangoSession;
@class TangoLaunchContext;


/**
  Authentication handler. This block is called when Tango Authentication is done.
*/
typedef void (^AuthenticationHandler)(
          TangoSession* session,
          NSError* error
        );

/**
  Access token handler.
*/
typedef void (^AccessTokenHandler)(
          TangoSession* session,
          NSString* accessToken,
          NSError* error
        );


/*
 * Constants used by NSNotificationCenter for Tango session notification
 */

/*! NSNotificationCenter name indicating that a new active session was set */
extern NSString *const TangoSessionCreatedTangoSessionNotification;

/*! NSNotificationCenter name indicating thatd an active session was unset */
extern NSString *const TangoSessionAuthenticatedTangoSessionNotification;

/*! NSNotificationCenter name indicating that the active session is open */
extern NSString *const TangoSessionAuthenticationErrorTangoSessionNotification;

/*! NSNotificationCenter name indicating that event is posted */
extern NSString *const TangoSessionEventPostedTangoSessionNotification;


/**
  The TangoSession is used to authenticate a user with Tango Application. After authentication it can be used to call the rest of Tango SDK API.
*/
@interface TangoSession : NSObject


/**
  Return a singleton share Tango Session. This function will always return the same object.
  The session can be in one of 3 states:
    -- cteated ( always tru after getting the session object
    -- Initialized: after calling initialize or initializeWithAppId:withUrlScheme
    -- Authenticated: after calling authenticate or after initialize and using cached SDK tokens.
*/
+ (TangoSession*)sharedSession;

/**
  Initialize the shared Tango Session with values found in the application bundle
  Returns TRUE if the initialization succeed, otherwise returns FALSE
*/
+ (BOOL)sessionInitialize;


/**
  Uninitialize the shared Tango Session.
*/
+ (void)sessionUninitialize;

/**
  Initialize the share Tango Session with the provided parameters. If any of the values is nil the application bundle is used.
  Returns TRUE if the initializacion succeed, otherwise returns FALSE
*/
+ (BOOL)sessionInitializeWithAppID:(NSString*)appID withUrlScheme:(NSString*)urlScheme;

/**
  Returns the human-readable version string for the SDK.
  */
+ (NSString *)sdkVersion;

/** Take the user to the Tango App Store page so that they can install or upgrade to the latest
    version. No prompt will be shown to the user.
    */
- (void)installTango;

/** Use this to determine if Tango is installed on the user's device.
    Returns YES if Tango is installed, NO otherwise.
    */
@property(readonly) BOOL tangoIsInstalled;

/** Detect if the user's installed version of Tango has SDK support.
    Returns YES if Tango is installed and supports SDK integration,
    NO otherwise.
    */
@property(readonly) BOOL tangoHasSdkSupport;

/* The session was initialized succesfully to use */
@property(readonly) BOOL isInitialized;

/* The session was authenticated succesfully to use */
@property(readonly) BOOL isAuthenticated;

/** Returns the human-readable environment name for the SDK. */
@property(readonly) NSString *sdkEnvironment;

@property(nonatomic, readonly) TangoLaunchContext *launchContext;

/**
  Handle URL received by the application.
  Check for urlScheme and process. TODO: validate sourceApplication
*/

- (BOOL)handleURL:(NSURL*)url withSourceApplication:(NSString*)sourceApplication;

- (BOOL)handleURL:(NSURL*)url withSourceApplication:(NSString*)sourceApplication
    userUrl:(NSString**)userUrl;

#pragma mark CORE API functions
/**
  Authentication functions.
  Before the session can be used, you must call this to authenticate with Tango.
*/

- (void) authenticateWithHandler:(AuthenticationHandler) handler;

/**
  Retrieve and access token to be used with Tango SSO
*/

- (void) accessTokenWithHandler:(AccessTokenHandler) handler; // TODO: find a better name to advice "retrieving"

/**
  Retrieve and access token to be used with Tango SSO.
  The operation will return the access token and fill the error parameter.
  NOTE: This function will block until an accessToken is generated.
*/
- (NSString*) accessToken:(NSError **)pError; // TODO: find a better name to advice "retrieving"

@end
