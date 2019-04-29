//
//  LSFloatingActionMenu.h
//  LSFloatingActionMenuDemo
//
//  Created by lslin on 16/4/18.
//  Copyright © 2016年 lessfun.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LSFloatingActionMenuItem.h"

typedef NS_ENUM(NSInteger, LSFloatingActionMenuDirection) {
    LSFloatingActionMenuDirectionUp    = 0,
    LSFloatingActionMenuDirectionDown  = 1,
    LSFloatingActionMenuDirectionLeft  = 2,
    LSFloatingActionMenuDirectionRight = 3,
};

@interface LSFloatingActionMenu : UIView

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, assign) BOOL rotateStartMenu;

@property (strong,nonatomic) UIView *bgView;
@property (strong,nonatomic) UIWindow *mainWindow;
@property UIView *windowView;

- (id)initWithFrame:(CGRect)frame
          direction:(LSFloatingActionMenuDirection)direction
          menuItems:(NSArray *)menuItems
        menuHandler:(void (^)(LSFloatingActionMenuItem *item, NSUInteger index))menuHandler
        openHandler:(void (^)(void))openHandler
       closeHandler:(void (^)(void))closeHandler;

- (LSFloatingActionMenuItem *)menuItemAtIndex:(NSUInteger)index;

- (void)open;

- (void)close;

@end

