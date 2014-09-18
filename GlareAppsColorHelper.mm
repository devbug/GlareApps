
#import "GlareAppsColorHelper.h"



@implementation GlareAppsColorHelper {
	NSMutableDictionary *_objects;
	NSMutableArray *_blurViews;
	BOOL _nowWindowRotating;
}

+ (instancetype)sharedInstance {
	static dispatch_once_t once;
	static GlareAppsColorHelper *sharedInstance;
	
	dispatch_once(&once, ^{
		sharedInstance = [[self alloc] init];
	});
	
	return sharedInstance;
}

- (void)_loadSettings {
	NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/kr.slak.GlareApps.plist"];
	
	_isWhiteness = [dict[@"GlareAppsUseWhiteTheme"] boolValue];
	if (dict[@"GlareAppsUseWhiteTheme"] == nil)
		_isWhiteness = NO;
	
	[dict release];
}

- (void)reloadSettings {
	[self _loadSettings];
}

- (id)init {
	if ((self = [super init])) {
		_objects = [[NSMutableDictionary alloc] init];
		_blurViews = [[NSMutableArray alloc] init];
		
		_nowWindowRotating = NO;
		
		_clearColor = [[UIColor clearColor] retain];
		_whiteColor = [[UIColor whiteColor] retain];
		_blackColor = [[UIColor blackColor] retain];
		_rgbBlackColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f] retain];
		_color_1_0__1_0 = [[UIColor colorWithWhite:1.0f alpha:1.0f] retain];
		_color_0_0__1_0 = [[UIColor colorWithWhite:0.0f alpha:1.0f] retain];
		_color_1_0__0_01 = [[UIColor colorWithWhite:1.0f alpha:0.01f] retain];
		_color_0_0__0_01 = [[UIColor colorWithWhite:0.0f alpha:0.01f] retain];
		_color_1_0__0_1 = [[UIColor colorWithWhite:1.0f alpha:0.1f] retain];
		_color_0_0__0_1 = [[UIColor colorWithWhite:0.0f alpha:0.1f] retain];
		_color_0_0__0_15 = [[UIColor colorWithWhite:0.0f alpha:0.15f] retain];
		_color_1_0__0_2 = [[UIColor colorWithWhite:1.0f alpha:0.2f] retain];
		_color_0_0__0_2 = [[UIColor colorWithWhite:0.0f alpha:0.2f] retain];
		_color_1_0__0_4 = [[UIColor colorWithWhite:1.0f alpha:0.4f] retain];
		_color_0_0__0_4 = [[UIColor colorWithWhite:0.0f alpha:0.4f] retain];
		_color_1_0__0_6 = [[UIColor colorWithWhite:1.0f alpha:0.6f] retain];
		_color_0_0__0_6 = [[UIColor colorWithWhite:0.0f alpha:0.6f] retain];
		_color_1_0__0_8 = [[UIColor colorWithWhite:1.0f alpha:0.8f] retain];
		_color_0_0__0_8 = [[UIColor colorWithWhite:0.0f alpha:0.8f] retain];
		_color_0_0__0_9 = [[UIColor colorWithWhite:0.0f alpha:0.9f] retain];
		_color_0_1__1_0 = [[UIColor colorWithWhite:0.0f alpha:1.0f] retain];
		_color_0_3__1_0 = [[UIColor colorWithWhite:0.3f alpha:1.0f] retain];
		_color_0_75__1_0 = [[UIColor colorWithWhite:0.75f alpha:1.0f] retain];
		_color_0_7__1_0 = [[UIColor colorWithWhite:0.7f alpha:1.0f] retain];
		_color_0_9__0_2 = [[UIColor colorWithWhite:0.9f alpha:0.2f] retain];
		_color_0_9__1_0 = [[UIColor colorWithWhite:0.9f alpha:1.0f] retain];
		_color_0_11__0_2 = [[UIColor colorWithWhite:0.11f alpha:0.2f] retain];
		_color_0_77__0_2 = [[UIColor colorWithWhite:0.77f alpha:0.2f] retain];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillRotate:) name:@"UIWindowWillRotateNotification" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidRotate:) name:@"UIWindowDidRotateNotification" object:nil];
		
		[self _loadSettings];
	}

	return self;
}

