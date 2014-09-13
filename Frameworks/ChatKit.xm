
#import "headers.h"



%hook CKBalloonView

- (BOOL)canUseOpaqueMask {
	return NO;
}

- (BOOL)isFilled {
	return YES;
}

%end

%hook CKUIBehavior

- (id)gray_balloonTextColor {
	return colorHelper.color_0_0__0_9;
}

%end



%ctor {
	if (!isThisAppEnabled()) return;
	
	%init;
}
