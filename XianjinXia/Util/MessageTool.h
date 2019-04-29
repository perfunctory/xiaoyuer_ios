//
//  MessageTool.h
//  
//
//  Created by liu xiwang on 2017/3/7.
//  Copyright © 2017年 liu xiwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageTool : NSObject

+ (MessageTool *)sharedManager;

-(void)sendMessagePhone:(NSString *)strPhone  withMessageContent:(NSString*)strContent;

@end
