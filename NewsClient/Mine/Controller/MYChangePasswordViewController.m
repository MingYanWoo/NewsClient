//
//  MYChangePasswordViewController.m
//  NewsClient
//
//  Created by MingYanWoo on 2017/4/13.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import "MYChangePasswordViewController.h"
#import "MBProgressHUD.h"
#import "MYLoadingView.h"
#import "MYRequestManager.h"
#import "MYAccount.h"
#import "NSString+MD5.h"

@interface MYChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPwdField;
@property (weak, nonatomic) IBOutlet UITextField *PwdField;
@property (weak, nonatomic) IBOutlet UITextField *sureNewPwdField;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@end

@implementation MYChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIImageView *oldPwdImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    oldPwdImage.image = [UIImage imageNamed:@"密码"];
    oldPwdImage.contentMode = UIViewContentModeScaleAspectFit;
    self.oldPwdField.leftView = oldPwdImage;
    self.oldPwdField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *passwordImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    passwordImage.image = [UIImage imageNamed:@"密码"];
    passwordImage.contentMode = UIViewContentModeScaleAspectFit;
    self.PwdField.leftView = passwordImage;
    self.PwdField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *surePwdImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    surePwdImage.image = [UIImage imageNamed:@"密码"];
    surePwdImage.contentMode = UIViewContentModeScaleAspectFit;
    self.sureNewPwdField.leftView = surePwdImage;
    self.sureNewPwdField.leftViewMode = UITextFieldViewModeAlways;
    
    self.oldPwdField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.oldPwdField.layer.borderWidth = 1;
    self.oldPwdField.layer.cornerRadius = MYButtonCorner;
    self.PwdField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.PwdField.layer.borderWidth = 1;
    self.PwdField.layer.cornerRadius = MYButtonCorner;
    self.sureNewPwdField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.sureNewPwdField.layer.borderWidth = 1;
    self.sureNewPwdField.layer.cornerRadius = MYButtonCorner;
    
    self.changeBtn.layer.cornerRadius = MYButtonCorner;
    self.changeBtn.backgroundColor = MYMainColor;
}

- (IBAction)changeBtnClicked:(id)sender {
    if ([self.oldPwdField.text isEqualToString:@""] || [self.PwdField.text isEqualToString:@""] || [self.sureNewPwdField.text isEqualToString:@""]) {
        MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [progressText setMode:MBProgressHUDModeText];
        progressText.label.text = @"密码为空";
        [progressText hideAnimated:YES afterDelay:MYTextHintTime];
        return;
    }
    if (self.PwdField.text.length < 6) {
        MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [progressText setMode:MBProgressHUDModeText];
        progressText.label.text = @"新密码太短";
        [progressText hideAnimated:YES afterDelay:MYTextHintTime];
        return;
    }
    if (![self.PwdField.text isEqualToString:self.sureNewPwdField.text]) {
        MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [progressText setMode:MBProgressHUDModeText];
        progressText.label.text = @"两次密码不一致";
        [progressText hideAnimated:YES afterDelay:MYTextHintTime];
        return;
    }
    
    MYLoadingView *loadingView = [[MYLoadingView alloc] initWithTitle:@"修改中..."];
    [loadingView showInView:self.view completion:^(BOOL finished) {
        NSDictionary *dict = @{@"username":[MYAccount accountModel].username, @"old_password":[self.oldPwdField.text MD5string], @"new_password":[self.PwdField.text MD5string]};
        [MYRequestManager requestForParameter:dict code:@"AccountChangePassword" cache:nil success:^(NSDictionary *response) {
            [loadingView hide];
            
            NSLog(@"response:%@",response);
            MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:MYKeyWindow animated:YES];
            [progressText setMode:MBProgressHUDModeText];
            progressText.label.text = response[@"msg"];
            [progressText hideAnimated:YES afterDelay:MYTextHintTime];
            int code = [response[@"code"] intValue];
            if (code == 0) {
                MYAccountModel *model = [MYAccount accountModel];
                model.password = [self.PwdField.text MD5string];
                [MYAccount saveAccountModel:model];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSString *errorDescribe) {
            [loadingView hide];

            MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [progressText setMode:MBProgressHUDModeText];
            progressText.label.text = @"网络异常";
            [progressText hideAnimated:YES afterDelay:MYTextHintTime];
        }];
    }];
}

@end
