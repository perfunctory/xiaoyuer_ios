//
//  TipMessage.h
//  MeiXiang
//
//  Created by FengDongsheng on 16/6/19.
//  Copyright © 2016年 FengDongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TipMessageModel.h"

@interface TipMessage : NSObject

@property (nonatomic, strong) TipMessageModel *tipMessage;

+ (TipMessage*)shared;

@end
