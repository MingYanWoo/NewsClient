//
//  MYNewsViewController.m
//  NewsClient
//
//  Created by MingYanWoo on 2017/3/20.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import "MYNewsViewController.h"
#import "MYNewsListHelper.h"
#import "MYNewsDetailViewController.h"

@interface MYNewsViewController () <MYNewsListHelperDelegate, UIScrollViewDelegate, UIViewControllerPreviewingDelegate>
@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (weak, nonatomic) IBOutlet UIScrollView *newsListScrollerView;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;
@property (weak, nonatomic) IBOutlet UIButton *finacBtn;
@property (weak, nonatomic) IBOutlet UIButton *techBtn;
@property (weak, nonatomic) IBOutlet UIButton *enterBtn;
@property (weak, nonatomic) IBOutlet UIView *typeIndicator;

@property (nonatomic, strong) MYNewsListHelper *topHelper;
@property (nonatomic, strong) MYNewsListHelper *finacHelper;
@property (nonatomic, strong) MYNewsListHelper *techHelper;
@property (nonatomic, strong) MYNewsListHelper *enterHelper;

@property (nonatomic, strong) UITableView *topTV;
@property (nonatomic, strong) UITableView *finacTV;
@property (nonatomic, strong) UITableView *techTV;
@property (nonatomic, strong) UITableView *enterTV;

@end

@implementation MYNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新闻";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.newsListScrollerView.contentSize = CGSizeMake(MYScreenWidth * 4, MYScreenHeight - self.typeView.bounds.size.height - self.navigationController.navigationBar.bounds.size.height - self.tabBarController.tabBar.bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height);
    self.newsListScrollerView.pagingEnabled = YES;
    self.newsListScrollerView.delegate = self;
    
    
    for (int i = 0; i < 4; i++) {
        UITableView *list = [[UITableView alloc] initWithFrame:CGRectMake(MYScreenWidth * i, 0, MYScreenWidth, MYScreenHeight - self.typeView.bounds.size.height - self.navigationController.navigationBar.bounds.size.height - self.tabBarController.tabBar.bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height)];
        MYNewsListHelper *helper = [[MYNewsListHelper alloc] initWithTableView:list];
        list.delegate = helper;
        list.dataSource = helper;
        helper.delegate = self;
        switch (i) {
            case 0:
                _topHelper = helper;
                _topTV = list;
                break;
            case 1:
                _finacHelper = helper;
                _finacTV = list;
                break;
            case 2:
                _techHelper = helper;
                _techTV = list;
                break;
            case 3:
                _enterHelper = helper;
                _enterTV = list;
                break;
            default:
                break;
        }
        helper.type = i;
        [self.newsListScrollerView addSubview:list];
    }
    
    //注册3D Touch
    [self registerForPreviewingWithDelegate:self sourceView:self.topTV];
    [self registerForPreviewingWithDelegate:self sourceView:self.finacTV];
    [self registerForPreviewingWithDelegate:self sourceView:self.techTV];
    [self registerForPreviewingWithDelegate:self sourceView:self.enterTV];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.typeIndicator.frame = CGRectMake(self.typeIndicator.frame.origin.x, self.typeIndicator.frame.origin.y, self.topBtn.frame.size.width, self.typeIndicator.frame.size.height);
    self.typeIndicator.backgroundColor = MYMainColor;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MYTableViewDeselected" object:nil];
}

- (void)changeType:(UIButton *)sender
{
    if (sender == self.topBtn) {
        self.topBtn.selected = YES;
        self.finacBtn.selected = NO;
        self.techBtn.selected = NO;
        self.enterBtn.selected = NO;
    }else if (sender == self.finacBtn) {
        self.topBtn.selected = NO;
        self.finacBtn.selected = YES;
        self.techBtn.selected = NO;
        self.enterBtn.selected = NO;
    }
    else if (sender == self.techBtn) {
        self.topBtn.selected = NO;
        self.finacBtn.selected = NO;
        self.techBtn.selected = YES;
        self.enterBtn.selected = NO;
    }
    else if (sender == self.enterBtn) {
        self.topBtn.selected = NO;
        self.finacBtn.selected = NO;
        self.techBtn.selected = NO;
        self.enterBtn.selected = YES;
    }
}

