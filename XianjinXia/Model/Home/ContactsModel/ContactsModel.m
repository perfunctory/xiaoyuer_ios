//
//  ContactsModel.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/16.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "ContactsModel.h"

@implementation listModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.type = dict[@"type"];
        self.name = dict[@"name"];
    }
    return self;
}

+ (instancetype)listWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

@end

@implementation ContactsModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.lineal_name = dict[@"lineal_name"];
        self.lineal_relation = dict[@"lineal_relation"];
        self.other_name = dict[@"other_name"];
        self.other_relation = dict[@"other_relation"];
        self.lineal_mobile = dict[@"lineal_mobile"];
        self.other_mobile = dict[@"other_mobile"];
        [self.lineal_list removeAllObjects];
        for (NSDictionary * tDict in dict[@"lineal_list"]) {
            [self.lineal_list addObject:[[listModel alloc] initWithDict:tDict]];
        }
        [self.other_list removeAllObjects];
        for (NSDictionary * tDict in dict[@"other_list"]) {
            [self.other_list addObject:[[listModel alloc] initWithDict:tDict]];
        }
    }
    return self;
}

+ (instancetype)contactsWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {};

- (NSMutableArray<listModel *> *)other_list {
    if (!_other_list) {
        _other_list = [NSMutableArray arrayWithCapacity:0];
    }
    return _other_list;
}

- (NSMutableArray<listModel *> *)lineal_list {
    if (!_lineal_list) {
        _lineal_list = [NSMutableArray arrayWithCapacity:0];
    }
    return _lineal_list;
}

@end
