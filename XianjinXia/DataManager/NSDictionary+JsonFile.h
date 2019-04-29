//
//  NSDictionary+JsonFile.h
//  MeiXiang
//
//  Created by FengDongsheng on 16/5/17.
//  Copyright © 2016年 FengDongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JsonFile)

/**
 *  NSDictionary from json file
 *
 *  @param fileName file name
 *
 *  @return dictionary
 */
+ (NSDictionary*)dictionaryWithContentsOfJSONString:(NSString*)fileName;

@end
