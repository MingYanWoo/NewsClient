//
//  MYInfoTableViewController.m
//  NewsClient
//
//  Created by MingYanWoo on 2017/4/7.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import "MYInfoTableViewController.h"
#import "MYAccount.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import "MYRequestManager.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"
#import "MYLoadingView.h"

@interface MYInfoTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) MYLoadingView *loadingView;

@end

@implementation MYInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 3;
        case 2:
            return 1;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70;
    }
    return 44;
}

- (UITableViewCell *)getCustomCellWithTableView:(UITableView *)tableView title:(NSString *)title content:(NSString *)content
{
    static NSString *cellID = @"MYInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.textLabel.text = title;
    cell.detailTextLabel.text = content;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    MYAccountModel *model = [MYAccount accountModel];
    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"头像";
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(MYScreenWidth - 90, 10, 50, 50)];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.layer.cornerRadius = imageV.bounds.size.width/2;
        imageV.clipsToBounds = YES;
        [imageV sd_setImageWithURL:[NSURL URLWithString:model.icon_url] placeholderImage:[UIImage imageNamed:@"icon_default1"]];
        [cell addSubview:imageV];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                cell = [self getCustomCellWithTableView:tableView title:@"昵称" content:model.nickname];
                break;
            case 1:
                cell = [self getCustomCellWithTableView:tableView title:@"生日" content:model.birthday];
                break;
            case 2:
                cell = [self getCustomCellWithTableView:tableView title:@"性别" content:model.sex];
                break;
            default:
                break;
        }
    }else if (indexPath.section == 2) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UILabel *logout = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MYScreenWidth, 44)];
        logout.text = @"退出登录";
        logout.textAlignment = NSTextAlignmentCenter;
        logout.textColor = MYMainColor;
        [cell addSubview:logout];
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self didSelectHeadIcon];
    }else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                [self didSelectNickname];
                break;
            case 1:
                [self didSelectBirthday];
                break;
            case 2:
                [self didSelectSex];
                break;
            default:
                break;
        }
    }else if (indexPath.section == 2) {
        [MYAccount doLogout];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MYMineVCRefresh" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didSelectHeadIcon
{
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    UIAlertAction *localPhoto = [UIAlertAction actionWithTitle:@"从本地相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pickLocalPhoto];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [sheet addAction:takePhoto];
    [sheet addAction:localPhoto];
    [sheet addAction:cancel];
    [self presentViewController:sheet animated:YES completion:nil];
}

- (void)didSelectNickname
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改昵称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    __weak typeof(alertController) weakAlert = alertController;
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self updateProfileWithNickname:weakAlert.textFields.lastObject.text sex:@"" birthday:@""];
    }];
    //文本输入框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:doneAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didSelectBirthday
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改生日\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, 272, 200)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    [alert.view addSubview:datePicker];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        //实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
        NSString *dateString = [dateFormat stringFromDate:datePicker.date];
        [self updateProfileWithNickname:@"" sex:@"" birthday:dateString];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancelAction];
    [alert addAction:doneAction];
    [self presentViewController:alert animated:YES completion:^{ }];
}

- (void)didSelectSex
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改性别\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 60, 272, 100)];
    picker.delegate = self;
    picker.dataSource = self;
    [alert.view addSubview:picker];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSInteger selectedRow = [picker selectedRowInComponent:0];
        if (selectedRow == 0) {
            [self updateProfileWithNickname:@"" sex:@"1" birthday:@""];
        }else {
            [self updateProfileWithNickname:@"" sex:@"0" birthday:@""];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancelAction];
    [alert addAction:doneAction];
    [self presentViewController:alert animated:YES completion:^{ }];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0) {
        return @"男";
    }else {
        return @"女";
    }
}

- (void)pickLocalPhoto
{
    //本地相册不需要检查，因为UIImagePickerController会自动检查并提醒
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //先检查相机可用是否
        BOOL cameraIsAvailable = [self checkCamera];
        if (YES == cameraIsAvailable) {
            [self presentViewController:picker animated:YES completion:nil];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在iPhone的“设置-隐私-相机”选项中，允许本应用程序访问你的相机。" delegate:self cancelButtonTitle:@"好，我知道了" otherButtonTitles:nil];
            [alert show];
        }
        
    }else {
        NSLog(@"相机不可用！");
    }
}

