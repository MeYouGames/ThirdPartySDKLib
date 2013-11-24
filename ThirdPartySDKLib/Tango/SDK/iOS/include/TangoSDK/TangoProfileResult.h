//
//  TangoProfileResult.h
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

/**
  This interface holds one or more profiles' results from the Tango SDK Profile call.
  This class is returned in the block handler defined in the getMyProfile and getMyFriendsProfiles API calls.
  
  This class extends the NSEnumerator abstract class to return an enumeration of TangoProfileEntry's.
  You may also use the "for profile in profileResult" syntax to enumerate the TangoProfileEntries
  via NSFastEnumeration.
*/

@class TangoProfileEntry;

@interface TangoProfileResult : NSObject <NSFastEnumeration>

/**
  Returns an enumeration of TangoProfileEntry objects.
  Each TangoProfileEntry wraps a profile entry with helper properties to get common fields.
*/
- (NSEnumerator*)profileEnumerator;

- (TangoProfileEntry *)objectAtIndex: (NSUInteger) index;

/**
  This property holds the number of entries received from the server.
*/
@property(readonly) NSUInteger count;

@end

