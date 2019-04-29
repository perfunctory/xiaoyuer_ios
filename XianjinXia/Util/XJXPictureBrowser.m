//
//  XJXPictureBrowser.m
//  KDFDApp
//
//  Created by haoran on 16/9/22.
//  Copyright © 2016年 cailiang. All rights reserved.
//

#import "XJXPictureBrowser.h"

static CGRect oldframe;
static void(^completeBlock)();

@implementation XJXPictureBrowser

+ (void)showImage:(UIImage *)image originFrame:(CGRect)frame complete:(void(^)())complete {
    //防止image为空的情况
    if (image) {
        
        oldframe = frame;
        completeBlock = [complete copy];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];
        imageView.image = image;
        imageView.tag = 201;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [[UIApplication sharedApplication].keyWindow addSubview:backgroundView];
        [[UIApplication sharedApplication].keyWindow addSubview:imageView];

        [backgroundView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage:)]];
        
        [UIView animateWithDuration:0.25f animations:^{
            
            imageView.frame = CGRectMake(0, (SCREEN_HEIGHT - image.size.height*SCREEN_WIDTH/image.size.width)/2, SCREEN_WIDTH, image.size.height*SCREEN_WIDTH/image.size.width);
            backgroundView.alpha = 1;
        } completion:nil];
    }
}

+ (void)hideImage:(UITapGestureRecognizer*)tap {
    
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView*)[[UIApplication sharedApplication].keyWindow viewWithTag:201];
    [UIView animateWithDuration:0.25f animations:^{
        
        imageView.frame = oldframe;
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [backgroundView removeFromSuperview];
        [imageView removeFromSuperview];
        !completeBlock ? : completeBlock(); completeBlock = NULL;
    }];
}

@end
