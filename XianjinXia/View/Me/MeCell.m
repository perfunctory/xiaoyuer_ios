//
//  MeCell.m
//  XianjinXia
//
//  Created by 刘燕鲁 on 2017/2/8.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "MeCell.h"
#import "UIImageView+Additions.h"
#import "UIImageView+lyt.h"
#import "UILabel+lyt.h"
#import "UIView+lyt.h"
#import <Lyt.h>
#import "UICopyLabel.h"
@interface MeCell()

@property(nonatomic, retain) UILabel        *lblTitle;
@property(nonatomic, retain) UIImageView    *imvIcon;
@property(nonatomic, retain) UIButton       *btnNext;
@property(nonatomic, retain) UILabel        *lblContent;
@property(nonatomic, retain) UIView        *lblLine;
@property(nonatomic, retain) UIImageView    *arrowShow;
@property(nonatomic, retain) UICopyLabel *labelCopy;
@end

@implementation MeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}


-(void)configUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _imvIcon = [UIImageView getImageViewWithImageName:@"" superView:self.contentView lytSet:^(UIImageView *imageView) {
        [imageView lyt_alignLeftToParentWithMargin:15*WIDTHRADIUS];
        [imageView lyt_centerYInParent];
        [imageView lyt_setSize:CGSizeMake(25.5*WIDTHRADIUS, 25.5*WIDTHRADIUS)];
    }];
    _lblTitle = [UILabel getLabelWithFontSize:16 textColor:Color_Title superView:self.contentView lytSet:^(UILabel *label) {
        [label lyt_placeRightOfView:_imvIcon margin:15.f*WIDTHRADIUS];
        [label lyt_centerYInParent];
    }];
    _lblContent = [UILabel getLabelWithFontSize:13 textColor:Color_content superView:self.contentView lytSet:^(UILabel *label) {
        [label lyt_alignRightToParentWithMargin:40.f*WIDTHRADIUS];
        [label lyt_centerYInParent];
    }];
    _lblLine = [UIView getViewWithColorHex:Color_LineColor superView:self.contentView lytSet:^(UIView *view) {
        [view lyt_alignTopToParent];
        [view lyt_alignLeftToParent];
        [view lyt_alignRightToParentWithMargin:-60];
        [view lyt_setHeight:.5f];
    }];
    
    _arrowShow = [UIImageView getImageViewWithImageName:@"borrow_arrowright.jpg" superView:self.contentView lytSet:^(UIImageView *imageView) {
//        [imageView lyt_alignLeftToParentWithMargin:15*WIDTHRADIUS];
        [imageView lyt_alignRightToParentWithMargin:15*WIDTHRADIUS];
        [imageView lyt_centerYInParent];
//        [imageView lyt_setSize:CGSizeMake(10, 10)];
    }];
    if (!_labelCopy) {
        _labelCopy = [[UICopyLabel alloc] init];
        _labelCopy.frame = CGRectMake(SCREEN_WIDTH - 110, 18, 90, 20);
        //    _labelCopy.text = @"2152872885";
        _labelCopy.textColor = [UIColor redColor];
        _labelCopy.font = [UIFont systemFontOfSize:14];
        _labelCopy.tag = 2001;
        
        [self.contentView addSubview:_labelCopy];
    }

    
    
}

- (void)updateTableViewCellWithdata:(NSArray *)entity index:(NSIndexPath *)indexPath{
    
    _lblTitle.text = [entity[indexPath.row] objectForKey:@"strTitle"];
    _arrowShow.hidden = NO;
    _labelCopy.hidden  = YES;
    [self.contentView viewWithTag:2001].hidden = YES;
    if (indexPath.row == 0) {//空格行
        self.backgroundColor = Color_TABBG;
        self.imvIcon.hidden = YES;
        _lblContent.hidden = YES;
        _lblTitle.hidden = YES;
        _lblLine.hidden = YES;
        _arrowShow.hidden = YES;
    }else{
        self.backgroundColor = [UIColor whiteColor];
        //银行卡
        _imvIcon.image = [UIImage imageNamed:[entity[indexPath.row] objectForKey:@"strIcon"]];
        self.imvIcon.hidden = NO;
        _lblTitle.hidden = NO;
        _lblLine.hidden = NO;
        
        if (indexPath.row==1) {
            if ([[entity[indexPath.row] objectForKey:@"strIcon"] length]==0) {//银行卡没有绑定
                _lblContent.hidden = YES;
                _lblContent.text = @"";
                
            }else{
                _lblContent.hidden = NO;
                _lblContent.text = [entity[indexPath.row] objectForKey:@"strContent"];
                
            }
        }else{
            if (indexPath.row == 5) {
                _lblLine.hidden = NO;
                
            }else
            {
                _lblLine.hidden = NO;
            }
            _lblContent.hidden = NO;
            _lblContent.text = [entity[indexPath.row] objectForKey:@"strContent"];
        }
        
        if (indexPath.row == 6) {
//            _arrowShow.hidden = YES;
            _lblContent.hidden = YES;
            
//            if (![self.contentView viewWithTag:2001]) {
//                _labelCopy.hidden = NO;
//                _labelCopy.text = [entity[indexPath.row] objectForKey:@"strContent"];
//            } else {
//                [self.contentView viewWithTag:2001].hidden = NO;
//                _labelCopy.text = [entity[indexPath.row] objectForKey:@"strContent"];
//            }
        }
    }
}

@end
