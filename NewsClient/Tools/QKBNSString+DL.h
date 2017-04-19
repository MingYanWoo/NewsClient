//
//  NSString.m
//  XingDong
//
//  Created by ZhangYaoYuan on 28/4/15.
//  Copyright (c) 2015 XingDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (DL)

- (NSString *)encodedURLString;

- (NSString *)md5String;

- (BOOL)isEmailFormat;

- (BOOL)isPhoneFormat;

- (BOOL)isIdentityCard;

- (CGSize)sizeForConstrainedSize:(CGSize)constrainedSize font:(UIFont *)font;

@end