- (UIColor *)maskColorForBlendedMode {
	return _color_0_75__1_0;
}

- (UIColor *)fakeWhiteClearColor {
	return _color_1_0__0_01;
}

- (UIColor *)fakeBlackClearColor {
	return _color_0_0__0_01;
}

- (UIColor *)themedFakeClearColor {
	if (_isWhiteness)
		return _color_1_0__0_01;
	
	return _color_0_0__0_01;
}

- (UIColor *)commonTextColor {
	if (_isWhiteness)
		return _blackColor;
	
	return _whiteColor;
}

- (UIColor *)commonTextColorWithAlpha:(CGFloat)alpha {
	UIColor *color = [self commonTextColor];
	
	return [color colorWithAlphaComponent:alpha];
}

- (UIColor *)lightTextColor {
	if (_isWhiteness)
		return _whiteColor;
	
	return _blackColor;
}

- (UIColor *)lightTextColorWithAlpha:(CGFloat)alpha {
	UIColor *color = [self lightTextColor];
	
	return [color colorWithAlphaComponent:alpha];
}

- (UIColor *)keyWindowBackgroundColor {
	return _clearColor;
}

- (UIColor *)systemGrayColor {
	if (_isWhiteness)
		return _color_0_0__0_4;
	
	return _color_1_0__0_4;
}

- (UIColor *)systemLightGrayColor {
	if (_isWhiteness)
		return _color_0_7__1_0;
	
	return _color_0_3__1_0;
}

- (UIColor *)systemDarkGrayColor {
	if (_isWhiteness)
		return _color_0_3__1_0;
	
	return _color_0_7__1_0;
}

- (UIColor *)defaultTableViewCellBackgroundColor {
	if (_isWhiteness)
		return _color_1_0__0_2;
	
	return _color_0_0__0_1;
}

- (UIColor *)defaultTableViewSeparatorColor {
	if (_isWhiteness)
		return _color_0_0__0_2;
	
	return _color_1_0__0_1;
}

- (UIColor *)defaultTableViewGroupCellTextColor {
	return [self commonTextColor];
}

- (UIColor *)defaultAlertViewRepresentationViewBackgroundColor {
	if (_isWhiteness)
		return _color_0_9__1_0;
	
	return _color_0_1__1_0;
}

- (UIColor *)defaultAddressBookCardCellDividerColor {
	if (_isWhiteness)
		return _whiteColor;
	
	return _blackColor;
}

- (UIColor *)preferencesUITableViewBackgroundColor {
	if (_isWhiteness)
		return _color_1_0__0_4;
	
	return _color_0_0__0_2;
}

- (UIColor *)stocksListTableViewCellSelectedColor {
	if (_isWhiteness)
		return _color_0_77__0_2;
	
	return _color_0_11__0_2;
}

- (UIColor *)mobilePhoneDialerBackgroundColor {
	if (_isWhiteness)
		return _color_1_0__0_6;
	
	return _color_0_0__0_6;
}

- (UIColor *)themedMusicSliderMaximumTrackImageTintColor {
	if (_isWhiteness)
		return [self _musicSliderMaximumTrackImageTintColorIfWhiteness];
	
	return [self _musicSliderMaximumTrackImageTintColorIfDarkness];
}

- (UIColor *)_musicSliderMaximumTrackImageTintColorIfDarkness {
	return _color_1_0__0_1;
}

- (UIColor *)_musicSliderMaximumTrackImageTintColorIfWhiteness {
	return _color_0_0__0_15;
}

- (UIColor *)musicNowPlayingViewTitlesDetailLabelTextColor {
	if (_isWhiteness)
		return _color_0_0__0_6;
	
	return _color_1_0__0_6;
}

- (UIColor *)musicTableViewCellTextColor {
	if (_isWhiteness)
		return _color_0_0__0_8;
	
	return _color_1_0__0_8;
}

- (UIColor *)colorWithWhite:(CGFloat)white alpha:(CGFloat)alpha {
	UIColor *color = [[UIColor alloc] initWithWhite:white alpha:alpha];
	
	return [color autorelease];
}
- (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	UIColor *color = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:alpha];
	
	return [color autorelease];
}


