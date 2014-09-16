
#import "headers.h"


@interface CalcDisplayView : UIView @end



%hook CalcDisplayView

- (void)layoutSubviews {
	%orig;
	
	self.backgroundColor = [colorHelper clearColor];
}

%end


%hook CalcValueView

+ (UIColor *)textColor {
	return [colorHelper commonTextColor];
}

%end



%ctor {
	if (!isThisAppEnabled()) return;
	
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.calculator"]) {
		%init;
	}
}
