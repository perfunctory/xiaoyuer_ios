//
//  AmountContentView.m
//  KDFDApp
//
//  Created by sword on 2017/1/4.
//  Copyright © 2017年 cailiang. All rights reserved.
//

#import "AmountContentView.h"

#import "UICountingLabel.h"
#import "HeightenSlider.h"
#import "SelectedDateView.h"
#import "HomeOnlySevenDayView.h"
#import "GraduationView.h"
#define MARGIN 40

@interface AmountContentView ()

@property (strong, nonatomic) UICountingLabel *selectedMoney;
@property (strong, nonatomic) UICountingLabel *selectedMoneyDesc;
@property (strong, nonatomic) UILabel *moneyDescription;
//@property (strong, nonatomic) HeightenSlider *slider;
@property (nonatomic, retain) GraduationView *ruler;//刻度尺
@property (nonatomic, strong) UILabel *lblServeMoney;

//@property (nonatomic, strong) UILabel *line;
//@property (nonatomic, strong) UIView *vLine;
@property (nonatomic, strong) UILabel *line1;
@property (nonatomic, strong) UIView *vLine1;
@property (nonatomic, strong) UILabel *lineSX;
@property (nonatomic, strong) UIView *vMoney;

@property (strong, nonatomic) SelectedDateView *dateView;

@property (strong,nonatomic)  HomeOnlySevenDayView * sevenDaysView;

@property (assign, nonatomic) NSInteger sliderValue;
@property (strong, nonatomic) UIButton *checkFee;//服务费用说明按钮
@property (strong, nonatomic) UIImageView *imvIocn;

@end

@implementation AmountContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
                
        [self addSubview:self.selectedMoney];
        [self addSubview:self.selectedMoneyDesc];
        [self addSubview:self.moneyDescription];
        //        [self addSubview:self.slider];
        [self addSubview:self.imvIocn];
        [self addSubview:self.vMoney];
        [self addSubview:self.ruler];
        [self addSubview:self.dateView];//可以选择七天十四天金额
        self.dateView.alpha = 0;
        //[self.dateView removeFromSuperview];
        [self addSubview:self.sevenDaysView];
        [self addSubview:self.checkFee];
        _lblServeMoney = [UILabel getLabelWithFontSize:11 textColor:UIColorFromRGB(0x666666) superView:self masonrySet:^(UILabel *view, MASConstraintMaker *make) {
            //            view.attributedText = [self changeYuanSize:@"125元"];
            // view.text = @"125元";
            make.top.mas_equalTo(@(52*WIDTHRADIUS));
            make.left.mas_equalTo([NSNumber numberWithFloat:SCREEN_WIDTH/2]);
            make.width.equalTo([NSNumber numberWithFloat:SCREEN_WIDTH/2]);
            make.height.mas_equalTo(@(12*WIDTHRADIUS));
        }];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)sliderAnimation {
    if( (self.entity.amountInfo.amounts.count) > self.sliderValue){
        
        !self.moneyDidChange ? : self.moneyDidChange([self.entity.amountInfo.amounts[self.sliderValue][@"amount"] integerValue], [self.dateView selectedIndex]);

        //    if (self.superview && (self.sliderValue > self.slider.value)) {
//
//        [self.selectedMoney countFrom:[self.entity.amountInfo.amounts[[self.slider moneyIndex]] integerValue]/100 to:[self.entity.amountInfo.amounts[self.sliderValue] integerValue]/100 withDuration:1];
//        
//        [self.selectedMoneyDesc countFrom:[self.entity.amountInfo.amounts[[self.slider moneyIndex]] integerValue]/100 to:[self.entity.amountInfo.amounts[self.sliderValue] integerValue]/100 withDuration:1];
//        
//        [UIView animateWithDuration:1 animations:^{
//            [self.slider setValue:self.sliderValue animated:YES];
//        } completion:^(BOOL finished) {
//            self.slider.value = self.sliderValue;
//        }];
//    }
    
    }
}

/**
 <#Description#>
 */
