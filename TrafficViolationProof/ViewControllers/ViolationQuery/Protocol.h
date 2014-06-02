//
//  Protocol.h
//  TrafficViolationProof
//
//  Created by ramonqlee on 5/30/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Protocol <NSObject>

@required
-(NSData*)pack:(id)obj;

-(id)unpack:(NSData*) data;

@end
