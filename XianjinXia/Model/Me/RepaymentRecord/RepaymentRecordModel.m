//
//  RepaymentRecordModel.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/14.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "RepaymentRecordModel.h"

@implementation RecordModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.text = dict[@"text"];
        self.time = dict[@"time"];
        self.title = dict[@"title"];
        self.url = dict[@"url"];
    }
    return self;
}

+ (instancetype)recordModelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

@end

@implementation RepaymentRecordModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self.item removeAllObjects];
        for (NSDictionary * tDict in dict[@"item"]) {
            RecordModel * model = [[RecordModel alloc] initWithDict:tDict];
            [self.item addObject:model];
        }
        self.link_url = dict[@"link_url"];
        self.page = [dict[@"page"] integerValue];
        self.pageSize = [dict[@"pageSize"] integerValue];
        self.pageTotal = ceil([dict[@"pageTotal"] integerValue] / 15);
    }
    return self;
}

+ (instancetype)repaymentRecordWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

- (NSMutableArray<RecordModel *> *)item {
    if (!_item) {
        _item = [NSMutableArray arrayWithCapacity:0];
    }
    return _item;
}

@end
