//
//  ValidatorUtil.h
//  MLIPhone
//
//  Created by yakehuang on 14-7-10.
//
//

#import <Foundation/Foundation.h>

@interface ValidatorUtil : NSObject

+ (BOOL)validateByRegex:(NSString *)regex withObject:(id)object;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//验证密码是否符合规则
+ (BOOL)isLoginPassword:(NSString *)password;
+(BOOL)isRegisterKey:(NSString*)key;
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
//url是否有效
+ (BOOL) validateURL:(NSString *)url;
//判断邮箱是否合法
+ (BOOL)validateEmail:(NSString *)email;
@end