- (void)addBlurView:(_UIBackdropView *)view {
	if (![_blurViews containsObject:view]) {
		[_blurViews addObject:view];
		[view release];
	}
}

- (void)removeBlurView:(_UIBackdropView *)view {
	if ([_blurViews containsObject:view]) {
		[view retain];
		[_blurViews removeObject:view];
	}
}

- (BOOL)nowWindowRotating {
	return _nowWindowRotating;
}

- (BOOL)isOwnBlurView:(_UIBackdropView *)backdrop {
	return [_blurViews containsObject:backdrop];
}

// UIWindowNewOrientationUserInfoKey
- (void)windowWillRotate:(NSNotification *)notification {
	_nowWindowRotating = YES;
}

- (void)windowDidRotate:(NSNotification *)notification {
	_nowWindowRotating = NO;
	
	for (_UIBackdropView *v in [_UIBackdropView allBackdropViews]) {
		if ([self needsToSetOwnBackgroundColorForBackdropView:v])
			v.backgroundColor = _clearColor;
	}
}

- (BOOL)needsToSetOwnBackgroundColorForBackdropView:(_UIBackdropView *)view {
	if ([view __glareapps_shouldRejectOwnBackgroundColor])
		return NO;
	
	if ([self isOwnBlurView:view])
		return YES;
	if ([view.superview isKindOfClass:[UITableViewHeaderFooterView class]])
		return YES;
	if ([view.superview isKindOfClass:objc_getClass("UISearchBarBackground")])
		return YES;
	if ([view.superview isKindOfClass:objc_getClass("UISearchDisplayControllerContainerView")])
		return YES;
	
	return NO;
}


- (void)dealloc {
	[_objects removeAllObjects];
	[_objects release];
	_objects = nil;
	
	[_blurViews removeAllObjects];
	[_blurViews release];
	_blurViews = nil;
	
	[_clearColor release]; _clearColor = nil;
	[_whiteColor release]; _whiteColor = nil;
	[_blackColor release]; _blackColor = nil;
	[_rgbBlackColor release]; _rgbBlackColor = nil;
	[_color_1_0__1_0 release]; _color_1_0__1_0 = nil;
	[_color_0_0__1_0 release]; _color_0_0__1_0 = nil;
	[_color_1_0__0_01 release]; _color_1_0__0_01 = nil;
	[_color_0_0__0_01 release]; _color_0_0__0_01 = nil;
	[_color_1_0__0_1 release]; _color_1_0__0_1 = nil;
	[_color_0_0__0_1 release]; _color_0_0__0_1 = nil;
	[_color_0_0__0_15 release]; _color_0_0__0_15 = nil;
	[_color_1_0__0_2 release]; _color_1_0__0_2 = nil;
	[_color_0_0__0_2 release]; _color_0_0__0_2 = nil;
	[_color_1_0__0_4 release]; _color_1_0__0_4 = nil;
	[_color_0_0__0_4 release]; _color_0_0__0_4 = nil;
	[_color_1_0__0_6 release]; _color_1_0__0_6 = nil;
	[_color_0_0__0_6 release]; _color_0_0__0_6 = nil;
	[_color_1_0__0_8 release]; _color_1_0__0_8 = nil;
	[_color_0_0__0_8 release]; _color_0_0__0_8 = nil;
	[_color_0_0__0_9 release]; _color_0_0__0_9 = nil;
	[_color_0_1__1_0 release]; _color_0_1__1_0 = nil;
	[_color_0_3__1_0 release]; _color_0_3__1_0 = nil;
	[_color_0_7__1_0 release]; _color_0_7__1_0 = nil;
	[_color_0_75__1_0 release]; _color_0_75__1_0 = nil;
	[_color_0_9__0_2 release]; _color_0_9__0_2 = nil;
	[_color_0_9__1_0 release]; _color_0_9__1_0 = nil;
	[_color_0_11__0_2 release]; _color_0_11__0_2 = nil;
	[_color_0_77__0_2 release]; _color_0_77__0_2 = nil;
	
	[super dealloc];
}

@end
