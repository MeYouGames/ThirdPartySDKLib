//
//  TangoMetricsSetRequest.h
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
#import "TangoJSONSerialization.h"


@interface TangoMetricsSetRequest : NSObject <TangoJSONSerialization>

/**
 * Save another metric with all functions.
 *
 * @param  name   The name of the metric that will be added.
 * @param  value  The value of the metric that will be added.
 */
- (void)setMetric:(NSString *)name withValue:(NSInteger)value;

/**
 * Save another metric.
 *
 * @param  name           The name of the metric that will be added.
 * @param  value          The value of the metric that will be added.
 * @param  functionOrNil  The functions to be recorded. If nil, the metric will be removed from the update.
 */
- (void)setMetric:(NSString *)name withValue:(NSInteger)value withFunction:(NSString *)functionOrNil;

/**
 * Save another metric to search for.
 *
 * @param  name            The name of the metric that will be added.
 * @param  value           The value of the metric that will be added.
 * @param  functionsOrNil  The functions to be fetched. If nil, the metric will be removed from the update.
 */
- (void)setMetric:(NSString *)name withValue:(NSInteger)value withFunctions:(NSArray *)functionsOrNil;

/**
 * Remove a metric from the request.
 *
 * @param name  The name of the metric that will be removed.
 */
- (void)removeMetric:(NSString *)name;

@end
