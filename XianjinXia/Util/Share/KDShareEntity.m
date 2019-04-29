//
//  KDShareEntity.m
//  KDLC
//
//  Created by haoran on 16/6/2.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import "KDShareEntity.h"
#import "UIImageView+Additions.h"

@implementation KDShareEntity


- (void)setShare_logo:(NSString *)share_logo
{
  if (![share_logo isEqualToString:@""]) {
//      UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished
      [UIImageView downLoadImageWithURL:share_logo complate:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL){ }];
    _share_logo = share_logo;
  } else {
    _share_logo = @"share.jpg";
  }
}

- (void)afterDataManage
{
  if ([_shareBtnTitle isEqualToString:@""]) {
    _shareBtnTitle = @"分享";
  }
}

- (NSString *)share_title
{
  if (!_share_title || [_share_title isEqualToString:@""]) {
    _share_title = @"信合宝";
  }
  return _share_title;
}

@end
