//
//  MYNewsListCell.h
//  NewsClient
//
//  Created by MingYanWoo on 2017/3/19.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYNewsModel;
@interface MYNewsListCell : UITableViewCell

@property (nonatomic, strong) MYNewsModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
