//
//  BaseRequest.m
//  Demo
//
//  Created by FengDongsheng on 15/5/29.
//  Copyright (c) 2015年 FengDongsheng. All rights reserved.
//

#import "BaseRequest.h"
#import "AFNetworking.h"
#import "DSNetWorkStatus.h"
#import "DSUtils.h"
#import "NSDictionary+JsonFile.h"
#import "UserManager.h"
#import "DSUtils.h"
#import "NSString+Url.h"
#import "DXAlertView.h"
#import "UserManager.h"

@interface AFHTTPSessionManager (ShareManagerForPreventLeaks)

+ (instancetype)shareManager;

@end

@implementation AFHTTPSessionManager(ShareManagerForPreventLeaks)

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    static AFHTTPSessionManager *result;
    dispatch_once(&onceToken, ^{
        result = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return result;
}

@end

@implementation BaseRequest

//在url后面拼接版本号等信息
- (NSString *)handleUrlWithParamWithStr:(NSString *)str {
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:@"mld" forKey:@"appName"];
    [dataDic setObject:@"ios" forKey:@"clientType"];
    [dataDic setObject:CurrentAppVersion forKey:@"appVersion"];
    [dataDic setObject:[DSUtils getUUIDString] forKey:@"deviceId"];
    [dataDic setValue:DSStringValue([UserManager sharedUserManager].userInfo.username) forKey:@"mobilePhone"];
    return [NSString addQueryStringToUrl:str params:dataDic];
}

- (void)doHttpWithUrl:(NSString *)url andMetohd:(NSString *)method andParameters:(NSDictionary *)parameters andHeaders:(NSDictionary *)headers withSuccessHandler:(successHandler)successHandler andFailHandler:(failHandler)failHandler{
    url = [self handleUrlWithParamWithStr:url];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([DSNetWorkStatus sharedNetWorkStatus].netWorkStatus == NotReachable) {
        failHandler(nil,-200,[TipMessage shared].tipMessage.errorMsgNetworkUnavailable);
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager shareManager];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    for (NSString*key in headers) {
        [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
    }
    NSString *userJsessionid = [UserDefaults objectForKey:@"sessionid"];
    NSString *userToken = [UserDefaults objectForKey:@"token"];
    if (userJsessionid.length!=0) {
        [manager.requestSerializer setValue:userJsessionid forHTTPHeaderField:@"sessionid"];
    }
    if (userToken.length!=0) {
        [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"token"];
    }
    [manager.requestSerializer setValue:[DSUtils getUUIDString] forHTTPHeaderField:@"deviceId"];
    [manager.requestSerializer setValue:[DSUtils generateRandomStringWithLength:10] forHTTPHeaderField:@"randomCode"];
    [manager.requestSerializer setValue:@"iOSApp" forHTTPHeaderField:@"Request-From"];
    [manager.requestSerializer requestWithMethod:[method uppercaseString] URLString:url parameters:parameters error:nil];
    void(^af_success_cb)() = ^(NSHTTPURLResponse *response, id responseObject) {
        NSDictionary * dict = responseObject;
        if ([[dict[@"code"] description] isEqualToString:@"-3"]) {
            DXAlertView * alertV = [[DXAlertView alloc] initTitleTime:[dict[@"time"] description]];
            [alertV show];
            successHandler(@{@"data":@"",@"message":@""}, response.statusCode);
        }else{
            if ([[dict[@"code"] description] isEqualToString:@"-2"]) {
                [[UserManager sharedUserManager] logout];
            }
            successHandler(responseObject,response.statusCode);
        }
        
    };
    void(^af_error_cb)(NSHTTPURLResponse *response, NSError *error) = ^(NSHTTPURLResponse *response, NSError *error) {
        
        NSString *strErrorMsg;
        if (response.statusCode == 401) {
            [[UserManager sharedUserManager] logout];
            strErrorMsg = [TipMessage shared].tipMessage.errorMsg401;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNeedLogin object:nil];
        } else if (response.statusCode/100 == 5) {
            strErrorMsg = [TipMessage shared].tipMessage.errorMsg50x;
        } else if (response.statusCode/100 == 3) {
            strErrorMsg = [TipMessage shared].tipMessage.errorMsg30x;
        } else {
            strErrorMsg = [error localizedDescription];
        }
        failHandler(error,response.statusCode,strErrorMsg);
    };
    
    if ([[method lowercaseString] isEqualToString:@"get"]) {
        [manager GET:url parameters:parameters progress:^(NSProgress *downloadProgress) {
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            af_success_cb((NSHTTPURLResponse*)task.response,responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            af_error_cb((NSHTTPURLResponse*)task.response,error);
        }];
    } else if ([[method lowercaseString] isEqual:@"post"]) {
        [manager POST:url parameters:parameters progress:^(NSProgress *uploadProgress) {
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            af_success_cb((NSHTTPURLResponse*)task.response,responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            af_error_cb((NSHTTPURLResponse*)task.response,error);
        }];
    }
}

- (void)upLoadFileWithUrl:(NSString*)url filePath:(NSString*)path fileName:(NSString*)fileName mimeType:(NSString*)mimeType withPorcessingHandler:(uploadingHandler)uploadingHandler withCompleteHandler:(uploadCompleteHandler)completeHandler withErrorHandler:(uploadErrorHandler)errHandler{
    if ([DSNetWorkStatus sharedNetWorkStatus].netWorkStatus == NotReachable) {
        errHandler([NSError errorWithDomain:[TipMessage shared].tipMessage.errorMsgNetworkUnavailable code:-200 userInfo:nil]);
        return;
    }
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:@"attachment" fileName:fileName mimeType:mimeType error:nil];
    } error:nil];
    
    NSString *userToken = [UserDefaults objectForKey:@"sessionid"];
    if (userToken.length!=0) {
        [request setValue:userToken forHTTPHeaderField:@"sessionid"];
    }
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nullable uploadProgress){
        dispatch_async(dispatch_get_main_queue(), ^{
            uploadingHandler(uploadProgress.fractionCompleted);
        });
    }
    completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            errHandler(error);
        } else {
            completeHandler(responseObject);
        }
    }];
    [uploadTask resume];
}

