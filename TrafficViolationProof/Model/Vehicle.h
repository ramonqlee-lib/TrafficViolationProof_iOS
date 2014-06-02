//
//  Vehicle.h
//  TrafficViolationProof
//
//  Created by ramonqlee on 5/29/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//
//车辆信息
#import <Foundation/Foundation.h>
#import "RMAppData.h"

@interface Vehicle : NSObject<Persistable>

@property(nonatomic,copy)NSString* area;
@property(nonatomic,copy)NSString* licNumber;
@property(nonatomic,copy)NSString* engineNumber;
@property(nonatomic,copy)NSString* frameNumber;

@end
