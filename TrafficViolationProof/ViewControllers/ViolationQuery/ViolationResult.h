//
//  ViolationResult.h
//  TrafficViolationProof
//
//  Created by ramonqlee on 5/30/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViolationResult : NSObject

@property(nonatomic,copy)NSString* detail;
@property(nonatomic,copy)NSString* lastUpdateTime;
@property(nonatomic,retain)NSArray* penalties;//Penalty array

@end
