//
//  PersonalInformationVC.m
//  XianjinXia
//
//  Created by sword on 2017/2/15.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "PersonalInformationVC.h"

#import <MGLivenessDetection/MGLivenessDetection.h>
#import <MGIDCard/MGIDCard.h>


#import "GDLocationVC.h"

#import "UserManager.h"

#import "CheckImagesCell.h"
#import "InputCell.h"
#import "SelectionCell.h"
#import "PickerCell.h"

#import "VerifyListRequest.h"

#import "KDKeyboardView.h"
#import "NSObject+InitWithDictionary.h"
#import "PersonalInformationModel.h"

#import "XJXPictureBrowser.h"
#import "AlertViewManager.h"
#import "NSString+Calculate.h"


typedef NS_ENUM(NSInteger, kFaceVerifyType) {
    
    kFaceVerifyFace = 10,
    kFaceVerifyCardFront = 11,
    kFaceVerifyCardBack = 12
};

@interface PersonalInformationVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *navBtn;

@property (assign, nonatomic) NSInteger realVerifyState;
@property (strong, nonatomic) PersonalInformationModel *infoModel;
@property (strong, nonatomic) NSDictionary *originInfo; /**< 原来的信息，用以区分信息是否修改 */
@property (assign, nonatomic) BOOL didUploadImage; /**< 是否上传过照片 */

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) VerifyListRequest *request;
@property (strong, nonatomic) NSDictionary *personalInfo;

@property (strong, nonatomic) CheckImagesCell *checkFace;
@property (strong, nonatomic) CheckImagesCell *checkIdCard;
@property (strong, nonatomic) InputCell *realNameInput;
@property (strong, nonatomic) InputCell *cardInput;
@property (strong, nonatomic) SelectionCell *selectAddressCell;
@property (strong, nonatomic) InputCell *detailAddressInput;

@property (strong, nonatomic) InputCell *qqInput;
@property (strong, nonatomic) InputCell *emailInput;

//@property (strong, nonatomic) PickerCell *degrees;
//@property (strong, nonatomic) NSArray *degreesList;
//@property (strong, nonatomic) PickerCell *maritalStatus;
//@property (strong, nonatomic) NSArray *maritalList;
//@property (strong, nonatomic) PickerCell *liveTime;
//@property (strong, nonatomic) NSArray *liveList;

//error info
@property (strong, nonatomic) NSArray<NSString *> *faceError;

@end

@implementation PersonalInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.didUploadImage = NO;
    [self baseSetup:PageGobackTypePop];
    self.title = @"个人信息";
    [self.view addSubview:self.tableView];
    [self.view updateConstraintsIfNeeded];
    
    [self loadData];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    if (self.tableView.translatesAutoresizingMaskIntoConstraints) {
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
        }];
    }
}

