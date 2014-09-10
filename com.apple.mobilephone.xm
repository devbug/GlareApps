
#import "headers.h"



@interface PHAbstractDialerView : UIView
- (UIControl *)deleteButton;
- (UIControl *)callButton;
- (UIControl *)addContactButton;
- (UIView *)phonePadView;
- (UIView *)lcdView;
- (BOOL)inCallMode;
@end
@interface PHHandsetDialerView : PHAbstractDialerView
- (UIView *)dimmingView;
- (UIView *)topBlankView;
- (UIView *)bottomBlankView;
- (UIView *)rightBlankView;
- (UIView *)leftBlankView;
- (UIColor *)dialerColor;
@end

@interface DialerController : UIViewController
- (PHAbstractDialerView *)dialerView;
@end

@interface PHHandsetDialerLCDView : UIView
- (UILabel *)numberLabel;
@end

@interface TPNumberPadLightStyleButton : UIControl
+ (id)imageForCharacter:(NSUInteger)character highlighted:(BOOL)highlighted;
+ (id)imageForCharacter:(NSUInteger)character;
@end
@interface TPNumberPadDarkStyleButton : UIControl
+ (id)imageForCharacter:(NSUInteger)character highlighted:(BOOL)highlighted;
+ (id)imageForCharacter:(NSUInteger)character;
@end




NSInteger currentBackdropStyle				= 0;


%hook UIApplication

- (void)__glareapps_applicationDidFinishLaunching {
	[[UIApplication sharedApplication] setStatusBarStyle:kBarStyleForWhiteness];
}

- (void)_setBackgroundStyle:(NSInteger)style {
	if (style < 1) style = (isFirmware71 ? 3 : 2) + (isWhiteness ? 0 : 1);
	
	currentBackdropStyle = style;
	
	%orig;
}

%end

%hook UIViewController

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	
	UIView *subview = (self.view.subviews.count > 0 ? self.view.subviews[0] : nil);
	subview.backgroundColor = [UIColor clearColor];
}

%end


%hook PhoneApplication

- (void)applicationWillEnterForeground:(id)application {
	%orig;
	
	[[UIApplication sharedApplication] setStatusBarStyle:kBarStyleForWhiteness];
}

- (void)applicationResume:(GSEventRef)event {
	%orig;
	
	[[UIApplication sharedApplication] setStatusBarStyle:kBarStyleForWhiteness];
}

%end


%hook PHHandsetDialerView

- (id)dialerColor {
	return [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:0.6f];
}

%end


%hook PHHandsetDialerLCDView

- (id)lcdColor {
	return [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:0.6f];
}

- (void)setText:(id)text needsFormat:(BOOL)format {
	%orig;
	
	self.numberLabel.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:1.0];
}

%end


%hook PHFavoritesCell

- (void)layoutSubviews {
	%orig;
	
	UILabel *_labelTextLabel = MSHookIvar<UILabel *>(self, "_labelTextLabel");
	
	_labelTextLabel.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kTintColorAlphaFactor];
}

%end


%hook PHRecentsCell

- (void)setCall:(id)call {
	%orig;
	
	UILabel *_callerNameLabel = MSHookIvar<UILabel *>(self, "_callerNameLabel");
	UILabel *_callerLabelLabel = MSHookIvar<UILabel *>(self, "_callerLabelLabel");
	UILabel *_callerCountLabel = MSHookIvar<UILabel *>(self, "_callerCountLabel");
	UILabel *_callerDateLabel = MSHookIvar<UILabel *>(self, "_callerDateLabel");
	
	setLabelTextColorIfHasBlackColor(_callerNameLabel);
	setLabelTextColorIfHasBlackColor(_callerLabelLabel);
	setLabelTextColorIfHasBlackColor(_callerCountLabel);
	_callerDateLabel.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kTintColorAlphaFactor];
	
	UIImageView *_callTypeIconView = MSHookIvar<UIImageView *>(self, "_callTypeIconView");
	
	_callTypeIconView.image = [_callTypeIconView.image _flatImageWithWhite:kLightColorWithWhiteForWhiteness alpha:1.0];
}

%end


%hook TPNumberPadLightStyleButton

+ (id)imageForCharacter:(NSUInteger)character {
	if (isWhiteness) return %orig;
	
	return [%c(TPNumberPadDarkStyleButton) imageForCharacter:character];
}

%end


%hook DialerController

- (void)viewWillAppear:(BOOL)animated {
	%orig(NO);
	
	_UIBackdropView *backdropView = (_UIBackdropView *)[self.dialerView viewWithTag:0xc001];
	[backdropView retain];
	
	CGRect frame = self.dialerView.frame;
	frame.origin.x = 0;
	
	if (backdropView == nil) {
		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleSystemDefaultSemiLight graphicsQuality:kBackdropGraphicQualitySystemDefault];
		settings.grayscaleTintAlpha = 0.0f;
		settings.blurRadius = 10.f;
		
		backdropView = [[_UIBackdropView alloc] initWithFrame:frame autosizesToFitSuperview:YES settings:settings];
		backdropView.tag = 0xc001;
		
		[self.dialerView insertSubview:backdropView atIndex:0];
	}
	
	backdropView.frame = frame;
	
	[backdropView release];
	
	[[UIApplication sharedApplication] _setBackgroundStyle:1];
}

- (void)viewDidAppear:(BOOL)animated {
	%orig;
	
	[[UIApplication sharedApplication] setStatusBarStyle:kBarStyleForWhiteness];
}

- (void)viewWillDisappear:(BOOL)animated {
	%orig;
	
	[[UIApplication sharedApplication] _setBackgroundStyle:0];
}

%end


%hook UITableViewCell

- (BOOL)__glareapps_isNeedsToSetJustClearBackground {
	return YES;
}

%end



%ctor {
	if (!isThisAppEnabled()) return;
	
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.mobilephone"]) {
		%init;
	}
}
