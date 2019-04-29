//
//  MyAwardModel.h
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseModel.h"

@interface MyAwardDetailModel : BaseModel
@property (nonatomic, copy) NSString        *awardId;
@property (nonatomic, copy) NSString        *periods;
@property (nonatomic, copy) NSString        *awardMoney;
@property (nonatomic, copy) NSString        *status;
@property (nonatomic, copy) NSString        *userId;
@property (nonatomic, copy) NSString        *luckyDraw;
@property (nonatomic, copy) NSDictionary    *addTime;
@property (nonatomic, copy) NSString        *stepName;
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)AwardListWithDict:(NSDictionary *)dict;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end

@interface MyAwardModel : BaseModel
@property (nonatomic, strong) NSMutableArray       <MyAwardDetailModel *>*item;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)AwardListWithDict:(NSDictionary *)dict;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
