//
//  MYCommentModel.m
//  NewsClient
//
//  Created by MingYanWoo on 2017/4/1.
//  Copyright © 2017年 MingYan. All rights reserved.
//

#import "MYCommentModel.h"

@implementation MYCommentModel

- (void)setComment_time:(NSString *)comment_time
{
    NSString *time = comment_time;
    //创建日期格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    //创建了两个日期对象
    NSDate *date1 = [dateFormatter dateFromString:time];
    NSDate *date2 = [NSDate date];
    
    //取两个日期对象的时间间隔：
    NSTimeInterval timeInterval = [date2 timeIntervalSinceDate:date1];
    
    int days = ((int)timeInterval)/(3600*24);
    int hours = ((int)timeInterval)/3600;
    int mins = ((int)timeInterval)/60;
    
    if (days > 0) {
        //大于1天，返回日期
        _comment_time = [comment_time substringWithRange:NSMakeRange(0, comment_time.length-3)];
        return;
    }else if (hours > 0) {
        //大于1小时，返回几小时前
        _comment_time = [NSString stringWithFormat:@"%d小时前", hours];
        return;
    }else if (mins > 0) {
        //大于1分钟，返回几分钟前
        _comment_time = [NSString stringWithFormat:@"%d分钟前", mins];
        return;
    }else {
        //小于1分钟，返回刚刚
        _comment_time = @"刚刚";
        return;
    }
}

@end
