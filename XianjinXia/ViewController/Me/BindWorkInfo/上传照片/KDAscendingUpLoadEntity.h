//
//  KDAscendingUpLoadEntity.h
//  KDIOSApp
//
//  Created by appleMac on 16/5/11.
//  Copyright © 2016年 KDIOSApp. All rights reserved.
//

#import "BaseModel.h"

@interface KDAscendingUpLoadImgEntity : BaseModel

@property (nonatomic, retain) NSString *imgId;
@property (nonatomic, retain) NSString *pic_name;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *url;

@end

@interface KDAscendingUpLoadEntity : BaseModel

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *notice;
@property (nonatomic, retain) NSString *max_pictures;
@property (nonatomic, retain) NSArray<KDAscendingUpLoadImgEntity *> *data;

@end
