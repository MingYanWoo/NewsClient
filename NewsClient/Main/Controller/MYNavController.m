//
//  MYNavController.m
//  NewsClient
//
//  Created by MingYanWoo on 2017/3/16.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import "MYNavController.h"

@interface MYNavController () <UIGestureRecognizerDelegate>

@end

@implementation MYNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor = MYMainColor;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    //  这句很核心 稍后讲解
    id target = self.interactivePopGestureRecognizer.delegate;
    //  这句很核心 稍后讲解
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    //  获取添加系统边缘触发手势的View
    UIView *targetView = self.interactivePopGestureRecognizer.view;
    
    //  创建pan手势 作用范围是全屏
    UIPanGestureRecognizer * fullScreenGes = [[UIPanGestureRecognizer alloc]initWithTarget:target action:handler];
    fullScreenGes.delegate = self;
    [targetView addGestureRecognizer:fullScreenGes];
    
    // 关闭边缘触发手势 防止和原有边缘手势冲突
    [self.interactivePopGestureRecognizer setEnabled:NO];
}

//  防止导航控制器只有一个rootViewcontroller时触发手势
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    //解决与左滑手势冲突
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    return self.childViewControllers.count == 1 ? NO : YES;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    viewController.navigationItem.backBarButtonItem = backItem;
    [super pushViewController:viewController animated:animated];
}


@end
