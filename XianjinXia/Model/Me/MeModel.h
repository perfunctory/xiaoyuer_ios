//
//  MeModel.h
//  XianjinXia
//
//  Created by 刘燕鲁 on 2017/2/13.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseModel.h"

@interface CradInfoModel : BaseModel
@property (nonatomic, retain) NSString *bank_name;
@property (nonatomic, retain) NSString *card_no_end;

@end

@interface VerifyInfoModel : BaseModel
@property (nonatomic, retain) NSString *real_verify_status;
@property (nonatomic, retain) NSString *real_bind_bank_card_status;
@property (nonatomic, retain) NSString *real_pay_pwd_status;
@end

@interface CreditInfoModel : BaseModel
@property (nonatomic, retain) NSString *card_amount;
@property (nonatomic, retain) NSString *card_unused_amount;
@property (nonatomic, retain) NSString *card_used_amount;
@property (nonatomic, retain) NSString *card_title;
@property (nonatomic, retain) NSString *risk_status;
@property (nonatomic, retain) NSString *shop_url;
@end

@interface ServiceModel : BaseModel
@property (nonatomic, retain) NSString *qq_group;
@property (nonatomic, retain) NSString *service_phone;
@property (nonatomic, retain) NSString *holiday;
@property (nonatomic, retain) NSString *peacetime;
@property (nonatomic, retain) NSArray *services_qq;

@end

@interface MeModel : BaseModel

@property (nonatomic, retain) CradInfoModel *card_info;
@property (nonatomic, retain) VerifyInfoModel *verify_info;
@property (nonatomic, retain) CreditInfoModel *credit_info;
@property (nonatomic, retain) ServiceModel *service;
@property (nonatomic, retain) NSString *invite_code;
@property (nonatomic, retain) NSString *share_url;
@property (nonatomic, retain) NSString *share_body;
@property (nonatomic, retain) NSString *share_logo;
@property (nonatomic, retain) NSString *share_title;
@property (nonatomic, retain) NSString *card_url;
@property (nonatomic, retain) NSString *phone;
@end
