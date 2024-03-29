//
//  TangoLeaderboardRequest.h
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

@interface TangoLeaderboardRequest : NSObject <TangoJSONSerialization>

/** Add another metric to the leaderboard.
    @param  metricName     The name of the metric that will be fetched.
    @param  function       The function to be fetched.
    @param  ascending      How the metrics should be sorted. If YES, the metrics will be sorted
                           ascendingly. If NO, the metrics will be sorted descendingly.
 */
- (void)setMetric:(NSString *)metricName withFunction:(NSString *)function ascending:(BOOL)ascending;

/** Remove a metric from the request.
    @param name  The name of the metric that will be removed.
 */
- (void)removeMetric:(NSString *)name;

@end
