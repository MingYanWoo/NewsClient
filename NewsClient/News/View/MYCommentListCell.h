//
//  MYCommentListCell.h
//  NewsClient
//
//  Created by MingYanWoo on 2017/3/31.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYCommentModel;
@interface MYCommentListCell : UITableViewCell

@property (nonatomic, strong) MYCommentModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
