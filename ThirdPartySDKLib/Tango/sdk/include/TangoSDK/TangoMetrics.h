//
//  TangoMetrics.h
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
#import "TangoMetricsGetRequest.h"
#import "TangoMetricsSetRequest.h"

/**
 * The handler used once the metrics have been fetched or saved. The handler will run
 * on the global queue.
 *
 * @param  possessions  For a send request, possessions is an array of the TangoPossession results.
 *                      For a fetch fetch request, possessions is an array of accounts, each account
 *                      containing an array of TangoPossession results.
 *
 * @param  error        The error object, with an error code of 0 on success.
 */
typedef void (^MetricsHandler)(NSArray *results, NSError *error);

@interface TangoMetrics : NSObject

/**
 * Send new metrics for the current account.
 *
 * @param  request   Specifies the new metrics that should be saved.
 * @param  handler   The handler that gets executed once the asynchronous request is completed.
 */
+ (void)send:(TangoMetricsSetRequest *)request withHandler:(MetricsHandler)handler;

/**
 * Fetch the metrics for the specified accounts.
 *
 * @param  request   Specifies the metrics and accounts that should be fetched for the request.
 * @param  handler   The handler that gets executed once the asynchronous request is completed.
 */
+ (void)fetch:(TangoMetricsGetRequest *)request withHandler:(MetricsHandler)handler;

@end