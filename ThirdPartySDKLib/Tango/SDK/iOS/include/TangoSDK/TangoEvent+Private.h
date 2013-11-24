//
//  TangoEvent+Private.h
//  
//
//  Created by Li Geng on 8/27/13.
//
//

#ifndef _TangoEvent_Private_h
#define _TangoEvent_Private_h

#import "TangoEvent.h"

@interface TangoEvent ()

@property (nonatomic, assign) EventCode eventCode;
@property (nonatomic, strong) id jsonContent;

- (TangoEvent *)initWithEventCode:(EventCode)code jsonObject:(id)content;

@end


#endif
