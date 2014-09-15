
#import "headers.h"



@interface MFComposeHeaderView : UIView @end
@interface MFComposeRecipientView : MFComposeHeaderView
@property(readonly) UITextField *textField;
@end

@interface MFRecipientTableViewCellDetailView : UIView
@property(readonly) UILabel *detailLabel;
@property(readonly) UILabel *labelLabel;
- (void)setTintColor:(id)arg1 animated:(BOOL)arg2;
- (id)tintColor;
@end
@interface MFRecipientTableViewCellTitleView : UIView
@property(readonly) UILabel *titleLabel;
- (void)setTintColor:(id)arg1 animated:(BOOL)arg2;
- (id)tintColor;
@end
@interface MFRecipientTableViewCell : UITableViewCell {
	MFRecipientTableViewCellDetailView *_detailView;
	MFRecipientTableViewCellTitleView *_titleView;
}
- (void)setTintColor:(id)arg1 animated:(BOOL)arg2;
- (id)tintColor;
@end

@interface MFComposeTextContentView : UITextContentView @end

@interface MFComposeScrollView : UIScrollView @end
@interface MFMailComposeView : UIView /*UITransitionView*/
@property(readonly, nonatomic) MFComposeScrollView *bodyScroller;
@end

