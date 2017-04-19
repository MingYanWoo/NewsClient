//
//  MYCommentListCell.m
//  NewsClient
//
//  Created by MingYanWoo on 2017/3/31.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import "MYCommentListCell.h"
#import "MYCommentModel.h"
#import "UIImageView+WebCache.h"

@interface MYCommentListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;


@end

@implementation MYCommentListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"MYCommentListCell";
    MYCommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MYCommentListCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconView.layer.cornerRadius = self.iconView.bounds.size.width/2;
    self.iconView.layer.masksToBounds = YES;
}

- (void)setModel:(MYCommentModel *)model
{
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.icon_url] placeholderImage:[UIImage imageNamed:@"icon_default1"]];
    self.nicknameLabel.text = model.nickname;
    self.timeLabel.text = model.comment_time;
    self.commentLabel.text = model.detail;
    self.sexView.image = model.sex == 0 ? [UIImage imageNamed:@"Female"] : [UIImage imageNamed:@"Male"];
}

@end
