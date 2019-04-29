//
//  GDLocationVCViewController.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/6.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "GDLocationVC.h"

#import "MJRefresh.h"

@interface GDLocationVC ()<MAMapViewDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
/**地图显示*/
@property (nonatomic, strong)  MAMapView * mapView;
/**中心点*/
@property (nonatomic, strong) UIImageView * centerMaker;
/**第一次定位标记 */
@property (nonatomic, assign) BOOL isFirstLocated;
/**搜索api*/
@property (nonatomic, strong) AMapSearchAPI * searchAPI;

///**搜索结果表格*/
//@property (nonatomic, strong) KDNoRefreshTableView * tableView;
/**定位结果表格*/
@property (nonatomic, strong) UITableView * tableView;
/**搜素结果表格*/
@property (nonatomic, strong) UITableView * searchtableView;
/**搜索结果数组*/
@property (nonatomic, strong) NSMutableArray * dataArray;
/**搜索页数*/
@property (nonatomic, assign) NSInteger searchPage;
// 选中的POI点
@property (nonatomic, strong) AMapPOI *selectedPoi;
/**搜索框*/
@property (nonatomic, strong) UISearchBar * bar;
/**蒙板*/
@property (nonatomic, strong)  UIView  * backView;
// 下拉更多请求数据的标记
@property (nonatomic, assign) BOOL isFromMoreLoadRequest;
/**搜素关键字*/
@property(nonatomic, copy) NSString * searchString;
@end

static const float  CELL_HEIGH = 64.f;
static const NSInteger    CELL_COUNT =5;
static const float TITLE_HEIGHT =64.f;
static const float cellHIght  = 60.f;
static NSString * const kNetState = @"NetState";

@implementation GDLocationVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.isFirstLocated=NO;
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self initNavUI];
    [self initMapView];
    [self initCenterMarker];
    [self initTB];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reachabilityChanged:) name:@"nctchanged" object:nil];
    
    [self Networkchange:[UserDefaults objectForKey:kNetState]];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tableView.separatorStyle = YES;
    self.searchtableView.separatorStyle = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)initNavUI
{
    UIView *NavBavkView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    NavBavkView.backgroundColor=Color_Red;
    [self.view addSubview:NavBavkView];
    self.bar=[[UISearchBar alloc]initWithFrame:CGRectMake(40, 22, SCREEN_WIDTH-60, 36)];
    for (UIView *view in self.bar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    self.bar.delegate=self;
    self.bar.tintColor=Color_Red;
    self.bar.placeholder=@"请输入地址";
    [NavBavkView addSubview:self.bar];
    UIButton * leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 22, 36, 36);
    [leftBtn setImage:ImageNamed(@"navigationBar_popBack") forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnclick) forControlEvents:UIControlEventTouchUpInside];
    [NavBavkView addSubview:leftBtn];
    
}
-(void)leftBtnclick
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Action
- (void)searchPoiBySearchString:(NSString *)searchString
{
    
    //POI关键字搜索
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = searchString;
    request.city=searchString;
    request.cityLimit = YES;
    [self.searchAPI AMapPOIKeywordsSearch:request];
    [self initsearchTB];
}


-(void)initMapView
{
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0,64,SCREEN_WIDTH, SCREEN_HEIGHT - CELL_HEIGH*CELL_COUNT)];
    
    self.mapView.delegate = self;
    // 不显示罗盘
    self.mapView.showsCompass = NO;
    self.mapView.showsLabels=YES;
    // 不显示比例尺
    self.mapView.showsScale =NO;
    //地图类型
    self.mapView.mapType=MAMapTypeStandard;
    //追踪用户的location与heading更新
    self.mapView.userTrackingMode=MAUserTrackingModeFollowWithHeading;
    //是否支持天空模式，默认为YES. 开启后，进入天空模式后，annotation重用可视范围会缩减
    self.mapView.skyModelEnable=NO;
    //是否显示交通
    self.mapView.showTraffic=YES;
    //定位精度
    self.mapView.desiredAccuracy=100.f;
    // 地图缩放等级
    [self.mapView setZoomLevel:15 animated:YES];
    //高德地图log位置
    self.mapView.logoCenter=CGPointMake(CGRectGetWidth(self.mapView.bounds)-36, CGRectGetHeight( self.mapView.bounds)-80);
    
