//
//  RepaymentModel.h
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/8.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseModel.h"

@interface RepayAmountModel : BaseModel
@property (nonatomic, copy) NSString * debt;
@property (nonatomic, copy) NSString * principal;
@property (nonatomic, copy) NSString * counter_fee;
@property (nonatomic, copy) NSString * receipts;
@property (nonatomic, copy) NSString * interests;
@property (nonatomic, copy) NSString * late_fee;
@property (nonatomic, copy) NSString * plan_fee_time;
@property (nonatomic, copy) NSString * text_tip;
@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString * status;

+ (instancetype)repayAmountModelWithDict:(NSDictionary *)dict;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
- (BOOL)isEqualToRepayAmountModel:(RepayAmountModel *)model;
@end

@interface Reimbursement : BaseModel
/**图片*/
@property (nonatomic ,copy) NSString * img_url;
/**说明文字*/
@property (nonatomic ,copy) NSString * title;
/**头部说明文字*/
@property (nonatomic ,copy) NSString * link_url;
@property (nonatomic, copy) NSString * type;

+ (instancetype)reimbursmentWithDict:(NSDictionary *)dict;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
- (BOOL)isEqualToReimbursment:(Reimbursement * )model;
@end

@interface RepaymentModel : BaseModel
@property (nonatomic, strong) NSMutableArray   <RepayAmountModel *> *list;
@property (nonatomic, strong) NSMutableArray   <Reimbursement *> *pay_type;
@property (nonatomic, copy) NSString    * pay_title;
@property (nonatomic, copy) NSString    * old_path;
@property (nonatomic, assign) NSInteger  count;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)RepayListWithDict:(NSDictionary *)dict;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
- (BOOL)isEqualToRepaymentModel:(RepaymentModel *)model;
@end
