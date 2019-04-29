//
//  TipMessageModel.h
//  MeiXiang
//
//  Created by FengDongsheng on 16/6/19.
//  Copyright © 2016年 FengDongsheng. All rights reserved.
//

#import "BaseModel.h"

@interface TipMessageModel : BaseModel

@property (nonatomic, copy  ) NSString  *tipTitle;                      //提示
@property (nonatomic, copy  ) NSString  *tipSureButton;                 //确定
@property (nonatomic, copy  ) NSString  *tipCancelButton;               //取消
@property (nonatomic, copy  ) NSString  *tipRequestSending;             //正在发送请求

@property (nonatomic, copy  ) NSString  *tipQuitSending;                //正在安全退出
@property (nonatomic, copy  ) NSString  *tipLoginSending;               //正在登陆
@property (nonatomic, copy  ) NSString  *tipRegistSending;              //正在为您注册账户
@property (nonatomic, copy  ) NSString  *tipVerificationCodeSending;    //正在发送验证码
@property (nonatomic, copy  ) NSString  *tipVerificationCodeSuccess;    //发送验证码成功
@property (nonatomic, copy  ) NSString  *tipInputRightMobileNumber;     //请输入正确的手机号码

@property (nonatomic, copy  ) NSString  *errorMsg401;                   //登陆过期请重新登陆
@property (nonatomic, copy  ) NSString  *errorMsg40x;
@property (nonatomic, copy  ) NSString  *errorMsg50x;
@property (nonatomic, copy  ) NSString  *errorMsg30x;
@property (nonatomic, copy  ) NSString  *errorMsgNetworkUnavailable;    //网络连接不可用

@end
