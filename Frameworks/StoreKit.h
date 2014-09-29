
#import "../headers.h"


@interface SKUIColorScheme : NSObject
@property(copy, nonatomic) UIColor *secondaryTextColor;
@property(copy, nonatomic) UIColor *primaryTextColor;
@property(copy, nonatomic) UIColor *highlightedTextColor;
@property(copy, nonatomic) UIColor *backgroundColor;
@property(readonly, nonatomic) NSInteger schemeStyle;
@end

@interface SKUIViewController : UIViewController
//@property(readonly, nonatomic) SKUIIPadSearchController *IPadSearchController;
@end

@interface SKUIProductPageTableView : UITableView @end
@interface SKUIProductPageTableViewController : UIViewController
- (SKUIProductPageTableView *)_tableView;
@property(readonly, nonatomic) UITableView *tableView;
@end

@interface SKUISegmentedTableHeaderView : UIView {
	_UIBackdropView *_backdropView;
}
//@property(retain, nonatomic) SUSegmentedControl *segmentedControl;
@end

@interface SKUIProductPageHeaderFloatingView : UIView {
	_UIBackdropView *_backdropView;
}
@end

@interface SKUIProductPageHeaderLabel : UIView
@property(retain, nonatomic) UIColor *ratingColor;
//@property(nonatomic) BOOL isPad;
@property(retain, nonatomic) UIColor *textColor;
@end

@interface SKUIProductPageHeaderView : UIView @end
@interface SKUIProductPageHeaderViewController : UIViewController
@property(readonly, nonatomic) SKUIProductPageHeaderFloatingView *floatingView;
@end

@interface SKUIIPadChartsHeaderView : UIControl @end
@interface SKUIIPadChartsColumnView : UIView @end

@interface SKUIProductPageCopyrightView : UIView
@property(retain, nonatomic) SKUIColorScheme *colorScheme;
@end

@interface SKUIProductPageFeaturesView : UIView
@property(retain, nonatomic) SKUIColorScheme *colorScheme;
@end

@interface SKUIScreenshotsView : UIView @end
@interface SKUIScreenshotsViewController : UIViewController @end

@interface SKUITextBoxView : UIControl {
	UILabel *_ratingLabel;
	UILabel *_subtitleLabel;
	UILabel *_titleLabel;
}
@property(retain, nonatomic) SKUIColorScheme *colorScheme;
- (UIButton *)_moreButton;
@end

@interface SKUICategoryTableViewController : UITableViewController @end

@interface SKUIWishlistViewController : SKUIViewController {
	_UIBackdropView *_backdropView;
}
@end

@interface SKUIIPadProductPageViewController : UIViewController @end

@interface SKUIProductPageTableExpandableHeaderView : UIControl @end

@interface SKUIIPadCustomerReviewsHeaderView : UIControl @end

@interface SKUISwooshView : UIView @end

@interface SKComposeReviewViewController : UIViewController @end

