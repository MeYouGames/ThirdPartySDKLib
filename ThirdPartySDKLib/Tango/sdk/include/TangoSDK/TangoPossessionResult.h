//
//  TangoPossessionResult.h
//  TangoSDK
//
// -*- ObjC -*-
// Copyright 2012-2013, TangoMe Inc ("Tango").  The SDK provided herein includes
// software and other technology provided by Tango that is subject to copyright and
// other intellectual property protections. All rights reserved.  Use only in
// accordance with the Evaluation License Agreement provided to you by Tango.
//
// Please read Tango_SDK_Evaluation_License_agreement_v1-2.docx

#import <Foundation/Foundation.h>

@interface TangoPossessionResult : NSObject

/// Whether the possessions were saved successfully.
@property (nonatomic, readonly) BOOL successful;

/// The error the SDK encountered while executing the request. The
/// error's code will be 0 if there was no error.
@property (nonatomic, strong) NSError *error;

/// Wether the possessions were stale or not.
@property (nonatomic, readonly) BOOL isStale;

/// The possessions sent to the server. The keys to the
/// dictionary are the possessions' names.
@property (nonatomic, readonly) NSDictionary *possessions;

/// The server's version of the possessions. The keys to the
/// dictionary are the possessions' names.
@property (nonatomic, readonly) NSDictionary *currentPossessions;

/// The names of the possessions that were stale.
@property (nonatomic, readonly) NSArray *stalePossessionNames;

@end