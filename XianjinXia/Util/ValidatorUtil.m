//
//  ValidatorUtil.m
//  MLIPhone
//
//  Created by yakehuang on 14-7-10.
//
//

#import "ValidatorUtil.h"

@implementation ValidatorUtil

+ (BOOL)validateByRegex:(NSString *)regex withObject:(id)object
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES% @", regex];
    return [predicate evaluateWithObject:object];
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length == 11) {
        return YES;
    }
    return NO;
    /**
	 * 借用手机充值的接口～～
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188
     147,178,170
     * 联通：130,131,132,155,156,185,186,145,176
     * 电信：133,1349,153,180,189,181,177
     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-9]|8[0-9])\\d{8}$";
//    NSString * MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[06-8]|8[0-9])\\d{8}$";
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12         */
//    NSString * CM =@"^1(34[0-8]|(3[5-9]|47|5[0-27-9]|78|8[2-478])[0-9])[0-9]{7}$";
//    // @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186,145,176
//     17         */
////    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    NSString * CU = @"^1(3[0-2]|45|5[56]|76|8[56])\\d{8}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,189,181,177
//     22         */
////    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
//    NSString * CT = @"^1(349|(33|53|77|8[019])\\d)\\d{7}$";
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    
//    if (([regextestmobile evaluateWithObject:mobileNum])
//        || ([regextestcm evaluateWithObject:mobileNum])
//        || ([regextestct evaluateWithObject:mobileNum])
//        || ([regextestcu evaluateWithObject:mobileNum]))
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
}

//
+(BOOL)isRegisterKey:(NSString*)key
{
    NSString * KEYVALUE = @"^(?![^a-zA-Z]+$)(?!\\D+$).{6,16}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", KEYVALUE];
    if ([regextestmobile evaluateWithObject:key]) {
        return YES;
    }
    return NO;
}
//判断密码是否符合规则
+ (BOOL)isLoginPassword:(NSString *)password{
    
    return true;
}

//身份证号
+ (BOOL)validateIdentityCard:(NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//url
+ (BOOL)validateURL:(NSString *)url
{
    BOOL flag;
    if (url.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"[a-zA-z]+://[^\\s]*";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:url];
}

+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
@end
