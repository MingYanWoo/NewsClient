//
//  MYNewsDetailViewController.m
//  NewsClient
//
//  Created by MingYanWoo on 2017/3/18.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import "MYNewsDetailViewController.h"
#import "MYNewsModel.h"
#import "MYNewsCommentViewController.h"
#import "MYLoadingView.h"

@interface MYNewsDetailViewController () <UIWebViewDelegate>

@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, strong) MYLoadingView *loadingView;

@end

@implementation MYNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *commentItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"评论"] style:UIBarButtonItemStylePlain target:self action:@selector(showCommentList)];
    self.navigationItem.rightBarButtonItem = commentItem;
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    [self.view addSubview:webView];
    _webView = webView;
    
    //拼接HTML字符串
    NSString *htmlStr = [NSString stringWithFormat:@"<h3>%@</h3><span style=\"color:gray; font-size:13px;\">%@ &nbsp&nbsp %@</span>", self.model.title, self.model.src, self.model.time];
    htmlStr = [htmlStr stringByAppendingString:self.model.content];
    
    self.loadingView = [[MYLoadingView alloc] initWithTitle:MYLoadingViewHint];
    [self.loadingView showInView:self.view completion:^(BOOL finished) {
        [self.webView loadHTMLString:htmlStr baseURL:nil];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.webView.frame = self.view.frame;
}

- (void)showCommentList
{
    MYNewsCommentViewController *commentVC = [[MYNewsCommentViewController alloc] init];
    commentVC.newsId = self.model.news_id;
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loadingView hide];
    self.loadingView = nil;
}

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
    UIPreviewAction *comment = [UIPreviewAction actionWithTitle:@"关注" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];
    UIPreviewAction *share = [UIPreviewAction actionWithTitle:@"分享" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];
    return @[comment, share];
}


@end
