//
//  TangoEvent.h
//  
//
//  Created by Li Geng on 8/27/13.
//
//

#ifndef ____TangoEvent__
#define ____TangoEvent__

#import <Foundation/Foundation.h>
#import <tango_sdk/event_codes.h>

@interface TangoEvent : NSObject

@property(nonatomic, readonly) EventCode eventCode;
@property(nonatomic, readonly) id jsonContent;

@end
#endif /* defined(____TangoEvent__) */
