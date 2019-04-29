//
//  ContactsModel.h
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/16.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseModel.h"

@interface listModel : BaseModel
@property (nonatomic, copy) NSString    * name;
@property (nonatomic, copy) NSString    * type;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)listWithDict:(NSDictionary *)dict;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end

@interface ContactsModel : BaseModel
@property (nonatomic, copy) NSString    * lineal_mobile;
@property (nonatomic, copy) NSString    * other_mobile;
@property (nonatomic, copy) NSString    * lineal_name;
@property (nonatomic, copy) NSString    * other_name;
@property (nonatomic, copy) NSString    * lineal_relation;
@property (nonatomic, copy) NSString    * other_relation;
@property (nonatomic, strong) NSMutableArray    <listModel *>* lineal_list;
@property (nonatomic, strong) NSMutableArray    <listModel *>* other_list;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)contactsWithDict:(NSDictionary *)dict;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