- (void)popVC {//覆盖父类方法
    if (self.didUploadImage || [self infoDidChange]) {
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:nil contentText:@"有修改尚未保存，您确定退出" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        alert.rightBlock = ^{
            [self.navigationController popViewControllerAnimated:YES];
        };
        [alert show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//        return self.personalInfo ? 9 : 0;
    return self.personalInfo ? 8 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//        switch (indexPath.row) {
//            case 0:
//                return self.checkFace;
//            case 1:
//                return self.checkIdCard;
//            case 2:
//                return self.realNameInput;
//            case 3:
//                return self.cardInput;
////            case 4:
////                return self.degrees;
//            case 4:
//                return self.selectAddressCell;
//            case 5:
//                return self.detailAddressInput;
//            case 6:
//                return self.maritalStatus;
//            case 7:
//                return self.liveTime;
//
//            default:
//                return [UITableViewCell new];
//        }
    
    switch (indexPath.row) {
        case 0:
            return self.checkFace;
        case 1:
            return self.checkIdCard;
        case 2:
            return self.realNameInput;
        case 3:
            return self.cardInput;
        case 4:
            return self.selectAddressCell;
        case 5:
            return self.detailAddressInput;
        case 6:
            return self.qqInput;
        case 7:
            return self.emailInput;
        default:
            return [UITableViewCell new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (0 == indexPath.row || 1 == indexPath.row) ? 80 : 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (4 == indexPath.row) {
        GDLocationVC *vc = [[GDLocationVC alloc]init];
        vc.address = ^(AMapPOI * model, MAUserLocation* Usermodel){
            
            self.infoModel.latitude = [NSNumber numberWithFloat: model.location.latitude];
            self.infoModel.longitude = [NSNumber numberWithFloat: model.location.longitude];
            self.infoModel.address_distinct = model.name;
            [self.selectAddressCell setSubTitleValue:model.name];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSString *)nameOfValue:(NSInteger)value array:(NSArray<NSDictionary *> *)aArr keyInDictionary:(NSString *)key {
    NSString *result = @"选择";
    
    for (NSInteger i = 0; i < aArr.count; ++i) {
        
        NSDictionary *aDic = aArr[i];
        if ([aDic[key] integerValue] == value) {
            result = aDic[@"name"];
            break;
        }
    }
    return result;
}

#pragma mark - Private
- (void)loadData {
    
    [self showLoading:@""];
    [self.request fetchPersonalInformationWithDictionary:@{} success:^(NSDictionary *dictResult) {
        
        [self hideLoading];
        self.personalInfo = dictResult[@"item"];
        
    } failed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        [self showMessage:errorMsg];
    }];
}

- (void)setPersonalInfo:(NSDictionary *)personalInfo {
    _personalInfo = personalInfo;
    
    self.realVerifyState = [personalInfo[@"real_verify_status"] integerValue];
    
    self.infoModel = [PersonalInformationModel yy_modelWithDictionary:personalInfo];
    self.originInfo = [self getDictionaryData:self.infoModel];
    
    #define RemoveEmptyWithDefaultValue(value, default) 0 != [value length] ? (value) : (default)
    self.checkFace.images = @[RemoveEmptyWithDefaultValue(personalInfo[@"face_recognition_picture"], @"face")];
    self.checkIdCard.images = @[ RemoveEmptyWithDefaultValue(personalInfo[@"id_number_z_picture"], @"card_front"), RemoveEmptyWithDefaultValue(personalInfo[@"id_number_f_picture"],  @"card_back")];
    
    self.realNameInput.inputValue = self.infoModel.name;
    self.cardInput.inputValue = self.infoModel.id_number;
    [self.selectAddressCell setSubTitleValue:self.infoModel.address_distinct];
    [self.detailAddressInput setInputValue:self.infoModel.address];
    
//        self.degreesList = personalInfo[@"degrees_all"];
//        self.degrees.selectDes = [self nameOfValue:[self.infoModel.degrees intValue] array:self.degreesList keyInDictionary:@"degrees"];
//        [self.degrees reloadPickerView];
//        self.maritalList = personalInfo[@"marriage_all"];
//        self.maritalStatus.selectDes = [self nameOfValue:[self.infoModel.marriage intValue] array:self.maritalList keyInDictionary:@"marriage"];
//        [self.maritalStatus reloadPickerView];
//        self.liveList = personalInfo[@"live_time_type_all"];
//        self.liveTime.selectDes = [self nameOfValue:[self.infoModel.live_time_type intValue] array:self.liveList keyInDictionary:@"live_time_type"];
//        [self.liveTime reloadPickerView];
    
    self.qqInput.inputValue = self.infoModel.qq;
    self.emailInput.inputValue = self.infoModel.email;
    
    [self.tableView reloadData];
    self.tableView.tableHeaderView.hidden = NO;
    if (!self.navigationItem.rightBarButtonItem) {
        self.navigationItem.rightBarButtonItem = self.navBtn;
    }
}

- (void)setRealVerifyState:(NSInteger)realVerifyState {
    
    _realVerifyState = realVerifyState;
    self.realNameInput.userInteractionEnabled = 1 != realVerifyState;
    self.cardInput.userInteractionEnabled = 1 != realVerifyState;
    
}

- (void)saveData {
    [self refreshInfoModel];
    
    //校验姓名
    if ([self.infoModel.name isEmptyOrWhitespace] ) {
        [[[DXAlertView alloc]initWithTitle:nil contentText:@"请填写姓名" leftButtonTitle:nil rightButtonTitle:@"确定"] show];
        return;
    }
    
    //校验身份证
    if (![self.infoModel.id_number isValidateIdentityCard]) {
        [[[DXAlertView alloc]initWithTitle:nil contentText:@"请填写有效身份证" leftButtonTitle:nil rightButtonTitle:@"确定"] show];
        return;
    }
    
    //校验地址
    if (![self.infoModel informationIsComplete]) {
        [[[DXAlertView alloc]initWithTitle:nil contentText:[self.infoModel lackOfInformationDescription] leftButtonTitle:nil rightButtonTitle:@"确定"] show];
        return;
    }
    
    //校验QQ
//    if (![self.infoModel.qq isValitadeQQ] ) {
//        [[[DXAlertView alloc]initWithTitle:nil contentText:@"请填写有效QQ号码" leftButtonTitle:nil rightButtonTitle:@"确定"] show];
//        return;
//    }
    
    //校验邮箱
//    if (![self.infoModel.email isValitadeEmail]) {
//        [[[DXAlertView alloc]initWithTitle:nil contentText:@"请填写有效邮箱" leftButtonTitle:nil rightButtonTitle:@"确定"] show];
//        return;
//    }
    
    //保存
    [self showLoading:@""];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.request savePersonmalInfoWithSuburl:self.realVerifyState ? kCreditInfoSavePersonInfo : kCreditCardSavePersonInfo dictionary:[self getDictionaryData:self.infoModel] success:^(NSDictionary *dictResult) {
        [self hideLoading];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        [UserManager sharedUserManager].userInfo.realname = self.infoModel.name;
        self.realVerifyState = YES;
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:nil contentText:dictResult[@"message"] leftButtonTitle:nil rightButtonTitle:@"确定"];
        alert.rightBlock = ^{
            [self.navigationController popViewControllerAnimated:YES];
        };
        [alert show];
    } failed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self showMessage:errorMsg];
    }];
}

- (void)refreshInfoModel {
    self.infoModel.name = self.realNameInput.inputValue;
    self.infoModel.id_number = self.cardInput.inputValue;
    self.infoModel.address = self.detailAddressInput.inputValue;
    self.infoModel.address_distinct = self.selectAddressCell.subTitle.text;
    
    self.infoModel.qq = self.qqInput.inputValue;
    self.infoModel.email = self.emailInput.inputValue;
}

- (BOOL)infoDidChange {
    [self refreshInfoModel];
    return ![self.originInfo isEqual:[self getDictionaryData:self.infoModel]];
}

- (void)startFaceVerify:(kFaceVerifyType)type {
    
    if (![MGLiveManager getLicense]) {
        return;
    }
    //判断是否打开权限
    if (![self isOpenCamera]) {
        //无权限 做一个友好的提示
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:@"请您设置允许信合宝访问您的相机\n设置>隐私>相机！" leftButtonTitle:nil rightButtonTitle:@"确定"];
        alert.rightBlock = ^{
            [[ApplicationUtil sharedApplicationUtil] gotoSettings];
        };
        [alert show];
        
    } else {
        
        if (kFaceVerifyFace == type) {
            [self verifyFace];
        } else {
            [self verifyCard:type];
        }
    }
}

