//
//  KDUpLoadImgCV.h
//  KDIOSApp
//
//  Created by appleMac on 16/5/11.
//  Copyright © 2016年 KDIOSApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDAscendingUpLoadEntity.h"

@interface KDUpLoadImgCV : UICollectionView

@property (nonatomic, retain) NSArray<KDAscendingUpLoadImgEntity *> *dataArray;
@property (assign, nonatomic) NSInteger maxNum;

//待上传的图片
@property (nonatomic, retain) NSMutableArray *uploadArray;

@property (assign, nonatomic) NSInteger type;

+ (id)getcollection;
@property (nonatomic, copy) void (^uploadImgSuccss)(void);
@end
