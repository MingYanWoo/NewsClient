//
//  NSString.m
//  XingDong
//
//  Created by ZhangYaoYuan on 28/4/15.
//  Copyright (c) 2015 XingDong. All rights reserved.
//


#import "QKBNSString+DL.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSString (DL)

- (NSString *)encodedURLString {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,
                                                                                             NULL,
                                                                                             CFSTR("?=&+"),
                                                                                             kCFStringEncodingUTF8)); // encoding
    return result;
}

- (NSString *)md5String {
    if(self.length < 1) return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

- (BOOL)isEmailFormat {
    BOOL isEmailFormat = NO;
    
    NSString* pattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]+";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    if ([predicate evaluateWithObject:self])
        isEmailFormat = YES;
    
    return isEmailFormat;
}

- (BOOL)isPhoneFormat {
    NSString *phoneRegex = @"^1[0-9]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL isPhone = [phoneTest evaluateWithObject:self];
    return isPhone;
}

- (BOOL)isIdentityCard {
    BOOL flag;
    if (self.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:self];
}

- (CGSize)sizeForConstrainedSize:(CGSize)constrainedSize font:(UIFont *)font {
    if (self.length < 1)
        return CGSizeZero;
    
    CGSize size = CGSizeZero;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        size = [self boundingRectWithSize:constrainedSize options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font} context:nil].size;
    } else
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = [self sizeWithFont:font constrainedToSize:constrainedSize];
#pragma clang diagnostic pop
    
    return CGSizeMake(size.width + 2, size.height + 4);
}

@end
