
#import "headers.h"




UIColor *blendColor() {
	return colorHelper.color_0_7__1_0;
}

void blendView(id control) {
	UIView *view = (UIView *)control;
	
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
		[view _setBackdropMaskViewFlags:7];
		[view _setDrawsAsBackdropOverlayWithBlendMode:!isWhiteness ? kCGBlendModeOverlay : kCGBlendModeMultiply];
	}
}




%hook UINavigationBar

- (void)layoutSubviews {
	%orig;
	
	self.tintColor = blendColor();
	
	UILabel *_titleView = MSHookIvar<UILabel *>(self, "_titleView");
	blendView(_titleView);
}

- (id)_titleTextColor {
	return blendColor();
}

%end


%hook UINavigationButton

- (void)layoutSubviews {
	%orig;
	
	blendView(self);
}

%end


%hook UINavigationItemButtonView

- (void)layoutSubviews {
	%orig;
	
	blendView(self);
}

%end


%hook UINavigationItemView

- (void)layoutSubviews {
	%orig;
	
	blendView(self);
}

%end


%hook _UINavigationBarBackIndicatorView

- (void)layoutSubviews {
	%orig;
	
	blendView(self);
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
	
	blendView(self);
}

%end


%hook UISegmentedControl

- (void)layoutSubviews {
	%orig;
	
	blendView(self);
}

%end


%hook UISegment

- (void)layoutSubviews {
	%orig;
	
	if (!self.isSelected)
		blendView(self.label);
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


