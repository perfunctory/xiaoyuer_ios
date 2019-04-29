//
//  SelectBankListModel.h
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/13.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseModel.h"

@interface BankList : BaseModel
@property (nonatomic, copy) NSString * bank_id;
@property (nonatomic, copy) NSString * bank_name;
@property (nonatomic, copy) NSString * url;
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)BankListWithDict:(NSDictionary *)dict;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end

@interface SelectBankListModel : BaseModel
@property (nonatomic, strong) NSMutableArray <BankList *> * item;
@property (nonatomic, copy) NSString                      * tips;
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)SelectBankListWithDict:(NSDictionary *)dict;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
