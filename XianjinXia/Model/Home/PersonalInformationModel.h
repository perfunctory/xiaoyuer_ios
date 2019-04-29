//
//  PersonalInformationModel.h
//  XianjinXia
//
//  Created by sword on 2017/2/17.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseModel.h"

@interface PersonalInformationModel : BaseModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *id_number;
@property (strong, nonatomic) NSString *marriage;
@property (strong, nonatomic) NSString *degrees;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *address_distinct;
@property (strong, nonatomic) NSString *live_time_type;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSNumber *latitude;

@property (strong, nonatomic) NSString *qq;
@property (strong, nonatomic) NSString *email;

- (BOOL)informationIsComplete;

- (NSString *)lackOfInformationDescription;

@end
