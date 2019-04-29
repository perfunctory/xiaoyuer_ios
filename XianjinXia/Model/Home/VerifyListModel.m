//
//  VerifyListModel.m
//  XianjinXia
//
//  Created by sword on 10/02/2017.
//  Copyright © 2017 lxw. All rights reserved.
//

#import "VerifyListModel.h"

@implementation VerifyListModel

- (instancetype)initWithDictionary:(NSDictionary *)aDic {
    
    if (self = [super init]) {
        _operators  = [self convertToAttributedString:aDic[@"operator"]];
        _title_mark = [self convertToAttributedString:aDic[@"title_mark"]];
        _type       = aDic[@"type"];
        _title      = aDic[@"title"];
        _subtitle   = aDic[@"subtitle"];
        _tag        = aDic[@"tag"];
        _logo       = aDic[@"logo"];
        _url        = aDic[@"url"];
        _status     = aDic[@"status"];
    }
    return self;
}
+ (instancetype)verifyListModelWithDictionary:(NSDictionary *)aDic {
    
    return [[[self class] alloc] initWithDictionary:aDic];
}

- (NSAttributedString *)convertToAttributedString:(NSString *)string {
    
    return [[NSAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
}

@end
