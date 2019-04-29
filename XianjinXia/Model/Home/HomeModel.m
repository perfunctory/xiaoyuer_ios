//
//  HomeModel.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/7.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeBorrowStateModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        _title = dict[@"title"];
        _body = dict[@"body"];
        _tag = dict[@"tag"];
    }
    return self;
}
+ (instancetype)homeBorrowStateWithDict:(NSDictionary *)dict{
    
    return [[[self class] alloc] initWithDict:dict];
}

@end

@implementation HomeButtonModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        _msg = dict[@"msg"];
        _ids = dict[@"id"];
    }
    return self;
}
+ (instancetype)homeButtonModelWithDict:(NSDictionary *)dict {
    
    return [[[self class] alloc] initWithDict:dict];
}

@end

@implementation HomeBorrowStateListModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        _header_tip = dict[@"header_tip"];
        _button = [HomeButtonModel homeButtonModelWithDict:dict[@"button"]];
        _lists = [self createListWithArray:dict[@"lists"]];
        _loanEndTime = dict[@"loanEndTime"];
        _lastRepaymentD = dict[@"lastRepaymentD"];
    }
    return self;
}
+ (instancetype)homeBorrowStateListWithDict:(NSDictionary *)dict {
    
    return [[[self class] alloc] initWithDict:dict];
}

- (NSArray *)createListWithArray:(NSArray *)arr {
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSDictionary *dic in arr) {
        [result addObject:[HomeBorrowStateModel homeBorrowStateWithDict:dic]];
    }
    
    return result;
}

@end

@implementation AmountInfoModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.amounts = dict[@"amount_free"];
//        self.days = dict[@"days"];
        self.days = @[dict[@"day"]];
//        self.interests = dict[@"accrual"];
//        self.enquiryFee = dict[@"creditVet"];
//        self.managementFee = dict[@"accountManage"];

        //新添加参数
//        self.accountManage = dict[@"accountManage"];
//        self.accrual = dict[@"accrual"];
//        self.creditVet = dict[@"creditVet"];
//        self.collectionChannel = dict[@"collectionChannel"];
//        self.platformUse = dict[@"platformUse"];
    }
    return self;
}

+ (instancetype)DayListWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end

@implementation ItemModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.card_amount        = dict[@"card_amount"];
        self.card_title         = dict[@"card_title"];
        self.card_verify_step   = dict[@"card_verify_step"];
        self.verify_loan_nums   = dict[@"verify_loan_nums"];
        self.verify_loan_pass   = dict[@"verify_loan_pass"];
        self.next_loan_day      = dict[@"next_loan_day"];
        self.risk_status        = dict[@"risk_status"];

    }
    return self;
}

+ (instancetype)itemWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end

@implementation ActivityModel
+ (instancetype)imageModelWithDict:(NSDictionary *)dict {
    ActivityModel * model = [[self alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}
@end

@implementation HomeModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        
        self.amountInfo = [[AmountInfoModel alloc] initWithDict:dict[@"amount_days_list"][0]];
        self.item = [[ItemModel alloc] initWithDict:dict[@"item"]];
        self.today_last_amount = dict[@"today_last_amount"];
        self.user_loan_log_list = dict[@"user_loan_log_list"];
        self.borrowStateList = [HomeBorrowStateListModel homeBorrowStateListWithDict:dict[@"item"][@"loan_infos"]];

        [self.activities removeAllObjects];
        for (NSDictionary * tDict in dict[@"index_images"]) {
            [self.activities addObject:[ActivityModel imageModelWithDict:tDict]];
        }
    }
    return self;
}

+ (instancetype)DayListWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict];
}

- (NSMutableArray<ActivityModel *> *)activities {
    
    if (!_activities) {
        _activities = [NSMutableArray array];
    }
    return _activities;
}
@end
