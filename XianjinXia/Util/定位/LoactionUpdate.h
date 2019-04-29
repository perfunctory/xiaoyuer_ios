//
//  LoactionUpdate.h
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/15.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoactionUpdate : NSObject
+(instancetype) shareInstance;

-(void)startLocationHandle:(int)iTime;

@end
