//
//  HomepageHeadView.h
//  XianjinXia
//
//  Created by sword on 2017/2/28.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeModel.h"

@interface ContentHeadView : UIView

@property (nonatomic, strong) HomeModel *entity;

@property (copy, nonatomic) void(^promoteCreditLineBlock)();
@property (copy, nonatomic) NSString *head_tip;
@property (copy, nonatomic) NSString *risk_status;//风控状态

@end
