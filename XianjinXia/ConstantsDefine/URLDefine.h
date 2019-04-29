//
//  URLDefine.h
//  Demo
//
//  Created by FengDongsheng on 15/5/27.
//  Copyright (c) 2015年 FengDongsheng. All rights reserved.
//

#ifndef Demo_URLDefine_h
#define Demo_URLDefine_h

/***************************账户相关********************************/
//检查当前版本是否需要更新接口
#define kCheckVersion                           @"/versionsManagers/appVersionCheck"
//登录接口
#define kKDLoginKey                             @"/credit-user/login"
//退出登录接口
#define kKDLogoutKey                            @"/credit-user/logout"
//注册接口

#define kKDZhuceKey                             @"/credit-user/register"
//注册验证码
#define KUserRegGetCode                         @"/credit-user/reg-get-code"
//修改登录密码
#define kUserChangePwd                          @"/credit-user/change-pwd"
//找回密码获取验证码
#define kUserResetPwdCode                       @"/credit-user/reset-pwd-code"
//找回密码验证码
#define kUserVerifyResetPwdCode                 @"/credit-user/reset-pwd-code"
//找回密码验证个人信息
#define kUserVerifyResetPassword                @"/credit-user/verify-reset-password"
//找回登录密码设置新密码
#define kUserResetPassword                      @"/credit-user/reset-password"
//找回交易密码设置新密码
#define kUserResetPayPassword                   @"/credit-user/reset-pay-password"
//初次设置交易密码
#define kUserSetPaypassword                     @"/credit-user/set-paypassword"
//修改交易密码
#define kUserChangePaypassword                  @"/credit-user/change-paypassword"
//我的借款
#define kUserLoanGetMyOrders                    @"/credit-loan/get-my-orders"
//用户个人信息
#define kUserGetInfo                            @"/credit-user/get-info"
//意见反馈
#define kCreditInfoFeedback                     @"/credit-info/feedback"
/****************************首页**********************************/
//首页
#define kCreditAppIndex                         @"/credit-app/index"
//提额（首页接口跳转）
#define newKCreditAppIndex                      @"/credit-app/newIndex"
//费用详情
#define kCreditServiceCharge                    @"/credit-user/service-charge"
//费用详情
#define newkCreditServiceCharge                    @"/credit-user/v2/service-charge"
//老用户弹框
#define kOlduser                                @"/credit-app/old_user"
//首页弹框
#define kAds                                    @"/ad/getAd"
//个推id
#define CliendId                                 @"/userClient/saveUserClientInfo"
/***************************认证***********************************/
//认证列表
#define kCreditCardGetVerificationInfo          @"/credit-card/get-verification-info"
//获取个人信息
#define kCreditCardGetPersonInfo                @"/credit-card/get-person-info"
//保存个人信息
#define kCreditCardSavePersonInfo               @"/credit-card/get-person-infos"
//
#define kCreditInfoSavePersonInfo               @"/credit-info/save-person-info"
//获取工作信息
#define kCreditCardGetWorkInfo                  @"/credit-card/get-work-info"
//保存工作信息
#define kCreditCardSaveWorkInfo                 @"/credit-card/save-work-info"

//获取紧急联系人信息
#define kCreditCardGetContacts                  @"/credit-card/get-contacts"

//保存紧急联系人信息
#define kCreditCardSaveContacts                 @"/credit-card/v2/get-contactss"

//获取芝麻参数
#define kCreditZmMobileApi                      @"/creditreport/zm-mobile-api"
//上报芝麻返回信息---待定
#define kZmMobileResultSave                     @"creditZmMobileResultSave"
//上传通讯录
#define kInfoUpLoadContacts                     @"/credit-info/up-load-contacts"
//上报app信息
#define kReportKey                              @"/credit-app/device-report"

//查询加分认证信息
#define kCreditWebScoreAuth                     @"/credit-web/score-auth"
//保存加分认证信息
#define kCreditInfoSaveScoreAuth                @"/credit-info/save-score-auth"

/***************************支付宝爬虫******************************/
//上报支付宝爬虫信息(英科)
#define kZhifubaoUpKeyYK                        @"/credit-alipay/get-user-info"
//上报TaoBao宝爬虫信息(英科)
#define kTaobaoUpKeyYK                          @"/credit-taobao/get-user-info"
//照片
//获取照片列表
#define kPictureGetPicList                      @"/picture/get-pic-list"
//上传照片列表
#define kPictureUploadImage                     @"/picture/upload-image"
//获取银行卡列表
#define kCreditCardBankCardInfo                 @"/credit-card/bank-card-info"
//获取绑卡验证码
#define kCreditCardGetCode                      @"/credit-card/get-code"
//获取用户绑卡---待定
#define kCreditCardGetBankCard                  @"creditCardGetBankCard"
//绑卡
#define kCreditCardAddBankCard                  @"/credit-card/add-bank-card"
/***************************申请借钱*********************************/
//获取确认页面信息
#define kCreditLoanGetConfirmLoan               @"/credit-loan/get-confirm-loan"

//获取确认页面信息新街口(调额版)
#define newkCreditLoanGetConfirmLoan               @"/credit-loan/v2/get-confirm-loan"

//申请借款
#define kCreditLoanApplyLoan                    @"/credit-loan/apply-loan"
//申请借款新接口（调额版）
#define newkCreditLoanApplyLoan                    @"/credit-loan/v2/apply-loan"


//获取合同签名状态
#define kCreditLoanGetAgreementStatus           @"/credit-loan/query-cfca-status"
//确认失败记录
#define kCreditConfirmFailedLoan                @"/credit-loan/confirm-failed-loan"
/***************************还款************************************/
#define kUserLoan                               @"/credit-loan/get-my-loan"
/***************************上报用户位置信息**************************/
#define KUserLocation                           @"/credit-info/upload-location"
#define KUserAppInfo                            @"/credit-info/up-load-contents"
/***************************推广活动Url*******************************/
#define KHomeAward                              @"/jsaward/awardCenterWeb/drawAwardIndexList"
#define KDrawAwardList                          @"/jsaward/awardCenterWeb/userDrawAwardList"
#define kAwardDetail                            @"/jsaward/awardCenter/drawAwardIndex?clientType=ios&app=1"

/***************************设置*******************************/
#define KFeedBack                               @"/credit-info/feedback"
#define KModifyLoginPassWord                    @"/credit-user/change-pwd"
#define KModifyPayPassWord                      @"/credit-user/change-paypassword"
#define KForgetPassWord                         @"/credit-user/verify-reset-password"
#define KResetPwdCode                           @"/credit-user/reset-pwd-code"
#define KResetPassword                          @"/credit-user/reset-password"
#define KSetPaypassword                         @"/credit-user/set-paypassword"
#define KResetPwdCode                           @"/credit-user/reset-pwd-code"
#define KUserVerifyResetPassword                @"/credit-user/verify-reset-password"
#define KZFB                                    @"/credit-alipay/get-user-info"

#endif