//    [self.mapView setZoomLevel:0.1f animated:YES];
    self.mapView.showsUserLocation=YES;
    // 开启定位
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = 1;
    [self.view addSubview:self.mapView];
    
    UIButton * rollbackBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rollbackBtn.frame=CGRectMake(10, CGRectGetHeight( self.mapView.bounds)-120, 60, 60);
    [rollbackBtn setImage:[UIImage imageNamed:@"GDLMapagin"] forState:UIControlStateNormal];
    [rollbackBtn addTarget:self action:@selector(rollbackBtnclick) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:rollbackBtn];
}
-(void)rollbackBtnclick
{
    
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
}
- (void)initCenterMarker
{
    UIImage *image = [UIImage imageNamed:@"centerMarker"];
    self.centerMaker = [[UIImageView alloc] initWithImage:image];
    self.centerMaker.frame = CGRectMake(CGRectGetWidth(self.view.bounds)/2-image.size.width/2, CGRectGetHeight( self.mapView.bounds)/2-image.size.height, image.size.width, image.size.height);
    self.centerMaker.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2, (CGRectGetHeight(self.mapView.bounds) -  CGRectGetHeight( self.centerMaker.bounds) )*0.8);
    [self.view addSubview:self.centerMaker];
}
-(void)initTB
{
    //self.tableView=[KDNoRefreshTableView getTableView];
    [self.view addSubview:self.tableView];
    
}
-(void)initsearchTB
{
    if (!self.searchtableView.superview) {
        [self.view addSubview:self.searchtableView];
    }
}
#pragma mark - tableView数据源代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellId = @"cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        //cell.accessoryType=UITableViewCellAccessoryNone;
    }
    if (tableView==self.tableView) {
        if (indexPath.row==0){
            cell.imageView.image=[UIImage imageNamed:@"GDLMapfist"];
            cell.textLabel.textColor=[UIColor colorWithHex:0xFF8003];
            cell.detailTextLabel.textColor=[UIColor colorWithHex:0xFF8003];
        }
        else{
            cell.imageView.image=[UIImage imageNamed:@"GDLMapnotn"];
            cell.textLabel.textColor=[UIColor colorWithHex:0x333333];
            cell.detailTextLabel.textColor=[UIColor colorWithHex:0x333333];
        }
        
    }else{
        cell.imageView.image=[UIImage imageNamed:@"GDLMapnotn"];
        cell.textLabel.textColor=[UIColor colorWithHex:0x333333];
        cell.detailTextLabel.textColor=[UIColor colorWithHex:0x333333];
        
    }
    
    AMapPOI *point = self.dataArray[indexPath.row];
    cell.textLabel.font=[UIFont italicSystemFontOfSize:16.f];
    cell.textLabel.text=point.name;
    cell.detailTextLabel.text=point.address;
    return cell;
}
#pragma mark - tableView代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count>indexPath.row) {
        AMapPOI *poi=self.dataArray[indexPath.row];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.address) {
            self.address(poi,self.mapView.userLocation);
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHIght;
    
}
#pragma mark - UISearchBar代理方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.backView removeFromSuperview];
    self.bar.showsCancelButton=NO;
    [self.view endEditing:YES];
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.bar.showsCancelButton=YES;
    if (!self.searchtableView.superview) {
        [self.view addSubview:self.backView];
    }
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (searchBar.text.length>0) {
        [self searchPoiBySearchString:searchBar.text];
        self.searchString=searchBar.text;
    } else {
        [self.searchtableView removeFromSuperview];
        [self rollbackBtnclick];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length>0) {
        [self searchPoiBySearchString:searchBar.text];
    }
    [searchBar resignFirstResponder];
    self.bar.showsCancelButton=NO;
    [self.backView removeFromSuperview];
}
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText

{
    if (searchBar.text.length>0) {
        [self searchPoiBySearchString:searchText];
        self.searchString=searchText;
    }
    
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    // 修改UISearchBar右侧的取消按钮文字颜色及背景图片
    for (id searchbuttons in [searchBar subviews]) {
        for (id btn in [searchbuttons subviews]) {
            if ([btn isKindOfClass:[UIButton class]]) {
                UIButton *cancelButton = (UIButton*)btn;
                // 修改文字颜色
                [cancelButton setTitle:@"取消"forState:UIControlStateNormal];
                [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark - 点击后面背景收键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self.backView removeFromSuperview];
    self.bar.showsCancelButton=NO;
}

//#pragma mark - AMapSearchDelegate
//- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
//{
//    if (response.regeocode != nil) {
//        // 去掉逆地理编码结果的省份和城市
//        NSString *address = response.regeocode.formattedAddress;
//        AMapAddressComponent *component = response.regeocode.addressComponent;
//        address = [address stringByReplacingOccurrencesOfString:component.province withString:@""];
//        address = [address stringByReplacingOccurrencesOfString:component.city withString:@""];
//        // 将逆地理编码结果保存到数组第一个位置，并作为选中的POI点
//        _selectedPoi = [[AMapPOI alloc] init];
//        _selectedPoi.name = address;
//        _selectedPoi.address = response.regeocode.formattedAddress;
//        _selectedPoi.location = request.location;
//        [self.dataArray setObject:_selectedPoi atIndexedSubscript:0];
//        // 刷新TableView第一行数据
//        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        [_tableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//        // 刷新后TableView返回顶部
//        [_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
//    }
//}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    // 首次定位
    if (updatingLocation&& !self.isFirstLocated ) {
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
        self.isFirstLocated = YES;
    }
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *reuseIndetifier = @"anntationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (!annotationView) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
            annotationView.image = [UIImage imageNamed:@"msg_location"];
            annotationView.centerOffset = CGPointMake(0, -18);
        }
        return annotationView;
    }
    return nil;
}
/*!
 @brief 地图加载失败
 @param mapView 地图View
 @param error 错误信息
 */
