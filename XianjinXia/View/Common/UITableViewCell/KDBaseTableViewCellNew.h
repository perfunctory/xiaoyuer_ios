//
//  KDBaseTableViewCellNew.h
//  KDLC
//
//  Created by 闫涛 on 15/6/15.
//  Copyright (c) 2015年 llyt. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KDBaseTableViewCellNew : UITableViewCell


@property (nonatomic, assign)BOOL arrowShow;//是否显示右箭头

@property (nonatomic, copy) void (^btnTouch)(NSString *benKey,NSString *sometingOther);

@property (nonatomic, copy) NSString *searchTextStr;//搜索的关键字，基金列表搜索用到的
@property (assign, nonatomic) BOOL isLastItem;   //判断是否是最后一项，如果分组了，则每组的最后一项返回YES，如果没分组，则最后一项返回YES

@property (assign, nonatomic) BOOL allGropeLastItem;    //分组的时候最后一组的最后一个

@property (nonatomic, assign) BOOL isFirstItem;     //判断是否是第一项，如果分组了，则每组的第一项返回YES，如果没分组，则第一项返回YES

@property (nonatomic, retain) UITableView *tableView;//cell所属的tableview

/**
 *  初始化
 *
 *  @param style           cell的风格
 *  @param reuseIdentifier identify
 *
 *  @return self(若用代码创建uitableviewcell，直接重写- (void)configUI，用xib创建uitableviewcell，直接用此方法来初始化)
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

/**
 *  构建uitableviewcell的UI
 */
- (void)configUI;

/**
 *  刷新uitableviewcell
 *
 *  @param entity    封装的数据
 *  @param indexPath indexPath
 */
- (void)updateTableViewCellWithdata:(id)entity index:(NSIndexPath *)indexPath;

/**
 *  返回行高
 */
- (CGFloat)heightForRow;

/**
 *  向右的箭头
 *
 *  @return button
 */
- (UIButton *)createButton;

/**
 *  字符串特殊处理(双色处理)
 *
 *  @param leftStr       左边的string
 *  @param rightStr      右边的string
 *  @param leftSize      左边的size
 *  @param rightSize     右边的size
 *  @param leftColorHex  左边的颜色
 *  @param rightColorHex 右边的颜色
 *
 *  @return NSMutableAttributedString
 */
- (NSMutableAttributedString *)attributeStringWithLeftStr:(NSString *)leftStr rightStr:(NSString *)rightStr leftFontSize:(CGFloat)leftSize rightFontSize:(CGFloat)rightSize leftColor:(NSString *)leftColorHex rightColor:(NSString *)rightColorHex;

/**
 *  字符串特殊处理
 *
 *  @param leftStr   左边的string
 *  @param rightStr  右边的string
 *  @param leftLine  左边是否有线
 *  @param rightLine 右边是否有线
 *
 *  @return NSMutableAttributedString
 */
- (NSMutableAttributedString *)attributeStringWithLeftStr:(NSString *)leftStr rightStr:(NSString *)rightStr leftHaveLine:(BOOL)leftLine rightHaveLine:(BOOL)rightLine;

@end
