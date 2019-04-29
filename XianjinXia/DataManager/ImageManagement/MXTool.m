//
//  MXTool.m
//  MeiXiang
//
//  Created by FengDongsheng on 16/5/23.
//  Copyright © 2016年 FengDongsheng. All rights reserved.
//

#import "MXTool.h"
#import "NSString+Calculate.h"
#import "DSAlbumManagement.h"

@implementation MXTool

+ (NSString*)getCurrentTimestamp{
    NSDate *datenow = [NSDate date];
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow dateByAddingTimeInterval:interval];
    NSString *timeSp = [NSString stringWithFormat:@"%f", [localeDate timeIntervalSince1970]];
    return timeSp;
}

+ (NSString*)generateImageName{
    return [[MXTool getCurrentTimestamp] md5];
}

+ (BOOL)saveImageWithName:(NSString*)imageName andImage:(UIImage*)image{
    if (imageName && [imageName isKindOfClass:[NSString class]] && imageName.length > 0 && image && [image isKindOfClass:[UIImage class]]) {
        NSData* imageData = UIImageJPEGRepresentation(image,0.5);
        //获取Library/Caches目录
        NSString *imagePath = [MXTool generateImagePathwithName:imageName];
        [imageData writeToFile:imagePath atomically:NO];
        return YES;
    }
    return NO;
}

+ (UIImage*)loadImageWithName:(NSString*)imageName{
    NSString *imagePath = [MXTool generateImagePathwithName:imageName];
    UIImage *reslutImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:imagePath]]];
    return reslutImage;
}

+ (void)deleteImageWithName:(NSString*)imageName{
    NSString *imagePath = [MXTool generateImagePathwithName:imageName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    }
}

+ (NSString*)generateImagePathwithName:(NSString*)imageName{
    if (imageName && [imageName isKindOfClass:[NSString class]] && imageName.length > 0){
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) lastObject];
        NSString *imagePathTemp = [cachesPath stringByAppendingPathComponent:@"Meixiangshenghuo"];
        NSError *error = nil;
        if (![[NSFileManager defaultManager] fileExistsAtPath:imagePathTemp]){
            [[NSFileManager defaultManager] createDirectoryAtPath:imagePathTemp withIntermediateDirectories:NO attributes:nil error:&error];
        }
        NSString *imagePath = [imagePathTemp stringByAppendingPathComponent:imageName];
        return imagePath;
    }else{
        return @"";
    }
}

+ (void)clearLocalImageCache{
    NSString *cachesPath =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) lastObject];
    NSString *imagePathTemp = [cachesPath stringByAppendingPathComponent:@"Meixiangshenghuo"];
    NSError *error = nil;
    for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:imagePathTemp error:&error]) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", imagePathTemp, file] error:&error];
    }
}

+ (UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth {
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)compressImage:(UIImage *)image toTargetsize:(float)size{
    UIImage *img1 = [MXTool compressImage:image toTargetWidth:image.size.width/2];
    NSData *data = UIImageJPEGRepresentation(img1, 0.5);
    if(data.length >= size*1024) {
        [self compressImage:img1 toTargetsize:size];
    }
    return img1;
}

@end
