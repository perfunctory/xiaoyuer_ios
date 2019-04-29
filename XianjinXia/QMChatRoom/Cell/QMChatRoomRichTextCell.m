//
//  QMChatRoomRichTextCell.m
//  IMSDK-OC
//
//  Created by lishuijiao on 2018/3/8.
//  Copyright © 2018年 HCF. All rights reserved.
//

#import "QMChatRoomRichTextCell.h"
#import "QMChatRoomShowRichTextController.h"
#import "QMAlert.h"

/**
 富文本消息
 */
@interface QMChatRoomRichTextCell() <MLEmojiLabelDelegate>

@end

@implementation QMChatRoomRichTextCell
{
    NSString *_messageId;
    
    UIView *_richView;
    
    UILabel *_titleLabel;
    
    UILabel *_descriptionLabel;
    
    UIImageView *_imageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _richView = [[UIView alloc] init];
    _richView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 160, 110);
    _richView.clipsToBounds = YES;
    [self.contentView addSubview:_richView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_richView addGestureRecognizer:tap];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 180, 30);
    _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _titleLabel.numberOfLines = 2;
    [_richView addSubview:_titleLabel];
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.frame = CGRectMake(10, _titleLabel.frame.size.height + 15, [UIScreen mainScreen].bounds.size.width - 250, 50);
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.font = [UIFont systemFontOfSize:12.0f];
    _descriptionLabel.textColor = [UIColor darkGrayColor];
    [_richView addSubview:_descriptionLabel];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake( _descriptionLabel.frame.size.width+20, _titleLabel.frame.size.height + 15, 60, 50);
    [_richView addSubview:_imageView];
}

- (void)setData:(CustomMessage *)message avater:(NSString *)avater {
    self.message = message;
    _messageId = message._id;
    [super setData:message avater:avater];

    if ([message.fromType isEqualToString:@"1"]) {
        
        _titleLabel.textColor = [UIColor blackColor];
        self.chatBackgroudImage.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+10, [UIScreen mainScreen].bounds.size.width - 160, 110);
        _richView.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+5, [UIScreen mainScreen].bounds.size.width - 160, 120);
        _titleLabel.text = message.richTextTitle;
        
        if (_titleLabel.text != nil) {
            CGFloat height = [self calculateRowHeight:_titleLabel.text fontSize:15];
            if (height > 20) {
                _titleLabel.frame = CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 180, 40);
                _imageView.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width - 230, _titleLabel.frame.size.height + 15, 60, 50);
                _descriptionLabel.frame = CGRectMake(10, _titleLabel.frame.size.height + 15, [UIScreen mainScreen].bounds.size.width - 250, 50);
            }
            NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:_titleLabel.text];
            NSRange range = NSMakeRange(0, content.length);
            [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
            _titleLabel.attributedText = content;
        }
        _descriptionLabel.text = message.richTextDescription;
        
        if ([message.richTextPicUrl  isEqual: @""]) {
            _descriptionLabel.frame = CGRectMake(10, _titleLabel.frame.size.height + 15, [UIScreen mainScreen].bounds.size.width - 180, 50);
            _imageView.hidden = YES;
        }else{
            _descriptionLabel.frame = CGRectMake(10, _titleLabel.frame.size.height + 15, [UIScreen mainScreen].bounds.size.width - 250, 50);
            _imageView.hidden = NO;
            [_imageView sd_setImageWithURL:[NSURL URLWithString:message.richTextPicUrl] placeholderImage:[UIImage imageNamed:@""]];
        }
        [_descriptionLabel sizeToFit];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"点击富文本");
    QMChatRoomShowRichTextController * showWebVC = [[QMChatRoomShowRichTextController alloc] init];
    showWebVC.urlStr = self.message.message;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showWebVC animated:true completion:nil];
}

- (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};//指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 180, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
