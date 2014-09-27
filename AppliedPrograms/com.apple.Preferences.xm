
#import "headers.h"


@interface PSSpecifier : NSObject @end
@interface PSTableCell : UITableViewCell
@property(retain, nonatomic) PSSpecifier *specifier;
@end
@interface PSControlTableCell : PSTableCell
@property(retain, nonatomic) id control;
- (id)newControl;
@end
@interface PSSliderTableCell : PSControlTableCell @end

@class PSListController;
@interface PSRootController : UINavigationController
- (PSRootController *)rootController;
- (PSListController *)parentController;
@end

@interface PSListController : UIViewController
- (id)bundle;
- (PSRootController *)rootController;
- (PSListController *)parentController;
@end



%hook UIApplication

- (void)__glareapps_applicationDidFinishLaunching {
	UIApplication *application = [UIApplication sharedApplication];
	
	[application _setApplicationBackdropStyle:kBackdropStyleForWhiteness];
	[application setStatusBarStyle:kBarStyleForWhiteness];
	[application _setDefaultTopNavBarTintColor:nil];
	
	NSArray *superviews = application.keyWindow.subviews;
	UIView *superview = (superviews.count > 0 ? superviews[0] : nil);
	UIView *view = (superview.subviews.count > 0 ? superview.subviews[0] : nil);
	view.backgroundColor = nil;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		view.alpha = kRealTransparentAlphaFactor;
}

%end


@interface PSSliderTableCell (GlareApps)
- (void)__glareapps_adjustSliderValueImageTintColor;
@end

%hook PSSliderTableCell

- (void)layoutSubviews {
	%orig;
	
	UISlider *slider = (UISlider *)self.control;
	
	UIColor *tintColor = [colorHelper systemGrayColor];
	
	for (UILabel *label in slider.subviews) {
		if ([label isKindOfClass:[UILabel class]])
			label.textColor = tintColor;
	}
}

%new
- (void)__glareapps_adjustSliderValueImageTintColor {
	if (self.superview) {
		UIView *tableView = self.superview;
		while (tableView != nil && ![tableView isKindOfClass:[UITableView class]]) {
			tableView = tableView.superview;
		}
		
		PSListController *listCtrlr = tableView._viewControllerForAncestor;
		PSListController *prev = listCtrlr;
		PSListController *parent = listCtrlr.parentController;
		
		while (parent && [parent respondsToSelector:@selector(bundle)] && ![parent isKindOfClass:%c(PrefsListController)]) {
			prev = parent;
			parent = parent.parentController;
		}
		
		NSBundle *bundle = prev.bundle;
		
		if ([bundle.bundleIdentifier hasPrefix:@"com.apple."]) {
			UISlider *slider = self.control;
			
			UIImage *maxValueImage = slider.maximumValueImage;
			maxValueImage = [maxValueImage _flatImageWithColor:[colorHelper systemGrayColor]];
			[slider setMaximumValueImage:maxValueImage];
			
			UIImage *minValueImage = slider.minimumValueImage;
			minValueImage = [minValueImage _flatImageWithColor:[colorHelper systemGrayColor]];
			[slider setMinimumValueImage:minValueImage];
		}
	}
}

- (void)didMoveToSuperview {
	%orig;
	
	[self __glareapps_adjustSliderValueImageTintColor];
}

- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)newSpecifier {
	%orig;
	
	[self __glareapps_adjustSliderValueImageTintColor];
}

- (id)newControl {
	UISlider *slider = %orig;
	
	UIColor *tintColor = [colorHelper systemGrayColor];
	
	if (![slider.maximumTrackTintColor isEqual:slider.minimumTrackTintColor])
		[slider setMaximumTrackTintColor:tintColor];
	
	return slider;
}

%end


%ctor {
	if (!isThisAppEnabled()) return;
	
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.Preferences"]) {
		%init;
	}
}
