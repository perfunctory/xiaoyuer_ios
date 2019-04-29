//
//  KDAscendingUpLoadEntity.m
//  KDIOSApp
//
//  Created by appleMac on 16/5/11.
//  Copyright © 2016年 KDIOSApp. All rights reserved.
//

#import "KDAscendingUpLoadEntity.h"

@implementation KDAscendingUpLoadImgEntity

- (NSString *)setKey:(NSString *)key
{
    if ([key isEqualToString:@"imgId"]) {
        return @"id";
    }
    return key;
}

@end

@implementation KDAscendingUpLoadEntity

- (Class)getClass:(NSString *)keyName
{
    if ([keyName isEqualToString:@"data"]) {
        return [KDAscendingUpLoadImgEntity class];
    }
    return nil;
}

@end
