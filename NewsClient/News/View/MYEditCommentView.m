//
//  MYEditCommentView.m
//  NewsClient
//
//  Created by MingYanWoo on 2017/4/1.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import "MYEditCommentView.h"
#import "MBProgressHUD.h"

#define MYMargin 10
#define MYButtonWidth 50
#define MYButtonHeight 30
#define MYTextFont           [UIFont systemFontOfSize:15]
#define MYTextViewHeight     100
#define MYSheetViewHeight    (MYMargin * 3 + MYButtonHeight + MYTextViewHeight)

@interface MYEditCommentView ()

@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UIView *editArea;

@end

@implementation MYEditCommentView

+ (instancetype)getView
{
    MYEditCommentView *view = [[self alloc] initWithFrame:CGRectMake(0, MYScreenHeight, MYScreenWidth, MYSheetViewHeight)];
    [view addEventResponsors];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:view];
    [UIView animateWithDuration:0.2 animations:^{
        view.frame = CGRectMake(0, MYScreenHeight-MYSheetViewHeight, MYScreenWidth, MYSheetViewHeight);
    }];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *editArea = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, MYSheetViewHeight)];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(MYMargin, MYMargin, MYButtonWidth, MYButtonHeight);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancelBtn setFont:MYTextFont];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [editArea addSubview:cancelBtn];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(self.bounds.size.width-MYMargin-MYButtonWidth, MYMargin, MYButtonWidth, MYButtonHeight);
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [sendBtn setFont:MYTextFont];
    [sendBtn addTarget:self action:@selector(sendBtnCilcked:withContent:) forControlEvents:UIControlEventTouchUpInside];
    [editArea addSubview:sendBtn];
    
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, MYButtonHeight)];
    hintLabel.text = @"写评论";
    [hintLabel setTextColor:[UIColor blackColor]];
    [hintLabel setFont:[UIFont systemFontOfSize:17]];
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.center = CGPointMake(self.bounds.size.width/2, cancelBtn.center.y);
    [editArea addSubview:hintLabel];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(MYMargin, CGRectGetMaxY(cancelBtn.frame)+MYMargin, self.bounds.size.width-2*MYMargin, MYTextViewHeight)];
    textView.layer.borderWidth = 1.0;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [editArea addSubview:textView];
    _textView = textView;
    
    [self addSubview:editArea];
    _editArea = editArea;
}

- (void)cancelBtnClicked
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MYCloseEditCommentView" object:nil];
}

- (void)sendBtnCilcked:(MYEditCommentView *)view withContent:(NSString *)content;
{
    if ([self.textView.text isEqualToString:@""]) {
        MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        [progressText setMode:MBProgressHUDModeText];
        progressText.label.text = @"评论不能为空！";
        [progressText hideAnimated:YES afterDelay:MYTextHintTime];
        return;
    }
    if ([_delegate respondsToSelector:@selector(sendBtnCilcked:withContent:)]) {
        [_delegate sendBtnCilcked:self withContent:self.textView.text];
    }
}

- (void)close
{
    [self.textView resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, MYScreenHeight, self.editArea.bounds.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)addEventResponsors
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Keyboard Notification Action
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    CGFloat keyboardHeight = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSTimeInterval animationDuration = [[aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        self.frame = CGRectMake(0, MYScreenHeight-MYSheetViewHeight-keyboardHeight, self.editArea.bounds.size.width, MYSheetViewHeight+keyboardHeight);
    } completion:nil];
}


@end