- (IBAction)typeChange:(UIButton *)sender {
    if (sender == self.topBtn) {
        [UIView animateWithDuration:0.2 animations:^{
            self.typeIndicator.frame = CGRectMake(0, self.typeView.bounds.size.height - 2, MYViewWidth/4, 2);
        }];
        [self.newsListScrollerView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if (sender == self.finacBtn) {
        [UIView animateWithDuration:0.2 animations:^{
            self.typeIndicator.frame = CGRectMake(MYViewWidth/4, self.typeView.bounds.size.height - 2, MYViewWidth/4, 2);
        }];
        [self.newsListScrollerView setContentOffset:CGPointMake(MYViewWidth, 0) animated:YES];
    }
    else if (sender == self.techBtn) {
        [UIView animateWithDuration:0.2 animations:^{
            self.typeIndicator.frame = CGRectMake(2*MYViewWidth/4, self.typeView.bounds.size.height - 2, MYViewWidth/4, 2);
        }];
        [self.newsListScrollerView setContentOffset:CGPointMake(2*MYViewWidth, 0) animated:YES];
    }
    else if (sender == self.enterBtn) {
        [UIView animateWithDuration:0.2 animations:^{
            self.typeIndicator.frame = CGRectMake(3*MYViewWidth/4, self.typeView.bounds.size.height - 2, MYViewWidth/4, 2);
        }];
        [self.newsListScrollerView setContentOffset:CGPointMake(3*MYViewWidth, 0) animated:YES];
    }
}

#pragma mark - UIViewControllerPreviewingDelegate

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    int page = self.newsListScrollerView.contentOffset.x / self.newsListScrollerView.contentSize.width * 4;
    UITableView *tableView = nil;
    NSObject *helper = nil;
    CGPoint loca;
    switch (page) {
        case 0:
            tableView = self.topTV;
            helper = self.topHelper;
            loca = CGPointMake(location.x, location.y);
            break;
        case 1:
            tableView = self.finacTV;
            helper = self.finacHelper;
            loca = CGPointMake(location.x + self.newsListScrollerView.contentSize.width/4, location.y);
            break;
        case 2:
            tableView = self.techTV;
            helper = self.techHelper;
            loca = CGPointMake(location.x + self.newsListScrollerView.contentSize.width/4*2, location.y);
            break;
        case 3:
            tableView = self.enterTV;
            helper = self.enterHelper;
            loca = CGPointMake(location.x + self.newsListScrollerView.contentSize.width/4*3, location.y);
            break;
        default:
            break;
    }
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:location];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //没有选择cell，直接return
    if (cell == nil) {
        return nil;
    }
    MYNewsDetailViewController *vc = [[MYNewsDetailViewController alloc] init];
    vc.model = [helper valueForKey:@"newsArray"][indexPath.row];
    previewingContext.sourceRect = cell.frame;
    return vc;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    viewControllerToCommit.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewControllerToCommit animated:YES];
}

#pragma mark - MYNewsListHelperDelegate

- (void)helperSelectedNews:(MYNewsListHelper *)helper withNewsModel:(MYNewsModel *)model
{
    MYNewsDetailViewController *detailVC = [[MYNewsDetailViewController alloc] init];
    detailVC.model = model;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat locat = scrollView.contentOffset.x / scrollView.contentSize.width;
    self.typeIndicator.frame = CGRectMake(MYViewWidth * locat, self.typeView.bounds.size.height - 2, MYViewWidth/4, 2);
    
    int page = 4 * locat;
    switch (page) {
        case 0:
            [self changeType:self.topBtn];
            break;
        case 1:
            [self changeType:self.finacBtn];
            break;
        case 2:
            [self changeType:self.techBtn];
            break;
        case 3:
            [self changeType:self.enterBtn];
            break;
        default:
            break;
    }
}




@end