- (void)updateConstraints {
    [super updateConstraints];
    if (self.selectedMoney.translatesAutoresizingMaskIntoConstraints&&self.selectedMoneyDesc.translatesAutoresizingMaskIntoConstraints) {
    _lineSX = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 30*WIDTHRADIUS, 0.5, 38*WIDTHRADIUS)];
    _lineSX.backgroundColor = UIColorFromRGB(0xaaaaaa);
    [self addSubview:_lineSX];
    
//    _line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5*WIDTHRADIUS)];
//    _line.backgroundColor = UIColorFromRGB(0xc1c1c1);
//    [self addSubview:_line];
//    
//    _vLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5*WIDTHRADIUS, SCREEN_WIDTH, 9.5*WIDTHRADIUS)];
//    _vLine.backgroundColor = UIColorFromRGB(0xeeeeee);
//    [self addSubview:_vLine];
 
    _line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 76*WIDTHRADIUS, SCREEN_WIDTH, 0.5*WIDTHRADIUS)];
    _line1.backgroundColor = UIColorFromRGB(0xc1c1c1);
    [self addSubview:_line1];
    
    _vLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, 76.5*WIDTHRADIUS, SCREEN_WIDTH, 9.5*WIDTHRADIUS)];
    _vLine1.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self addSubview:_vLine1];
    


        
        [self createDesc:@"到账金额" withType:@"0"];
        [self createDesc:@"服务费用" withType:@"1"];
        [self.selectedMoneyDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            //   make.top.equalTo(self.mas_top).with.offset(20);
            //  make.centerX.equalTo(self.mas_centerX);
            make.top.mas_equalTo(@(52*WIDTHRADIUS));
            make.left.mas_equalTo(@0);
            make.width.equalTo([NSNumber numberWithFloat:SCREEN_WIDTH/2]);
            make.height.mas_equalTo(@(12*WIDTHRADIUS));
            
        }];
        [self.selectedMoneyDesc setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _lblServeMoney.textAlignment = NSTextAlignmentCenter;
        [self.moneyDescription mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vLine1.mas_bottom).with.offset(15*WIDTHRADIUS);
            make.centerX.equalTo(self.selectedMoney.mas_centerX);
        }];
        

        [self.selectedMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.moneyDescription.mas_bottom).with.offset(15*WIDTHRADIUS);
            make.centerX.equalTo(self.mas_centerX);
        }];
        [self.selectedMoney setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        

        
//        [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left).with.offset(MARGIN);
//            make.right.equalTo(self.mas_right).with.offset(-MARGIN);
//            make.top.equalTo(self.selectedMoney.mas_bottom).with.offset(20);
//        }];
        [self.ruler mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(MARGIN);
            make.right.equalTo(self.mas_right).with.offset(-MARGIN);
            make.top.equalTo(self.selectedMoney.mas_bottom).with.offset(20*WIDTHRADIUS);
            make.height.mas_equalTo(35*WIDTHRADIUS);
        }];
//        
//        _vMoney = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-1, 0, 2, 35)];
//        [_vMoney mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.ruler.mas_bottom);
//        }];
//        _vMoney.backgroundColor = UIColorFromRGB(0xf2a311);
        
        [_vMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCREEN_WIDTH/2-1);
            make.bottom.equalTo(self.ruler.mas_bottom);
            make.width.mas_equalTo(2);
            make.height.mas_equalTo(35*WIDTHRADIUS);
        }];
        
        [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(MARGIN);
            make.right.equalTo(self.mas_right).with.offset(-MARGIN);
            make.top.equalTo(self.ruler.mas_bottom).with.offset(30*WIDTHRADIUS);
            if (iPhone5) {
            make.bottom.equalTo(@(-20)).priorityMedium();
            }else{
             make.bottom.equalTo(@(-25)).priorityMedium();
            }

        }];
#pragma mark  --添加七天 添加七天-
        [self.sevenDaysView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-MARGIN);
            make.top.equalTo(self.ruler.mas_bottom).with.offset(10);
            if (iPhone5) {
                make.bottom.equalTo(@(-20)).priorityMedium();
            }else{
                make.bottom.equalTo(@(-25)).priorityMedium();
            }
            
        }];
        
        
        
        
        [self.imvIocn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
}

