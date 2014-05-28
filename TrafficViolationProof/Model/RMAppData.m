//
//  RMAppData.m
//  Elite
//
//  Created by Ramonqlee on 11/4/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import "RMAppData.h"
#import "SQLiteManager.h"
#import "StringUtil.h"

@implementation RMAppData

+(void)add:(id<Persistable>)item
{
    if (!item) {
        return;
    }
    
    [RMAppData makeSureDBExist:item];
    SQLiteManager* dbManager = [[[SQLiteManager alloc] initWithDatabaseNamed:[item dbFileName]]autorelease];
    
#if 0
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@', '%d', '%d', '%d')",
                     kDBTableName, kDBTitle, kDBSummary, kDBContent,kDBPageUrl,kCommentNumber,kFavoriteNumber,kLikeNumber,[article.title sqliteEscape],[article.summary sqliteEscape],[article.content sqliteEscape],article.url,article.commentNumber,article.favoriteNumber,article.likeNumber];
#else
    NSString* sql = [item insertIntoTableSql];
#endif
    [dbManager doQuery:sql];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:[item postNotificationName] object:nil];
}
+(void)makeSureDBExist:(id<Persistable>)item
{
    if (!item) {
        return;
    }
    SQLiteManager* dbManager = [[[SQLiteManager alloc]initWithDatabaseNamed:[item dbFileName]]autorelease];
    if (![dbManager openDatabase]) {
        //create table
        
#if 0
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT PRIMARY KEY,%@ INTEGER,%@ INTEGER,%@ INTEGER )",kDBTableName,kDBTitle,kDBSummary,kDBContent,kDBPageUrl,kCommentNumber,kFavoriteNumber,kLikeNumber];
#else
        NSString *sqlCreateTable = [item createTableSql];
#endif
        [dbManager doQuery:sqlCreateTable];
        
        //update table for timestamp
        //        ALTER TABLE table_name
        //        ADD column_name datatype
        //NSString* sqlUpdateTableSql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ DOUBLE",kDBTableName,kDBFavoriteTime];
        //[dbManager doQuery:sqlUpdateTableSql];
        
        [dbManager closeDatabase];
    }
}
+(void)remove:(id<Persistable>)item
{
    if (!item) {
        return;
    }
    SQLiteManager* dbManager = [[[SQLiteManager alloc] initWithDatabaseNamed:[item dbFileName]]autorelease];
    
#if 0
    NSString *sql = [NSString stringWithFormat:@"delete from Content where PageUrl = '%@'",url];
#else
    NSString* sql = [item deleteFromTableSql];
#endif
    [dbManager doQuery:sql];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:[item postNotificationName] object:nil];
}
+(NSArray*)query:(NSRange)range withPersistable:(id<Persistable>)item
{
    if (!item) {
        return nil;
    }
    
    return  [RMAppData getTableValue:[item dbFileName] withTableName:[item tableName] withRange:range];
}

+(NSArray*)getTableValue:(NSString*)dbName withTableName:(NSString*)tableName withRange:(NSRange)range
{
    SQLiteManager* dbManager = [[[SQLiteManager alloc] initWithDatabaseNamed:dbName]autorelease];
    NSString* query = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %d OFFSET %d",tableName,range.length,range.location];
    
    NSLog(@"query:%@",query);
    
    NSArray* items =  [dbManager getRowsForQuery:query];
#if 1
    return items;
#else
    NSMutableArray* data = [[[NSMutableArray alloc]init]autorelease];
    //    for (NSDictionary* item in items)
    for (NSInteger i = items.count-1; i>=0;i--)//descending order
    {
        NSDictionary* item = [items objectAtIndex:i];
        RMArticle* article = [[[RMArticle alloc]init]autorelease];
        article.title = [item objectForKey:kDBTitle];
        article.summary = [item objectForKey:kDBSummary];
        article.content = [item objectForKey:kDBContent];
        article.url = [item objectForKey:kDBPageUrl];
        //
        if (!article.url|| article.url.length==0) {
            article.url = kChannelUrl;
        }
        
        article.title = [article.title sqliteUnescape];
        article.summary = [article.summary sqliteUnescape];
        article.content = [article.content sqliteUnescape];
        
        article.likeNumber = ((NSString*)[item objectForKey:kLikeNumber]).intValue;
        article.commentNumber = ((NSString*)[item objectForKey:kCommentNumber]).intValue;
        article.favoriteNumber = ((NSString*)[item objectForKey:kFavoriteNumber]).intValue;
        [data addObject:article];
    }
    return data;
#endif
}

@end
