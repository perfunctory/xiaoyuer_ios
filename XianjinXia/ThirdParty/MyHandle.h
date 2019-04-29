//
//  MyHandle.h
//  XianjinXia
//
//  Created by 刘群 on 2018/9/28.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyHandle : NSObject
@property (nonatomic,assign) NSInteger showTag; //是否显示首页公司名称  0：不显示  1：显示
@property (nonnull,copy) NSString *clientId;
+(instancetype)shareHandle;
@end
