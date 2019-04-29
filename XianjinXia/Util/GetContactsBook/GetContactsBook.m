//
//  GetContactsBook.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/16.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "GetContactsBook.h"
#import <AddressBook/AddressBook.h>
#import <ContactsUI/ContactsUI.h>
#import "UserManager.h"
#import "VerifyListRequest.h"

static GetContactsBook *instance;

@interface GetContactsBook ()

@property (nonatomic, strong) VerifyListRequest * requestVer;

@end

@implementation GetContactsBook

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

+ (GetContactsBook *)shareControl {
    @synchronized (self) {
        if (!instance) {
            instance = [[GetContactsBook alloc] init];
        }
    }
    return instance;
}

#pragma mark - 获取联系人
- (NSMutableDictionary *)getPersonInfo {
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.dataArrayDic = [NSMutableArray arrayWithCapacity:0];
    
    //typedef CFTypeRef ABAddressBookRef;
    //typedef const void * CFTypeRef;
    //指向常量的指针
    ABAddressBookRef addressBook = nil;
    //判断当前系统的版本
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        //如果不小于6.0，使用对应的api获取通讯录，注意，必须先请求用户的同意，如果未获得同意或者用户未操作，此通讯录的内容为空
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);//等待同意后向下执行//为了保证用户同意后在进行操作，此时使用多线程的信号量机制，创建信号量，信号量的资源数0表示没有资源，调用dispatch_semaphore_wait会立即等待。若对此处不理解，请参看GCD信号量同步相关内容。
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);//发出访问通讯录的请求
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){
            //如果用户同意，才会执行此block里面的方法
            //此方法发送一个信号，增加一个资源数
            dispatch_semaphore_signal(sema);});
        //如果之前的block没有执行，则sema的资源数为零，程序将被阻塞
        //当用户选择同意，block的方法被执行， sema资源数为1；
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        //        dispatch_release(sema);
    }//如果系统是6.0之前的系统，不需要获得同意，直接访问else{  addressBook = ABAddressBookCreate(); }
    //通讯录信息已获得，开始取出
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    //联系人条目数（使用long而不使用int是为了兼容64位）
    long peopleCount = 0;
    if (results) {
        peopleCount = CFArrayGetCount(results);
    }
    for (int i=0; i<peopleCount; i++)
    {
        NSMutableDictionary *tempDic = [@{} mutableCopy];
        ABRecordRef record = CFArrayGetValueAtIndex(results, i);
        
        //取得完整名字（与上面firstName、lastName无关）
        CFStringRef  fullName=ABRecordCopyCompositeName(record);
        //        NSLog(@"%@",(__bridge NSString*)fullName);
        [tempDic setObject:(__bridge NSString*)fullName ? (__bridge NSString *)fullName : @"" forKey:@"name"];
        
        // 读取电话,不只一个
        NSString *phoneStr = @"";
        ABMultiValueRef phones = ABRecordCopyValue(record, kABPersonPhoneProperty);
        long phoneCount = ABMultiValueGetCount(phones);
        //大于5个号码 判断为垃圾号码 可能是杀毒软件添加的 我们去掉这些号码
        if (phoneCount >5) {
            continue;
        }
        for (int j=0; j<phoneCount; j++) {
            // label
            CFStringRef lable = ABMultiValueCopyLabelAtIndex(phones, j);
            // phone number
            CFStringRef number = ABMultiValueCopyValueAtIndex(phones, j);
            // localize label
            CFStringRef local = ABAddressBookCopyLocalizedLabel(lable);
            //此处可使用一个字典来存储通讯录信息
            NSString * mobile = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, j);
            mobile = [self phoneNumClear:mobile];
//            if (j>0 && mobile.length == 11 && phoneStr.length == 11) {
//                phoneStr = [phoneStr stringByAppendingString:@":"];
//            }
            phoneStr = (mobile.length == 11 && phoneStr.length == 0) ? [phoneStr stringByAppendingString:mobile] : [phoneStr stringByAppendingString:@""];//[phoneStr stringByAppendingString:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, j)];
//            phoneStr = [self clearPhone:phoneStr];
            if (local)CFRelease(local);
            if (lable) CFRelease(lable);
            if (number)CFRelease(number);
            
        }
        [tempDic setObject:phoneStr  forKey:@"mobile"];
        [_dataArrayDic addObject:tempDic];
        if (fullName)CFRelease(fullName);
        if (phones) CFRelease(phones);
        record = NULL;
    }
    if (results)CFRelease(results);
    
    results = nil;if (addressBook)CFRelease(addressBook);
    addressBook = NULL;
    
    //排序
    //建立一个字典，字典保存key是A-Z  值是数组
    NSMutableDictionary*index=[NSMutableDictionary dictionaryWithCapacity:0];
    for (NSDictionary*dic in [self.dataArrayDic copy]) {
        NSString* str=[dic objectForKey:@"name"];
        NSString* phone = [dic objectForKey:@"mobile"];
        //获得中文拼音首字母，如果是英文或数字则#
        if (!str || [str isEqualToString:@""]) {
            continue;
        }
        if (!phone) {
            continue;
        }
        NSString *firstLetter = nil;
        
        if ([str canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            firstLetter = [[NSString stringWithFormat:@"%c",[str characterAtIndex:0]]uppercaseString];
        }else
        {
            if ([self transformToPinyin:str]&&![[self transformToPinyin:str]isEqualToString:@""]) {
                firstLetter = [[NSString stringWithFormat:@"%c",[[self transformToPinyin:str] characterAtIndex:0]]uppercaseString];
            }else
            {
                firstLetter = @"#";
            }
        }
        //如果首字母是数字或者特殊符号
        if (firstLetter.length>0) {
            if (!isalpha([firstLetter characterAtIndex:0])) {
                firstLetter = @"#";
            }
        }
        if ([[index allKeys]containsObject:firstLetter]) {
            //判断index字典中，是否有这个key如果有，取出值进行追加操作
            [[index objectForKey:firstLetter] addObject:dic];
        }else{
            NSMutableArray*tempArray=[NSMutableArray arrayWithCapacity:0];
            [tempArray addObject:dic];
            [index setObject:tempArray forKey:firstLetter];
        }
    }
    
    [self.dataArray addObjectsFromArray:[index allKeys] ? [index allKeys] : @[]];
    
    return index;
}

