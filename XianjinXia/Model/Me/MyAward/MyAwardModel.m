//
//  MyAwardModel.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "MyAwardModel.h"

@implementation MyAwardDetailModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.awardId = dict[@"awardId"];
        self.periods = dict[@"periods"];
        self.awardMoney = dict[@"awardMoney"];
        self.status = dict[@"status"];
        self.userId = dict[@"userId"];
        self.luckyDraw = dict[@"luckyDraw"];
//        self.addTime = dict[@"addTime"];
        self.stepName = dict[@"stepName"];
    }
    return self;
}

+ (instancetype)AwardListWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
@end

@implementation MyAwardModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self.item removeAllObjects];
        for (NSDictionary * tDict in dict) {
            [self.item addObject:[MyAwardDetailModel AwardListWithDict:tDict]];
        }
    }
    return self;
}

+ (instancetype)AwardListWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

- (NSArray<MyAwardDetailModel *> *)item {
    if (!_item) {
        _item = [NSMutableArray arrayWithCapacity:0];
    }
    return _item;
}

@end
