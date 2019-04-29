//
//  HomeActivityCell.h
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/7.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WIDTH_HEIGHT_RADIUS (75.0/34)

@interface HomeActivityCell : UITableViewCell

@property (strong, nonatomic) UIButton *apactivityImage;
@property (assign, nonatomic) CGFloat bottomCon;

@property (copy, nonatomic) void(^clickImageBlock)();

@end
