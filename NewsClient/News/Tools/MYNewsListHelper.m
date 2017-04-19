//
//  MYNewsListHelper.m
//  NewsClient
//
//  Created by MingYanWoo on 2017/3/20.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import "MYNewsListHelper.h"
#import "MYRequestManager.h"
#import "MJExtension.h"
#import "MYNewsModel.h"
#import "MYNewsListCell.h"
#import "MJRefresh.h"
#import "MYNewsDatabaseManager.h"

@interface MYNewsListHelper () 

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation MYNewsListHelper

- (NSMutableArray *)newsArray
{
    if (nil == _newsArray) {
        _newsArray = [[NSMutableArray alloc] init];
    }
    return _newsArray;
}

- (instancetype)initWithTableView:(UITableView *)tableView
{
    if (self = [super init]) {
        self.tableView = tableView;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewsList)];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreNews)];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewDeselected) name:@"MYTableViewDeselected" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearNewsArray) name:@"MYNewsArrayClear" object:nil];
        
    }
    return self;
}

- (void)tableViewDeselected
{
    [self.tableView deselectRowAtIndexPath:self.indexPath animated:YES];
}

- (void)clearNewsArray
{
    [self.newsArray removeAllObjects];
    [self.tableView reloadData];
}

- (void)setType:(int)type
{
    _type = type;
    [self getNewsFromDatabase];
}

- (void)getNewsFromDatabase
{
    NSMutableArray *newsArrayFromDB = [MYNewsDatabaseManager getNewsWithParam:nil type:self.type];
    if (newsArrayFromDB.count) {
        [self.newsArray addObjectsFromArray:newsArrayFromDB];
        [self.tableView reloadData];
    }else {
        [self getNewsList];
    }
}

- (void)getNewsList
{
    MYNewsModel *model = [self.newsArray firstObject];
    [MYRequestManager requestForParameter:@{@"type":@(self.type), @"since_id":@(model.news_id)} code:@"NewsTimeline" cache:nil success:^(NSDictionary *response) {
        int code = [response[@"code"] intValue];
        if (code == 0) {
            NSArray *news = response[@"data"][@"news"];
            [self.tableView.mj_footer resetNoMoreData];
            NSMutableArray *newNewsArray = [MYNewsModel mj_objectArrayWithKeyValuesArray:news];
            NSLog(@"newNewsArray:%@",newNewsArray);
            if (newNewsArray.count) {
                [MYNewsDatabaseManager saveNews:news withType:self.type];
            }
            [newNewsArray addObjectsFromArray:self.newsArray];
            self.newsArray = newNewsArray;
            NSLog(@"self.newsArray:%@", self.newsArray);
            //更新时间
            for (MYNewsModel *model in self.newsArray) {
                [model setTime:model.time];
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }else {
            NSLog(@"%@", response[@"msg"]);
        }
    } failure:^(NSString *errorDescribe) {
        NSLog(@"err:%@", errorDescribe);
    }];
}

- (void)loadMoreNews
{
    MYNewsModel *model = [self.newsArray lastObject];
    //先从数据库取，数据库没有再请求
    NSMutableArray *newMoreArray = [MYNewsDatabaseManager getNewsWithParam:@{@"maxId":@(model.news_id)} type:self.type];
    if (newMoreArray.count) {
        [self.newsArray addObjectsFromArray:newMoreArray];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    [MYRequestManager requestForParameter:@{@"type":@(self.type), @"max_id":@(model.news_id)} code:@"NewsTimeline" cache:nil success:^(NSDictionary *response) {
        int code = [response[@"code"] intValue];
        if (code == 0) {
            NSArray *news = response[@"data"][@"news"];
            if (news.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            NSArray *moreNewsArray = [MYNewsModel mj_objectArrayWithKeyValuesArray:news];
            if (moreNewsArray.count) {
                [MYNewsDatabaseManager saveNews:moreNewsArray withType:self.type];
            }
            [self.newsArray addObjectsFromArray:moreNewsArray];
            NSLog(@"self.newsArray:%@", self.newsArray);
            //更新时间
            for (MYNewsModel *model in self.newsArray) {
                [model setTime:model.time];
            }
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }else {
            NSLog(@"%@", response[@"msg"]);
        }
    } failure:^(NSString *errorDescribe) {
        NSLog(@"err:%@", errorDescribe);
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
    if ([self.delegate respondsToSelector:@selector(helperSelectedNews:withNewsModel:)]) {
        self.indexPath = indexPath;
        [self.delegate helperSelectedNews:self withNewsModel:self.newsArray[indexPath.row]];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
