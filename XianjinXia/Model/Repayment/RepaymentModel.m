//
//  RepaymentModel.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/8.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "RepaymentModel.h"

@implementation RepayAmountModel
+ (instancetype)repayAmountModelWithDict:(NSDictionary *)dict {
    RepayAmountModel * model = [[RepayAmountModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

- (BOOL)isEqualToRepayAmountModel:(RepayAmountModel *)model {
    if (!model) {
        return NO;
    }
    BOOL b1 = [self.debt isEqualToString:model.debt] || (!self.debt && !model.debt);
    BOOL b2 = [self.principal isEqualToString:model.principal] || (!self.principal && !model.principal);
    BOOL b3 = [self.counter_fee isEqualToString:model.counter_fee] || (!self.counter_fee && !model.counter_fee);
    BOOL b4 = [self.receipts isEqualToString:model.receipts] || (!self.receipts && !model.receipts);
    BOOL b5 = [[self.interests description] isEqualToString:[model.interests description]] || (![self.interests description] && ![model.interests description]);
    BOOL b6 = [self.late_fee isEqualToString:model.late_fee] || (!self.late_fee && !model.late_fee);
    BOOL b7 = [self.plan_fee_time isEqualToString:model.plan_fee_time] || (!self.plan_fee_time && !model.plan_fee_time);
    BOOL b8 = [self.text_tip isEqualToString:model.text_tip] || (!self.text_tip && !model.text_tip);
    BOOL b9 = [self.url isEqualToString:model.url] || (!self.url && !model.url);
    return b1 && b2 && b3 && b4 && b5 && b6 && b7 && b8 && b9;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}
@end

@implementation Reimbursement
+ (instancetype)reimbursmentWithDict:(NSDictionary *)dict {
    Reimbursement * model = [[Reimbursement alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

- (BOOL)isEqualToReimbursment:(Reimbursement *)model {
    if (!model) {
        return NO;
    }
    BOOL b1 = [self.img_url isEqualToString:model.img_url] || (!self.img_url && !model.img_url);
    BOOL b2 = [self.title isEqualToString:model.title] || (!self.title && !model.title);
    BOOL b3 = [self.link_url isEqualToString:model.link_url] || (!self.link_url && !model.link_url);
    BOOL b4 = [[self.type description] isEqualToString:[model.type description]] || (![self.type description] && ![model.type description]);
    return b1 && b2 && b3 && b4;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}
@end

@implementation RepaymentModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.pay_title = dict[@"pay_title"];
        self.old_path = dict[@"old_path"];
        self.count = [dict[@"count"] integerValue];
        [self.list removeAllObjects];
        for (NSDictionary * tDict in dict[@"list"]) {
            [self.list addObject:[RepayAmountModel repayAmountModelWithDict:tDict]];
        }
        [self.pay_type removeAllObjects];
        for (NSDictionary * tDict in dict[@"pay_type"]) {
            [self.pay_type addObject:[Reimbursement reimbursmentWithDict:tDict]];
        }
    }
    return self;
}

- (BOOL)isEqualToRepaymentModel:(RepaymentModel *)model {
    if (!model) {
        return NO;
    }
    BOOL haveEqualList = [self listIsEqualWithList:self.list withModelList:model.list] || (!self.list && !model.list);
    BOOL haveEqualPayTitle = [self.pay_title isEqualToString:model.pay_title] || (!self.pay_title && !model.pay_title);
    BOOL haveEqualOldPath = [self.old_path isEqualToString:model.old_path] || (!self.old_path && !model.old_path);
    BOOL haveEqualCount = self.count == model.count;
    BOOL haveEqualPayType = [self payTypeIsEqualWithList:self.pay_type withModelList:model.pay_type] || (!self.pay_type && !model.pay_type);//[self.pay_type isEqualToArray:model.pay_type];
    return haveEqualList && haveEqualCount && haveEqualOldPath && haveEqualPayType && haveEqualPayTitle;
}

- (BOOL)listIsEqualWithList:(NSArray *)list withModelList:(NSArray *)modelList {
    BOOL bol = false;
    if (list.count == modelList.count) {
        bol = true;
        for (int i = 0; i < list.count; i++) {
            RepayAmountModel * model1 = list[i];
            RepayAmountModel * model2 = modelList[i];
            if (![model1 isEqualToRepayAmountModel:model2]) {
                bol = false;
                break;
            }
        }
    }
    return bol;
}

- (BOOL)payTypeIsEqualWithList:(NSArray *)payType withModelList:(NSArray *)modelPayType {
    BOOL bol = false;
    if (payType.count == modelPayType.count) {
        bol = true;
        for (int i = 0; i < payType.count; i++) {
            Reimbursement * model1 = payType[i];
            Reimbursement * model2 = modelPayType[i];
            if (![model1 isEqualToReimbursment:model2]) {
                bol = false;
                break;
            }
        }
    }
    return bol;
}

+ (instancetype)RepayListWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

- (NSMutableArray<RepayAmountModel *> *)list {
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (NSMutableArray<Reimbursement *> *)pay_type {
    if (!_pay_type) {
        _pay_type = [NSMutableArray array];
    }
    return _pay_type;
}

@end
