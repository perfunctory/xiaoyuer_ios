//
//  MessageTool.m
//
//
//  Created by liu xiwang on 2017/3/7.
//  Copyright © 2017年 liu xiwang. All rights reserved.
//

#import "MessageTool.h"
#import <MessageUI/MessageUI.h>

@interface MessageTool()<MFMessageComposeViewControllerDelegate>


@end

@implementation MessageTool

+ (MessageTool *)sharedManager
{
    static MessageTool *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

-(void)sendMessagePhone:(NSString *)strPhone  withMessageContent:(NSString*)strContent{
    if([MFMessageComposeViewController canSendText]){
        
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init]; //autorelease];
        
        controller.recipients = [NSArray arrayWithObject:strPhone];
        
        controller.body = strContent;
        
        controller.messageComposeDelegate = self;
        
        UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        [rootViewController presentViewController:controller animated:YES completion:nil];
    }else{
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"该设备不支持短信功能" preferredStyle:UIAlertControllerStyleAlert];
        UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        UIAlertAction *btn2 = [UIAlertAction actionWithTitle:@"确定"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnullaction) {
            
        }];
        [alter addAction:btn2];
        [rootViewController presentViewController:alter animated:YES completion:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result

{
    [controller dismissViewControllerAnimated:NO completion:nil];//关键的一句   不能为YES
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    NSString *strMessage;
    switch (result){
        case MessageComposeResultCancelled:{
            strMessage = @"取消发送";
            //click cancel button
        }
            break;
            
        case MessageComposeResultFailed:{
            strMessage = @"发送失败";
        }
            break;
            
        case MessageComposeResultSent:{
            strMessage = @"发送成功";
            //do something
            
        }
            break;
            
        default:
            
            break;
    }
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:nil message:strMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *btn2 = [UIAlertAction actionWithTitle:@"确定"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnullaction) {
        
    }];
    [alter addAction:btn2];
    [rootViewController presentViewController:alter animated:YES completion:nil];
}

@end
