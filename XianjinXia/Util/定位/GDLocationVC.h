//
//  GDLocationVCViewController.h
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/6.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "SecondLevelViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@class AMapPOI;
@class MAUserLocation;

@interface GDLocationVC : SecondLevelViewController

/**纬度*/
@property (nonatomic, assign) CGFloat latitude; //!< 纬度（垂直方向）
/**经度*/
@property (nonatomic, assign) CGFloat longitude; //!< 经度（水平方向）
/**用户选择回调*/
@property(nonatomic,copy) void(^address)(AMapPOI * model,MAUserLocation* Usermodel);

@end
