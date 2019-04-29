//
//  UserManager.m
//  EveryDay
//
//  Created by FengDongsheng on 15/6/25.
//  Copyright (c) 2015年 FengDongsheng. All rights reserved.
//

#import "UserManager.h"
#import "LoginVC.h"
#import <objc/runtime.h>
#import "DSUtils.h"
#import <YYModel/YYModel.h>
#import "NSObject+InitWithDictionary.h"

//#import "UserOperateRequest.h"
#define USER_MANAGER    @"user_manager"

@implementation UserManager
@synthesize countDownStateOfLoan = _countDownStateOfLoan;

+ (UserManager*)sharedUserManager{
    static UserManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UserManager alloc] init];
        [manager initUser];
    });
    return manager;
}

- (void)initUser{
    
    UserModel *info = [UserModel yy_modelWithDictionary:[UserDefaults objectForKey:USER_MANAGER]];
    self.userInfo = info;
    _countDownStateOfLoan = [UserDefaults boolForKey:DSStringValue(self.userInfo.username)];
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int count = 0;
    Ivar *vars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = vars[i];
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    free(vars);
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    unsigned int count = 0;
    if (self = [super init]) {
        Ivar *vars = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i++) {
            Ivar var = vars[i];
            const char *name = ivar_getName(var);
            //归档
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(vars);
    }
    return self;
}

- (BOOL)checkLogin:(UIViewController *)viewController{
    NSString *sessionid = DSStringValue([UserDefaults objectForKey:@"sessionid"]);
    if (sessionid.length == 0) {
        if (![[DSUtils obtainTopViewController] isKindOfClass:[LoginVC class]]){
            LoginVC *vcLogin = [[LoginVC alloc] init];
            UINavigationController *vcNavigation = [[UINavigationController alloc] initWithRootViewController:vcLogin];
            [viewController presentViewController:vcNavigation animated:YES completion:nil];
        }
        return NO;
    }
    return YES;
}

- (BOOL)isLogin{
    NSString *sessionid = DSStringValue([UserDefaults objectForKey:@"sessionid"]);
    if (sessionid.length > 0) {
        return YES;
    }
    return NO;
}

- (void)showLoginPage:(UIViewController *)viewController{
    if (![[DSUtils obtainTopViewController] isKindOfClass:[LoginVC class]]){
        LoginVC *vcLogin = [[LoginVC alloc] init];
        UINavigationController *vcNavigation = [[UINavigationController alloc] initWithRootViewController:vcLogin];
        [viewController presentViewController:vcNavigation animated:YES completion:nil];
    }
}

- (void)checkSetPhone:(UIViewController *)viewController{
    
}

//退出登录
- (void)logout{
//    MyFundRequest * request = [[MyFundRequest alloc] init];
//    if ([UserDefaults objectForKey:@"fundSessionId"]) {
//        [request fundLogoutWitDict:nil onSuccess:^(NSDictionary *resultDic) {
//            
//        } andFailed:^(NSInteger code, NSString *errorMsg) {
//            
//        }];
//    }
    [UserDefaults setObject:@"" forKey:@"sessionid"];
    [UserDefaults setObject:@"" forKey:@"token"];
    [UserDefaults setObject:@{} forKey:USER_MANAGER];
    [UserDefaults setObject:@"" forKey:@"username"];

//    [UserDefaults setObject:@[] forKey:@"contacts"];
    [UserDefaults synchronize];
}

//登录
- (void)updateUserInfo:(NSDictionary *)uInfo{
    self.userInfo = [UserModel yy_modelWithDictionary:uInfo];
    _countDownStateOfLoan = [UserDefaults boolForKey:DSStringValue(self.userInfo.username)];
    [UserDefaults setObject:uInfo forKey:USER_MANAGER];
    [UserDefaults setObject:self.userInfo.sessionid forKey:@"sessionid"];
    [UserDefaults setObject:[uInfo objectForKey:@"token"] forKey:@"token"];
    [UserDefaults setObject:[uInfo objectForKey:@"username"] forKey:@"username"];

    [UserDefaults synchronize];
}

//获取用户信息
- (void)getUserInfoSuccess:(void(^)(UserModel* userInfo))successCb andFailed:(void(^)(NSInteger code, NSString *errorMsg))failCb{
//    UserOperateRequest *requestUserOperate = [[UserOperateRequest alloc] init];
//    [requestUserOperate getUserInfoWithDict:@{} onSuccess:^(NSDictionary *dictResult) {
//        [self updateUserInfo:dictResult];
//        successCb(self.userInfo);
//    } andFailed:^(NSInteger code, NSString *errorMsg) {
//        failCb(code, errorMsg);
//    }];
}

- (void)getUserRongyunTokenSuccess:(void(^)(NSString* rongyunToken))successCb andFailed:(void(^)(NSInteger code, NSString *errorMsg))failCb{
//    UserOperateRequest *requestUserOperate = [[UserOperateRequest alloc] init];
//    [requestUserOperate getUserRongyunTokenWithDict:@{} onSuccess:^(NSDictionary *dictResult) {
//        successCb(DSStringValue(dictResult[@"token"]));
//    } andFailed:^(NSInteger code, NSString *errorMsg) {
//        failCb(code, errorMsg);
//    }];
}

- (void)updatePayPassWordtatus:(NSInteger)status
{
    
    self.real_pay_pwd_status = status;
    _userInfo.real_pay_pwd_status = [NSString stringWithFormat:@"%ld",(long)status];
    NSDictionary *dict = [self getDictionaryData:_userInfo];
    [UserDefaults setObject:dict forKey:USER_MANAGER];
}

- (void)setCountDownStateOfLoan:(BOOL)countDownStateOfLoan {
    _countDownStateOfLoan = countDownStateOfLoan;
    
    [UserDefaults setBool:countDownStateOfLoan forKey:DSStringValue(self.userInfo.username)];
    [UserDefaults synchronize];
}

@end
