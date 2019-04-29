//
//  NoNetReloadView.h

//
//  Created by summer sun on 12/23/11.
//

#import <UIKit/UIKit.h>

@interface NoNetReloadView : UIView

@property (nonatomic, retain) UILabel *tipLabel;

@property (nonatomic, retain) UILabel *reloadBtn;

@property (nonatomic, retain) UIImageView *nonetView;

@property (copy, nonatomic) dispatch_block_t btnClick;

@end
