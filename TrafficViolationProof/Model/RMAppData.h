//  负责数据的持久化
//  RMAppData.h
//  Elite
//
//  Created by Ramonqlee on 11/4/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import <Foundation/Foundation.h>

//实现对象持久化的协议：基于数据库模型方式
@protocol Persistable <NSObject>

-(NSString*)dbFileName;//存储的文件名
-(NSString*)tableName;//存储的表名
-(NSString*)postNotificationName;//当数据发生变化时，发送该通知

-(NSString*)rowExistSql;//查询记录是否存在
-(NSString*)createTableSql;//首次创建数据库的sql语句
-(NSString*)insertIntoTableSql;//插入语句
-(NSString*)deleteFromTableSql;//删除sql

//-(id)newObject:(NSDictionary*)dict;//传入dict，生成对象
//-(NSString*)key;//表中的key，可用于删除等操作。
@end


@interface RMAppData : NSObject

//获取记录总数
+(NSInteger)count:(id<Persistable>)item;

//当前记录是否存在
+(BOOL)recordExist:(id<Persistable>)item;

//收藏库的操作
+(void)add:(id<Persistable>)item;//添加到收藏库中

+(void)remove:(id<Persistable>)item;

+(NSArray*)query:(NSRange)range withPersistable:(id<Persistable>)item;//返回NSDictionary对象的数组

@end
