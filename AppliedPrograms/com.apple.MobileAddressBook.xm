
#import "headers.h"



%hook UIApplication

- (void)__glareapps_applicationDidFinishLaunching {
	%orig;
	
	NSArray *superviews = [UIApplication sharedApplication].keyWindow.subviews;
	UIView *superview = (superviews.count > 0 ? superviews[0] : nil);
	UIView *view = (superview.subviews.count > 0 ? superview.subviews[0] : nil);
	view.backgroundColor = nil;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		view.alpha = kRealTransparentAlphaFactor;
}

%end



%ctor {
	if (!isThisAppEnabled()) return;
	
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.MobileAddressBook"]) {
		%init;
	}
}
