//
//  UIImageView+Additions.m
//  KDLC
//
//  Created by 曹晓丽 on 16/3/24.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import "UIImageView+Additions.h"
#import <SDWebImage/SDImageCache.h>

@implementation UIImageView (Additions)

- (void)setImageWithURL:(NSString *)urlString{
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self sd_setImageWithURL:[NSURL URLWithString:urlString]];
}

- (void)setImageWithURL:(NSString *)urlString placeholderImgString:(NSString *)placeholderImgString{
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:placeholderImgString]];
}

- (void)setImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholderImg{
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeholderImg];
}

- (void)setImageWithURL:(NSString *)urlString placeholderImg:(UIImage *)placeholderImg completed:(SDExternalCompletionBlock)completedBlock{
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeholderImg completed:completedBlock];
}

- (void)setImageWithURL:(NSString *)urlString placeholderImgString:(NSString *)placeholderImgString completed:(SDExternalCompletionBlock)completedBlock{
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:placeholderImgString] completed:completedBlock];
}

+ (BOOL)haveCacheImageWIthURL:(id)url
{
    if ([UIImageView validURL:url]) {
        url = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
        url = [NSURL URLWithString:url];
        [[SDWebImageManager sharedManager] cachedImageExistsForURL:url completion:nil];
        return YES;
    }
    return NO;
}

+ (UIImage *)cacheImageWithURL:(id)url
{
    if ([UIImageView validURL:url]) {
        url = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
        url = [NSURL URLWithString:url];
        NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
        UIImage *tempImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
        if (tempImage) {
            return tempImage;
        }
    }
    return nil;
}

+ (void)downLoadImageWithURL:(id)url complate:(SDInternalCompletionBlock)complate
{
    if ([UIImageView validURL:url]) {
        url = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
        url = [NSURL URLWithString:url];
        [[SDWebImageManager sharedManager] loadImageWithURL:url options:0 progress:nil completed:complate];
    }
}

+ (BOOL)validURL:(id)url
{
    if ([url isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:url];
    }
    
    if (![url isKindOfClass:[NSURL class]]) {
        return NO;
    }
    return YES;
}

@end
