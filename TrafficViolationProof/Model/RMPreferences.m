//
//  RMPreferences.m
//  TrafficViolationProof
//
//  Created by ramonqlee on 6/7/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "RMPreferences.h"

@implementation RMPreferences

+(void)setString:(NSString*)value forKey:(NSString*)key
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    [def setObject:value forKey:key];
    
    [def synchronize];
}

+(NSString*)stringForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults]stringForKey:key];
}
@end