- (BOOL)isOpenCamera {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
        return NO;
    } else {
        return YES;
    }
}

- (void)showButtonImageWithButton:(UIButton *)button {
    
    button.hidden = YES;
    [XJXPictureBrowser showImage:button.imageView.image originFrame:[button.superview convertRect:button.frame toView:[UIApplication sharedApplication].keyWindow] complete:^{
        button.hidden = NO;
    }];
}

#pragma mark -  人脸识别
- (void)verifyFace {
    
    MGLiveManager *manager = [[MGLiveManager alloc] init];
    manager.detectionWithMovier = NO;
    manager.actionCount = 3;
    
    [manager startFaceDecetionViewController:self finish:^(FaceIDData *finishDic, UIViewController *viewController) {
        
        [viewController dismissViewControllerAnimated:YES completion:nil];
        NSData *data = [[finishDic images] valueForKey:@"image_best"];
        [self uploadImageWithData:data type:kFaceVerifyFace success:^(NSDictionary *dictResult, UIImage *image) {
            self.checkFace.images = @[image];
        }];
    } error:^(MGLivenessDetectionFailedType errorType, UIViewController *viewController) {
        
        [viewController dismissViewControllerAnimated:YES completion:nil];
        NSString * str = (self.faceError.count - errorType < 1) ? @"检测失败，请重试" : self.faceError[errorType];
        
        [[[DXAlertView alloc] initWithTitle:nil contentText:str leftButtonTitle:nil rightButtonTitle:@"确定"] show];
        
    }];
    
}

#pragma mark - 身份证识别
- (void)verifyCard:(kFaceVerifyType)type {
    
    MGIDCardManager * manager = [[MGIDCardManager alloc]init];
    
    
    [manager IDCardStartDetection:self IdCardSide: kFaceVerifyCardFront == type ? IDCARD_SIDE_FRONT :IDCARD_SIDE_BACK finish:^(MGIDCardModel *model) {
        
        NSData *data = UIImagePNGRepresentation([model croppedImageOfIDCard]) ? : UIImageJPEGRepresentation([model croppedImageOfIDCard], 0.5);
        [self uploadImageWithData:data type:type success:^(NSDictionary *dictResult, UIImage *image) {
            if (type == kFaceVerifyCardFront) {
                
                [self.realNameInput setInputValue:dictResult[@"name"]];
                [self.cardInput setInputValue:dictResult[@"id_card_number"]];
                self.checkIdCard.images = @[image, self.checkIdCard.images[1]];
            } else {
                self.checkIdCard.images = @[self.checkIdCard.images[0], image];
            }
        }];
    } errr:nil];
}

