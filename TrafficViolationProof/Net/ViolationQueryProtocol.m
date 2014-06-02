//
//  ViolationQueryProtocol.m
//  TrafficViolationProof
//
//  Created by ramonqlee on 5/30/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "ViolationQueryProtocol.h"
#import "JSONKit.h"
#import "Vehicle.h"

static NSString* AREA = @"area";// 查询所在地区的违章
static NSString* LICNUMBER = @"licNumber";// 车牌号
static NSString* ENGINENUMBER = @"engineNumber";// 发动机号[部分地区必选，部分地区必选但是不匹配]
static NSString* FRAMENUMBER = @"frameNumber";// 车架号[部分地区必选]


@implementation ViolationQueryProtocol

-(NSData*)pack:(id)tmp;
{
    NSDictionary* dict = [[[NSMutableDictionary alloc]init]autorelease];
    if (tmp==nil || ![tmp isKindOfClass:[Vehicle class]]) {
        return [[dict JSONString] dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    Vehicle* vehicle = (Vehicle*)tmp;
    
    NSString* urlEncodedString = [vehicle.area stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dict setValue:urlEncodedString forKey:AREA];
    
    urlEncodedString = [vehicle.licNumber stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dict setValue:urlEncodedString forKey:LICNUMBER];
    [dict setValue:vehicle.engineNumber forKey:ENGINENUMBER];
    
    
    if (vehicle.frameNumber && vehicle.frameNumber.length!=0) {
//        [dict setValue:vehicle.frameNumber forKey:FRAMENUMBER];
        [dict setValue:@"123456" forKey:FRAMENUMBER];
    }
    
    return [[dict JSONString] dataUsingEncoding:NSUTF8StringEncoding];
}

-(id)unpack:(NSData*) data
{
    return nil;
}
@end
