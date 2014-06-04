//
//  Vehicle.m
//  TrafficViolationProof
//
//  Created by ramonqlee on 5/29/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "Vehicle.h"

const static NSString* kArea = @"area";
const static NSString* kLicNumberType = @"licNumberType";
const static NSString* kLicNumber=@"licNumber";
const static NSString* kEngineNumber=@"engineNumber";
const static NSString* kFrameNumber=@"frameNumber";
const static NSString* kComment=@"comment";

@implementation Vehicle

-(NSString*)dbFileName//存储的文件名
{
    return @"car.db";
}
-(NSString*)tableName//存储的表名
{
    return @"car";
}
-(NSString*)postNotificationName//当数据发生变化时，发送该通知
{
    return @"carChangedNotification";
}

-(NSString*)createTableSql//首次创建数据库的sql语句
{
    NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT, %@ TEXT,  %@ TEXT PRIMARY KEY,%@ TEXT,%@ TEXT,%@ TEXT)",[self tableName],kArea,kLicNumberType,kLicNumber,kEngineNumber,kFrameNumber,kComment];
    return sqlCreateTable;
}
-(NSString*)insertIntoTableSql//插入语句
{
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@', '%@', '%@')",
                     [self tableName],kArea,kLicNumberType,kLicNumber,kEngineNumber,kFrameNumber,kComment,_area,_licNumberType,_licNumber,_engineNumber,_frameNumber,_comment];
    return  sql;
}
-(NSString*)deleteFromTableSql//删除sql
{
    NSString *sql = [NSString stringWithFormat:@"delete from '%@' where '%@' = '%@'",[self tableName],kLicNumber,_licNumber];
    return sql;
}
@end