- (void)uploadImageWithData:(NSData *)imageData type:(kFaceVerifyType)type success:( void(^)(NSDictionary *dictResult, UIImage *image) ) successBlock {
    
    [self showLoading:@""];
    [self.request uploadFaceVerifyImageWithDictionary:@{@"type":[NSNumber numberWithInteger:type]} imageData:imageData fileName:@"imageFile.jpg" key:@"attach" success:^(NSDictionary *dictResult) {
        [self hideLoading];
        
        self.didUploadImage = YES;
        if (successBlock) {
            successBlock(dictResult, [UIImage imageWithData:imageData]);
        }
    } failed:^(NSInteger code, NSString *errorMsg) {
        
        [self hideLoading];
        [self showMessage:errorMsg];
    }];
}

#pragma mark - Getter 懒加载
- (UIBarButtonItem *)navBtn {
    
    if (!_navBtn) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"保存" forState:normal];
        [button setTitleColor:[UIColor whiteColor] forState:normal];
        button.titleLabel.font = Font_Title;
        [button addTarget:self action:@selector(saveData) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _navBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _navBtn;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        _tableView.backgroundColor = Color_Background;
        _tableView.separatorColor = Color_LineColor;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.layoutMargins = UIEdgeInsetsZero;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        header.text = @"    身份认证信息保存后将无法修改，请务必保证正确";
        header.font = Font_SubTitle;
        header.textColor = Color_Title;
        _tableView.tableHeaderView = header;
        _tableView.tableHeaderView.hidden = YES;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (VerifyListRequest *)request {
    
    if (!_request) {
        _request = [[VerifyListRequest alloc] init];
    }
    return _request;
}

#pragma mark -不同类型的cell懒加载-
- (CheckImagesCell *)checkFace {
    
    if (!_checkFace) {
        _checkFace = [[CheckImagesCell alloc] initWithTitle:@"人脸识别"];
        
        _checkFace.images = @[@"face"];
        
        @Weak(self)
        _checkFace.clickImageBlock = ^(NSInteger index, BOOL defaultImage, UIButton *imageButton){
            @Strong(self)
            
            if (self.realVerifyState) {
                [self showButtonImageWithButton:imageButton];
            } else {
                if (!defaultImage) {
                    [AlertViewManager showInViewController:self title:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
                        if (1 == buttonIndex) {
                            [self startFaceVerify:kFaceVerifyFace];
                        } else if (2 == buttonIndex) {
                            [self showButtonImageWithButton:imageButton];
                        }
                    } cancelButtonTitle:@"取消" otherButtonTitles:@"动态人脸识别", @"查看大图", nil];
                } else {
                    [self umengEvent:UmengEvent_Person_Info_Face];
                    [self startFaceVerify:kFaceVerifyFace];
                }
            }
        };
    }
    return _checkFace;
}

- (CheckImagesCell *)checkIdCard {
    
    if (!_checkIdCard) {
        _checkIdCard = [[CheckImagesCell alloc] initWithTitle:@"身份证识别"];
        
        _checkIdCard.images = @[@"card_front", @"card_back"];
        
        @Weak(self)
        _checkIdCard.clickImageBlock = ^(NSInteger index, BOOL defaultImage, UIButton *imageButton){
            @Strong(self)
            
            if (self.realVerifyState) {
                [self showButtonImageWithButton:imageButton];
            } else {
                if (!defaultImage) {
                    [AlertViewManager showInViewController:self title:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
                        if (1 == buttonIndex) {
                            [self startFaceVerify:0 == index ? kFaceVerifyCardFront : kFaceVerifyCardBack];
                        } else if (2 == buttonIndex) {
                            [self showButtonImageWithButton:imageButton];
                        }
                    } cancelButtonTitle:@"取消" otherButtonTitles:0 == index ? @"身份证正面识别" : @"身份证反面识别", @"查看大图", nil];
                } else {
                    if (0 == index) {
                        [self umengEvent:UmengEvent_Person_Info_Idcard_Front];
                    }else{
                        [self umengEvent:UmengEvent_Person_Info_Idcard_Back];
                    }
                    [self startFaceVerify:0 == index ? kFaceVerifyCardFront : kFaceVerifyCardBack];
                }
            }
        };
    }
    return _checkIdCard;
}

