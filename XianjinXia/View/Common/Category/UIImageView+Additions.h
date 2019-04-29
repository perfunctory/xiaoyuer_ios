//
//  UIImageView+Additions.h
//  KDLC
//
//  Created by 曹晓丽 on 16/3/24.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface UIImageView (Additions)

- (void)setImageWithURL:(NSString *)urlString;

- (void)setImageWithURL:(NSString *)urlString placeholderImgString:(NSString *)placeholderImgString;

- (void)setImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholderImg;

- (void)setImageWithURL:(NSString *)urlString placeholderImg:(UIImage *)placeholderImg completed:(SDExternalCompletionBlock)completedBlock;

- (void)setImageWithURL:(NSString *)urlString placeholderImgString:(NSString *)placeholderImgString completed:(SDExternalCompletionBlock)completedBlock;

+ (BOOL)validURL:(id)url;

+ (BOOL)haveCacheImageWIthURL:(id)url;

+ (UIImage *)cacheImageWithURL:(id)url;

+ (void)downLoadImageWithURL:(id)url complate:(SDInternalCompletionBlock)complate;

@end
