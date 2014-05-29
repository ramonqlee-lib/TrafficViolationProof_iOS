//
//  ViolationQueryProtocol.h
//  TrafficViolationProof
//
//  Created by ramonqlee on 5/30/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocol.h"

@interface ViolationQueryProtocol : NSObject  <Protocol>
-(NSData*)pack;

-(id)unpack:(NSData*) data;
@end
