//
//  KDKeyboardView.m
//  KDLC
//
//  Created by apple on 15/9/9.
//  Copyright (c) 2015年 llyt. All rights reserved.
//

#import "KDKeyboardView.h"
#import "UITextField+ExtentRange.h"
#import "UIImage+Additions.h"

@interface KDKeyboardView ()
{
    SEL _selector;
}

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height3;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height4;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height5;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *width1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *width2;

@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIButton *num4;
@property (strong, nonatomic) IBOutlet UIButton *num3;
@property (strong, nonatomic) IBOutlet UIButton *num1;
@property (strong, nonatomic) IBOutlet UIButton *num6;
@property (strong, nonatomic) IBOutlet UIButton *num5;
@property (strong, nonatomic) IBOutlet UIButton *num7;
@property (strong, nonatomic) IBOutlet UIButton *num9;
@property (strong, nonatomic) IBOutlet UIButton *num2;
@property (strong, nonatomic) IBOutlet UIButton *num8;
@property (strong, nonatomic) IBOutlet UIButton *downBtn;
@property (strong, nonatomic) IBOutlet UIButton *num0;
@property (strong, nonatomic) IBOutlet UIButton *changeBtn;

//键盘类型
@property (nonatomic, assign) kdKeyBoardType type;
//用于处理增删字符
@property (weak, nonatomic) id <UIKeyInput> keyInput;
//代理
@property (nonatomic, retain) id<KDTextfieldDelegate> delegate;
//target
@property (nonatomic, weak) id target;
//长按删除定时器
@property (retain, nonatomic) NSTimer *longPressDeleteTimer;
@end

static KDKeyboardView *_shareKeyBoard;
static __weak id currentFirstResponder;

@interface KDKeyboardButton : UIButton

@property (strong, nonatomic) NSTimer *continuousPressTimer;
@property (assign, nonatomic) NSTimeInterval continuousPressTimeInterval;

// Notes the continuous press time interval, then adds the target/action to the UIControlEventValueChanged event.
- (void)addTarget:(id)target action:(SEL)action forContinuousPressWithTimeInterval:(NSTimeInterval)timeInterval;

@end

@implementation KDKeyboardButton

- (void)addTarget:(id)target action:(SEL)action forContinuousPressWithTimeInterval:(NSTimeInterval)timeInterval
{
    self.continuousPressTimeInterval = timeInterval;
    
    [self addTarget:target action:action forControlEvents:UIControlEventValueChanged];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL begins = [super beginTrackingWithTouch:touch withEvent:event];
    const NSTimeInterval continuousPressTimeInterval = self.continuousPressTimeInterval;
    
    if (begins && continuousPressTimeInterval > 0) {
        [self _beginContinuousPressDelayed];
    }
    
    return begins;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    [self _cancelContinousPressIfNeeded];
}

- (void)dealloc
{
    [self _cancelContinousPressIfNeeded];
}

- (void)_beginContinuousPress
{
    const NSTimeInterval continuousPressTimeInterval = self.continuousPressTimeInterval;
    
    if (!self.isTracking || continuousPressTimeInterval == 0) {
        return;
    }
    
    self.continuousPressTimer = [NSTimer scheduledTimerWithTimeInterval:continuousPressTimeInterval target:self selector:@selector(_handleContinuousPressTimer:) userInfo:nil repeats:YES];
}

- (void)_handleContinuousPressTimer:(NSTimer *)timer
{
    if (!self.isTracking) {
        [self _cancelContinousPressIfNeeded];
        return;
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)_beginContinuousPressDelayed
{
    [self performSelector:@selector(_beginContinuousPress) withObject:nil afterDelay:0.5f];
}

- (void)_cancelContinousPressIfNeeded
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_beginContinuousPress) object:nil];
    
    NSTimer *timer = self.continuousPressTimer;
    if (timer) {
        [timer invalidate];
        
        self.continuousPressTimer = nil;
    }
}

@end


