//
//  MYTabBarController.m
//  NewsClient
//
//  Created by MingYanWoo on 2017/3/16.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import "MYTabBarController.h"
#import "MYNavController.h"
#import "MYSearchViewController.h"
#import "MYMineViewController.h"
#import "MYMessageViewController.h"
#import "MYNewsViewController.h"

@interface MYTabBarController ()

@end

@implementation MYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTabBarItem];
    
    [self.tabBar setTintColor:MYMainColor];
}

- (void)setUpTabBarItem
{
    //新闻
    MYNewsViewController *newsListVC = [[MYNewsViewController alloc] init];
    [self setOneChildViewController:newsListVC image:[UIImage imageNamed:@"the-middle-1"] selectedImage:[UIImage imageNamed:@"the-middle-2"] title:@"新闻"];
//    //消息
//    MYMessageViewController *messageVC = [[MYMessageViewController alloc] init];
//    [self setOneChildViewController:messageVC image:[UIImage imageNamed:@"information-1"] selectedImage:[UIImage imageNamed:@"information-2"] title:@"消息"];
    //搜索
    MYSearchViewController *searchVC = [[MYSearchViewController alloc] init];
    [self setOneChildViewController:searchVC image:[UIImage imageNamed:@"search-1"] selectedImage:[UIImage imageNamed:@"search-2"] title:@"搜索"];
    //我
    MYMineViewController *mineVC = [[MYMineViewController alloc] init];
    [self setOneChildViewController:mineVC image:[UIImage imageNamed:@"person-1"] selectedImage:[UIImage imageNamed:@"person-2"] title:@"我"];
}

//设置子控制器TabBar属性
- (void)setOneChildViewController:(UIViewController *)vc image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title
{
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selectedImage;
    
    MYNavController *nav = [[MYNavController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:nav];
}

@end
