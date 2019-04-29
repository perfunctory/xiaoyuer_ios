//
//  UIImage+Additions.m
//  MLIPhone
//
//  Created by yakehuang on 5/6/14.
//
//

#import "UIImage+Additions.h"
#import <SDWebImage/SDImageCache.h>
#import <SDWebImageManager.h>
@implementation UIImage (Additions)

- (UIImage *)rescaleImageToSize:(CGSize)size
{
	CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
	UIGraphicsBeginImageContext(rect.size);
	[self drawInRect:rect];  // scales image to rect
	UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return resImage;
}

- (UIImage *)cropImageToRect:(CGRect)cropRect
{
	// Begin the drawing (again)
	UIGraphicsBeginImageContext(cropRect.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	// Tanslate and scale upside-down to compensate for Quartz's inverted coordinate system
	CGContextTranslateCTM(ctx, 0.0, cropRect.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);
	
	// Draw view into context
	CGRect drawRect = CGRectMake(-cropRect.origin.x, cropRect.origin.y - (self.size.height - cropRect.size.height) , self.size.width, self.size.height);
	CGContextDrawImage(ctx, drawRect, self.CGImage);
	
	// Create the new UIImage from the context
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// End the drawing
	UIGraphicsEndImageContext();
	
	return newImage;
}

- (UIImage *)cutImageWithRadius:(int)radius
{
    UIGraphicsBeginImageContext(self.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    float x1 = 0.;
    float y1 = 0.;
    float x2 = x1+self.size.width;
    float y2 = y1;
    float x3 = x2;
    float y3 = y1+self.size.height;
    float x4 = x1;
    float y4 = y3;
    radius = radius*2;
    
    CGContextMoveToPoint(gc, x1, y1+radius);
    CGContextAddArcToPoint(gc, x1, y1, x1+radius, y1, radius);
    CGContextAddArcToPoint(gc, x2, y2, x2, y2+radius, radius);
    CGContextAddArcToPoint(gc, x3, y3, x3-radius, y3, radius);
    CGContextAddArcToPoint(gc, x4, y4, x4, y4-radius, radius);
    
    
    CGContextClosePath(gc);
    CGContextClip(gc);
    
    CGContextTranslateCTM(gc, 0, self.size.height);
    CGContextScaleCTM(gc, 1, -1);
    CGContextDrawImage(gc, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
    
    
    
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimage;
}

+ (UIImage *)cacheImageWithURL:(id)url
{
    if ([UIImage validURL:url]) {
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


+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+(instancetype)circleWithImage:(UIImage *)OriginalImage
{
//    UIGraphicsBeginImageContextWithOptions(OriginalImage.size, NO, 0.0);
    UIGraphicsBeginImageContext(OriginalImage.size);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGRect circleRect = CGRectMake(0, 0, OriginalImage.size.width, OriginalImage.size.height);
    CGContextAddEllipseInRect(ref,circleRect);
    CGContextClip(ref);
    //画图
    [OriginalImage drawInRect:circleRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
