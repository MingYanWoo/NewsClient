//
//  MYAccountModel.h
//  NewsClient
//
//  Created by MingYanWoo on 2017/3/29.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYAccountModel : NSObject <NSCoding>

/**
 *  用户名
 */
@property (nonatomic, copy) NSString *username;
/**
 *  密码
 */
@property (nonatomic, copy) NSString *password;
/**
 *  account_token
 */
@property (nonatomic, copy) NSString *account_token;
/**
 *  昵称
 */
@property (nonatomic, copy) NSString *nickname;
/**
 *  生日
 */
@property (nonatomic, copy) NSString *birthday;
/**
 *  用户id
 */
@property (nonatomic, copy) NSString *user_id;
/**
 *  头像
 */
@property (nonatomic, copy) NSString *icon_url;
/**
 *  性别
 */
@property (nonatomic, copy) NSString *sex;

@end
