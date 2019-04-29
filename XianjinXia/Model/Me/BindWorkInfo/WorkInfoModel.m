//
//  WorkInfoModel.m
//  XianjinXia
//
//  Created by 刘燕鲁 on 2017/2/16.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "WorkInfoModel.h"

@implementation WorkInfoModel

- (Class)getClass:(NSString *)keyName
{
    if ([keyName isEqualToString:@"company_period_list"]) {
        return [WorkTimeModel class];
    }
    return nil;
}
@end

@implementation WorkTimeModel

@end