- (UIButton *)checkFee {
    
    if (!_checkFee) {
        _checkFee = [[UIButton alloc] init];
        
        [_checkFee setImage:ImageNamed(@"home_GTH") forState:UIControlStateNormal];
        [_checkFee addTarget:self action:@selector(checkBorrowFee) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkFee;
}

- (void)checkBorrowFee {
       !self.applyOrCheckFeeBlock ? : self.applyOrCheckFeeBlock(NO);
    
}


-(void)createDesc:(NSString*)strDesc withType:(NSString*)strType{
    UILabel *lblDesc = [UILabel getLabelWithFontSize:13 textColor:UIColorFromRGB(0x666666) superView:self masonrySet:^(UILabel *view, MASConstraintMaker *make) {
        view.text = strDesc;
        if ([strType isEqualToString:@"0"]) {
            make.top.equalTo(self.mas_top).offset((25*WIDTHRADIUS));
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(SCREEN_WIDTH/2);
            
        }else if ([strType isEqualToString:@"1"]) {
            make.top.equalTo(self.mas_top).offset((25*WIDTHRADIUS));
            make.left.mas_equalTo(SCREEN_WIDTH/2);
            make.width.mas_equalTo(SCREEN_WIDTH/2);
            
            
        }
        make.height.mas_equalTo(@(14*WIDTHRADIUS));
    }];
    lblDesc.textAlignment = NSTextAlignmentCenter;
    
    if ([strType isEqualToString:@"1"]) {
        [self.checkFee mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lblDesc.mas_centerY);
            make.left.equalTo(lblDesc.mas_centerX).offset(15);
            make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(40, 40*WIDTHRADIUS)]);
        }];
    }
}
#pragma mark - Public
- (NSDictionary *)selectedDicionary {
//     if( (self.entity.amountInfo.amounts.count) > self.sliderValue){
//        return @{@"money":@([self.entity.amountInfo.amounts[self.sliderValue] integerValue]/100), @"period":[self.dateView selectedDay]};
//     }
//    return @{@"money":@(0), @"period":[self.dateView selectedDay]};
    
    
    
    if( (self.entity.amountInfo.amounts.count) > self.sliderValue){
        return @{@"money":@([self.entity.amountInfo.amounts[self.sliderValue][@"amount"] integerValue]/100), @"period":self.entity.amountInfo.days.firstObject};
    }
    return @{@"money":@(0), @"period":self.entity.amountInfo.days.firstObject};
    
    
    
}


#pragma mark - Private
//- (void)dataValueDidChange {
//    
//    if (self.sliderValue != [self.slider moneyIndex]) {
//        
//        self.sliderValue = [self.slider moneyIndex];
//    }
//}
//- (void)touchesCancel {
//    
//    [self.slider setValue:self.sliderValue animated:YES];
//}
- (NSAttributedString *)changeYuanSize:(NSString *)str {
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:str];
    
    [result addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:[str rangeOfString:@"元"]];
    return result;
}

- (NSInteger)sliderMaxValueWithArray:(NSArray<NSDictionary *> *)arr {
    
    NSMutableArray *marr = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        [marr addObject:dic[@"amount"]];
    }
    
    NSSet *tmpSet = [NSSet setWithArray:marr];
    
    NSInteger result = [tmpSet count];
    
    for (NSString *str in tmpSet) {
        if (0 != str.integerValue%(100*100)) {
            result -= 1;
        }
    }
    
    return result-1;
}

