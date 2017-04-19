//
//  MYNewsDatabaseManager.m
//  NewsClient
//
//  Created by MingYanWoo on 2017/4/11.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import "MYNewsDatabaseManager.h"
#import "FMDB.h"
#import "MYNewsModel.h"
#import "MJExtension.h"

@implementation MYNewsDatabaseManager

static FMDatabase *_db;
+ (void)initialize
{
    NSString *cachePath =NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cachePath stringByAppendingString:@"/news.sqlite"];
    _db = [FMDatabase databaseWithPath:filePath];
    if ([_db open]) {
        NSLog(@"数据库打开成功");
    }else {
        NSLog(@"数据库打开失败");
    }
    
    NSString *sql = @"create table if not exists t_news (id integer primary key autoincrement, news_id integer, type integer, dict blob);";
    BOOL create = [_db executeUpdate:sql];
    if (create) {
        NSLog(@"创建表成功");
    }else {
        NSLog(@"创建表失败");
    }
}

+ (void)saveNews:(NSArray *)newsArray withType:(int)type
{
//    for (MYNewsModel *model in newsArray) {
//        NSString *newsId = [NSString stringWithFormat:@"%d", model.news_id];
//        NSString *newsType = [NSString stringWithFormat:@"%d", type];
//        NSDictionary *newsDict = model.mj_keyValues;
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:newsDict];
//        
//        BOOL insert = [_db executeUpdate:@"insert into t_news (news_id, type, dict) values(?, ?, ?);", newsId, newsType, data];
//        if (insert) {
//            NSLog(@"插入成功");
//        }else {
//            NSLog(@"插入失败");
//        }
//    }
    for (NSDictionary *dict in newsArray) {
        NSString *newsId = dict[@"news_id"];
        NSString *newsType = [NSString stringWithFormat:@"%d", type];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
        
        BOOL insert = [_db executeUpdate:@"insert into t_news (news_id, type, dict) values(?, ?, ?);", newsId, newsType, data];
        if (insert) {
            NSLog(@"插入成功");
        }else {
            NSLog(@"插入失败");
        }
    }
}

+ (NSMutableArray *)getNewsWithParam:(NSDictionary *)param type:(int)type
{
//    NSString *sql = nil;
//    if (param[@"sinceId"]) {
//        sql = [NSString stringWithFormat:@"select * from t_news where news_id > '%@' and type = '%@' order by news_id desc limit 20;", param[@"sinceId"], @(type)];
//    }else if (param[@"maxId"]) {
//        sql = [NSString stringWithFormat:@"select * from t_news where news_id < '%@' and type = '%@' order by news_id desc limit 20;", param[@"maxId"], @(type)];
//    }else {
//        sql = [NSString stringWithFormat:@"select * from t_news where type = '%@' order by news_id desc limit 20;", @(type)];
//    }
//    
//    NSMutableArray *result = [[NSMutableArray alloc] init];
//    FMResultSet *select = [_db executeQuery:sql];
//    while ([select next]) {
//        NSData *data = [select dataForColumn:@"dict"];
//        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        MYNewsModel *model = [MYNewsModel mj_objectWithKeyValues:dict];
//        [result addObject:model];
//    }
//    return result;
    NSString *sql = nil;
    if (param[@"sinceId"]) {
        sql = [NSString stringWithFormat:@"select * from t_news where news_id > '%@' and type = '%@' order by news_id desc limit 20;", param[@"sinceId"], @(type)];
    }else if (param[@"maxId"]) {
        sql = [NSString stringWithFormat:@"select * from t_news where news_id < '%@' and type = '%@' order by news_id desc limit 20;", param[@"maxId"], @(type)];
    }else {
        sql = [NSString stringWithFormat:@"select * from t_news where type = '%@' order by news_id desc limit 20;", @(type)];
    }
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    FMResultSet *select = [_db executeQuery:sql];
    while ([select next]) {
        NSData *data = [select dataForColumn:@"dict"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        MYNewsModel *model = [MYNewsModel mj_objectWithKeyValues:dict];
        [result addObject:model];
    }
    return result;

}

+ (BOOL)removeAllCache
{
    BOOL delete = [_db executeUpdate:@"delete from t_news;"];
    if (delete) {
        NSLog(@"删除成功");
    }else {
        NSLog(@"删除失败");
    }
    return delete;
}

@end
