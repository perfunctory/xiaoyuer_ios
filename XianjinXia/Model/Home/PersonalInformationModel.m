//
//  PersonalInformationModel.m
//  XianjinXia
//
//  Created by sword on 2017/2/17.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "PersonalInformationModel.h"

@implementation PersonalInformationModel

- (BOOL)informationIsComplete {
    
    return 0 != self.address.length && 0 != self.address_distinct.length;
}

- (NSString *)lackOfInformationDescription {
    if (0 == self.address_distinct.length) {
        return @"请填写现居地址";
    }
    if (0 == self.address.length) {
        return @"请填写详细地址";
    }
    return @"信息不全，请完善信息";
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    
    return @{@"live_time_type" : @"live_period"};
}

@end