#pragma mark - Setter
- (void)setEntity:(HomeModel *)entity {
    
    _entity = entity;
    
    self.sliderValue = [self sliderMaxValueWithArray:_entity.amountInfo.amounts];
    NSInteger diff;
    if (_entity.amountInfo.amounts.count>1) {
       diff = [_entity.amountInfo.amounts[1][@"amount"] integerValue]/100 - [_entity.amountInfo.amounts[0][@"amount"]integerValue]/100;
        [[NSUserDefaults standardUserDefaults]setInteger:diff forKey:@"DIFF"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }else{
        if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DIFF"]>0) {
            diff = [[NSUserDefaults standardUserDefaults]integerForKey:@"DIFF"];
        }else{
            diff = 500;
        }
    }
        [self.ruler show:[[entity.amountInfo.amounts firstObject][@"amount"] integerValue] / 100 maxValue:[[entity.amountInfo.amounts lastObject][@"amount"] integerValue] / 100 interval:diff];
    self.moneyDescription.text = 1 == self.entity.item.verify_loan_pass.integerValue ? @"借款金额（元）" : @"借款金额（元）";//@"可借额度" : @"最高借款额度"
    __weak typeof(self)weakSelf = self;
    _ruler.valueDidChange = ^(NSString * currentValue) {
//        NSLog(@"。。。。。。。。。。%ld,。。。。。。。。%ld",self.entity.amountInfo.amounts.count, self.sliderValue);
        if((self.entity.amountInfo.amounts.count) > self.sliderValue){
            if (self.entity.amountInfo.amounts.count!=0) {
                if( (self.entity.amountInfo.amounts.count) > self.sliderValue){
                    //账户管理费 ： accountManage 利息 accrual  信审creditVet  代收通道collectionChannel   平台使用费platformUse
                    CGFloat amount = [weakSelf.entity.amountInfo.amounts[weakSelf.sliderValue][@"amount"] integerValue];//滑块滑动的位置
                    NSInteger maxAmount = [weakSelf.entity.amountInfo.amounts.lastObject[@"amount"] integerValue];//后台返回最大可借款金额
                    //计算费率
                    CGFloat accrualM = [weakSelf.entity.amountInfo.amounts[weakSelf.sliderValue][@"accrual"] integerValue]/maxAmount * amount;//利息
                    CGFloat accountManageM = [weakSelf.entity.amountInfo.amounts[weakSelf.sliderValue][@"accountManage"] integerValue]/maxAmount *amount;//账户管理
                    CGFloat  creditVetM  = [weakSelf.entity.amountInfo.amounts[weakSelf.sliderValue][@"creditVet"] integerValue]/maxAmount *amount;//信审
                    CGFloat collectionChannelM  = [weakSelf.entity.amountInfo.amounts[weakSelf.sliderValue][@"collectionChannel"] integerValue]/maxAmount * amount;//代收通道费
                    CGFloat  platformUseM = [weakSelf.entity.amountInfo.amounts[weakSelf.sliderValue][@"platformUse"] integerValue]/maxAmount *amount;//平台使用费

                    CGFloat allM = accrualM + accountManageM + creditVetM + collectionChannelM + platformUseM;
                    
                    
//                    weakSelf.lblServeMoney.attributedText =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f元",allM / 100]];
//                    weakSelf.selectedMoneyDesc.attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f元",(amount - allM) / 100]];
                    weakSelf.lblServeMoney.attributedText =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f元",[weakSelf.entity.amountInfo.amounts[weakSelf.sliderValue][@"totalFee"]floatValue] / 100]];
                    weakSelf.selectedMoneyDesc.attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f元",[weakSelf.entity.amountInfo.amounts[weakSelf.sliderValue][@"arrivalMoney"]floatValue] / 100]];
               }
            }else{
                //        NSDecimalNumber *maxAmount = [[NSDecimalNumber alloc] initWithString:[weakSelf.entity.amountInfo.amounts lastObject]];
                //        NSDecimalNumber *interest = [[NSDecimalNumber alloc] initWithString:self.entity.amountInfo.interests[[self.dateView selectedIndex]]];
                //        NSDecimalNumber *fee = [[interest decimalNumberByMultiplyingBy:amount] decimalNumberByDividingBy:maxAmount];
                weakSelf.lblServeMoney.attributedText =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"0.00元"]];//[self changeYuanSize:[NSString stringWithFormat:@"%.2f元",7000.00/100+sliderValue]];//[fee doubleValue]
            }
       
        
            weakSelf.selectedMoney.attributedText = [weakSelf changeYuanSize:[NSString stringWithFormat:@"%li元", [currentValue integerValue]]];
            ;
    //        weakSelf.selectedMoneyDesc.attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%li元", [currentValue integerValue]]];//[weakSelf changeYuanSize:[NSString stringWithFormat:@"%li元", [currentValue integerValue]]];
            weakSelf.sliderValue = [self sliderMaxValueWithArray:entity.amountInfo.amounts]-([[entity.amountInfo.amounts lastObject][@"amount"] integerValue] / 100-[currentValue integerValue])/diff;
//            NSLog(@"sdhfjkadsfadsfhkdhkkkhk %li %li %li %li",[weakSelf sliderMaxValueWithArray:entity.amountInfo.amounts],[[entity.amountInfo.amounts lastObject][@"amount"] integerValue] / 100,[currentValue integerValue],([[entity.amountInfo.amounts lastObject][@"amount"] integerValue] / 100-[currentValue integerValue])/100);
           
            if( (self.entity.amountInfo.amounts.count) > self.sliderValue){
            !weakSelf.moneyDidChange ? : weakSelf.moneyDidChange([weakSelf.entity.amountInfo.amounts[weakSelf.sliderValue][@"amount"] integerValue], [weakSelf.dateView selectedIndex]);
            }
      }
    };
