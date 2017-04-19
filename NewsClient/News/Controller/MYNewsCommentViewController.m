//
//  MYNewsCommentViewController.m
//  NewsClient
//
//  Created by MingYanWoo on 2017/3/31.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import "MYNewsCommentViewController.h"
#import "MYRequestManager.h"
#import "MYCommentModel.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"
#import "MYCommentListCell.h"
#import "MYEditCommentView.h"
#import "MYAccount.h"
#import "MYLoginViewController.h"
#import "MYLoadingView.h"

@interface MYNewsCommentViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MYEditCommentViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *commentField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *commentArray;

@property (nonatomic, weak) MYEditCommentView *editCommentView;
@property (nonatomic, weak) UIView *coverView;

@property (nonatomic, strong) MYLoadingView *loadingView;

@end

@implementation MYNewsCommentViewController

- (NSMutableArray *)commentArray
{
    if (_commentArray == nil) {
        _commentArray = [[NSMutableArray alloc] init];
    }
    return _commentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评论";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *blankView = [[UIView alloc] init];
    self.tableView.tableHeaderView = blankView;
    self.tableView.tableFooterView = blankView;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    UIImageView *commentImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 20)];
    commentImage.image = [UIImage imageNamed:@"编辑"];
    commentImage.contentMode = UIViewContentModeScaleAspectFit;
    [leftView addSubview:commentImage];
    self.commentField.leftView = leftView;
    self.commentField.leftViewMode = UITextFieldViewModeAlways;
    
    self.commentField.layer.cornerRadius = 15;
    self.commentField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.commentField.layer.borderWidth = 1;
    
    self.commentField.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickToClose) name:@"MYCloseEditCommentView" object:nil];
    
    [self requestComment];
}

-(void)textFieldDidBeginEditing:(UITextField*)textField
{
    [textField resignFirstResponder];
    //检查是否登录
    if (![MYAccount isLogin]) {
        MYLoginViewController *loginVC = [[MYLoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
        return;
    }
    [self showEditCommentView];
}

- (void)showEditCommentView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *coverView = [[UIView alloc] initWithFrame:window.frame];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.6;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToClose)];
    [coverView addGestureRecognizer:tap];
    [window addSubview:coverView];
    self.editCommentView = [MYEditCommentView getView];
    self.editCommentView.delegate = self;
    _coverView = coverView;
}

- (void)clickToClose
{
    [UIView animateWithDuration:0.2 animations:^{
        self.coverView.alpha = 0.0;
        [self.editCommentView close];
    } completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
    }];
}

- (void)sendBtnCilcked:(MYEditCommentView *)view withContent:(NSString *)content
{
    MYAccountModel *model = [MYAccount accountModel];
    [MYRequestManager requestForParameter:@{
        @"user_id":model.user_id,
        @"account_token":model.account_token,
        @"news_id":@(self.newsId),
        @"comment":content,
    } code:@"CreateComment" cache:nil success:^(NSDictionary *response) {
        int code = [response[@"code"] intValue];
        if (code == 0) {
            [self requestComment];
            [self clickToClose];
        }else {
            MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [progressText setMode:MBProgressHUDModeText];
            progressText.label.text = response[@"msg"];
            [progressText hideAnimated:YES afterDelay:MYTextHintTime];
        }
    } failure:^(NSString *errorDescribe) {
        MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [progressText setMode:MBProgressHUDModeText];
        progressText.label.text = @"网络异常";
        [progressText hideAnimated:YES afterDelay:MYTextHintTime];
    }];
}

- (void)requestComment
{
    self.loadingView = [[MYLoadingView alloc] initWithTitle:MYLoadingViewHint];
    [self.loadingView showInView:self.view completion:^(BOOL finished) {
        [MYRequestManager requestForParameter:@{@"news_id":@(self.newsId),} code:@"ShowComment" cache:nil success:^(NSDictionary *response) {
            [self.loadingView hide];
            self.loadingView = nil;
            NSLog(@"comment :%@", response);
            int code = [response[@"code"] intValue];
            if (code == 0) {
                self.commentArray = [MYCommentModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"comment"]];
                [self.tableView reloadData];
            }else {
                MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [progressText setMode:MBProgressHUDModeText];
                progressText.label.text = response[@"msg"];
                [progressText hideAnimated:YES afterDelay:MYTextHintTime];
            }
        } failure:^(NSString *errorDescribe) {
            NSLog(@"error:%@",errorDescribe);
            [self.loadingView hide];
            self.loadingView = nil;
            
            MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [progressText setMode:MBProgressHUDModeText];
            progressText.label.text = @"网络异常";
            [progressText hideAnimated:YES afterDelay:MYTextHintTime];
        }];

    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 70;
    return self.tableView.rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYCommentListCell *cell = [MYCommentListCell cellWithTableView:tableView];
    cell.model = self.commentArray[indexPath.row];
    return cell;
}

@end
