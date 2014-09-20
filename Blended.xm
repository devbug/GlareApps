
#import "headers.h"




UIColor *blendColor() {
	return [colorHelper maskColorForBlendedMode];
}

void blendView(id control) {
	UIView *view = (UIView *)control;
	
	if (view.alpha == 0.0f) return;
	if (view.hidden) return;
	
	if ([view respondsToSelector:@selector(setOpaque:)])
		view.opaque = NO;
	
	UIColor *blendedColor = blendColor();
	
	if ([view respondsToSelector:@selector(setTintColor:)])
		view.tintColor = blendedColor;
	if ([view respondsToSelector:@selector(_setTintColor:)])
		[view performSelector:@selector(_setTintColor:) withObject:blendedColor];
	if ([view respondsToSelector:@selector(_UIAppearance_setTintColor:)])
		[view performSelector:@selector(_UIAppearance_setTintColor:) withObject:blendedColor];
	if ([view respondsToSelector:@selector(setTextColor:)])
		[view performSelector:@selector(setTextColor:) withObject:blendedColor];
	
	if ([view respondsToSelector:@selector(_setDrawsAsBackdropOverlayWithBlendMode:)]) {
		[view _setBackdropMaskViewFlags:2];
		[view _setDrawsAsBackdropOverlayWithBlendMode:!isWhiteness ? kCGBlendModeOverlay : kCGBlendModeMultiply];
	}
}




%hook UINavigationBar

- (void)layoutSubviews {
	%orig;
	
	self.tintColor = blendColor();
	
	for (UIView *v in self.subviews) {
		if (v == self._backgroundView) continue;
		
		blendView(v);
	}
}

- (id)_titleTextColor {
	return blendColor();
}

- (id)buttonItemTextColor {
	return blendColor();
}

- (void)_updateNavigationBarItemsForStyle:(UIBarStyle)style previousTintColor:(id)color {
	%orig;
	
	for (UIView *v in self.subviews) {
		if (v == self._backgroundView) continue;
		
		blendView(v);
	}
}

%end


%hook UINavigationItemView

- (id)_currentTextColorForBarStyle:(UIBarStyle)style {
	return blendColor();
}

%end


%hook UIToolbarButton

- (void)layoutSubviews {
	%orig;
	
	blendView(self);
}

%end


%hook UITabBarButton

- (void)layoutSubviews {
	%orig;
	
	if (self._selected) {
		self._swappableImageView.alpha = 1.0f;
	}
	else {
		self._swappableImageView.alpha = isWhiteness ? 0.3f : 0.2f;
	}
	
	blendView(self);
}

%end


%hook UISegmentedControl

- (void)layoutSubviews {
	%orig;
	
	blendView(self);
}

%end


%hook UIStatusBar

- (void)setForegroundColor:(UIColor *)color animationParameters:(id)params {
	
}

- (void)setForegroundColor:(UIColor *)color {
	
}

- (id)initWithFrame:(CGRect)frame {
	self = %orig;
	
	if (self) {
		UIColor *&_foregroundColor = MSHookIvar<UIColor *>(self, "_foregroundColor");
		[_foregroundColor release];
		_foregroundColor = [blendColor() copy];
		blendView(self);
	}
	
	return self;
}

%end




%ctor
{
	if (!isThisAppEnabled()) return;
	if (!useBlendedMode) return;
	
	%init;
}


