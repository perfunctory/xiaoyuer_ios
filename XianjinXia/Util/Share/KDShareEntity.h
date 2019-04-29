//
//  KDShareEntity.h
//  KDLC
//
//  Created by haoran on 16/6/2.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import "BaseModel.h"

@interface KDShareEntity : BaseModel

//0直接弹分享选择框 1右上角出来分享按钮
@property (nonatomic, retain) NSString *type;

//分享title
@property (nonatomic, retain) NSString *share_title;
//分享描述
@property (nonatomic, retain) NSString *share_body;
//分享链接
@property (nonatomic, retain) NSString *share_url;
//分享图片
@property (nonatomic, retain) NSString *share_logo;

//按钮文案
@property (nonatomic, retain) NSString *shareBtnTitle;
//是否分享
@property (nonatomic, retain) NSString *isShare;
//分享有奖描述
@property (nonatomic, retain) NSString *sharePageTitle;

//分享渠道['wx','wechatf','qq','qqzone','sina','sms']; 
@property (nonatomic, retain) NSArray *sharePlatform;
//是否上报
@property (nonatomic, retain) NSString *shareIsUp;
//上报id
@property (nonatomic, retain) NSString *shareUpId;
//上报类型
@property (nonatomic, retain) NSString *shareUpType;
//上报url
@property (nonatomic, retain) NSString *shareUpUrl;

//分享成功后事件
@property (nonatomic, copy) dispatch_block_t block;

@end
