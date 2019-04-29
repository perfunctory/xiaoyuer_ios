//
//  KDAscendingUpLoadVC.h
//  KDIOSApp
//
//  Created by appleMac on 16/5/7.
//  Copyright © 2016年 KDIOSApp. All rights reserved.
//

#import "BaseViewController.h"

//上传照片的类型
//	1:身份证,2:学历证明,3:工作证明,4:收入证明,5:财产证明,6、工牌照片、7、个人名片，8、银行卡 9:好房贷房产证 10:人脸识别,11:身份证正面,12:身份证 100:其它证明
typedef NS_ENUM(NSInteger, uploadImgType){
    IdCard = 1,
    Certificate,
    Work,
    Salary,
    Property,
    workCard,
    personCard,
    bankCard,
    house,
    face,
    cardFront,
    cardBack,
    Others=100
};

@interface KDAscendingUpLoadVC : BaseViewController

@property (nonatomic, copy) void (^uploadImgSuccss)(void);

- (instancetype)initWithType:(uploadImgType)type;

- (void)getPageData;

@end
