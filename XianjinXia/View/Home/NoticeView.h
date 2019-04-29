//
//  NoticeView.h
//  KDFDApp
//
//  Created by Innext on 2016/12/30.
//  Copyright © 2016年 cailiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    updateAlert,
    adsAlert
}AlertType;

typedef void(^NoticeBlock)();

@interface NoticeView : UIView

@property (nonatomic, copy) NoticeBlock nBlock;

- (void)showWithPic:(NSString *)urlPic withType:(AlertType)type;
- (void)dismiss;

@end
