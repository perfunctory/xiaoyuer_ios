//
//  VerifyListModel.h
//  XianjinXia
//
//  Created by sword on 10/02/2017.
//  Copyright © 2017 lxw. All rights reserved.
//

#import "BaseModel.h"

@interface VerifyListModel : BaseModel

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSAttributedString *operators;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSNumber *status;
@property (nonatomic, copy) NSAttributedString *title_mark;

- (instancetype)initWithDictionary:(NSDictionary *)aDic;
+ (instancetype)verifyListModelWithDictionary:(NSDictionary *)aDic;

@end
