//
//  TangoMetric.h
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

@interface TangoMetric : NSObject

// The metric's name, known as the MetricId internally.
@property (nonatomic, strong) NSString *name;

// The metric's value.
@property (nonatomic, assign) NSInteger value;

// The date that the metric was last updated at.
@property (nonatomic, strong) NSDate *lastModified;

// The functions supported by the metric, known as the RollUps internally.
// The supported functions currently are: "MAX_LAST_HOUR", "MAX_THIS_HOUR",
// "MAX_LAST_DAY", "MAX_THIS_DAY", "MAX_LAST_WEEK", "MAX_THIS_WEEK", "MAX",
// "AVE", "SUM", "COUNT", "MIN"
@property (nonatomic, strong) NSArray *functions;

// The current metric's function type.
@property (nonatomic, strong) NSString *function;

/**
 * Create a new metric.
 *
 * @param  name          The metric's name, known as the MetricId internally.
 * @param  value         The metric's value.
 * @param  lastModified  The date that the metric was last updated at.
 * @param  function      The metric's function type.
 */
+ (TangoMetric *)metricWithName:(NSString *)name value:(NSInteger)value
                   lastModified:(NSDate *)lastModified function:(NSString *)function;

/**
 * Create a new metric.
 *
 * @param  name          The metric's name, known as the MetricId internally.
 * @param  value         The metric's value.
 * @param  lastModified  The date that the metric was last updated at.
 * @param  function      The metric's function type.
 */
- (TangoMetric *)initWithName:(NSString *)name value:(NSInteger)value
                 lastModified:(NSDate *)lastModified function:(NSString *)function;

@end
