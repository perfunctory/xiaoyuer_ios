//
//  MyHandle.m
//  XianjinXia
//
//  Created by 刘群 on 2018/9/28.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "MyHandle.h"

@implementation MyHandle
+(instancetype)shareHandle{
    
    static MyHandle *handle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [[MyHandle alloc]init];
    });
    return handle;
}
@end
