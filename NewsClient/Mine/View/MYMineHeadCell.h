//
//  MYMineHeadCell.h
//  NewsClient
//
//  Created by MingYanWoo on 2017/3/30.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYAccountModel;
@interface MYMineHeadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;

@property (nonatomic, strong) MYAccountModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
