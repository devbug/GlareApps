
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
	
	if ([self.superview isKindOfClass:[UITabBar class]])
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

- (void)layoutSubviews {
	%orig;
	
	self.foregroundColor = blendColor();
	blendView(self);
}

%end




%ctor
{
	if (!isThisAppEnabled()) return;
	if (!useBlendedMode) return;
	
	%init;
}


