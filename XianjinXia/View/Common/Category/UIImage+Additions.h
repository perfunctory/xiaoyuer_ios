//
//  UIImage+Additions.h
//  MLIPhone
//
//  Created by yakehuang on 5/6/14.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)

// 重置图片尺寸
- (UIImage *)rescaleImageToSize:(CGSize)size;

// 裁剪图片
- (UIImage *)cropImageToRect:(CGRect)cropRect;

- (UIImage *)cutImageWithRadius:(int)radius;

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)cacheImageWithURL:(id)url;
//圆形图片
+ (instancetype)circleWithImage:(UIImage *)OriginalImage;
@end
