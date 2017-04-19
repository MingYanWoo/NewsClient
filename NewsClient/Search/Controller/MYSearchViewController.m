//
//  MYSearchViewController.m
//  NewsClient
//
//  Created by MingYanWoo on 2017/3/16.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import "MYSearchViewController.h"
#import "MYRequestManager.h"
#import "MYNewsListCell.h"
#import "MYNewsDetailViewController.h"
#import "MYNewsModel.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"

@interface MYSearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, weak) UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) UIView *coverView;

@property (nonatomic, strong) NSMutableArray *newsArray;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation MYSearchViewController

- (NSMutableArray *)newsArray
{
    if (_newsArray == nil) {
        _newsArray = [[NSMutableArray alloc] init];
    }
    return _newsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"搜索新闻";
    searchBar.tintColor = MYMainColor;
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    _searchBar = searchBar;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.indexPath animated:YES];
}

- (void)requestWithKeyword:(NSString *)keyword
{
    [MYRequestManager requestForParameter:@{@"keyword":keyword} code:@"SearchNews" cache:nil success:^(NSDictionary *response) {
        int code = [response[@"code"] intValue];
        if (code == 0) {
            NSArray *news = response[@"data"][@"news"];
            [self.newsArray removeAllObjects];
            self.newsArray = [MYNewsModel mj_objectArrayWithKeyValuesArray:news];
            NSLog(@"%@", self.newsArray);
            if (self.newsArray.count != 0) {
                [self.coverView removeFromSuperview];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSString *errorDescribe) {
        MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [progressText setMode:MBProgressHUDModeText];
        progressText.label.text = @"网络异常";
        [progressText hideAnimated:YES afterDelay:MYTextHintTime];
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        [self.newsArray removeAllObjects];
        [self.tableView reloadData];
        [self appendCoverView];
        return;
    }
    [self requestWithKeyword:searchText];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if ([searchBar.text isEqualToString:@""]) {
        [self appendCoverView];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self clickToClose];
}

- (void)appendCoverView
{
    if (_coverView != nil) {
        return;
    }
    UIView *coverView = [[UIView alloc] initWithFrame:self.view.frame];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.3;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToClose)];
    [coverView addGestureRecognizer:tap];
    [self.view addSubview:coverView];
    _coverView = coverView;
}

- (void)clickToClose
{
    [UIView animateWithDuration:0.2 animations:^{
        self.coverView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
        [self.searchBar endEditing:YES];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYNewsListCell *cell = [MYNewsListCell cellWithTableView:tableView];
    cell.model = self.newsArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar endEditing:YES];
    self.indexPath = indexPath;
    MYNewsDetailViewController *detailVC = [[MYNewsDetailViewController alloc] init];
    detailVC.model = self.newsArray[indexPath.row];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar endEditing:YES];
}

@end
