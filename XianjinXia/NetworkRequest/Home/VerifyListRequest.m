//
//  VerifyListRequest.m
//  XianjinXia
//
//  Created by sword on 10/02/2017.
//  Copyright © 2017 lxw. All rights reserved.
//

#import "VerifyListRequest.h"

@implementation VerifyListRequest

- (void)fetchUserVerifyListWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    
    [self doHttpWithUrl:[NSString stringWithFormat:@"%@%@", Url_Server, kCreditCardGetVerificationInfo] andMetohd:kHttpRequestGet andParameters:[paramDict copy] andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([[DSStringValue(dictResult[@"code"]) description] isEqualToString:@"0"]) {
                successCb(dictResult[@"data"]);
            }else{
                failCb(statusCode,DSStringValue(dictResult[@"message"]));
            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
    } andFailHandler:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode, errorMsg);
    }];
}

- (void)getContactsListWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    
    [self doHttpWithUrl:[NSString stringWithFormat:@"%@%@", Url_Server, kCreditCardGetContacts] andMetohd:kHttpRequestGet andParameters:[paramDict copy] andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([DSStringValue([dictResult[@"code"] description]) isEqualToString:@"0"]) {
                successCb(dictResult[@"data"]);
            }else{
                failCb(statusCode,DSStringValue(dictResult[@"message"]));
            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
    } andFailHandler:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode, errorMsg);
    }];
}

- (void)fetchPersonalInformationWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    [self doHttpWithUrl:[NSString stringWithFormat:@"%@%@", Url_Server, kCreditCardGetPersonInfo] andMetohd:kHttpRequestGet andParameters:[paramDict copy] andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([DSStringValue([dictResult[@"code"] description]) isEqualToString:@"0"]) {
                successCb(dictResult[@"data"]);
            }else{
                failCb(statusCode,DSStringValue(dictResult[@"message"]));
            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
    } andFailHandler:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode, errorMsg);
    }];
}

- (void)fetchAuthMoreInfoWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    [self doHttpWithUrl:[NSString stringWithFormat:@"%@%@", Url_Server, kCreditWebScoreAuth] andMetohd:kHttpRequestGet andParameters:[paramDict copy] andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([DSStringValue([dictResult[@"code"] description]) isEqualToString:@"0"]) {
                successCb(dictResult[@"data"]);
            }else{
                failCb(statusCode,DSStringValue(dictResult[@"message"]));
            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
    } andFailHandler:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode, errorMsg);
    }];
}

- (void)SaveContactsWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    [self doHttpWithUrl:[NSString stringWithFormat:@"%@%@", Url_Server, kCreditCardSaveContacts] andMetohd:kHttpRequestGet andParameters:[paramDict copy] andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([DSStringValue([dictResult[@"code"] description]) isEqualToString:@"0"]) {
                successCb(dictResult[@"data"]);
            }else{
                failCb(statusCode,DSStringValue(dictResult[@"message"]));
            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
    } andFailHandler:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode, errorMsg);
    }];
}

- (void)saveAuthMoreInfoWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    [self doHttpWithUrl:[NSString stringWithFormat:@"%@%@", Url_Server, kCreditInfoSaveScoreAuth] andMetohd:kHttpRequestGet andParameters:[paramDict copy] andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([DSStringValue([dictResult[@"code"] description]) isEqualToString:@"0"]) {
                successCb(dictResult[@"data"]);
            }else{
                failCb(statusCode,DSStringValue(dictResult[@"message"]));
            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
    } andFailHandler:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode, errorMsg);
    }];
}

- (void)updateContactsWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    [self doHttpWithUrl:[NSString stringWithFormat:@"%@%@", Url_Server, kInfoUpLoadContacts] andMetohd:kHttpRequestPost andParameters:[paramDict copy] andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([DSStringValue([dictResult[@"code"] description]) isEqualToString:@"0"]) {
                successCb(dictResult[@"data"]);
            }else{
                failCb(statusCode,DSStringValue(dictResult[@"message"]));
            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
    } andFailHandler:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode, errorMsg);
    }];
}

- (void)uploadFaceVerifyImageWithDictionary:(NSDictionary *)paramDict imageData:(NSData *)imageData fileName:(NSString *)fileName key:(NSString *)key success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    
    [self uploadImageWithUrl:[NSString stringWithFormat:@"%@%@", Url_Server, kPictureUploadImage] dicParama:paramDict imageData:imageData fileName:fileName key:key withSuccessHandler:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([DSStringValue([dictResult[@"code"] description]) isEqualToString:@"0"]) {
                successCb(dictResult[@"data"]);
            }else{
                failCb(statusCode,DSStringValue(dictResult[@"message"]));
            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
    } andFailHandler:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode, errorMsg);
    }];
}

- (void)savePersonmalInfoWithSuburl:(NSString *)suburl dictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    
    [self doHttpWithUrl:[NSString stringWithFormat:@"%@%@", Url_Server, suburl] andMetohd:kHttpRequestPost andParameters:[paramDict copy] andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([DSStringValue([dictResult[@"code"] description]) isEqualToString:@"0"]) {
                successCb(dictResult);
            }else{
                failCb(statusCode,DSStringValue(dictResult[@"message"]));
            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
    } andFailHandler:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode, errorMsg);
    }];
}

@end
