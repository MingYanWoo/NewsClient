//
//  MYAccountModel.m
//  NewsClient
//
//  Created by MingYanWoo on 2017/3/29.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import "MYAccountModel.h"

@implementation MYAccountModel

- (void)setSex:(NSString *)sex
{
    _sex = [sex isEqualToString:@"0"] ? @"女":@"男";
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _username = [aDecoder decodeObjectForKey:@"username"];
        _password = [aDecoder decodeObjectForKey:@"password"];
        _account_token = [aDecoder decodeObjectForKey:@"account_token"];
        _nickname = [aDecoder decodeObjectForKey:@"nickname"];
        _birthday = [aDecoder decodeObjectForKey:@"birthday"];
        _user_id = [aDecoder decodeObjectForKey:@"user_id"];
        _icon_url = [aDecoder decodeObjectForKey:@"icon_url"];
        _sex = [aDecoder decodeObjectForKey:@"sex"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_password forKey:@"password"];
    [aCoder encodeObject:_account_token forKey:@"account_token"];
    [aCoder encodeObject:_nickname forKey:@"nickname"];
    [aCoder encodeObject:_birthday forKey:@"birthday"];
    [aCoder encodeObject:_user_id forKey:@"user_id"];
    [aCoder encodeObject:_icon_url forKey:@"icon_url"];
    [aCoder encodeObject:_sex forKey:@"sex"];
}

@end