//    self.selectedMoney.attributedText = [self changeYuanSize:[NSString stringWithFormat:@"%li", [self.entity.amountInfo.amounts[[self.slider moneyIndex]] integerValue]/100]];
//    
//        self.selectedMoneyDesc.attributedText = [self changeYuanSize:[NSString stringWithFormat:@"%li元", [self.entity.amountInfo.amounts[[self.slider moneyIndex]] integerValue]/100]];
}
//
- (void)setSliderValue:(NSInteger)sliderValue {
    _sliderValue = sliderValue;

    NSLog(@"----000-----%lu", (unsigned long)[self.dateView selectedIndex]);

    if (self.entity.amountInfo.amounts.count!=0) {
       
        if( (self.entity.amountInfo.amounts.count) > self.sliderValue){
            CGFloat amount = [self.entity.amountInfo.amounts[self.sliderValue][@"amount"] integerValue];//滑块滑动的位置
            NSInteger maxAmount = [self.entity.amountInfo.amounts.lastObject[@"amount"] integerValue];//后台返回最大可借款金额
            //计算费率
            CGFloat accrualM = [self.entity.amountInfo.amounts[self.sliderValue][@"accrual"] floatValue]/maxAmount * amount;//利息
            CGFloat accountManageM = [self.entity.amountInfo.amounts[self.sliderValue][@"accountManage"]floatValue]/maxAmount *amount;//账户管理
            CGFloat  creditVetM  = [self.entity.amountInfo.amounts[self.sliderValue][@"creditVet"] floatValue]/maxAmount *amount;//信审
            CGFloat collectionChannelM  = [self.entity.amountInfo.amounts[self.sliderValue][@"collectionChannel"]floatValue]/maxAmount * amount;//代收通道费
            CGFloat  platformUseM = [self.entity.amountInfo.amounts[self.sliderValue][@"platformUse"] floatValue]/maxAmount *amount;//平台使用费
            
            CGFloat allM = accrualM + accountManageM + creditVetM + collectionChannelM + platformUseM;
            
            
            self.lblServeMoney.attributedText =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f元",[self.entity.amountInfo.amounts[self.sliderValue][@"totalFee"]floatValue]/ 100]];
            self.selectedMoneyDesc.attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f元",[self.entity.amountInfo.amounts[self.sliderValue][@"arrivalMoney"]floatValue]/100]];
        }

    }else{
        self.lblServeMoney.attributedText =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"0.00元"]];//[self changeYuanSize:[NSString stringWithFormat:@"%.2f元",7000.00/100+sliderValue]];//[fee doubleValue]
    }
     if( (self.entity.amountInfo.amounts.count) > self.sliderValue){
        !self.moneyDidChange ? : self.moneyDidChange([self.entity.amountInfo.amounts[sliderValue][@"amount"] integerValue], [self.dateView selectedIndex]);
     }
}

