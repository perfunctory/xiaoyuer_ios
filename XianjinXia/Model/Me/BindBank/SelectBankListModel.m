//
//  SelectBankListModel.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/13.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "SelectBankListModel.h"

@implementation BankList
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.bank_id = dict[@"bank_id"];
        self.bank_name = dict[@"bank_name"];
        self.url = dict[@"url"];
    }
    return self;
}

+ (instancetype)BankListWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

@end

@implementation SelectBankListModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.tips = dict[@"tips"];
        [self.item removeAllObjects];
        for (NSDictionary * tDict in dict[@"item"]) {
            BankList * model = [[BankList alloc] initWithDict:tDict];
            [self.item addObject:model];
        }
    }
    return self;
}

+ (instancetype)SelectBankListWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

- (NSArray<BankList *> *)item {
    if (!_item) {
        _item = [NSMutableArray arrayWithCapacity:0];
    }
    return _item;
}

@end
