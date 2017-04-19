//
//  MYNewsDatabaseManager.h
//  NewsClient
//
//  Created by MingYanWoo on 2017/4/11.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYNewsDatabaseManager : NSObject

//插入新闻
+ (void)saveNews:(NSArray *)newsArray withType:(int)type;
//取出新闻
+ (NSMutableArray *)getNewsWithParam:(NSDictionary *)param type:(int)type;
//清除所有记录
+ (BOOL)removeAllCache;

@end
