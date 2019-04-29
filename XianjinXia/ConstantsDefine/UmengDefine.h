//
//  UmengDefine.h
//  XianjinXia
//
//  Created by 童欣凯 on 2018/2/9.
//  Copyright © 2018年 lxw. All rights reserved.
//

#ifndef UmengDefine_h
#define UmengDefine_h

/***************************登录*******************************/
#define UmengEvent_Login_Sec                               @"Login_Sec" //登录
#define UmengEvent_ForgetPwd                               @"ForgetPwd" //忘记密码
#define UmengEvent_Register                                @"Register" //注册
#define UmengEvent_Login_First                             @"Login_First" //登录

/***************************借款*******************************/
#define UmengEvent_Home_ad                                 @"Home_ad"
#define UmengEvent_Home_ad_cancel                          @"Home_ad_cancel"
#define UmengEvent_Home                                    @"Home"//借款
#define UmengEvent_Home_Msg                                @"Home_Msg"//借款消息
#define UmengEvent_Home_Banner                             @"Home_Banner"//借款banner
#define UmengEvent_Home_Lend                               @"Home_Lend"//我要借款
#define UmengEvent_Lend_Increase_Limit_Auto                @"Lend_Increase_Limit_Auto"//提额自动跳转
#define UmengEvent_Lend_Increase_Limit_Click               @"Lend_Increase_Limit_Click"//提额手动跳转

/***************************认证中心*******************************/
#define UmengEvent_Ver                                     @"Ver"    //认证中心
#define UmengEvent_Ver_PersonInfo                          @"Ver_PersonInfo"   //个人信息
#define UmengEvent_Ver_WorkInfo                            @"Ver_WorkInfo"     //工作信息
#define UmengEvent_Ver_Contacts                            @"Ver_Contacts"
#define UmengEvent_Ver_mobile                              @"Ver_mobile"
#define UmengEvent_Ver_Other                               @"Ver_Other"
#define UmengEvent_Ver_Zfb                                 @"Ver_Zfb"
#define UmengEvent_Ver_ZM                                  @"Ver_ZM"
#define UmengEvent_Ver_Less                                @"Ver_Less"
#define UmengEvent_Ver_More                                @"Ver_More"
//tag=1 个人信息 tag=2 工作信息 tag=3 紧急联系人 tag=4收款信息 tag=5 手机运营商 tag=6 卡片等级 tag＝7 更多信息 tag=8 芝麻授信 tag=9 支付宝认证
/***************************还款*******************************/
#define UmengEvent_Repay                                   @"Repay"
#define UmengEvent_Repay_repay                             @"Repay_repay"
#define UmengEvent_Repay_help                              @"Repay_help"
#define UmengEvent_Repay_cellClick                         @"Repay_cellClick"
#define UmengEvent_Repay_Bank                              @"Repay_Bank"//银行卡还款
#define UmengEvent_Repay_More                              @"Repay_More"//更多还款方式

/***************************我的*******************************/
#define UmengEvent_Me                                      @"Me"
#define UmengEvent_Me_Setting                              @"Me_Setting"//设置
#define UmengEvent_Me_MoneyHelp                            @"Me_MoneyHelp"
#define UmengEvent_Me_material                             @"Me_material"//完善资料
#define UmengEvent_Me_Record                               @"Me_Record"//借款记录
#define UmengEvent_Me_Bank                                 @"Me_Bank"//收款银行卡
#define UmengEvent_Me_Share                                @"Me_Share"//推荐给好友
#define UmengEvent_Me_Message                              @"Me_Message"//消息中心
#define UmengEvent_Me_Help                                 @"Me_Help"//帮助中心
#define UmengEvent_Me_Contacts                             @"Me_Contacts"//联系客服
#define UmengEvent_Me_FeedBack                             @"Me_FeedBack"//意见反馈

#define UmengEvent_Lend_Btn_To_Verify                      @"lend_btn_to_verify" // 我要借款（未认证）
#define UmengEvent_Lend_Btn_To_Lend                        @"lend_btn_to_lend" //我要借款（已登录）
#define UmengEvent_Lend_Btn_To_Login                       @"lend_btn_to_login" //立即申请（未登录）
#define UmengEvent_Lend_Confirm                            @"lend_confirm" //确认申请
#define UmengEvent_Lend_Bank_No_Bind                       @"lend_bank_no_bind" //到账银行（未绑定银行卡）
#define UmengEvent_Lend_Bank_Bind                          @"lend_bank_bind" //到账银行（已绑定银行卡）
#define UmengEvent_Person_Info_Face                        @"person_info_face" //人脸识别
#define UmengEvent_Perfect_Information                     @"perfect_information" //完善资料
#define UmengEvent_Person_Info_Idcard_Front                @"person_info_idcard_front" //身份证识别正面
#define UmengEvent_Person_Info_Idcard_Back                 @"person_info_idcard_back" //身份证识别反面
#define UmengEvent_Contact_Relation_Family                 @"contact_relation_family" //与本人关系（直属亲属）
#define UmengEvent_Contact_Person_Family                   @"contact_person_family" //紧急联系人（直属亲属）
#define UmengEvent_Contact_Relation_Other                  @"contact_relation_other" //与本人关系（其他）
#define UmengEvent_Contact_Person_Other                    @"contact_person_other" //紧急联系人（其他）
#define UmengEvent_Auth_Taobao                             @"auth_taobao" //淘宝授信
#define UmengEvent_Phone                                   @"PHONE" //手机运营商
#define UmengEvent_Proceeds_Bank                           @"proceeds_bank" //收款银行卡
#define UmengEvent_Bank_Add                                @"bank_add" //添加银行卡
#define UmengEvent_Repayment                               @"repayment" //还款-tab
#define UmengEvent_My                                      @"my" //我的-tab
#define UmengEvent_Lend                                    @"lend" //借款

#endif /* UmengDefine_h */
