
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

