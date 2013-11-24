//
//  TangoPossession.h
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

@interface TangoPossession : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSInteger version;
@property (nonatomic, strong) NSDate *lastModified;
@property (nonatomic, readonly) BOOL exists;

/**
 * Create a new Tango Possession object. Name defaults to an empty string, value and version to 0,
 * lastModfied to nil, and exists to false.
 */
- (TangoPossession *)init;

/**
 * Convenience constructor to create a new Tango Possession object.
 *
 * @param  name          The TangoPossession's ItemId
 * @param  value         The value for the TangoPossession.
 * @param  version       The internal version of the TangoPossession.
 * @param  lastModified  The last time the TangoPossession was saved.
 */
+ (TangoPossession *)possessionWithName:(NSString *)name value:(NSInteger)value
                                version:(NSInteger)version lastModified:(NSDate *)lastModified;

/**
 * Create a new Tango Possession object.
 *
 * @param  name          The TangoPossession's ItemId
 * @param  value         The value for the TangoPossession.
 * @param  version       The internal version of the TangoPossession.
 * @param  lastModified  The last time the TangoPossession was saved.
 */
- (TangoPossession *)initWithName:(NSString *)name value:(NSInteger)value
                          version:(NSInteger)version lastModified:(NSDate *)lastModified;

@end
