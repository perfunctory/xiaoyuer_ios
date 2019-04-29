//
//  VerifyListRequest.h
//  XianjinXia
//
//  Created by sword on 10/02/2017.
//  Copyright © 2017 lxw. All rights reserved.
//

#import "BaseRequest.h"

@interface VerifyListRequest : BaseRequest

//获取认证列表信息
- (void)fetchUserVerifyListWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
/**
 * 紧急联系人获取
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */
- (void)getContactsListWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
//获取个人信息列表
- (void)fetchPersonalInformationWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

//获取加分认证信息
- (void)fetchAuthMoreInfoWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

/**
 * 保存紧急联系人
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */
- (void)SaveContactsWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

//保存加分认证信息
- (void)saveAuthMoreInfoWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

/**
 * 上传手机通讯录
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */
- (void)updateContactsWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

/**
 * 上传Face++图片
 *
 *  @param paramDict 参数字典
 *  @param imageData 文件内容
 *  @param fileName 文件名称
 *  @param key 文件对应key
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */
- (void)uploadFaceVerifyImageWithDictionary:(NSDictionary *)paramDict imageData:(NSData *)imageData fileName:(NSString *)fileName key:(NSString *)key success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

/**
 * 保存个人信息
 *
 *  @param suburl 服务器的相对地址
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */
- (void)savePersonmalInfoWithSuburl:(NSString *)suburl dictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
@end
