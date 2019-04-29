//
//  UserModel.h
//  MeiXiang
//
//  Created by FengDongsheng on 16/6/15.
//  Copyright © 2016年 FengDongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface UserModel : BaseModel

@property (nonatomic, copy) NSString *sessionid;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *realname;
@property (nonatomic, copy) NSString *real_pay_pwd_status;

@end
