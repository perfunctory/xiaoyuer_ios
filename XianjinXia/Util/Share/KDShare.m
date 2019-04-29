//
//  KDShare.m
//  KDLC
//
//  Created by haoran on 15/6/9.
//  Copyright (c) 2015年 llyt. All rights reserved.
//

#import "KDShare.h"
@interface KDShare()

@end

@implementation KDShare
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shareImage = [UIImage imageNamed:@"share.jpg"];
    }
    return self;
}
- (void)setShareTitle:(NSString *)title andShareContent:(NSString *)content andShareUrl:(NSString *)url 
{
    self.shareTitle = title;
    self.shareContent = content;
    self.shareUrl = url;
    self.shareImage = [UIImage imageNamed:@"share.jpg"];
}

- (void)setUpId:(NSString *)upId upType:(NSString *)upType upUrl:(NSString *)upUrl
{
    self.upId = upId;
    self.upType = upType;
    self.upUrl = upUrl;
}
- (void)setActityTitle:(NSString *)title andShareSuccMsg:(NSString *)succmsg
{
    self.actityTitle = title;
    self.shareSuccMsg = succmsg;
}
- (void)setShareTitle:(NSString *)shareTitle
{
    if (shareTitle && ![shareTitle isEqualToString:@""]) {
        _shareTitle = shareTitle;
        return;
    }
    
}

- (void)setShareContent:(NSString *)shareContent
{
    if (shareContent && ![shareContent isEqualToString:@""]) {
        _shareContent = shareContent;
        return;
    }
    
}

- (void)setShareUrl:(NSString *)shareUrl
{
    if (shareUrl && ![shareUrl isEqualToString:@""]) {
        _shareUrl = shareUrl;
        return;
    }
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
//    self = [super initWithCoder:coder];
    if (self) {
        
        //        shareData = [coder decodeObjectForKey:@"shareData"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
//    [super encodeWithCoder:aCoder];
    //    [aCoder encodeObject:shareData forKey:@"shareData"];
    
}

@end