@implementation UIResponder (FirstResponder)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-repeated-use-of-weak"
+ (id)MM_currentFirstResponder
{
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(MM_findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

#pragma clang diagnostic pop
- (void)MM_findFirstResponder:(id)sender
{
    currentFirstResponder = self;
}

@end

@implementation KDKeyboardView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _height1.constant = _height2.constant = _height3.constant = _height4.constant = _width1.constant = _width2.constant = _height5.constant = 0.5;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (view.tag <= 1100 && view.tag >= 1000) {
            [(UIButton *)view setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xececec]] forState:UIControlStateHighlighted];
        }
        if (view.tag == 1103) {
            [(KDKeyboardButton *)view addTarget:self action:@selector(_backspaceRepeat:) forContinuousPressWithTimeInterval:0.15f];
        }
    }];
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    [(UIButton *)[self viewWithTag:1100] setUserInteractionEnabled:((self.type == KDIDNUM) || (self.type == KDFLOATKEYBOARD))];
}

+(instancetype)KDKeyBoardWithKdKeyBoard:(kdKeyBoardType )type
                                 target:(id)target
                              textfield:(UITextField *)textfield
                               delegate:(id<KDTextfieldDelegate>)delegate
                           valueChanged:(SEL)selector
{
    KDKeyboardView *keyBoard = [[[NSBundle mainBundle] loadNibNamed:@"KDKeyboardView" owner:nil options:nil] lastObject];
    keyBoard.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_WIDTH * 0.618+30);
    keyBoard.type = type;
    keyBoard.textfield = textfield;
    keyBoard.delegate = delegate;
    [textfield addTarget:target action:selector forControlEvents:UIControlEventEditingChanged];
    keyBoard.target = target;
    textfield.inputView = keyBoard;
    
    switch (type) {
        case KDIDNUM:
            [keyBoard.changeBtn setTitle:@"X" forState:UIControlStateNormal];
            break;
        case TELEPHONE:
        case PHONECODE:
        case PAYPASSWORD:
        case BANKCARDNUM:
        case DATE:
        case KDNUMBERKEYBOARD:
            [keyBoard.changeBtn setTitle:@"" forState:UIControlStateNormal];
            break;
        case KDFLOATKEYBOARD:
            [keyBoard.changeBtn setTitle:@"." forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    return keyBoard;
}

- (id<UIKeyInput>)keyInput
{
    id <UIKeyInput> keyInput = _keyInput;
    if (keyInput) {
        return keyInput;
    }
    
    keyInput = [UIResponder MM_currentFirstResponder];
    if (![keyInput conformsToProtocol:@protocol(UITextInput)]) {
        NSLog(@"Warning: First responder %@ does not conform to the UIKeyInput protocol.", keyInput);
        return nil;
    }
    
    _keyInput = keyInput;
    
    return keyInput;
}

- (void)_backspaceRepeat:(UIButton *)button
{
    id <UIKeyInput> keyInput = self.keyInput;
    
    if (![keyInput hasText]) {
        return;
    }
    
    [self btnClick:button];
}

/*
 *1000---1009  : 数字0~9
 *1100         : X或.或空，根据键盘类型判断
 *1101         : 收键盘
 *1102         : 确定
 *1103         : 回退
 */
- (IBAction)btnClick:(UIButton *)btn
{
    // Get first responder.
    id <UIKeyInput> keyInput = self.keyInput;
    
    if (!keyInput) {
        return;
    }
    NSString *putStr = _textfield.text;
    NSRange currentLocationRange = [_textfield selectedRange];

    //1000---1009 数字0~9
    if (btn.tag < 1100){
        switch (self.type) {
            case KDIDNUM:
                if (putStr.length <= 18) {
                    [keyInput insertText:[btn titleForState:UIControlStateNormal]];
                }
                break;
            case TELEPHONE:
                if (putStr.length < 11) {
                    [keyInput insertText:[btn titleForState:UIControlStateNormal]];
                }
                break;
            case PHONECODE:
                if (putStr.length <= 6) {
                    [keyInput insertText:[btn titleForState:UIControlStateNormal]];
                }
                break;
            case PAYPASSWORD:
                //为了防止截长后重复调用输完密码后的函数，这里不截长，只在传参时传密码的前六位
                //解决iOS9密码密文输入时大小不一样的问题
                if (_textfield.text.length == 0) {
                    _textfield.text = @" ";
                    [_textfield resignFirstResponder];
                    [_textfield becomeFirstResponder];
                }
                [keyInput insertText:[btn titleForState:UIControlStateNormal]];
                break;
            case BANKCARDNUM:
                if (putStr.length <= 27) {
                    
                    if (currentLocationRange.location % 10 == 4 || currentLocationRange.location % 10 == 9) {
                        [keyInput insertText:[NSString stringWithFormat:@" %@",[btn titleForState:UIControlStateNormal]]];
                    }else{
                        [keyInput insertText:[btn titleForState:UIControlStateNormal]];
                    }
                    currentLocationRange = [_textfield selectedRange];
                    _textfield.text = [self setKeyboardText:_textfield.text];
                    [_textfield setSelectedRange:currentLocationRange];
                }
                break;
            case DATE:
                if (putStr.length <= 4) {
                    [keyInput insertText:[btn titleForState:UIControlStateNormal]];
                }
                break;
            case KDNUMBERKEYBOARD:
                [keyInput insertText:[btn titleForState:UIControlStateNormal]];
                break;
            case KDFLOATKEYBOARD:
            {
                //00
                if ([putStr rangeOfString:@"."].location == NSNotFound) {
                    if ([_textfield.text isEqualToString:@"0"] && btn.tag == 1000) {
                        return;
                    }
                }else{
                    //0.123
                    if ([[putStr componentsSeparatedByString:@"."][1] length] >= 2) {
                        return;
                    }
                }
                [keyInput insertText:[btn titleForState:UIControlStateNormal]];
            }
                break;
            default:
                break;
        }
        return;
    }
    
    //删除
    else if (btn.tag == 1103) {
        if (self.type == BANKCARDNUM) {
            [keyInput deleteBackward];
            currentLocationRange = [_textfield selectedRange];
            _textfield.text = [self setKeyboardText:_textfield.text];
            [_textfield setSelectedRange:currentLocationRange];
            
        }else{
            [keyInput deleteBackward];
        }
        return;
    }
    
    //收键盘
    else if (btn.tag == 1101) {
        if ([self.delegate respondsToSelector:@selector(hideKeyBoard:)]) {
            [self.delegate hideKeyBoard:self];
        }
        [self hideSelf];
        return;
    }
    
    //特殊字符，X . 或者空
    else if (btn.tag == 1100)
    {
        switch (self.type) {
                
            case KDIDNUM:
                //身份证号为15或18位，当且仅当还剩最后一位没输且光标定位在最后的时候才允许输特殊字符
                if ((_textfield.text.length == 14 && currentLocationRange.location == 14) || (_textfield.text.length == 17 && currentLocationRange.location == 17)) {
                    [keyInput insertText:[btn titleForState:UIControlStateNormal]];
                }
                break;
            case KDFLOATKEYBOARD:
                if ([_textfield.text rangeOfString:@"."].location != NSNotFound) {
                    break;
                }
                if (_textfield.text.length == 0 || currentLocationRange.location == 0) {
                    [keyInput insertText:@"0."];
                    break;
                }
                [keyInput insertText:[btn titleForState:UIControlStateNormal]];
            default:
                break;
        }
        return;
    }
}

- (NSString *)setKeyboardText:(NSString *)text
{
    NSString *stringCardNumber = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *str = @"";
    if (!stringCardNumber||[stringCardNumber isEqualToString:@""] ) {
        return  @"";
    }
    if ([self isPureInt:stringCardNumber]) {
        NSInteger shang = stringCardNumber.length /4;
        NSInteger yu = stringCardNumber.length %4;
        if (shang>0) {
            for (int i=0; i<shang; i++) {
                str = (i==shang-1||shang==1)&&yu==0?[str stringByAppendingString:[NSString stringWithFormat:@"%@",[stringCardNumber substringWithRange:NSMakeRange(i*4, 4)]]]: [str stringByAppendingString:[NSString stringWithFormat:@"%@ ",[stringCardNumber substringWithRange:NSMakeRange(i*4, 4)]]];
            }
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@",[stringCardNumber substringFromIndex:shang*4]]];
        }else
        {
            str = stringCardNumber;
        }
    }else
    {
        str = @"";
    }
    return str;
}

//判断是否为正整数
- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (void)hideSelf
{
    [self.textfield endEditing:YES];
}

@end
