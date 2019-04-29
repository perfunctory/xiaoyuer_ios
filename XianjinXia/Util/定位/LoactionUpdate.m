//
//  LoactionUpdate.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/15.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "LoactionUpdate.h"
#import "GDLocationManager.h"

@interface LoactionUpdate ()
@property (nonatomic, retain) NSTimer *timer;
@end

@implementation LoactionUpdate
+ (instancetype)shareInstance
{
    static dispatch_once_t predicate;
    static LoactionUpdate *manager = nil;
    dispatch_once(&predicate, ^{
        manager = [[LoactionUpdate alloc]init];
    });
    return manager;
}

-(void)startLocationHandle:(int)iTime{//按照分钟来
    _timer = [NSTimer scheduledTimerWithTimeInterval:iTime*60 target:self selector:@selector(timeClick) userInfo:nil repeats:YES];
}

-(void)timeClick{
    [[GDLocationManager shareInstance] startLocation];//30分钟之后上传数据
}
@end
