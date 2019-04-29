//
//  EventCalendar.h
//  app添加到手机日历提醒事件
//
//  Created by 刘燕鲁 on 16/12/27.
//  Copyright © 2016年 刘燕鲁. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol EventCalendarDelegate <NSObject>

- (void)updateStateOfButton:(BOOL)successOrError;
@end

@interface EventCalendar : NSObject

@property (nonatomic, weak) id<EventCalendarDelegate> delegate;

+ (instancetype)sharedEventCalendar;

+ (BOOL)checkHaveValue;

//检查日历是否同意或者还未申请权限
+ (BOOL)checkEventStoreAccessForCalendarOrNotDetermined;

/**
 *  将App事件添加到系统日历提醒事项，实现闹铃提醒的功能
 *
 *  @param title      事件标题
 *  @param location   事件位置
 *  @param startDate  开始时间
 *  @param endDate    结束时间
 *  @param allDay     是否全天
 *  @param alarmArray 闹钟集合
 */

- (void)createEventCalendarTitle:(NSString *)title location:(NSString *)location startDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)allDay alarmArray:(NSArray *)alarmArray;

- (BOOL)loadEventstartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

@end