- (void)upLoadFileWithUrl:(NSString*)url dicParama:(NSDictionary *)dicPara fileArr:(NSArray *)arrFile name:(NSString*)name fileName:(NSString*)fileName mimeType:(NSString*)mimeType withPorcessingHandler:(uploadingHandler)uploadingHandler withCompleteHandler:(uploadCompleteHandler)completeHandler withErrorHandler:(uploadErrorHandler)errHandler{
    if ([DSNetWorkStatus sharedNetWorkStatus].netWorkStatus == NotReachable) {
        errHandler([NSError errorWithDomain:[TipMessage shared].tipMessage.errorMsgNetworkUnavailable code:-200 userInfo:nil]);
        return;
    }
    
     NSString *strUrl = [self handleUrlWithParamWithStr:url];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:strUrl parameters:dicPara constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        int i = 0;
        for (UIImage *imvPhoto in arrFile) {
            
            
            NSString *imvNames = [NSString stringWithFormat:@"%@%i",name,i];
            [MXTool saveImageWithName:imvNames andImage:[MXTool compressImage:imvPhoto toTargetsize:SCREEN_WIDTH*1.5]];
            
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:[MXTool  generateImagePathwithName:imvNames]] name:name fileName:fileName mimeType:mimeType error:nil];
            

            
//            [formData appendPartWithFileData:UIImageJPEGRepresentation(imvPhoto, 0.5) name:name fileName:fileName mimeType:mimeType];
            i ++;
        }
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nullable uploadProgress){
        dispatch_async(dispatch_get_main_queue(), ^{
            uploadingHandler(uploadProgress.fractionCompleted);
        });
    }
                                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                          if (error) {
                                              errHandler(error);
                                          } else {
                                              completeHandler(responseObject);
                                          }
                                      }];
    [uploadTask resume];
}


- (void)downloadFileWithUrl:(NSString*)url withProcess:(downloadingHandler)downloadingHandler withCompleteHandler:(downloadCompleteHandler)downloadCompleteHandler withErrorHandler:(downloadErrorHandler)errHandler{
    if ([DSNetWorkStatus sharedNetWorkStatus].netWorkStatus == NotReachable) {
        errHandler([NSError errorWithDomain:[TipMessage shared].tipMessage.errorMsgNetworkUnavailable code:-200 userInfo:nil]);
        return;
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        downloadingHandler(downloadProgress.fractionCompleted);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            errHandler(error);
        }else{
            downloadCompleteHandler([filePath absoluteString]);
        }
    }];
    [downloadTask resume];
}