#pragma mark - Getter
- (UICountingLabel *)selectedMoney {
    
    if (!_selectedMoney) {
        _selectedMoney = [[UICountingLabel alloc] init];
          //首页借款金额字体颜色
        _selectedMoney.textColor = Color_Red;//Color_Red_New;
        _selectedMoney.font = FontBoldSystem(30);
        _selectedMoney.attributedText = [self changeYuanSize:@"0"];
        [_selectedMoney sizeToFit];
        
        @Weak(self)
        _selectedMoney.attributedFormatBlock = ^(CGFloat value) {
            @Strong(self)
            
            return [self changeYuanSize:[NSString stringWithFormat:@"%li元", (long)value]];
        };
    }
    return _selectedMoney;
}

- (UICountingLabel *)selectedMoneyDesc {
    
    if (!_selectedMoneyDesc) {
        _selectedMoneyDesc = [[UICountingLabel alloc] init];
      
        _selectedMoneyDesc.textColor = UIColorFromRGB(0x666666);//Color_Red_New;
        _selectedMoneyDesc.font = FontSystem(11);
        _selectedMoneyDesc.attributedText = [[NSMutableAttributedString alloc] initWithString:@"0.00元"];//[self changeYuanSize:@"5000元"];
        _selectedMoneyDesc.textAlignment = NSTextAlignmentCenter;
        [_selectedMoneyDesc sizeToFit];
        
        @Weak(self)
        _selectedMoneyDesc.attributedFormatBlock = ^(CGFloat value) {
            @Strong(self)
            
            return [self changeYuanSize:[NSString stringWithFormat:@"%li元", (long)value]];
        };
    }
    return _selectedMoneyDesc;
}

- (UILabel *)moneyDescription {
    
    if (!_moneyDescription) {
        _moneyDescription = [[UILabel alloc] init];
        
        _moneyDescription.textColor = [UIColor colorWithHex:0x666666];
        _moneyDescription.font = [UIFont systemFontOfSize:14];
        _moneyDescription.text = @"借款金额（元）";// @"可借额度"
    }
    return _moneyDescription;
}
//- (HeightenSlider *)slider {
//    
//    if (!_slider) {
//        _slider = [[HeightenSlider alloc] init];
//        
//        [_slider setThumbImage:[UIImage imageNamed:@"thumb_slide"] forState:UIControlStateNormal];
//        _slider.minimumTrackTintColor = [UIColor colorWithHex:0xFCC225];
//        _slider.maximumTrackTintColor = [UIColor lightGrayColor];
//        [_slider addTarget:self action:@selector(dataValueDidChange) forControlEvents:UIControlEventValueChanged];
//        [_slider addTarget:self action:@selector(touchesCancel) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _slider;
//}
-(GraduationView *)ruler{
    if (!_ruler) {
        _ruler = [[GraduationView alloc] init];
        _ruler.frame = CGRectMake(0, 30*WIDTHRADIUS, SCREEN_WIDTH, 70*WIDTHRADIUS);
    }
    return _ruler;
}


-(HomeOnlySevenDayView *)sevenDaysView{

    if (!_sevenDaysView) {
        _sevenDaysView = [[HomeOnlySevenDayView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 55*WIDTHRADIUS)];
        _sevenDaysView.backgroundColor = [UIColor whiteColor];
    }

    return _sevenDaysView;


}



//借款选择七天十四天
- (SelectedDateView *)dateView {
    
    if (!_dateView) {
        _dateView = [[SelectedDateView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55*WIDTHRADIUS)];
        
        @Weak(self)
        _dateView.selectedDayDidChange = ^(SelectedDateView *dateView) {
            @Strong(self)
            self.sliderValue = self.sliderValue;
        };
    }
    return _dateView;
}

-(UIView *)vMoney{
    if (!_vMoney) {
        _vMoney = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-1, 0, 2, 35*WIDTHRADIUS)];
        //_vMoney.backgroundColor = UIColorFromRGB(0xf2a311);
        //选择贷款金额尺度线颜色
        _vMoney.backgroundColor = Color_Red;
    }
    return _vMoney;
}
-(UIImageView *)imvIocn{
    if (!_imvIocn) {
        _imvIocn = [[UIImageView alloc]init];
    }
    _imvIocn.image = ImageNamed(@"home_JC");
    return _imvIocn;
}

@end
