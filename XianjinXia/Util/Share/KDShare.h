//
//  KDShare.h
//  KDLC
//
//  Created by haoran on 15/6/9.
//  Copyright (c) 2015年 llyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDShare :BaseModel<NSCoding>

//分享数据
@property (nonatomic, retain) NSString *shareTitle;
@property (nonatomic, retain) NSString *shareContent;
@property (nonatomic, retain) NSString *shareUrl;
@property (nonatomic, retain) UIImage *shareImage;

@property (nonatomic, retain) NSString *actityTitle;//分享头部活动文案
@property (nonatomic, retain) NSString *shareSuccMsg;//分享成功之后弹窗文案
//分享平台
@property (nonatomic,strong)NSArray *titles;
@property (nonatomic,strong)NSArray *images;

//分享/分享有奖
@property (nonatomic, retain) NSString *showShare;

//上报数据
@property (nonatomic, retain) NSString *upId;
@property (nonatomic, retain) NSString *upType;
@property (nonatomic, retain) NSString *upUrl;
//分享平台下发  传yes
@property (assign,nonatomic)  BOOL downPlatform;

- (void)setUpId:(NSString *)upId upType:(NSString *)upType upUrl:(NSString *)upUrl;

- (void)setShareTitle:(NSString *)title andShareContent:(NSString *)content andShareUrl:(NSString *)url;
- (void)setActityTitle:(NSString *)title andShareSuccMsg:(NSString *)succmsg;
@end
