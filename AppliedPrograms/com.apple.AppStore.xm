
#import "headers.h"




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
