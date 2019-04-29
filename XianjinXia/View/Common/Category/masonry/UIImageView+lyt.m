//
//  UIImageView+lyt.m
//  KDIOSApp
//
//  Created by appleMac on 16/5/1.
//  Copyright © 2016年 KDIOSApp. All rights reserved.
//

#import "UIImageView+lyt.h"

@implementation UIImageView (lyt)

+(UIImageView *)getImageViewWithImageName:(NSString *)imageName superView:(UIView *)superView lytSet:(void (^)(UIImageView *imageView))block
{
    UIImageView *imageView;
    if (!imageName || [imageName isEqualToString:@""]) {
        imageView = [[UIImageView alloc] init];
    } else {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    }
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:imageView];
    
    if (block) {
        block(imageView);
    }
    return imageView;
}

@end
