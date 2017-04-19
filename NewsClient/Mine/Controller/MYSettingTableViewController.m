//
//  MYSettingTableViewController.m
//  NewsClient
//
//  Created by MingYanWoo on 2017/4/7.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import "MYSettingTableViewController.h"
#import "MYAccount.h"
#import "MYNewsDatabaseManager.h"
#import "SDImageCache.h"
#import "MYLoadingView.h"
#import "MYChangePasswordViewController.h"

@interface MYSettingTableViewController ()

@property (nonatomic, assign) CGFloat cacheSize;

@end

@implementation MYSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.cacheSize = [self getCacheSize];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 2;
        case 2:
            return 1;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MYSettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = @"修改密码";
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"清除缓存";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM", self.cacheSize];
        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"关于";
        }
    }else if (indexPath.section == 2) {
        UILabel *logout = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MYScreenWidth, 44)];
        logout.text = @"退出登录";
        logout.textAlignment = NSTextAlignmentCenter;
        logout.textColor = MYMainColor;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell addSubview:logout];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MYChangePasswordViewController *vc = [[MYChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [MYNewsDatabaseManager removeAllCache];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MYNewsArrayClear" object:nil];
            
            MYLoadingView *loadingView = [[MYLoadingView alloc] initWithTitle:@"清理中..."];
            [loadingView showInView:self.view completion:^(BOOL finished) {
                [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                    self.cacheSize = [self getCacheSize];
                    [loadingView hide];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }];
            }];
        }
    }
    if (indexPath.section == 2) {
        [MYAccount doLogout];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MYMineVCRefresh" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (CGFloat)getCacheSize
{
    NSUInteger intSize = [SDImageCache sharedImageCache].getSize;
    CGFloat floatSize = intSize / 1024.0 / 1024.0;
    return floatSize;
}


@end
