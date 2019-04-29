//
//  NSDictionary+JsonFile.m
//  MeiXiang
//
//  Created by FengDongsheng on 16/5/17.
//  Copyright © 2016年 FengDongsheng. All rights reserved.
//

#import "NSDictionary+JsonFile.h"

@implementation NSDictionary (JsonFile)

+ (NSDictionary*)dictionaryWithContentsOfJSONString:(NSString*)fileName{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    __autoreleasing NSError* error = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                           options:kNilOptions error:&error];
    
    if (error != nil) return nil;
    return result;
}

@end
