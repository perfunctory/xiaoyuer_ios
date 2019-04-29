//
//  RepaymentRecordModel.h
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/14.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseModel.h"

@interface RecordModel : BaseModel
@property (nonatomic, copy) NSString * text;
@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * url;
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)recordModelWithDict:(NSDictionary *)dict;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end

@interface RepaymentRecordModel : BaseModel
@property (nonatomic, strong) NSMutableArray    <RecordModel *> * item;
@property (nonatomic, copy) NSString                            * link_url;
@property (nonatomic, assign) NSInteger                           page;
@property (nonatomic, assign) NSInteger                           pageSize;
@property (nonatomic, assign) NSInteger                           pageTotal;
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)repaymentRecordWithDict:(NSDictionary *)dict;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