//检查相机是否可用
- (BOOL)checkCamera
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(AVAuthorizationStatusRestricted == authStatus ||
       AVAuthorizationStatusDenied == authStatus)
    {
        //相机不可用
        return NO;
    }
    //相机可用
    return YES;
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        NSString *key = nil;
        if (picker.allowsEditing)
        {
            key = UIImagePickerControllerEditedImage;
        }
        else
        {
            key = UIImagePickerControllerOriginalImage;
        }
        //获取图片
        UIImage *image = [info objectForKey:key];
        
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            //压缩图片质量
            image = [self reduceImage:image percent:0.1];
            CGSize imageSize = image.size;
            imageSize.height = 320;
            imageSize.width = 320;
            //压缩图片尺寸
            image = [self imageWithImageSimple:image scaledToSize:imageSize];
        }
        //上传到服务器
        [self uploadPhoto:image];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

//压缩图片质量
-(UIImage *)reduceImage:(UIImage *)image percent:(float)percent
{
    NSData *imageData = UIImageJPEGRepresentation(image, percent);
    UIImage *newImage = [UIImage imageWithData:imageData];
    return newImage;
}
//压缩图片尺寸
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)uploadPhoto:(UIImage *)image
{
    MYAccountModel *model = [MYAccount accountModel];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    self.loadingView = [[MYLoadingView alloc] initWithTitle:@"上传中..."];
    [self.loadingView showInView:self.view completion:^(BOOL finished) {
        [manager POST:[NSString stringWithFormat:@"%@account/upload_profile_photo.php", MY_Request_Url] parameters:@{@"user_id":model.user_id, @"account_token":model.account_token } constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            [formData appendPartWithFileData:imageData name:@"photo" fileName:@"image.jpeg" mimeType:@"image/jpeg"];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self.loadingView hide];
            self.loadingView = nil;
            NSLog(@"suss:%@", responseObject);
            int code = [responseObject[@"code"] intValue];
            if (code == 0) {
                MYAccountModel *model = [MYAccountModel mj_objectWithKeyValues:responseObject[@"data"]];
                model.password = [MYAccount accountModel].password;
                [MYAccount saveAccountModel:model];
                [self.tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MYMineVCRefresh" object:nil];
            }else {
                MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [progressText setMode:MBProgressHUDModeText];
                progressText.label.text = responseObject[@"msg"];
                [progressText hideAnimated:YES afterDelay:MYTextHintTime];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.loadingView hide];
            self.loadingView = nil;
            NSLog(@"err:%@", error);
            MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [progressText setMode:MBProgressHUDModeText];
            progressText.label.text = @"网络异常";
            [progressText hideAnimated:YES afterDelay:MYTextHintTime];
        }];
    }];
    
}

- (void)updateProfileWithNickname:(NSString *)nickname sex:(NSString *)sex birthday:(NSString *)birthday
{
    NSDictionary *dict = @{
        @"user_id":[MYAccount accountModel].user_id,
        @"account_token":[MYAccount accountModel].account_token,
        @"nickname":nickname,
        @"sex":sex,
        @"birthday":birthday,
    };
    self.loadingView = [[MYLoadingView alloc] initWithTitle:@"更新中..."];
    [self.loadingView showInView:self.view completion:^(BOOL finished) {
        [MYRequestManager requestForParameter:dict code:@"UpdateProfile" cache:nil success:^(NSDictionary *response) {
            [self.loadingView hide];
            self.loadingView = nil;
            NSLog(@"suss:%@", response);
            int code = [response[@"code"] intValue];
            if (code == 0) {
                MYAccountModel *model = [MYAccountModel mj_objectWithKeyValues:response[@"data"]];
                model.password = [MYAccount accountModel].password;
                [MYAccount saveAccountModel:model];
                [self.tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MYMineVCRefresh" object:nil];
            }else {
                MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [progressText setMode:MBProgressHUDModeText];
                progressText.label.text = response[@"msg"];
                [progressText hideAnimated:YES afterDelay:MYTextHintTime];
            }
        } failure:^(NSString *errorDescribe) {
            [self.loadingView hide];
            self.loadingView = nil;
            NSLog(@"err:%@", errorDescribe);
            MBProgressHUD *progressText = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [progressText setMode:MBProgressHUDModeText];
            progressText.label.text = @"网络异常";
            [progressText hideAnimated:YES afterDelay:MYTextHintTime];
        }];
    }];
}

@end
