//
//  RMPreferences.h
//  TrafficViolationProof
//
//  Created by ramonqlee on 6/7/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMPreferences : NSObject

//string
+(void)setString:(NSString*)value forKey:(NSString*)key;
+(NSString*)stringForKey:(NSString*)key;

@end
