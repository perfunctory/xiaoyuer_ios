//
//  TipMessage.m
//  MeiXiang
//
//  Created by FengDongsheng on 16/6/19.
//  Copyright © 2016年 FengDongsheng. All rights reserved.
//

#import "TipMessage.h"
#import "NSDictionary+JsonFile.h"
#import <YYModel.h>

@implementation TipMessage

+ (TipMessage*)shared{
    static TipMessage *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TipMessage alloc] init];
        sharedInstance.tipMessage = [TipMessageModel yy_modelWithDictionary:[NSDictionary dictionaryWithContentsOfJSONString:@"TipMessage"]];
    });
    return sharedInstance;
}

@end
