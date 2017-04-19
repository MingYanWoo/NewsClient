//
//  MYEditCommentView.h
//  NewsClient
//
//  Created by MingYanWoo on 2017/4/1.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYEditCommentView;
@protocol MYEditCommentViewDelegate <NSObject>

- (void)sendBtnCilcked:(MYEditCommentView *)view withContent:(NSString *)content;

@end

@interface MYEditCommentView : UIView

@property (nonatomic, weak) id<MYEditCommentViewDelegate> delegate;

+ (instancetype)getView;
- (void)close;

@end
