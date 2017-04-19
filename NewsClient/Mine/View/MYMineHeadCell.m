//
//  MYMineHeadCell.m
//  NewsClient
//
//  Created by MingYanWoo on 2017/3/30.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import "MYMineHeadCell.h"
#import "MYAccountModel.h"
#import "UIImageView+WebCache.h"

@implementation MYMineHeadCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"MYMineHeadCell";
    MYMineHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MYMineHeadCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithRed:217.0/255.0 green:67.0/255.0 blue:63.0/255.0 alpha:1.0];
    self.iconView.layer.cornerRadius=self.iconView.frame.size.width/2;//裁成圆角
    self.iconView.layer.masksToBounds=YES;
    
    UITapGestureRecognizer *tapNickname = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedNickname)];
    self.nicknameLabel.userInteractionEnabled = YES;
    [self.nicknameLabel addGestureRecognizer:tapNickname];
    
    UITapGestureRecognizer *tapHeadIcon = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedHeadIcon)];
    self.iconView.userInteractionEnabled = YES;
    [self.iconView addGestureRecognizer:tapHeadIcon];
}

- (void)setModel:(MYAccountModel *)model
{
    if (model == nil) {
        self.nicknameLabel.text = @"登录/注册";
        self.iconView.image = [UIImage imageNamed:@"icon_default"];
        self.sexView.alpha = 0.0;
        return;
    }
    _model = model;
    self.nicknameLabel.text = model.nickname;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.icon_url] placeholderImage:[UIImage imageNamed:@"icon_default1"]];
    self.sexView.alpha = 1.0;
    self.sexView.image = [model.sex isEqualToString:@"女"] ? [UIImage imageNamed:@"Female"] : [UIImage imageNamed:@"Male"];
}

- (void)didClickedNickname
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MYDidClickedNickname" object:nil];
}

- (void)didClickedHeadIcon
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MYDidClickedHeadIcon" object:nil];
}


@end
