//
//  Vehicle.h
//  TrafficViolationProof
//
//  Created by ramonqlee on 5/29/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMAppData.h"

/**
 private static String AREA = "area";// 查询所在地区的违章
 private static String LICNUMBER = "licNumber";// 车牌号
 private static String ENGINENUMBER = "engineNumber";// 发动机号[部分地区必选，部分地区必选但是不匹配]
 private static String FRAMENUMBER = "frameNumber";// 车架号[部分地区必选]
 
 private String _area="北京";
 private String _licNumber="冀F810JH";
 private String _engineNumber="hgdddf";
 private String _frameNumber;
 */
@interface Vehicle : NSObject<Persistable>

@property(nonatomic,copy)NSString* area;
@property(nonatomic,copy)NSString* licNumber;
@property(nonatomic,copy)NSString* engineNumber;
@property(nonatomic,copy)NSString* frameNumber;

@end
