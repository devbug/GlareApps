
#import "Sharing.h"



static BOOL initialized = NO;



%hook SFAirDropIconView

- (void)layoutSubviews {
	%orig;
	
	if (!isWhiteness) {
		UIImageView *_imageView = MSHookIvar<UIImageView *>(self, "_imageView");
		[_imageView _setDrawsAsBackdropOverlay:NO];
		_imageView.image = [_imageView.image _flatImageWithColor:[colorHelper whiteColor]];
	}
}

- (void)setHighlighted:(BOOL)highlighted {
	if (!isWhiteness) {
		//UIImageView *_imageView = MSHookIvar<UIImageView *>(self, "_imageView");
		//[_imageView _setDrawsAsBackdropOverlay:NO];
		//_imageView.image = [_imageView.image _flatImageWithColor:[colorHelper whiteColor]];
		return;
	}
	
	%orig;
}

- (void)setAlpha:(CGFloat)alpha {
	%orig;
	
	if (!isWhiteness) {
		UIImageView *_imageView = MSHookIvar<UIImageView *>(self, "_imageView");
		[_imageView _setDrawsAsBackdropOverlay:NO];
		_imageView.image = [_imageView.image _flatImageWithColor:[colorHelper whiteColor]];
	}
}

%end



void initHookForSharingFramework() {
	if (!isThisAppEnabled() || initialized) return;
	
	if (%c(SFAirDropIconView) != Nil) {
		initialized = YES;
		
		%init;
	}
}
