//
//  EventCalendar.m
//  app添加到手机日历提醒事件
//
//  Created by 刘燕鲁 on 16/12/27.
//  Copyright © 2016年 刘燕鲁. All rights reserved.
//

#import "EventCalendar.h"
#import <EventKit/EventKit.h>
#import <UIKit/UIKit.h>


@interface EventCalendar()<UIAlertViewDelegate>

@end

@implementation EventCalendar {
    
    EKEventStore *_eventStore;
}
static EventCalendar *calendar;

+ (instancetype)sharedEventCalendar {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [[EventCalendar alloc] init];
    });
    return calendar;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [super allocWithZone:zone];
    });
    return calendar;
}

- (void)createEventCalendarTitle:(NSString *)title location:(NSString *)location startDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)allDay alarmArray:(NSArray *)alarmArray{
    
    @Weak(self)
    _eventStore = [[EKEventStore alloc] init];
    [_eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error){
        @Strong(self)
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error || !granted) {
                [self.delegate updateStateOfButton:NO];
            } else {
                
                EKEvent *event  = [EKEvent eventWithEventStore:_eventStore];
                event.title     = title;
                event.location = location;
                
                NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
                [tempFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
                
                event.startDate = startDate;
                event.endDate   = endDate;
                event.allDay = allDay;
                //添加提醒
                if (alarmArray && alarmArray.count > 0) {
                    
                    for (NSString *timeString in alarmArray) {
                        [event addAlarm:[EKAlarm alarmWithRelativeOffset:[timeString integerValue]]];
                    }
                }
                
                [event setCalendar:[_eventStore defaultCalendarForNewEvents]];
                NSError *err;
                [_eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                
                if ([title isEqualToString:@"借款提醒"]) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"NextBorrowCalendar"];
                    [self.delegate updateStateOfButton:YES];
                }
            }
        });
    }];
}

-(BOOL)loadEventstartDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    
    _eventStore = [[EKEventStore alloc] init];
    //获取事件时间段内的事件
    NSPredicate *predicate = [_eventStore predicateForEventsWithStartDate:startDate
                                                                  endDate:endDate
                                                                calendars:nil];
    NSArray *arrayEvents = [_eventStore eventsMatchingPredicate:predicate];
    //    NSMutableArray *eventArrays = [[NSMutableArray alloc]init];
    for (EKEvent *event in arrayEvents) {
        
        if ([event.title isEqualToString:@"借享还款提醒"]) {
            EKCalendar *calendar = event.calendar;
            [_eventStore removeCalendar:calendar commit:YES error:nil];
            return YES;
        }
    }
    return NO;
}

//alertDalegate
+ (BOOL)checkHaveValue{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"NextBorrowCalendar"] isEqualToString:@"YES"]) {
        return YES;
    }else{
        return NO;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"NextBorrowCalendar"];
        
    }
}

+ (BOOL)checkEventStoreAccessForCalendarOrNotDetermined {
    
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    return EKAuthorizationStatusAuthorized == status || EKAuthorizationStatusNotDetermined == status;
}

@end
