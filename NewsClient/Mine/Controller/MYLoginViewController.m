//
//  MYLoginViewController.m
//  NewsClient
//
//  Created by MingYanWoo on 2017/3/28.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import "MYLoginViewController.h"
#import "MYRequestManager.h"
#import "MBProgressHUD.h"
#import "NSString+MD5.h"
#import "MJExtension.h"
#import "MYAccount.h"
#import "MYRegisterViewController.h"
#import "MYLoadingView.h"

@interface MYLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic, strong) MYLoadingView *loadingView;

@end

@implementation MYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    UIImageView *usernameImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    usernameImage.image = [UIImage imageNamed:@"用户名"];
    usernameImage.contentMode = UIViewContentModeScaleAspectFit;
    self.usernameField.leftView = usernameImage;
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *passwordImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    passwordImage.image = [UIImage imageNamed:@"密码"];
    passwordImage.contentMode = UIViewContentModeScaleAspectFit;
    self.passwordField.leftView = passwordImage;
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    
    self.usernameField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.usernameField.layer.borderWidth = 1;
    self.usernameField.layer.cornerRadius = MYButtonCorner;
    self.passwordField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.passwordField.layer.borderWidth = 1;
    self.passwordField.layer.cornerRadius = MYButtonCorner;
    
    self.loginBtn.backgroundColor = MYMainColor;
    self.loginBtn.layer.cornerRadius = MYButtonCorner;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (IBAction)backBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginBtnClicked:(id)sender {
    [self loginRequest];
}

- (IBAction)registerBtnClicked:(id)sender {
    MYRegisterViewController *registerVC = [[MYRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)loginRequest
{
    if ([self.usernameField.text isEqualToString:@""] || [self.passwordField.text isEqualToString:@""]) {
        MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [progressText setMode:MBProgressHUDModeText];
        progressText.label.text = @"用户名或密码为空";
        [progressText hideAnimated:YES afterDelay:MYTextHintTime];
        return;
    }
    NSDictionary *dict = @{@"username":self.usernameField.text, @"password":[self.passwordField.text MD5string]};
    self.loadingView = [[MYLoadingView alloc] initWithTitle:@"登录中..."];
    [self.loadingView showInView:self.view completion:^(BOOL finished) {
        [MYRequestManager requestForParameter:dict code:@"AccountLogin" cache:nil success:^(NSDictionary *response) {
            [self.loadingView hide];
            self.loadingView = nil;
            
            NSLog(@"response:%@",response);
            int code = [response[@"code"] intValue];
            if (code == 0) {
                MYAccountModel *model = [MYAccountModel mj_objectWithKeyValues:response[@"data"]];
                model.password = [self.passwordField.text MD5string];
                [MYAccount saveAccountModel:model];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MYMineVCRefresh" object:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else {
                MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [progressText setMode:MBProgressHUDModeText];
                progressText.label.text = response[@"msg"];
                [progressText hideAnimated:YES afterDelay:MYTextHintTime];
            }
        } failure:^(NSString *errorDescribe) {
            [self.loadingView hide];
            self.loadingView = nil;
            
            MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [progressText setMode:MBProgressHUDModeText];
            progressText.label.text = @"网络异常";
            [progressText hideAnimated:YES afterDelay:MYTextHintTime];
        }];
    }];
}

@end
