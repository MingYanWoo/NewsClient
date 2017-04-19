//
//  MYAccount.m
//  NewsClient
//
//  Created by MingYanWoo on 2017/3/29.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import "MYAccount.h"
#import "MYRequestManager.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"

#define MYFilePath [NSString stringWithFormat:@"%@/MYAccount", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]]

@implementation MYAccount

+ (instancetype)sharedAccount
{
    static MYAccount *_account = nil;
    if (_account == nil) {
        _account = [[MYAccount alloc] init];
    }
    return _account;
}


+ (MYAccountModel *)accountModel
{
    MYAccountModel *accountModel = [NSKeyedUnarchiver unarchiveObjectWithFile:MYFilePath];
    return accountModel;
}

+ (void)saveAccountModel:(MYAccountModel *)accountModel
{
    [NSKeyedArchiver archiveRootObject:accountModel toFile:MYFilePath];
}

+ (void)doLogin
{
    if ([MYAccount isLogin]) {
        MYAccountModel *model = [MYAccount accountModel];
        [MYRequestManager requestForParameter:@{@"username":model.username, @"password":model.password,} code:@"AccountLogin" cache:nil success:^(NSDictionary *response) {
            NSLog(@"response:%@",response);
            int code = [response[@"code"] intValue];
            if (code == 0) {
                MYAccountModel *newModel = [MYAccountModel mj_objectWithKeyValues:response[@"data"]];
                newModel.password = model.password;
                [MYAccount saveAccountModel:newModel];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MYMineVCRefresh" object:nil];
            }else {
                MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                [progressText setMode:MBProgressHUDModeText];
                progressText.label.text = response[@"msg"];
                [progressText hideAnimated:YES afterDelay:MYTextHintTime];
            }

        } failure:^(NSString *errorDescribe) {
            MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            [progressText setMode:MBProgressHUDModeText];
            progressText.label.text = @"网络异常，登录失败";
            [progressText hideAnimated:YES afterDelay:MYTextHintTime];
        }];
    }
}

+ (void)doLogout
{
    [MYAccount saveAccountModel:nil];
    MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [progressText setMode:MBProgressHUDModeText];
    progressText.label.text = @"注销成功";
    [progressText hideAnimated:YES afterDelay:MYTextHintTime];
}

+ (BOOL)isLogin
{
    if ([MYAccount accountModel] == nil) {
        return NO;
    }else {
        return YES;
    }
}


@end
