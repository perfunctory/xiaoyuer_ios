//
//  UpImageRequest.h
//  XianjinXia
//
//  Created by 刘燕鲁 on 2017/2/17.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseRequest.h"
@interface UpImageRequest : BaseRequest

- (void)upImageInfoWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

- (void)getImageInfoWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;


@end
