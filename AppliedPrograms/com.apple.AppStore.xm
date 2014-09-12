
#import "headers.h"
#import <CoreText/CoreText.h>


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

@interface ASPurchasedHeaderView : UIView @end




%hook ASAppDelegate

%new
- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration {
	[[UIApplication sharedApplication] keyWindow].backgroundColor = [colorHelper keyWindowBackgroundColor];
}

%new
- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
	[[UIApplication sharedApplication] keyWindow].backgroundColor = nil;
}

%end


%hook SKUIColorScheme

- (UIColor *)backgroundColor {
	return [colorHelper clearColor];
}

- (void)setBackgroundColor:(UIColor *)color {
	%orig([colorHelper clearColor]);
}

%end


%hook SKUIProductPageTableViewController

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	
	self.tableView.backgroundColor = [colorHelper clearColor];
	self._tableView.backgroundColor = [colorHelper clearColor];
	self.view.backgroundColor = [colorHelper clearColor];
}

%end


%hook SKUIProductPageHeaderLabel

- (void)layoutSubviews {
	self.textColor = [colorHelper commonTextColor];
	
	%orig;
}

%end


%hook SKUIProductPageHeaderView

- (void)setBackgroundColor:(id)color {
	%orig([colorHelper clearColor]);
}

- (void)layoutSubviews {
	%orig;
	
	self.backgroundColor = [colorHelper clearColor];
}

- (id)initWithClientContext:(id)cc {
	UIView *rtn = %orig;
	
	if (rtn) {
		rtn.backgroundColor = [colorHelper clearColor];
	}
	
	return rtn;
}

%end


%hook SKUIProductPageCopyrightView

- (void)setBackgroundColor:(id)color {
	%orig([colorHelper clearColor]);
}

- (void)layoutSubviews {
	%orig;
	
	self.backgroundColor = [colorHelper clearColor];
}

- (id)init {
	UIView *rtn = %orig;
	
	if (rtn) {
		rtn.backgroundColor = [colorHelper clearColor];
	}
	
	return rtn;
}

%end


%hook SKUIProductPagePlaceholderView

- (void)setBackgroundColor:(id)color {
	%orig([colorHelper clearColor]);
}

%end


%hook SKUIProductPageFeaturesView

- (void)setBackgroundColor:(id)color {
	%orig([colorHelper clearColor]);
}

- (void)layoutSubviews {
	%orig;
	
	self.backgroundColor = [colorHelper clearColor];
}

%end


%hook SKUIScreenshotsView

- (void)setBackgroundColor:(id)color {
	%orig([colorHelper clearColor]);
}

- (void)layoutSubviews {
	%orig;
	
	self.backgroundColor = [colorHelper clearColor];
}

- (id)initWithFrame:(CGRect)frame {
	UIView *rtn = %orig;
	
	if (rtn) {
		rtn.backgroundColor = [colorHelper clearColor];
	}
	
	return rtn;
}

%end


%hook SKUITextBoxView

- (void)setBackgroundColor:(id)color {
	%orig([colorHelper clearColor]);
}

- (void)layoutSubviews {
	%orig;
	
	self.backgroundColor = [colorHelper clearColor];
}

- (void)setColorScheme:(SKUIColorScheme *)scheme {
	scheme.primaryTextColor = [colorHelper commonTextColor];
	scheme.secondaryTextColor = nil;
	
	%orig;
}

- (void)setFrame:(CGRect)frame {
	%orig;
	
	SKUIColorScheme *scheme = [[%c(SKUIColorScheme) alloc] init];
	
	self.colorScheme = scheme;
	
	[scheme release];
}

%end


%hook UIView

- (void)__glareapps_backgroundTest {
	%orig;
	
	if ([NSStringFromClass(self.class) hasPrefix:@"SKUI"])
		self.backgroundColor = [colorHelper clearColor];
}

%end


%hook SKUICategoryTableViewController

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

%end


%hook SKUIWishlistViewController

- (void)viewDidLayoutSubviews {
	%orig;
	
	if (!isPad) {
		_UIBackdropView *_backdropView = MSHookIvar<_UIBackdropView *>(self, "_backdropView");
		_backdropView.alpha = 0.0f;
	}
}

- (void)_reloadNavigationBarAnimated:(BOOL)animated {
	%orig;
	
	self.navigationItem.navigationBar.translucent = YES;
}

%end


%hook SKUIIPadProductPageViewController

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	
	_UIBackdropView *backdropView = (_UIBackdropView *)[self.view viewWithTag:0xc001];
	[backdropView retain];
	
	if (backdropView == nil) {
		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleForWhiteness graphicsQuality:kBackdropGraphicQualitySystemDefault];
		settings.grayscaleTintAlpha = 0.6f;
		
		backdropView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
		backdropView.tag = 0xc001;
		
		[self.view insertSubview:backdropView atIndex:0];
	}
	
	[backdropView release];
}

- (void)viewDidLayoutSubviews {
	%orig;
	
	_UIBackdropView *backdropView = (_UIBackdropView *)[self.view viewWithTag:0xc001];
	[backdropView retain];
	
	[backdropView removeFromSuperview];
	[self.view insertSubview:backdropView atIndex:0];
	
	[backdropView release];
}

%end


%hook SKUIProductPageTableExpandableHeaderView

- (void)setBackgroundColor:(id)color {
	%orig([colorHelper clearColor]);
}

- (void)layoutSubviews {
	%orig;
	
	self.backgroundColor = [colorHelper clearColor];
}

%end


%hook SKUIIPadCustomerReviewsHeaderView

- (void)setBackgroundColor:(id)color {
	%orig([colorHelper clearColor]);
}

- (void)layoutSubviews {
	%orig;
	
	self.backgroundColor = [colorHelper clearColor];
}

%end


%hook SKUISwooshView

- (void)setBackgroundColor:(id)color {
	%orig([colorHelper clearColor]);
}

- (void)layoutSubviews {
	%orig;
	
	self.backgroundColor = [colorHelper clearColor];
}

%end


%hook ASPurchasedCellLayout

- (void)setIconImage:(UIImage *)iconImage {
	if (isPad) {
		// To do : icon image masking
	}
	
	%orig;
}

%end



%ctor {
	if (!isThisAppEnabled()) return;
	
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.AppStore"]) {
		%init;
	}
}
