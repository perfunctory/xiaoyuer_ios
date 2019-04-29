//
//  MXTool.h
//  MeiXiang
//
//  Created by FengDongsheng on 16/5/23.
//  Copyright © 2016年 FengDongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXTool : NSObject

/**
 *  获取当前时间戳
 *
 *  @return 时间戳字符串
 */
+ (NSString*)getCurrentTimestamp;

/**
 *  根据时间戳生成图片名称（生成规则：时间戳md5）
 *
 *  @return 图片名称
 */
+ (NSString*)generateImageName;

/**
 *  保存图片到沙盒
 *
 *  @param imageName 图片名称
 *  @param image     图片
 *
 *  @return 是否保存成功
 */
+ (BOOL)saveImageWithName:(NSString*)imageName andImage:(UIImage*)image;

/**
 *  从沙盒中获取图片
 *
 *  @param imageName 图片名称
 *
 *  @return 图片
 */
+ (UIImage*)loadImageWithName:(NSString*)imageName;

/**
 *  从沙盒中删除图片
 *
 *  @param imageName 图片名称
 */
+ (void)deleteImageWithName:(NSString*)imageName;

/**
 *  根据图片名称获取图片路径
 *
 *  @param imageName 图片名称
 *
 *  @return 图片路径
 */
+ (NSString*)generateImagePathwithName:(NSString*)imageName;

/**
 *  清空本地存储的照片缓存
 */
+ (void)clearLocalImageCache;

/**
 *  压缩图片尺寸
 *
 *  @param sourceImage 源数据
 *  @param targetWidth 目标宽度
 *
 *  @return 缩小尺寸后的图片
 */
+ (UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth;

/**
 *  压缩图片到固定大小
 *
 *  @param image 源数据
 *  @param size  目标大小
 *
 *  @return 缩小后的图片
 */
+ (UIImage *)compressImage:(UIImage *)image toTargetsize:(float)size;


@end
