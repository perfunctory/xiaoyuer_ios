//
//  WorkInfoModel.h
//  XianjinXia
//
//  Created by 刘燕鲁 on 2017/2/16.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseModel.h"


//入职时长
@interface WorkTimeModel : BaseModel

@property (nonatomic, retain) NSString *entry_time_type;
@property (nonatomic, retain) NSString *name;

@end

@interface WorkInfoModel : BaseModel

@property (nonatomic, retain) NSString *company_name;
@property (nonatomic, retain) NSString *company_post;
@property (nonatomic, retain) NSString *company_address;
@property (nonatomic, retain) NSString *company_address_distinct;
@property (nonatomic, retain) NSString *work_address;
@property (nonatomic, retain) NSString *company_phone;
@property (nonatomic, retain) NSString *company_period;
@property (nonatomic, retain) NSString *company_salary;
@property (nonatomic, retain) NSString *company_picture;
@property (nonatomic, retain) NSArray<WorkTimeModel *> *company_period_list;

@end