- (NSString *)transformToPinyin:(NSString *)str {
    NSMutableString *mutableString = [NSMutableString stringWithString:str];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return mutableString;
}

#pragma  mark 字母转换大小写--6.0
-(NSString*)upperStr:(NSString*)str{
    // 全部转换为小写
    NSString *lowerStr = [str lowercaseStringWithLocale:[NSLocale currentLocale]];
    //    NSLog(@"lowerStr: %@", lowerStr);
    return lowerStr;
}
#pragma mark 排序
-(NSArray*)sortMethod
{
    NSArray*array=  [[self.dataArray copy] sortedArrayUsingFunction:cmp context:NULL];
    return array;
}
//构建数组排序方法SEL
//NSInteger cmp(id, id, void *);
NSInteger cmp(NSString * a, NSString* b, void * p)
{
    if([a compare:b] == 1){
        return NSOrderedDescending;//(1)
    }else
        return  NSOrderedAscending;//(-1)
}

+ (void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized))block
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    
    if (authStatus != kABAuthorizationStatusAuthorized) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                 NSLog(@"Error: %@", (__bridge NSError *)error);
                }else if (!granted) {
                 block(NO);
                }else {
                 block(YES);
                }
            });
        });
    }else {
        block(YES);
    }
}

- (void)upLoadAddressBook {
    NSMutableArray *addressBook = [[UserDefaults objectForKey:@"contacts"] mutableCopy];
    if (![UserManager sharedUserManager].isLogin) {
        return;
    }
    if (addressBook.count == 0) {
        addressBook = [self uploadAddress];
        if (addressBook.count == 0) {
            return;
        }
    }else {
        [addressBook removeAllObjects];
        addressBook =  [self uploadAddress];
    }
    
    id package = [self deleteduplicateWith:addressBook];
    NSData  *data = [NSJSONSerialization dataWithJSONObject:package options:NSJSONWritingPrettyPrinted error:nil ];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonString);
    [self.requestVer updateContactsWithDictionary:@{@"data":jsonString} success:^(NSDictionary *dictResult) {
        NSLog(@"通讯录上传成功");
    } failed:^(NSInteger code, NSString *errorMsg) {
        NSLog(@"通讯录上传失败");
    }];
}

//去重
- (NSMutableArray *)deleteduplicateWith:(NSMutableArray *)addressBook {
    NSMutableArray * contact = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * arrContent = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * tDict in addressBook.lastObject) {
        if (![contact containsObject:tDict[@"mobile"]]) {
            [contact addObject:tDict[@"mobile"]];
            [arrContent addObject:tDict];
        }
    }
    return arrContent;
}

-(NSMutableArray *)uploadAddress {
    NSMutableArray *addressBook;
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableArray * titleArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * arrData = [NSMutableArray arrayWithCapacity:0];
    if ([self getPersonInfo]&&[self sortMethod]) {
        dataDic = [self getPersonInfo];
        titleArr = [[self sortMethod] mutableCopy];
        arrData = [NSMutableArray arrayWithCapacity:0];
        
        [titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *indexString = obj;
            NSInteger index = idx;
            [arrData addObject:[@[] mutableCopy]];
            NSArray *tempArr = dataDic[indexString];
            [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arrData[index] addObject:obj];
            }];
        }];
    }
    if (arrData.count>0) {
        NSMutableArray *packageArray = [@[] mutableCopy];
        [packageArray addObject:[@[] mutableCopy]];
        __weak __typeof(self)weskSelf = self;
        [arrData enumerateObjectsUsingBlock:^(NSArray  *obj1, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj1 enumerateObjectsUsingBlock:^(NSDictionary *obj2, NSUInteger idx, BOOL * _Nonnull stop) {
                [[packageArray lastObject] addObject:[NSDictionary dictionaryWithObjects:@[obj2[@"name"],[weskSelf phoneNumClear:obj2[@"mobile"]],@([[UserManager sharedUserManager].userInfo.uid floatValue])] forKeys:@[@"name",@"mobile",@"user_id"]]];
            }];
        }];
        [UserDefaults setObject:packageArray forKey:@"contacts"];
        addressBook = packageArray;
    }
    return addressBook;
}

//过滤手机号
- (NSString *)phoneNumClear:(NSString *)str {
    str = [str stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    return str;
}

- (VerifyListRequest *)requestVer {
    if (!_requestVer) {
        _requestVer = [[VerifyListRequest alloc] init];
    }
    return _requestVer;
}

@end
