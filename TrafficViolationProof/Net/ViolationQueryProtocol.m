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
#import "Penalty.h"

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
    if (!_result) {
        _result = [[ViolationResult alloc]init];
    }
    //解析json结构，获取违章信息
    if (!data || data.length==0) {
        return _result;
    }
    
    JSONDecoder* decoder = [[[JSONDecoder alloc]init]autorelease];
    const NSDictionary *ret = [decoder objectWithData:data];
    NSLog(@"res= %@", ret);
    const NSDictionary* summary = [ret objectForKey:@"@attributes"];
    if (!summary) {
        return _result;
    }
    
    
    _result.detail = [summary objectForKey:@"detail"];
    _result.lastUpdateTime = [summary objectForKey:@"lastUpdateTime"];
   
    const NSDictionary* wz = [ret objectForKey:@"wz"];
    if (!wz) {
        return _result;
    }
    NSMutableArray* penalties = [[NSMutableArray alloc]init];
    
    if(!_result.penalties)
    {
        _result.penalties = penalties;
    }
    //array or only one
    if ([wz isKindOfClass:[NSArray class]]) {
        for (NSDictionary* item in wz) {
            //parse wz one by one
            id obj = [self parseWz:item];
            if (obj) {
                [penalties addObject:obj];
            }
        }
    }
    else
    {
        id obj = [self parseWz:wz];
        if (obj) {
            [penalties addObject:obj];
        }
    }
    
    return _result;
}
-(id)parseWz:(const NSDictionary*)item
{
    if (!item) {
        return nil;
    }
    NSLog(@"%@",item);
    const NSDictionary* wz = [item objectForKey:@"@attributes"];
    if (!wz) {
        return nil;
    }
    Penalty* p = [[[Penalty alloc]init]autorelease];
    p.timeString = [wz objectForKey:@"time"];
    p.locationString = [wz objectForKey:@"location"];
    p.reasonString = [wz objectForKey:@"reason"];
    p.fineString = [wz objectForKey:@"penalty"];
    
    p.licenceNumberString = [wz objectForKey:@"lpn"];
    p.scoreString = [wz objectForKey:@"points"];
    p.illegalCodeString = [wz objectForKey:@"wzid"];
    p.tipString = [wz objectForKey:@"tip"];
    
    return p;
}
@end
