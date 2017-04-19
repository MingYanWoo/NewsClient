//
//  MYNewsModel.h
//  NewsClient
//
//  Created by MingYanWoo on 2017/3/18.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYNewsModel : NSObject

/**
 *  新闻id
 */
@property (nonatomic, assign) int news_id;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  内容
 */
@property (nonatomic, copy) NSString *content;
/**
 *  新闻来源
 */
@property (nonatomic, copy) NSString *src;
/**
 *  发布时间
 */
@property (nonatomic, copy) NSString *time;
/**
 *  发布时相对现在的时间
 */
@property (nonatomic, copy) NSString *relativeTime;
/**
 *  新闻类型
 */
@property (nonatomic, assign) int type;
/**
 *  新闻标题图片
 */
@property (nonatomic, copy) NSString *img_url;
/**
 *  新闻唯一key
 */
@property (nonatomic, copy) NSString *uniquekey;

@end
