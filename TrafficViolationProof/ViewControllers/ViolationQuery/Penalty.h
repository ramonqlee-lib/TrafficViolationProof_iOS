//
//  Penalty.h
//  TrafficViolationProof
//
//  Created by ramonqlee on 5/30/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//
//违章信息

#import <Foundation/Foundation.h>

@interface Penalty : NSObject

@property(nonatomic,copy)NSString* licenceNumberString;
@property(nonatomic,copy)NSString* timeString;
@property(nonatomic,copy)NSString* locationString;
@property(nonatomic,copy)NSString* reasonString;
@property(nonatomic,copy)NSString* fineString;
@property(nonatomic,copy)NSString* scoreString;
@property(nonatomic,copy)NSString* illegalCodeString;
@property(nonatomic,copy)NSString* tipString;

@end
