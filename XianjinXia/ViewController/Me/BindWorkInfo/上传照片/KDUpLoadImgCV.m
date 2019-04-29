//
//  KDUpLoadImgCV.m
//  KDIOSApp
//
//  Created by appleMac on 16/5/11.
//  Copyright © 2016年 KDIOSApp. All rights reserved.
//

#import "KDUpLoadImgCV.h"
#import <ELCImagePickerController/ELCImagePickerController.h>
#import "UpImageRequest.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "KDAscendingUpLoadVC.h"
#import "YLProgressBar.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImageView+WebCache.h"
#import "UIView+lyt.h"
#import <Lyt.h>
#import "UILabel+lyt.h"
#import "UIButton+lyt.h"
#define KEYWINDOW       ([UIApplication sharedApplication].keyWindow)
@interface KDUpLoadImgCV ()<UIActionSheetDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,ELCImagePickerControllerDelegate>

@property (nonatomic, retain) UpImageRequest *request;
@property (nonatomic, retain) NSMutableArray *pageDataArray;

@property (nonatomic, retain) NSMutableArray *uploadIndexPathArray;

@property (nonatomic, retain) UIImageView *bigImgView;
@property (assign, nonatomic) CGRect lastSelectedImgFrame;

@end

@implementation KDUpLoadImgCV

+ (id)getcollection
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 5 * 15) / 4,(SCREEN_WIDTH - 5 * 15) / 4);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 15;
    layout.minimumLineSpacing = 15;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.footerReferenceSize = CGSizeMake(SCREEN_WIDTH, 80);
    
    KDUpLoadImgCV *collectionView = [[KDUpLoadImgCV alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    collectionView.delegate = collectionView;
    collectionView.dataSource = collectionView;
    collectionView.showsHorizontalScrollIndicator = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GradientCell"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    return collectionView;
}

- (UpImageRequest *)request
{
    if (!_request) {
        _request = [[UpImageRequest alloc] init];
    }
    return _request;
}

- (void)setDataArray:(NSArray<KDAscendingUpLoadImgEntity *> *)dataArray
{
    _dataArray = dataArray;
    if (!_pageDataArray) {
        _pageDataArray = [@[] mutableCopy];
    }
    [_pageDataArray removeAllObjects];
    [_pageDataArray addObjectsFromArray:dataArray];
    
    if (!_uploadArray) {
        _uploadArray = [@[] mutableCopy];
    }
    
    if (!_uploadIndexPathArray) {
        _uploadIndexPathArray = [@[] mutableCopy];
    }
    
}

- (void)uploadImages
{
    if (self.uploadArray.count == 0) {
        [[[DXAlertView alloc] initWithTitle:@"" contentText:@"您还未选择照片" leftButtonTitle:nil rightButtonTitle:@"确定"] show];
        return;
    }
    
    NSIndexPath *indexPath = [self.uploadIndexPathArray objectAtIndex:0];
    UICollectionViewCell * cell;
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    if (CGRectIntersectsRect(self.bounds, attributes.frame)) {
        cell = [self cellForItemAtIndexPath:indexPath];
    }
    UIButton *deleteBtn = [cell.contentView viewWithTag:1003];
    deleteBtn.hidden = YES;
    YLProgressBar *progressBarRoundedFat = (YLProgressBar *)[cell.contentView viewWithTag:1002];
    progressBarRoundedFat.hidden = NO;
    __weak typeof(self) weakSelf = self;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Url_Server,kPictureUploadImage];
    [self.request upLoadFileWithUrl:strUrl dicParama:@{@"type":@(_type)} fileArr:self.uploadArray name:@"attach" fileName:@"imageFile.jpg" mimeType:@"image/jpeg" withPorcessingHandler:^(double progressValue) {
        if (cell) {
            [progressBarRoundedFat setProgress:progressValue animated:YES];
        }
    } withCompleteHandler:^(id responseObject) {
        progressBarRoundedFat.hidden = YES;
        
        if (weakSelf.uploadArray.count > 0 && weakSelf.uploadIndexPathArray.count > 0) {
            [weakSelf.uploadArray removeObjectAtIndex:0];
            [weakSelf.uploadIndexPathArray removeObjectAtIndex:0];
        }
        
        if (weakSelf.uploadArray.count > 0) {
            [weakSelf uploadImages];
            //            [weakSelf performSelector:@selector(uploadImages) withObject:nil afterDelay:0.1];
        } else {
            [(KDAscendingUpLoadVC *)weakSelf.viewController getPageData];
            if (weakSelf.uploadImgSuccss) {
                weakSelf.uploadImgSuccss();
            }
        }
        
        //清楚图片缓存
        [MXTool clearLocalImageCache];

    } withErrorHandler:^(NSError *errMessage) {
        progressBarRoundedFat.hidden = YES;
        deleteBtn.hidden = NO;
        
    }];
    
}

