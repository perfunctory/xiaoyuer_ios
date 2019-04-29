//
//  NotificationService.m
//  NotificationService
//
//  Created by 童欣凯 on 2018/3/16.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "NotificationService.h"
#import <GTExtensionSDK/GeTuiExtSdk.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService


- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    //使用 handelNotificationServiceRequest 上报推送送达数据。
//    [GeTuiExtSdk handelNotificationServiceRequest:request withComplete:^{
//
//        //注意：是否修改下发后的title内容以项目实际需求而定
//        //self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [需求而定]", self.bestAttemptContent.title];
//
//        // 待展示推送的回调处理需要放到回执完成的回调中
//        self.contentHandler(self.bestAttemptContent);
//    }];
    
    [GeTuiExtSdk handelNotificationServiceRequest:request withAttachmentsComplete:^(NSArray *attachments, NSArray* errors) {

        //注意：是否修改下发后的title内容以项目实际需求而定
        //self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [需求而定]", self.bestAttemptContent.title];

        self.bestAttemptContent.attachments = attachments; //设置通知中的多媒体附件

        NSLog(@"个推处理APNs消息遇到错误：%@",errors); //如果APNs处理有错误，可以在这里查看相关错误详情

        self.contentHandler(self.bestAttemptContent); //展示推送的回调处理需要放到个推回执完成的回调中
    }];
}

//NotificationService处理超时时系统调用
- (void)serviceExtensionTimeWillExpire {
    
    //销毁SDK，释放资源
    [GeTuiExtSdk destory];
    //结束 NotificationService 调用
    self.contentHandler(self.bestAttemptContent);
}


@end