///新
- (void)upLoadFileWithUrl:(NSString*)url dicParama:(NSDictionary *)dicPara filePath:(NSString*)path name:(NSString*)name fileName:(NSString*)fileName mimeType:(NSString*)mimeType withPorcessingHandler:(uploadingHandler)uploadingHandler withCompleteHandler:(uploadCompleteHandler)completeHandler withErrorHandler:(uploadErrorHandler)errHandler{
    if ([DSNetWorkStatus sharedNetWorkStatus].netWorkStatus == NotReachable) {
        errHandler([NSError errorWithDomain:[TipMessage shared].tipMessage.errorMsgNetworkUnavailable code:-200 userInfo:nil]);
        return;
    }
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:dicPara constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (int i = 0; i < [dicPara[@"commentImages"] count]; i ++) {
            NSString *imvNames = [NSString stringWithFormat:@"commentImages%i",i];
            [MXTool saveImageWithName:imvNames andImage:[MXTool compressImage:dicPara[@"commentImages"][i] toTargetsize:SCREEN_WIDTH*1.5]];

            [formData appendPartWithFileURL:[NSURL fileURLWithPath:[MXTool  generateImagePathwithName:imvNames]] name:name fileName:fileName mimeType:mimeType error:nil];

        }
        
    } error:nil];
    NSString *userToken = [UserDefaults objectForKey:@"sessionid"];
    if (userToken.length!=0) {
        [request setValue:userToken forHTTPHeaderField:@"sessionid"];
    }
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nullable uploadProgress){
        dispatch_async(dispatch_get_main_queue(), ^{
            uploadingHandler(uploadProgress.fractionCompleted);
        });
    }
                                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                          if (error) {
                                              errHandler(error);
                                          } else {
                                              completeHandler(responseObject);
                                          }
                                      }];
    [uploadTask resume];
}

- (void)uploadImageWithUrl:(NSString*)url dicParama:(NSDictionary *)paramDict imageData:(NSData *)imageData fileName:(NSString *)fileName key:(NSString *)key withSuccessHandler:(successHandler)successHandler andFailHandler:(failHandler)failHandler {
    
    url = [self handleUrlWithParamWithStr:url];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //    url = [url stringByAddingPercentEncodingWithAllowedCharacters:NSUTF8StringEncoding];
    if ([DSNetWorkStatus sharedNetWorkStatus].netWorkStatus == NotReachable) {
        failHandler(nil,-200,[TipMessage shared].tipMessage.errorMsgNetworkUnavailable);
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager shareManager];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSString *userJsessionid = [UserDefaults objectForKey:@"sessionid"];
    NSString *userToken = [UserDefaults objectForKey:@"token"];
    if (userJsessionid.length!=0) {
        [manager.requestSerializer setValue:userJsessionid forHTTPHeaderField:@"sessionid"];
    }
    if (userToken.length!=0) {
        [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"token"];
    }
    //    NSString *funSessionId = [UserDefaults objectForKey:@"fundSessionId"];
    //    if (funSessionId) {
    //        [manager.requestSerializer setValue:funSessionId forHTTPHeaderField:@"fundSessionId"];
    //    }
    [manager.requestSerializer setValue:[DSUtils getUUIDString] forHTTPHeaderField:@"deviceId"];
    [manager.requestSerializer setValue:[DSUtils generateRandomStringWithLength:10] forHTTPHeaderField:@"randomCode"];
    [manager.requestSerializer setValue:@"iOSApp" forHTTPHeaderField:@"Request-From"];
    [manager.requestSerializer requestWithMethod:@"POST" URLString:url parameters:paramDict error:nil];
    void(^af_success_cb)() = ^(NSHTTPURLResponse *response, id responseObject) {
        successHandler(responseObject,response.statusCode);
    };
    void(^af_error_cb)(NSHTTPURLResponse *response, NSError *error) = ^(NSHTTPURLResponse *response, NSError *error) {
        
        NSString *strErrorMsg;
        if (response.statusCode == 401) {
            [[UserManager sharedUserManager] logout];
            strErrorMsg = [TipMessage shared].tipMessage.errorMsg401;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNeedLogin object:nil];
        } else if (response.statusCode/100 == 5) {
            strErrorMsg = [TipMessage shared].tipMessage.errorMsg50x;
        } else if (response.statusCode/100 == 3) {
            strErrorMsg = [TipMessage shared].tipMessage.errorMsg30x;
        } else {
            strErrorMsg = [error localizedDescription];
        }
        failHandler(error,response.statusCode,strErrorMsg);
    };
    
    [manager POST:url parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:imageData name:key fileName:fileName mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        af_success_cb((NSHTTPURLResponse*)task.response,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        af_error_cb((NSHTTPURLResponse*)task.response,error);
    }];
}

@end
