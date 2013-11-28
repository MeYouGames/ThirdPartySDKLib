//
//  TangoProfileEntry+private.h
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

#import "TangoProfileEntry.h"

/**
  Private inteface
*/
@interface TangoProfileEntry()
  /**
    Initialize a profile entry with a dictionary of fields
  */
+ (id)profileEntryWithDictionary:(NSDictionary *)profileEntryDictionary;

  /**
    Tis dictionary holds all the fields retireved for this profile
  */
  @property(nonatomic, retain) NSDictionary* profileEntry;
@end