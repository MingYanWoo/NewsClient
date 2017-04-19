//
//  MYMineViewController.m
//  NewsClient
//
//  Created by MingYanWoo on 2017/3/16.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import "MYMineViewController.h"
#import "MYLoginViewController.h"
#import "MYMineHeadCell.h"
#import "MYAccount.h"
#import "MYSettingTableViewController.h"
#import "MYInfoTableViewController.h"

@interface MYMineViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation MYMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"MYMineVCRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickedNickname) name:@"MYDidClickedNickname" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickedHeadIcon) name:@"MYDidClickedHeadIcon" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tableView deselectRowAtIndexPath:self.indexPath animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)refreshTableView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (UITableViewCell *)getCustomCellWithTableView:(UITableView *)tableView title:(NSString *)title imageName:(NSString *)image
{
    static NSString *cellID = @"MYMineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = title;
    cell.imageView.image = [UIImage imageNamed:image];
    //调整图片大小
    CGSize itemSize = CGSizeMake(20, 20);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 2;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 200;
    }else if (indexPath.section == 1){
        return 50;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MYMineHeadCell *cell = [MYMineHeadCell cellWithTableView:tableView];
        cell.model = [MYAccount accountModel];
        return cell;
    }else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            return [self getCustomCellWithTableView:tableView title:@"我的关注" imageName:@"关注"];
        }else if (indexPath.row == 1) {
            return [self getCustomCellWithTableView:tableView title:@"设置" imageName:@"设置"];
        }
    }
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = @"111";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    if (indexPath.row == 1) {
        MYSettingTableViewController *setting = [[MYSettingTableViewController alloc] init];
        setting.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setting animated:YES];
        return;
    }

}

- (void)didClickedNickname
{
    //判断是否已登录
    if ([MYAccount isLogin]) {
        MYInfoTableViewController *info = [[MYInfoTableViewController alloc] init];
        info.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:info animated:YES];
    }else {
        MYLoginViewController *login = [[MYLoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)didClickedHeadIcon
{
    //判断是否已登录
    if ([MYAccount isLogin]) {
        MYInfoTableViewController *info = [[MYInfoTableViewController alloc] init];
        info.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:info animated:YES];
    }else {
        MYLoginViewController *login = [[MYLoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
