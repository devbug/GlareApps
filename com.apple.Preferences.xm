
#import "headers.h"


@interface PSTableCell : UITableViewCell @end
@interface PSControlTableCell : PSTableCell
@property(retain, nonatomic) UIControl *control;
@end
@interface PSSliderTableCell : PSControlTableCell @end



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


%hook PSSliderTableCell

- (void)layoutSubviews {
	%orig;
	
	UISlider *slider = (UISlider *)self.control;
	
	UIColor *tintColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kTintColorAlphaFactor];
	
	if (![slider.maximumTrackTintColor isEqual:slider.minimumTrackTintColor])
		[slider setMaximumTrackTintColor:tintColor];
	
	for (UILabel *label in slider.subviews) {
		if ([label isKindOfClass:[UILabel class]])
			label.textColor = tintColor;
	}
}

%end


%ctor {
	if (!isThisAppEnabled()) return;
	
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.Preferences"]) {
		%init;
	}
}
