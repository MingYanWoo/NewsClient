//
//  MYRegisterViewController.m
//  NewsClient
//
//  Created by MingYanWoo on 2017/4/7.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import "MYRegisterViewController.h"
#import "MYAccount.h"
#import "MYRequestManager.h"
#import "MBProgressHUD.h"
#import "MYLoadingView.h"
#import "NSString+MD5.h"

@interface MYRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *surePwdField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (nonatomic, strong) MYLoadingView *loadingView;

@end

@implementation MYRegisterViewController

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
    self.pwdField.leftView = passwordImage;
    self.pwdField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *surePwdImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    surePwdImage.image = [UIImage imageNamed:@"密码"];
    surePwdImage.contentMode = UIViewContentModeScaleAspectFit;
    self.surePwdField.leftView = surePwdImage;
    self.surePwdField.leftViewMode = UITextFieldViewModeAlways;

    self.usernameField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.usernameField.layer.borderWidth = 1;
    self.usernameField.layer.cornerRadius = MYButtonCorner;
    self.pwdField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.pwdField.layer.borderWidth = 1;
    self.pwdField.layer.cornerRadius = MYButtonCorner;
    self.surePwdField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.surePwdField.layer.borderWidth = 1;
    self.surePwdField.layer.cornerRadius = MYButtonCorner;
    
    self.registerBtn.backgroundColor = MYMainColor;
    self.registerBtn.layer.cornerRadius = MYButtonCorner;
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

- (IBAction)closeBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)registerBtnClicked:(id)sender {
    if ([self.usernameField.text isEqualToString:@""]) {
        MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [progressText setMode:MBProgressHUDModeText];
        progressText.label.text = @"用户名为空";
        [progressText hideAnimated:YES afterDelay:MYTextHintTime];
        return;
    }
    if (self.pwdField.text.length < 6) {
        MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [progressText setMode:MBProgressHUDModeText];
        progressText.label.text = @"密码太短";
        [progressText hideAnimated:YES afterDelay:MYTextHintTime];
        return;
    }
    if ([self.pwdField.text isEqualToString:@""] || [self.surePwdField.text isEqualToString:@""]) {
        MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [progressText setMode:MBProgressHUDModeText];
        progressText.label.text = @"密码为空";
        [progressText hideAnimated:YES afterDelay:MYTextHintTime];
        return;
    }
    if (![self.pwdField.text isEqualToString:self.surePwdField.text]) {
        MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [progressText setMode:MBProgressHUDModeText];
        progressText.label.text = @"两次密码不一致";
        [progressText hideAnimated:YES afterDelay:MYTextHintTime];
        return;
    }
    self.loadingView = [[MYLoadingView alloc] initWithTitle:@"注册中..."];
    [self.loadingView showInView:self.view completion:^(BOOL finished) {
        NSDictionary *dict = @{@"username":self.usernameField.text, @"password":[self.pwdField.text MD5string]};
        [MYRequestManager requestForParameter:dict code:@"AccountRegister" cache:nil success:^(NSDictionary *response) {
            [self.loadingView hide];
            self.loadingView = nil;
            
            NSLog(@"response:%@",response);
            MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:MYKeyWindow animated:YES];
            [progressText setMode:MBProgressHUDModeText];
            progressText.label.text = response[@"msg"];
            [progressText hideAnimated:YES afterDelay:MYTextHintTime];
            int code = [response[@"code"] intValue];
            if (code == 0) {
                [self.navigationController popViewControllerAnimated:YES];
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
