//
//  VerifyListBottomView.h
//  XianjinXia
//
//  Created by sword on 2017/3/31.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, kPointToThe) {
    kPointToTheBottom,
    kPointToTheTop
};

@interface VerifyListBottomView : UIView

@property (assign, nonatomic) kPointToThe direction;
@property (copy, nonatomic) void(^directionButtonClicked)(kPointToThe currentDirection);

+ (instancetype)verifyListBottomView;

@end
