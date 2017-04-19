//
//  MYNewsListCell.m
//  NewsClient
//
//  Created by MingYanWoo on 2017/3/19.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import "MYNewsListCell.h"
#import "MYNewsModel.h"
#import "UIImageView+WebCache.h"

@interface MYNewsListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UILabel *newsSrc;
@property (weak, nonatomic) IBOutlet UILabel *newsTime;

@end

@implementation MYNewsListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"MYNewsListCell";
    MYNewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MYNewsListCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setModel:(MYNewsModel *)model
{
    _model = model;
    [self.newsImageView sd_setImageWithURL:[NSURL URLWithString:self.model.img_url] placeholderImage:[UIImage imageNamed:@""]];
    self.newsTitle.text = self.model.title;
//    self.newsSrc.text = [NSString stringWithFormat:@"%d", self.model.news_id];
    self.newsSrc.text = model.src;
    self.newsTime.text = self.model.relativeTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
