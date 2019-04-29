//
//  HomeOnlySevenDayView.m
//  XianjinXia
//
//  Created by 杭州乌云网络科技有限公司 on 17/10/25.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "HomeOnlySevenDayView.h"

@implementation HomeOnlySevenDayView


- (void)drawRect:(CGRect)rect {
    // Drawing code
    
   // self.backgroundColor = [UIColor clearColor];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 3, 180, 30)];
    lab.text = @"借款期限（天）";
    [lab setFont:[UIFont systemFontOfSize:13]];
    lab.textColor = [UIColor lightGrayColor];
    UILabel * dayLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 3, 50, 25)];
    
    
    dayLab.text = @"7天";
    [dayLab setFont:[UIFont systemFontOfSize:14]];
    dayLab.textAlignment = NSTextAlignmentCenter;
    dayLab.textColor = Color_Red_New;
    dayLab.layer.borderWidth = 1.5;
    dayLab.layer.cornerRadius = 12;
    dayLab.layer.borderColor = Color_Red_New.CGColor;
    
    
    [self addSubview:lab];
    [self addSubview:dayLab];
    
}

@end
