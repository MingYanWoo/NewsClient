//
//  MYRequestManager.h
//  NewsClient
//
//  Created by MingYanWoo on 2017/3/17.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"


@interface MYRequestManager : NSObject

+ (void)requestWtihUrl:(NSString *)urlStr
          ForParameter:(NSDictionary *)parameter
                  code:(NSString *)code
                 cache:(void (^)(NSDictionary *cacheDictionary))cache
               success:(void (^)(NSDictionary *response))success
               failure:(void (^)(NSString *errorDescribe))failure;

+ (void)requestForParameter:(NSDictionary *)parameter
                       code:(NSString *)code
                      cache:(void (^)(NSDictionary *cacheDictionary))cache
                    success:(void (^)(NSDictionary *response))success
                    failure:(void (^)(NSString *errorDescribe))failure;
///带图片或文件类型请求
+ (void)requestForParameter:(NSDictionary *)parameter
                       code:(NSString *)code
  constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      cache:(void (^)(NSDictionary *cacheDictionary))cache
                    success:(void (^)(NSDictionary *responseDictionary))success
                    failure:(void (^)(NSString *errorDescribe))failure;

@end
