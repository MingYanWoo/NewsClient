//
//  MYLoadingView.h
//  NewsClient
//
//  Created by MingYanWoo on 2017/4/7.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYLoadingView : UIView

- (id)initWithTitle:(NSString *)title;

- (void)hide;

- (void)hide:(BOOL)isHide;

//显示loading
- (void)show:(void (^)(BOOL finished))completion;

- (void)showInView:(UIView *)view completion:(void (^)(BOOL finished))completion;

@end
