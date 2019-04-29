//
//  CountDownBottomView.m
//  XianjinXia
//
//  Created by sword on 2017/3/1.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "CountDownBottomView.h"
#import "EventCalendar.h"

@interface CountDownBottomView ()<EventCalendarDelegate>

@property (strong, nonatomic) UIButton *alertBorrow;

@end

@implementation CountDownBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.alertBorrow];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.alertBorrow.translatesAutoresizingMaskIntoConstraints) {

        [self.alertBorrow mas_makeConstraints:^(MASConstraintMaker *make) {
            if (iPhone5) {
                make.top.equalTo(self.mas_top).with.offset(16);
                make.bottom.equalTo(self.mas_bottom).with.offset(-16).priorityMedium();
            }else{
            make.top.equalTo(self.mas_top).with.offset(40);
            make.bottom.equalTo(self.mas_bottom).with.offset(-25).priorityMedium();
            }
            make.left.equalTo(self.mas_left).with.offset(40);
            make.right.equalTo(self.mas_right).with.offset(-40);

            make.height.equalTo(@40);
        }];
    }
}

- (void)setEntity:(HomeModel *)entity {
    _entity = entity;
    
    if (0 != [entity.item.next_loan_day integerValue]) {
        self.alertBorrow.enabled = ![EventCalendar checkHaveValue];
        [self.alertBorrow setImage: ImageNamed(@"remind_borrow") forState:UIControlStateNormal];
        [self.alertBorrow setTitle: [EventCalendar checkHaveValue] ? @" 已添加提醒" : @" 提醒我" forState:UIControlStateNormal];
    } else {
        self.alertBorrow.enabled = YES;
        [self.alertBorrow setImage: nil forState:UIControlStateNormal];
        [self.alertBorrow setTitle: @"现在就还" forState:UIControlStateNormal];
    }
}

- (void)alert {
    
    if (0 != [self.entity.item.next_loan_day integerValue]) {
        
        if ([EventCalendar checkEventStoreAccessForCalendarOrNotDetermined]) {

            [self loadUserBorrowMoneyData:[self getCanBorrowMoenyDay:[self.entity.item.next_loan_day integerValue]]];
        } else {
            [self openCalendar];
        }
    } else {
        if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UITabBarController class]]) {
             [UserDefaults setObject:@"2" forKey:@"Setp"];
            [(UITabBarController *)([UIApplication sharedApplication].keyWindow.rootViewController) setSelectedIndex:1];
        }
    }
}

- (NSString *)getCanBorrowMoenyDay:(NSInteger )day{

    NSDate*nowDate = [NSDate date];
    NSDate* theDate;
    NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
    theDate = [nowDate initWithTimeIntervalSinceNow: + oneDay*day];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    return  [dateFormatter stringFromDate:theDate];
}

#pragma mark --  日历模块
- (void)openCalendar{
    DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:@"你还未打开日历权限" leftButtonTitle:@"取消" rightButtonTitle:@"去设置"];
    alert.rightBlock = ^{
        [[ApplicationUtil sharedApplicationUtil] gotoSettings];
    };
    [alert show];
    return;
}
- (void)loadUserBorrowMoneyData:(NSString *)dataStr{
    
    EventCalendar *calendar = [EventCalendar sharedEventCalendar];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
    
    NSDate *date = [dateFormat dateFromString:dataStr];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    //取出日期中的月份和日期
    [dateFormat setDateFormat:@"MM"];
    NSInteger currentMonth=[[dateFormat stringFromDate:localeDate]integerValue];
    [dateFormat setDateFormat:@"dd"];
    NSInteger currentDay=[[dateFormat stringFromDate:localeDate] integerValue];
    calendar.delegate = self;
    [calendar createEventCalendarTitle:@"借款提醒" location:[NSString stringWithFormat:@"明日%ld月%ld日  信合宝明日可继续借款",currentMonth,currentDay] startDate:[NSDate dateWithTimeInterval:7200 sinceDate:localeDate] endDate:[NSDate dateWithTimeInterval:43200 sinceDate:localeDate] allDay:NO alarmArray:@[@"-86400"] ];
    
}

- (UIButton *)alertBorrow {
    
    if (!_alertBorrow) {
        _alertBorrow = [[UIButton alloc] init];
        _alertBorrow.titleLabel.font = [UIFont systemFontOfSize:18];
        [_alertBorrow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_alertBorrow setBackgroundImage:[UIImage imageNamed:@"button_red_background"] forState:UIControlStateNormal];
        [_alertBorrow setBackgroundImage:[UIImage imageNamed:@"button_gray_background"] forState:UIControlStateDisabled];
        [_alertBorrow setImage:ImageNamed(@"remind_borrow") forState:UIControlStateNormal];
        [_alertBorrow setTitle:@" 提醒我" forState:UIControlStateNormal];
        [_alertBorrow addTarget:self action:@selector(alert) forControlEvents:UIControlEventTouchUpInside];
    }
    return _alertBorrow;
}

- (void)updateStateOfButton:(BOOL)successOrError{

    //改变button状态
    if (successOrError) {
        self.alertBorrow.enabled = NO;
        [self.alertBorrow setImage:ImageNamed(@"remind_borrow") forState:UIControlStateNormal];
        [self.alertBorrow setTitle:@" 已添加提醒" forState:UIControlStateNormal];
    }
}


@end
