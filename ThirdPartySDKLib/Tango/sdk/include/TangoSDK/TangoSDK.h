//
//  TangoSDK.h
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

#ifndef __IPHONE_5_0
#warning "This library uses features only available in iOS SDK 5.0 and later."
#endif

#ifdef __OBJC__
  // Core
  #import "TangoTypes.h"
  #import "TangoSession.h"
  #import "TangoError.h"
  #import "NSError+TangoError.h"
  #import "TangoLaunchContext.h"

  // Profile API
  #import "TangoProfile.h"
  #import "TangoProfileResult.h"
  #import "TangoProfileEntry.h"

  // Messaging API
  #import "TangoMessaging.h"
  #import "TangoMessage.h"

  // Metrics API
  #import "TangoMetrics.h"
  #import "TangoMetric.h"
  #import "TangoMetricsGetRequest.h"
  #import "TangoMetricsSetRequest.h"

  // Leaderboard API
  #import "TangoLeaderboard.h"
  #import "TangoLeaderboardEntry.h"
  #import "TangoLeaderboardRequest.h"

  // Possessions API
  #import "TangoPossessions.h"
  #import "TangoPossession.h"
  #import "TangoPossessionResult.h"

#endif
