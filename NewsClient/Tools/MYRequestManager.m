//
//  MYRequestManager.m
//  NewsClient
//
//  Created by MingYanWoo on 2017/3/17.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import "MYRequestManager.h"

@implementation MYRequestManager

+ (void)requestWtihUrl:(NSString *)urlStr ForParameter:(NSDictionary *)parameter code:(NSString *)code cache:(void (^)(NSDictionary *))cache success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 18;
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:code forHTTPHeaderField:@"code"];
    [manager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error.localizedDescription);
        }
    }];
}

+ (void)requestForParameter:(NSDictionary *)parameter code:(NSString *)code cache:(void (^)(NSDictionary *))cache success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure
{
    [self requestWtihUrl:MY_Request_Url ForParameter:parameter code:code cache:cache success:success failure:failure];
}

+ (void)requestForParameter:(NSDictionary *)parameter code:(NSString *)code constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block cache:(void (^)(NSDictionary *))cache success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:code forHTTPHeaderField:@"code"];
    [manager POST:MY_Request_Url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (block) {
            block(formData);
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error.localizedDescription);
        }
    }];
}

@end