- (SelectionCell *)selectAddressCell {
    
    if (!_selectAddressCell) {
        _selectAddressCell = [[SelectionCell alloc] initWithTitle:@"现居地址" subTitle:@""];
    }
    return _selectAddressCell;
}

//- (PickerCell *)degrees {
//
//    if (!_degrees) {
//        _degrees = [[PickerCell alloc] initWithTitle:@"学历" subTitle:@"" selectDes:@"选择"];
//
//        @Weak(self)
//        _degrees.numberOfRow = ^NSInteger{
//            @Strong(self)
//            return self.degreesList.count;
//        };
//        _degrees.stringOfRow = ^(NSInteger row){
//            @Strong(self)
//            return self.degreesList[row][@"name"];
//        };
//        _degrees.didSelectBlock = ^(NSInteger selectedRow) {
//            @Strong(self)
//            self.infoModel.degrees = self.degreesList[selectedRow][@"degrees"];
//            self.degrees.selectDes = self.degreesList[selectedRow][@"name"];
//        };
//    }
//    return _degrees;
//}

- (InputCell *)realNameInput {
    
    if (!_realNameInput) {
        _realNameInput = [[InputCell alloc] initWithTitle:@"姓名" placeholder:@"请输入真实姓名"];
    }
    return _realNameInput;
}

- (InputCell *)cardInput {
    
    if (!_cardInput) {
        _cardInput = [[InputCell alloc] initWithTitle:@"身份证" placeholder:@"请输入身份证号码"];
        
        [KDKeyboardView KDKeyBoardWithKdKeyBoard:KDIDNUM target:self textfield:_cardInput.inputTextField delegate:nil valueChanged:nil];
    }
    return _cardInput;
}

- (InputCell *)detailAddressInput {
    
    if (!_detailAddressInput) {
        _detailAddressInput = [[InputCell alloc] initWithTitle:@"" placeholder:@"请输入详细地址"];
    }
    return _detailAddressInput;
}

-(InputCell *) qqInput{
    if(!_qqInput){
        _qqInput = [[InputCell alloc] initWithTitle:@"QQ" placeholder:@"请输入有效QQ号码"];
    }
    return _qqInput;
}

-(InputCell *) emailInput{
    if (!_emailInput) {
        _emailInput = [[InputCell alloc] initWithTitle:@"邮箱" placeholder:@"请输入有效邮箱"];
    }
    return _emailInput;
}

//- (PickerCell *)maritalStatus {
//
//    if (!_maritalStatus) {
//        _maritalStatus = [[PickerCell alloc] initWithTitle:@"婚姻状态" subTitle:@"(选填)" selectDes:@"选择"];
//
//        @Weak(self)
//        _maritalStatus.numberOfRow = ^NSInteger{
//            @Strong(self)
//            return self.maritalList.count;
//        };
//        _maritalStatus.stringOfRow = ^(NSInteger row){
//            @Strong(self)
//            return self.maritalList[row][@"name"];
//        };
//        _maritalStatus.didSelectBlock = ^(NSInteger selectedRow) {
//            @Strong(self)
//            self.infoModel.marriage = self.maritalList[selectedRow][@"marriage"];
//            self.maritalStatus.selectDes = self.maritalList[selectedRow][@"name"];
//        };
//    }
//    return _maritalStatus;
//}

//- (PickerCell *)liveTime {
//
//    if (!_liveTime) {
//        _liveTime = [[PickerCell alloc] initWithTitle:@"居住时长" subTitle:@"(选填)" selectDes:@"选择"];
//
//        @Weak(self)
//        _liveTime.numberOfRow = ^NSInteger{
//            @Strong(self)
//            return self.liveList.count;
//        };
//        _liveTime.stringOfRow = ^(NSInteger row){
//            @Strong(self)
//            return self.liveList[row][@"name"];
//        };
//        _liveTime.didSelectBlock = ^(NSInteger selectedRow) {
//            @Strong(self)
//            self.infoModel.live_time_type = self.liveList[selectedRow][@"live_time_type"];
//            self.liveTime.selectDes = self.liveList[selectedRow][@"name"];
//        };
//    }
//    return _liveTime;
//}

#pragma mark - Error
- (NSArray<NSString *> *)faceError {
    
    if (!_faceError) {
        _faceError = @[@"动作错误,请重新操作!", @"未知错误!", @"操作超时!", @"未检测到面孔!", @"检测出多张面孔!", @"动作重复!", @"请摘下面具,再操作!"];
    }
    return _faceError;
}

@end
