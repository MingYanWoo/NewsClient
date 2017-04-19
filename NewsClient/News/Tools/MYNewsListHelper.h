//
//  MYNewsListHelper.h
//  NewsClient
//
//  Created by MingYanWoo on 2017/3/20.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MYNewsListHelper;
@class MYNewsModel;
@protocol MYNewsListHelperDelegate <NSObject>

- (void)helperSelectedNews:(MYNewsListHelper *)helper withNewsModel:(MYNewsModel *)model;

@end

@interface MYNewsListHelper : NSObject <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *newsArray;

@property (nonatomic, assign) int type;

@property (nonatomic, weak) id<MYNewsListHelperDelegate> delegate;

- (instancetype)initWithTableView:(UITableView *)tableView;

@end