- (void)deleteImg:(UIButton *)btn
{
    

    UIImageView *imgView = [btn.superview viewWithTag:1001];
    if (self.pageDataArray.count>0&&self.uploadArray.count>0) {
        [self.pageDataArray removeObject:imgView.image];
        [self.uploadArray removeObject:imgView.image];
        [self reloadData];
    }
}

//显示大图
- (void)showBigImgWithIndex:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    _lastSelectedImgFrame = [self convertRect:attributes.frame toView:KEYWINDOW];
    if (!_bigImgView) {
        _bigImgView = [[UIImageView alloc] init];
        [KEYWINDOW addSubview:_bigImgView];
        _bigImgView.hidden = YES;
        _bigImgView.backgroundColor = [UIColor blackColor];
        _bigImgView.userInteractionEnabled = YES;
        _bigImgView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImg)];
        [_bigImgView addGestureRecognizer:gesture];
    }
    _bigImgView.frame = _lastSelectedImgFrame;
    id imageData = self.pageDataArray[indexPath.row];
    if ([self.dataArray indexOfObject:[self.pageDataArray objectAtIndex:indexPath.row]] <= self.dataArray.count) {
        [_bigImgView sd_setImageWithURL:imageData[@"url"] placeholderImage:[UIImage imageNamed:@""] options:0 progress:nil completed:nil];
    } else {
        _bigImgView.image = imageData;
    }
    [self showImg];
}

- (void)showImg
{
    __weak typeof(self) weakSelf = self;
    _bigImgView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.bigImgView.frame = KEYWINDOW.bounds;
    }];
}

- (void)hideImg
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.bigImgView.alpha = 0.0f;
        weakSelf.bigImgView.frame = weakSelf.lastSelectedImgFrame;
    } completion:^(BOOL finished) {
        if (finished) {
            weakSelf.bigImgView.hidden = YES;
            weakSelf.bigImgView.alpha = 1.0f;
        }
    }];
}

#pragma mark collectionDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.pageDataArray.count) {
        //上传图片
        //        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", nil];
        [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
        [actionSheet showInView:self];
    } else {
        //看大图
        [self showBigImgWithIndex:indexPath];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //    return _pageDataArray.count + 1;
    if(_pageDataArray.count== 0){
        return 1;
    }else if(_pageDataArray.count ==_maxNum){
        return _pageDataArray.count ;
    }else {
        return _pageDataArray.count + 1;
        
    }
    //    return _pageDataArray.count ;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    

    static NSString * CellIdentifier = @"GradientCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (![cell.contentView viewWithTag:1001]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 5 * 15) / 4, (SCREEN_WIDTH - 5 * 15) / 4)];
        imageView.tag = 1001;
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderColor = Color_Red.CGColor;
        imageView.layer.borderWidth = 0.5f;
        [cell.contentView addSubview:imageView];
        
        YLProgressBar *progressBarRoundedFat = [[YLProgressBar alloc] initWithFrame:CGRectMake(0, (SCREEN_WIDTH - 5 * 15) / 4 - 8, (SCREEN_WIDTH - 5 * 15) / 4, 8)];
        NSArray *tintColors = @[Color_Red];
        progressBarRoundedFat.tag = 1002;
        progressBarRoundedFat.progressTintColors       = tintColors;
        progressBarRoundedFat.stripesOrientation       = YLProgressBarStripesOrientationLeft;
        progressBarRoundedFat.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayModeProgress;
        progressBarRoundedFat.indicatorTextLabel.font  = [UIFont systemFontOfSize:13];
        progressBarRoundedFat.progressStretch          = NO;
        progressBarRoundedFat.backgroundColor = [UIColor whiteColor];
        progressBarRoundedFat.alpha = 0.6f;
        progressBarRoundedFat.hidden = YES;
        [cell.contentView addSubview:progressBarRoundedFat];
        
        [UIButton getButtonWithFontSize:0 TextColorHex:[UIColor colorWithHex:0x000000] backGroundColor2:[UIColor colorWithHex:0x000000 alpha:0.3f] superView:cell.contentView lytSet:^(UIButton *button) {
            [button lyt_alignRightToParent];
            [button lyt_alignBottomToParent];
            [button lyt_setSize:CGSizeMake(20, 20)];
            button.tag = 1003;
            [button setImage:[UIImage imageNamed:@"ascending_dustbin"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(deleteImg:) forControlEvents:UIControlEventTouchUpInside];
            button.contentMode = UIViewContentModeCenter;
        }];
        
        [UILabel getLabelWithFontSize:13 textColor:Color_White superView:cell.contentView lytSet:^(UILabel *label) {
            [label lyt_alignLeftToParent];
            [label lyt_alignRightToParent];
            [label lyt_centerYInParent];
            [label lyt_setHeight:24.f];
            label.tag = 1004;
            label.text = @"已上传";
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor colorWithHex:0x000000 alpha:.3f];
        }];
        
        
    }
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1001];
    UIButton *btn = [cell.contentView viewWithTag:1003];
    UILabel *label = [cell.contentView viewWithTag:1004];
    
    if (indexPath.row == self.pageDataArray.count) {
        //上传图片的图标
        imageView.image = [UIImage imageNamed:0 == self.pageDataArray.count ? @"ascending_photo" : @"ascending_add_img"];
        btn.hidden = YES;
        label.hidden = YES;
    } else {
        id imageData = self.pageDataArray[indexPath.row];
        if ([self.dataArray indexOfObject:imageData] <= self.dataArray.count) {
            //已上传过的图片
            
            [imageView sd_setImageWithURL:imageData[@"url"] placeholderImage:[UIImage imageNamed:@"ascending_upload_normal"] options:0 progress:nil completed:nil];
            btn.hidden = YES;
            label.hidden = NO;
        } else {
            
                //未上传的图片
                imageView.image = imageData;
                btn.hidden = NO;
                label.hidden = YES;
//            [_uploadIndexPathArray addObject:indexPath];

//            if (indexPath.row  self.pageDataArray.count) {

            if(_uploadIndexPathArray.count ==0){
                 [_uploadIndexPathArray addObject:indexPath];
            }else {
                
                if (![_uploadIndexPathArray containsObject:indexPath]) {
                    [_uploadIndexPathArray addObject:indexPath];

                }
            }
            
        }
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionFooter){
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        if (![reusableview viewWithTag:1001]) {
            UIView *collectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 80)];
            collectionFooterView.tag = 1001;
            [reusableview addSubview:collectionFooterView];
            
            UIButton *btn = [UIButton getButtonWithFontSize:15 TextColorHex:Color_White backGroundColor:Color_Red superView:collectionFooterView lytSet:^(UIButton *button) {
                [button lyt_centerInParent];
                [button lyt_setSize:CGSizeMake(SCREEN_WIDTH - 30, 44)];
            }];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 5.0f;
            [btn setTitle:@"上传" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(uploadImages) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return reusableview;
}


//actionsheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.maxNum - self.pageDataArray.count <= 0) {
        [self performSelector:@selector(showAlert:) withObject:@"图片数量已达上限" afterDelay:0.5f];
        return;
    }
    if (buttonIndex != 0 && buttonIndex != 1) {
        return;
    }
    if (buttonIndex == 0) {
        [self showCamera];
    }
    //    } else {
    //        [self showPhotoAlbum];
    //    }
}

- (void)showCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self performSelector:@selector(showAlert:) withObject:@"相机打开失败" afterDelay:0.5f];
        return;
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied) {
        [self performSelector:@selector(showAlert:) withObject:@"请在设置-->隐私-->相机-->“给你用”中打开相机使用权限" afterDelay:0.5f];
        return;
    }
    UIImagePickerController *imageVC = [[UIImagePickerController alloc] init];
    imageVC.allowsEditing = NO;
    imageVC.delegate = self;
    imageVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.viewController presentViewController:imageVC animated:YES completion:nil];
}

- (void)showPhotoAlbum
{
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] init];
    elcPicker.maximumImagesCount = self.maxNum - self.pageDataArray.count;
    elcPicker.imagePickerDelegate = self;
    [self.viewController presentViewController:elcPicker animated:YES completion:nil];
}

#pragma mark camare
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak typeof(self) weakSelf = self;
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    [self.uploadArray addObject:image];
    [self.viewController dismissViewControllerAnimated:YES completion:^{
        [weakSelf.pageDataArray removeAllObjects];
        [weakSelf.pageDataArray addObjectsFromArray:weakSelf.dataArray];
        [weakSelf.pageDataArray addObjectsFromArray:weakSelf.uploadArray];
        [weakSelf reloadData];
    }];
}


#pragma mark ELCImagePickerControllerDelegate
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    __weak typeof(self) weakSelf = self;
    [info enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [weakSelf.uploadArray addObject:image];
                [weakSelf.uploadIndexPathArray removeAllObjects];
            }
        }
    }];
    
    [self.viewController dismissViewControllerAnimated:YES completion:^{
        [weakSelf.pageDataArray removeAllObjects];
        [weakSelf.pageDataArray addObjectsFromArray:weakSelf.dataArray];
        [weakSelf.pageDataArray addObjectsFromArray:weakSelf.uploadArray];
        [weakSelf reloadData];
    }];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAlert:(NSString *)alertText
{
    [[[DXAlertView alloc] initWithTitle:@"" contentText:alertText leftButtonTitle:nil rightButtonTitle:@"确定"] show];
}

@end