- (void)mapViewDidFailLoadingMap:(MAMapView *)mapView withError:(NSError *)error
{
    NSLog(@"%@",error.userInfo);
}
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if ( self.isFirstLocated) {
        AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude];
        [self searchReGeocodeWithAMapGeoPoint:point];
        [self searchPoiByAMapGeoPoint:point];
        // 范围移动时当前页面数重置
        self.searchPage = 1;
    }
}
// 搜索逆向地理编码-AMapGeoPoint
- (void)searchReGeocodeWithAMapGeoPoint:(AMapGeoPoint *)location
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = location;
    
    // 返回扩展信息
    regeo.requireExtension = YES;
    [_searchAPI AMapReGoecodeSearch:regeo];
    
}

// 搜索中心点坐标周围的POI-AMapGeoPoint
- (void)searchPoiByAMapGeoPoint:(AMapGeoPoint *)location
{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = location;
    // 搜索半径
    request.radius = 200.f;
    // 搜索结果排序
    request.sortrule = 1.f;
    request.offset=10.f;
    // 当前页数
    request.page = self.searchPage;
    [self.searchAPI AMapPOIAroundSearch:request];
    
    
}
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.isFromMoreLoadRequest) {
        self.isFromMoreLoadRequest = NO;
    }else{
        [self.dataArray removeAllObjects];
    }
    
    __weak __typeof(&*self)weakSelf = self;
    // 添加数据并刷新TableView
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        [weakSelf.dataArray addObject:obj];
    }];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    // 刷新完成,没有数据时不显示footer
    if (response.pois.count == 0) {
        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
    }
    else {
        self.tableView.mj_footer.state = MJRefreshStateIdle;
    }
    
    [self.tableView reloadData];
    [self.searchtableView reloadData];
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    [self showMessage:@"数据错误,请稍后再试!"];
    NSLog(@"%@",[NSBundle mainBundle].bundleIdentifier);
}

#pragma mark - 网络环境监听
- (void)reachabilityChanged:(NSNotification *)note
{
    [self Networkchange:note.userInfo[@"netstate"]];
    
}

-(void)Networkchange:(NSString *)network
{
    if (![network isEqualToString:@"未知网络错误"]) {
        
        if(!self.isFirstLocated){
            AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude];
            [self searchReGeocodeWithAMapGeoPoint:point];
            [self searchPoiByAMapGeoPoint:point];
        }

    }else{
        [self showMessage:@"没有网络,请稍后再试!"];
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Action
- (void)loadMoreData
{
    self.searchPage++;
    AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude];
    [self searchPoiByAMapGeoPoint:point];
    self.isFromMoreLoadRequest = YES;
}
-(void)searchloadMoreData
{
    self.searchPage++;
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = self.searchString;
    request.city=self.searchString;
    request.cityLimit = YES;
    [self.searchAPI AMapPOIKeywordsSearch:request];
    self.isFromMoreLoadRequest = YES;
}
#pragma mark - 懒加载
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}
-(AMapSearchAPI *)searchAPI
{
    if (!_searchAPI) {
        _searchAPI=[[AMapSearchAPI alloc]init];
        _searchAPI.delegate=self;
    }
    return _searchAPI;
}
-(UIView *)backView
{
    if (!_backView) {
        _backView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64.f)];
        _backView.backgroundColor=[UIColor grayColor];
        _backView.alpha=0.3f;
    }
    return _backView;
}
-(UITableView *)searchtableView
{
    if (!_searchtableView) {
        _searchtableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        _searchtableView.delegate=self;
        _searchtableView.dataSource=self;
        _searchtableView.showsVerticalScrollIndicator=NO;
        _searchtableView.backgroundColor=[UIColor colorWithHex:0xEFF3F5];
        _searchtableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(searchloadMoreData)];
        _searchtableView.contentInset = UIEdgeInsetsMake(-33.f, 0, 0, 0);
    }
    return _searchtableView;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_mapView.frame)-TITLE_HEIGHT, SCREEN_WIDTH, CELL_HEIGH*CELL_COUNT ) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.backgroundColor = [UIColor colorWithHex:0xEFF3F5];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _tableView.contentInset = UIEdgeInsetsMake(-33.f, 0, 0, 0);
    }
    return _tableView;
}

@end

