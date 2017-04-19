//
//  MYLoadingView.m
//  NewsClient
//
//  Created by MingYanWoo on 2017/4/7.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import "MYLoadingView.h"
#import "QKBNSString+DL.h"

@interface MYLoadingView (){
    UIView *bgView;
    UILabel *titleLabel;
    UIImageView *loadingBgImageView;
    UIImageView *loadingImageView;
    
    BOOL isFinshed;
}

@end

@implementation MYLoadingView

- (id)initWithTitle:(NSString *)title {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithWhite:0. alpha:.2]];
        
        bgView = [[UIView alloc] initWithFrame:(CGRect){CGPointZero,70,70}];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        [bgView.layer setCornerRadius:5];
        [bgView setClipsToBounds:YES];
        [self addSubview:bgView];
        
        loadingBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        [loadingBgImageView setFrame:(CGRect){20, 20, 30, 30}];
        [loadingBgImageView setContentMode:UIViewContentModeScaleAspectFit];
        [loadingBgImageView setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        [bgView addSubview:loadingBgImageView];
        
        loadingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading"]];
        [loadingImageView setFrame:CGRectMake(20, 45/2, 25, 25)];
        [loadingImageView setContentMode:UIViewContentModeScaleAspectFit];
        [loadingImageView setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        [bgView addSubview:loadingImageView];
        
        titleLabel = [[UILabel alloc] initWithFrame:(CGRect){CGRectGetMaxX(loadingBgImageView.frame) + 10, 0, 100, 70}];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
        [titleLabel setTextColor:[UIColor darkGrayColor]];
        [titleLabel setAdjustsFontSizeToFitWidth:YES];
        [titleLabel setText:title];
        [bgView addSubview:titleLabel];
        
        CGSize size = [title sizeForConstrainedSize:CGSizeMake(900, 30) font:titleLabel.font];
        if (size.width > CGRectGetWidth([[UIScreen mainScreen] bounds]) - CGRectGetMaxX(loadingBgImageView.frame) - 40) {
            size.width = CGRectGetWidth([[UIScreen mainScreen] bounds]) - CGRectGetMaxX(loadingBgImageView.frame) - 40;
        }
        [titleLabel setFrame:(CGRect){CGRectGetMaxX(loadingBgImageView.frame) + 10, 0, size.width, 70}];
        
        [bgView setFrame:(CGRect){0, 0, CGRectGetMaxX(titleLabel.frame) + 20, 70}];
        [bgView setCenter:CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2)];
        [bgView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    }
    return self;
}

#pragma mark - public

- (void)hide:(BOOL)isHide {
    [self hide];
}

- (void)hide {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    isFinshed = YES;
    [self removeFromSuperview];
}

//显示loading
- (void)show:(void (^)(BOOL finished))completion {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self setFrame:[UIApplication sharedApplication].keyWindow.bounds];
    [self setAlpha:0];
    [UIView animateWithDuration:.3 animations:^{
        [self setAlpha:1];
    } completion:^(BOOL finished) {
        [self startLoadingAnimate:[NSNumber numberWithFloat:0]];
        if (completion)
            completion(finished);
    }];
}

- (void)showInView:(UIView *)view completion:(void (^)(BOOL finished))completion {
    [view addSubview:self];
    [self setFrame:view.bounds];
    [self setAlpha:0];
    [UIView animateWithDuration:.3 animations:^{
        [self setAlpha:1];
    } completion:^(BOOL finished) {
        [self startLoadingAnimate:[NSNumber numberWithFloat:0]];
        if (completion)
            completion(finished);
    }];
}

#pragma mark - private

- (void)startLoadingAnimate:(NSNumber *)transform {
    CGFloat transformFloat = transform.floatValue + 0.15;
    [loadingImageView setTransform:CGAffineTransformMakeRotation(transform.floatValue)];
    if (isFinshed == NO)
        [self performSelector:@selector(startLoadingAnimate:) withObject:[NSNumber numberWithFloat:transformFloat] afterDelay:0.02];
}

@end
