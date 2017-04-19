//
//  MYAccount.h
//  NewsClient
//
//  Created by MingYanWoo on 2017/3/29.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYAccountModel.h"

@interface MYAccount : NSObject

+ (instancetype)sharedAccount;

+ (void)saveAccountModel:(MYAccountModel *)accountModel;
+ (MYAccountModel *)accountModel;

//登录
+ (void)doLogin;
//注销
+ (void)doLogout;
//检查是否登录
+ (BOOL)isLogin;

@end
