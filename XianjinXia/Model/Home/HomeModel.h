//
//  HomeModel.h
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/7.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseModel.h"

@interface HomeBorrowStateModel : BaseModel

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *tag;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)homeBorrowStateWithDict:(NSDictionary *)dict;
@end

@interface HomeButtonModel : BaseModel

@property (nonatomic, retain) NSString *msg;
@property (nonatomic, retain) NSString *ids;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)homeButtonModelWithDict:(NSDictionary *)dict;
@end

@interface HomeBorrowStateListModel : BaseModel

@property (nonatomic, retain) NSArray <HomeBorrowStateModel *>*lists;
@property (nonatomic, retain) NSString *header_tip;
@property (nonatomic, retain) NSString *loanEndTime; /**<  应还款时间 */
@property (nonatomic, retain) NSString *lastRepaymentD;
@property (nonatomic, retain) HomeButtonModel *button;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)homeBorrowStateListWithDict:(NSDictionary *)dict;
@end

@interface AmountInfoModel : BaseModel
@property (nonatomic, strong) NSArray * amounts;
@property (nonatomic, strong) NSArray * days;
@property (nonatomic, strong) NSArray * interests;
@property (nonatomic, strong) NSArray * managementFee;
@property (nonatomic, strong) NSArray * enquiryFee;
//新添加数组
@property (nonatomic,strong)  NSArray * accountManage;//账户管理
@property (nonatomic,strong)  NSArray *  accrual;//利息
@property (nonatomic,strong)  NSArray *  creditVet;//信审
@property (nonatomic,strong)  NSArray *  collectionChannel;//代收通道
@property (nonatomic,strong)  NSArray *  platformUse;//平台使用



- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)DayListWithDict:(NSDictionary *)dict;
@end

@interface ItemModel : BaseModel
@property (nonatomic, copy) NSString * card_amount;
@property (nonatomic, copy) NSString * card_title;
@property (nonatomic, copy) NSString * card_verify_step;
@property (nonatomic, copy) NSString * verify_loan_nums;
@property (nonatomic, copy) NSString * verify_loan_pass;
@property (nonatomic, copy) NSString * next_loan_day;


//添加风控状态
@property (nonatomic, copy) NSString * risk_status;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)itemWithDict:(NSDictionary *)dict;
@end

@interface ActivityModel : BaseModel
@property (nonatomic, copy) NSString * reurl;
@property (nonatomic, copy) NSString * sort;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * url;

+ (instancetype)imageModelWithDict:(NSDictionary *)dict;

@end

@interface HomeModel : BaseModel

@property (nonatomic, strong) HomeBorrowStateListModel *borrowStateList;
@property (nonatomic, strong) AmountInfoModel * amountInfo;
@property (nonatomic, strong) NSMutableArray  <ActivityModel *> *activities;
@property (nonatomic, strong) ItemModel * item;
@property (nonatomic, copy) NSString * today_last_amount;
@property (nonatomic, strong) NSArray * user_loan_log_list;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)DayListWithDict:(NSDictionary *)dict;

@end
