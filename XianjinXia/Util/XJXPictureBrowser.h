//
//  XJXPictureBrowser.h
//  KDFDApp
//
//  Created by haoran on 16/9/22.
//  Copyright © 2016年 cailiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJXPictureBrowser : NSObject

/**
 *	@brief	浏览头像
 *  @param image 需要预览的图片
 *  @param frame 相对于window的原始位置
 *  @param complete 完成后的回调
 */
+ (void)showImage:(UIImage *)image originFrame:(CGRect)frame complete:(void(^)())complete;

@end
