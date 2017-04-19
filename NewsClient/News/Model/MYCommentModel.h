//
//  MYCommentModel.h
//  NewsClient
//
//  Created by MingYanWoo on 2017/4/1.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYCommentModel : NSObject


/**
 *  评论内容
 */
@property (nonatomic, copy) NSString *detail;
/**
 *  评论id
 */
@property (nonatomic, assign) int comment_id;
/**
 *  评论昵称
 */
@property (nonatomic, copy) NSString *nickname;
/**
 *  新闻id
 */
@property (nonatomic, assign) int news_id;
/**
 *  评论用户头像
 */
@property (nonatomic, copy) NSString *icon_url;
/**
 *  评论用户id
 */
@property (nonatomic, assign) int user_id;
/**
 *  评论时间
 */
@property (nonatomic, copy) NSString *comment_time;
/**
 *  评论用户性别
 */
@property (nonatomic, assign) int sex;

@end
