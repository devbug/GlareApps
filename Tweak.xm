
#import "headers.h"




#pragma mark -
#pragma mark Settings


static BOOL GlareAppsEnable = YES;
static NSArray *GlareAppsWhiteList = nil;


static void LoadSettings() {
	NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/kr.slak.GlareApps.plist"];
	if (!dict) return;
	
	GlareAppsEnable = [dict[@"GlareAppsEnable"] boolValue];
	if (dict[@"GlareAppsEnable"] == nil)
		GlareAppsEnable = YES;
	
	if (!GlareAppsWhiteList){
		[GlareAppsWhiteList release];
		GlareAppsWhiteList = nil;
	}
	if (dict[@"WhiteList"] != nil)
		GlareAppsWhiteList = [dict[@"WhiteList"] retain];
	
	isWhiteness = [dict[@"GlareAppsUseWhiteTheme"] boolValue];
	if (dict[@"GlareAppsUseWhiteTheme"] == nil)
		isWhiteness = NO;
	
	[dict release];
}

void reloadPrefsNotification(CFNotificationCenterRef center,
							void *observer,
							CFStringRef name,
							const void *object,
							CFDictionaryRef userInfo) {
	LoadSettings();
}

BOOL isThisAppEnabled() {
	if (!GlareAppsEnable) return NO;
	
	if (GlareAppsWhiteList) {
		if (![GlareAppsWhiteList containsObject:[[NSBundle mainBundle] bundleIdentifier]])
			return NO;
	} else return NO;
	
	return YES;
}

void setLabelTextColorIfHasBlackColor(UILabel *label) {
	if (label.attributedText) return;
	
	if ([label.textColor isEqual:[UIColor blackColor]] 
			|| [label.textColor isEqual:[UIColor colorWithWhite:0.0 alpha:1.0]] 
			|| [label.textColor isEqual:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]]) {
		label.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:1.0f];
		return;
	}
	
	if ([[label.textColor description] hasPrefix:@"UIDeviceWhiteColorSpace"]) {
		CGFloat white = 0.0f, alpha = 0.0f;
		[label.textColor getWhite:&white alpha:&alpha];
		
		if (white != kLightColorWithWhiteForWhiteness && white < 0.4) {
			label.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:fabs(1.0-white)*alpha];
		}
	}
}

NSMutableAttributedString *colorReplacedAttributedString(NSAttributedString *text) {
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:text];
	[attributedString enumerateAttributesInRange:(NSRange){0,[attributedString length]} 
										 options:NSAttributedStringEnumerationReverse 
									  usingBlock:^(NSDictionary *attributes, NSRange range, BOOL *stop) {
		NSMutableDictionary *mutableAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
		UIColor *color = mutableAttributes[@"NSColor"];
		if ([[color description] hasPrefix:@"UIDeviceWhiteColorSpace"]) {
			CGFloat white = 0.0f, alpha = 0.0f;
			[color getWhite:&white alpha:&alpha];
			mutableAttributes[@"NSColor"] = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:alpha];
		}
		[attributedString setAttributes:mutableAttributes range:range];
	}];
	
	return [attributedString autorelease];
}



#pragma mark -
#pragma mark Global


BOOL isWhiteness							= NO;
BOOL isFirmware70							= YES;
BOOL isFirmware71							= NO;

UIKBRenderConfig *kbRenderConfig			= nil;




@implementation UIApplication (GlareApps)

- (void)__glareapps_applicationDidFinishLaunching {
	[[UIApplication sharedApplication] _setApplicationBackdropStyle:kBackdropStyleForWhiteness];
	[[UIApplication sharedApplication] setStatusBarStyle:kBarStyleForWhiteness];
	[[UIApplication sharedApplication] keyWindow].backgroundColor = nil;
}

@end



%group Launching_1

%hook AppDelegate

- (void)applicationDidFinishLaunching:(id)application {
	%orig;
	
	[[UIApplication sharedApplication] __glareapps_applicationDidFinishLaunching];
}

%end

%end

%group Launching_2

%hook AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	BOOL rtn = %orig;
	
	[[UIApplication sharedApplication] __glareapps_applicationDidFinishLaunching];
	
	return rtn;
}

%end

%end

%group Launching_3

%hook AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	BOOL rtn = %orig;
	
	[[UIApplication sharedApplication] __glareapps_applicationDidFinishLaunching];
	
	return rtn;
}

%end

%end


%group Rotate_1

%hook AppDelegate

- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration {
	%orig;
	
	[[UIApplication sharedApplication] keyWindow].backgroundColor = [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:0.2f];
}

%end

%end

%group Rotate_2

%hook AppDelegate

- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
	%orig;
	
	[[UIApplication sharedApplication] keyWindow].backgroundColor = nil;
}

%end

%end


%group Rotate_New_1

%hook AppDelegate

%new
- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration {
	[[UIApplication sharedApplication] keyWindow].backgroundColor = [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:0.2f];
}

%end

%end

%group Rotate_New_2

%hook AppDelegate

%new
- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
	[[UIApplication sharedApplication] keyWindow].backgroundColor = nil;
}

%end

%end


%hook UIApplication

- (NSInteger)_loadMainInterfaceFile {
	NSInteger rtn = %orig;
	
	id delegate = [self delegate];
	Class $AppDelegate = delegate ? [delegate class] : [self class];
	
	if ([$AppDelegate instancesRespondToSelector:@selector(applicationDidFinishLaunching:)]) {
		%init(Launching_1, AppDelegate = $AppDelegate);
	}
	else if ([$AppDelegate instancesRespondToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
		%init(Launching_2, AppDelegate = $AppDelegate);
	}
	else if ([$AppDelegate instancesRespondToSelector:@selector(application:willFinishLaunchingWithOptions:)]) {
		%init(Launching_3, AppDelegate = $AppDelegate);
	}
	
	//[[UIApplication sharedApplication] _setApplicationBackdropStyle:kBackdropStyleForWhiteness];
	//[[UIApplication sharedApplication] setStatusBarStyle:kBarStyleForWhiteness];
	//[[UIApplication sharedApplication] keyWindow].backgroundColor = nil;
	
	if ([$AppDelegate instancesRespondToSelector:@selector(application:willChangeStatusBarOrientation:)]) {
		%init(Rotate_1, AppDelegate = $AppDelegate);
	}
	else {
		%init(Rotate_New_1, AppDelegate = $AppDelegate);
	}
	
	if ([$AppDelegate instancesRespondToSelector:@selector(application:didChangeStatusBarOrientation:)]) {
		%init(Rotate_2, AppDelegate = $AppDelegate);
	}
	else {
		%init(Rotate_New_2, AppDelegate = $AppDelegate);
	}
	
	return rtn;
}

%end


%hook UINavigationController

- (BOOL)_clipUnderlapWhileTransitioning {
	return YES;
}

%end

%hook _UINavigationParallaxTransition

- (BOOL)clipUnderlapWhileTransitioning {
	return YES;
}

- (void)setClipUnderlapWhileTransitioning:(BOOL)flag {
	%orig(YES);
}

%end


void clearBar(UIView *view) {
	if (![view respondsToSelector:@selector(setBarTintColor:)] || ![view respondsToSelector:@selector(setTranslucent:)]) return;
	
	UINavigationBar *bar = (UINavigationBar *)view;
	
	bar.barStyle = kBarStyleForWhiteness;
	
	bar.barTintColor = nil;
	bar.backgroundColor = [UIColor clearColor];
	bar.translucent = YES;
	
	[bar setNeedsLayout];
}

%hook UIViewController

- (void)viewWillAppear:(BOOL)animated {
	clearBar(self.navigationController.navigationBar);
	clearBar(self.navigationController.toolbar);
	clearBar(self.tabBarController.tabBar);
	
	%orig;
	
	[[UIApplication sharedApplication] setStatusBarStyle:kBarStyleForWhiteness];
	self.view.backgroundColor = [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kTransparentAlphaFactor];
	self.dropShadowView.backgroundColor = nil;
}

- (void)viewDidAppear:(BOOL)animated {
	%orig;
	
	[[UIApplication sharedApplication] setStatusBarStyle:kBarStyleForWhiteness];
}

%end


@interface UIView (GlareApps)
- (void)__glareapps_backgroundTest;
@end

@implementation UIView (GlareApps)

- (void)__glareapps_backgroundTest {
	UIColor *color = self.backgroundColor;
	
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.Music"])
		return;
	
	if ([self isKindOfClass:[UITableViewCell class]]) {
		return;
	}
	
	if ([self respondsToSelector:@selector(setTransparentBackground:)]) {
		[self performSelector:@selector(setTransparentBackground:) withObject:@(YES)];
	}
	
	NSString *selfclass = NSStringFromClass(self.class);
	NSString *superviewclass = NSStringFromClass(self.superview.class);
	
	if ([selfclass hasPrefix:@"_UIModalItem"]) {
		return;
	}
	if ([selfclass hasPrefix:@"_UI"] || [superviewclass hasPrefix:@"_UI"]) {
		return;
	}
	if ([selfclass hasPrefix:@"UISearch"] || [superviewclass hasPrefix:@"UISearch"]) {
		return;
	}
	if ([selfclass hasPrefix:@"UIAction"] || [superviewclass hasPrefix:@"UIAction"]) {
		return;
	}
	if ([selfclass hasPrefix:@"UIAlert"] || [superviewclass hasPrefix:@"UIAlert"]) {
		return;
	}
	if (self.window != nil && self.window != [UIApplication sharedApplication].keyWindow) {
		return;
	}
	
	if ([color isEqual:[UIColor clearColor]]) {
		return;
	}
	if ([color isEqual:[UIColor blackColor]] || [color isEqual:[UIColor whiteColor]]) {
		self.backgroundColor = [UIColor clearColor];
		return;
	}
	if (color != nil && ![color isEqual:[UIColor clearColor]]
			&& [[color description] hasPrefix:@"UIDeviceWhiteColorSpace"]
			&& ![color isEqual:[UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:0.2f]]
			&& ![color isEqual:[UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kJustClearAlphaFactor * 2.0f]]
			&& ![color isEqual:[UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kTransparentAlphaFactor]]
			&& ![color isEqual:[UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kJustClearAlphaFactor]]
			&& ![color isEqual:[UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kClearAlphaFactor]]) {
		//self.backgroundColor = [UIColor clearColor];
		return;
	}
}

@end

%hook UIView

- (id)initWithFrame:(CGRect)frame {
	id rtn = %orig;
	
	if (rtn) {
		[self __glareapps_backgroundTest];
	}
	
	return rtn;
}

- (id)init {
	id rtn = %orig;
	
	if (rtn) {
		[self __glareapps_backgroundTest];
	}
	
	return rtn;
}

- (id)initWithCoder:(id)zone {
	id rtn = %orig;
	
	if (rtn) {
		[self __glareapps_backgroundTest];
	}
	
	return rtn;
}

- (void)layoutSubviews {
	[self __glareapps_backgroundTest];
	
	%orig;
}

- (void)setBackgroundColor:(UIColor *)color {
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.Music"]) {
		%orig;
		return;
	}
	
	if ([self isKindOfClass:[UITableViewCell class]]) {
		%orig;
		return;
	}
	
	NSString *selfclass = NSStringFromClass(self.class);
	NSString *superviewclass = NSStringFromClass(self.superview.class);
	
	if ([selfclass hasPrefix:@"_UIModalItem"]) {
		%orig;
		return;
	}
	if ([selfclass hasPrefix:@"_UI"] || [superviewclass hasPrefix:@"_UI"]) {
		%orig;
		return;
	}
	if ([selfclass hasPrefix:@"UISearch"] || [superviewclass hasPrefix:@"UISearch"]) {
		%orig;
		return;
	}
	if ([selfclass hasPrefix:@"UIAction"] || [superviewclass hasPrefix:@"UIAction"]) {
		%orig;
		return;
	}
	if ([selfclass hasPrefix:@"UIAlert"] || [superviewclass hasPrefix:@"UIAlert"]) {
		%orig;
		return;
	}
	if (self.window != nil && self.window != [UIApplication sharedApplication].keyWindow) {
		%orig;
		return;
	}
	
	if ([color isEqual:[UIColor clearColor]]) {
		%orig;
		return;
	}
	if ([color isEqual:[UIColor whiteColor]]) {
		%orig([UIColor clearColor]);
		return;
	}
	if (color != nil && ![color isEqual:[UIColor clearColor]]
			&& [[color description] hasPrefix:@"UIDeviceWhiteColorSpace"]
			&& ![color isEqual:[UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:0.2f]]
			&& ![color isEqual:[UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kJustClearAlphaFactor * 2.0f]]
			&& ![color isEqual:[UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kTransparentAlphaFactor]]
			&& ![color isEqual:[UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kJustClearAlphaFactor]]
			&& ![color isEqual:[UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kClearAlphaFactor]]) {
		//%orig([UIColor clearColor]);
		//return;
	}
	
	%orig;
}

%end


@interface UILabel (GlareApps)
- (BOOL)__glareapps_isActionSheetOrActivityGroup;
@end

@implementation UILabel (GlareApps)

- (BOOL)__glareapps_isActionSheetOrActivityGroup {
	BOOL isActionSheetOrActivityGroup = NO;
	
	NSString *superviewName = NSStringFromClass([self.superview class]);
	NSString *supersuperviewName = NSStringFromClass([self.superview.superview class]);
	
	isActionSheetOrActivityGroup = [superviewName hasPrefix:@"UIActionSheet"];
	if (!isActionSheetOrActivityGroup && [superviewName hasPrefix:@"UIAlert"]) {
		isActionSheetOrActivityGroup = [supersuperviewName hasPrefix:@"UIActionSheet"];
	}
	if (!isActionSheetOrActivityGroup)
		isActionSheetOrActivityGroup = [superviewName hasPrefix:@"UIActivityGroup"];
	if (!isActionSheetOrActivityGroup)
		isActionSheetOrActivityGroup = [superviewName hasPrefix:@"_UIToolbar"];
	if (!isActionSheetOrActivityGroup)
		isActionSheetOrActivityGroup = [superviewName isEqualToString:@"PLWallpaperButton"];
	
	return isActionSheetOrActivityGroup;
}

@end


%hook UILabel

- (void)setTextColor:(UIColor *)textColor {
	CGFloat white = 0.0f, alpha = 0.0f;
	
	if (![self.superview isKindOfClass:%c(UITableViewCellContentView)] 
			&& [[textColor description] hasPrefix:@"UIDeviceWhiteColorSpace"] && [textColor getWhite:&white alpha:&alpha]) {
		if (white == 0.5 && alpha == 1.0f)
			textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kTintColorAlphaFactor];
	}
	
	NSString *selfText = nil;
	if ([self isKindOfClass:%c(UIDateLabel)])
		selfText = ((UIDateLabel *)self)._dateString;
	else
		selfText = self.text;
	
	if (!isWhiteness && selfText && ![self __glareapps_isActionSheetOrActivityGroup]
			&& [[textColor description] hasPrefix:@"UIDeviceWhiteColorSpace"] && [textColor getWhite:&white alpha:&alpha]) {
		if (white != kLightColorWithWhiteForWhiteness)
			textColor = [UIColor colorWithWhite:fabs(kLightColorWithWhiteForWhiteness - white) alpha:alpha];
	}
	
	%orig;
}

- (void)setText:(NSString *)text {
	%orig;
	
	self.textColor = self.textColor;
}

- (void)setAttributedText:(NSAttributedString *)text {
	%orig(colorReplacedAttributedString(text));
}

%end


%hook UITextView

- (void)setTextColor:(UIColor *)textColor {
	CGFloat white = 0.0f, alpha = 0.0f;
	
	if (![self.superview isKindOfClass:%c(UITableViewCellContentView)] 
			&& [[textColor description] hasPrefix:@"UIDeviceWhiteColorSpace"] && [textColor getWhite:&white alpha:&alpha]) {
		if (white == 0.5 && alpha == 1.0f)
			textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kTintColorAlphaFactor];
	}
	
	%orig;
}

- (UIKeyboardAppearance)keyboardAppearance {
	return (isWhiteness ? UIKeyboardAppearanceLight : UIKeyboardAppearanceDark);
}

- (void)setKeyboardAppearance:(UIKeyboardAppearance)appearance {
	%orig((isWhiteness ? UIKeyboardAppearanceLight : UIKeyboardAppearanceDark));
}

- (void)layoutSubviews {
	%orig;
	
	if (!isWhiteness && [self.textColor isEqual:[UIColor blackColor]])
		self.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:1.0];
	if ([self respondsToSelector:@selector(setKeyboardAppearance:)] && ![self isKindOfClass:%c(CKBalloonTextView)])
		self.keyboardAppearance = (isWhiteness ? UIKeyboardAppearanceLight : UIKeyboardAppearanceDark);
}

%end

%hook UITextField

- (UIKeyboardAppearance)keyboardAppearance {
	return (isWhiteness ? UIKeyboardAppearanceLight : UIKeyboardAppearanceDark);
}

- (void)setKeyboardAppearance:(UIKeyboardAppearance)appearance {
	%orig((isWhiteness ? UIKeyboardAppearanceLight : UIKeyboardAppearanceDark));
}

- (void)layoutSubviews {
	%orig;
	
	NSString *superviewName = NSStringFromClass([self.superview class]);
	
	if (!isWhiteness && [self.textColor isEqual:[UIColor blackColor]] && ![superviewName hasPrefix:@"_UIModalItem"])
		self.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:1.0];
	if ([self respondsToSelector:@selector(setKeyboardAppearance:)])
		self.keyboardAppearance = (isWhiteness ? UIKeyboardAppearanceLight : UIKeyboardAppearanceDark);
}

- (id)_placeholderColor {
	return [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kTintColorAlphaFactor];
}

%end


%hook UIKBRenderConfig

+ (id)darkConfig {
	return kbRenderConfig;
}
+ (id)defaultConfig {
	return kbRenderConfig;
}

%end


%hook _UIModalItemContentView

- (void)layout {
	%orig;
	
	self.backgroundColor = nil;
	self.buttonTable.backgroundColor = nil;
	self.titleLabel.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:1.0f];
	self.subtitleLabel.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:1.0f];
	self.messageLabel.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:1.0f];
}

%end

%hook _UIModalItemAlertContentView

- (void)layout {
	%orig;
	
	self.backgroundColor = nil;
	self.buttonTable.backgroundColor = nil;
	self.titleLabel.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:1.0f];
	self.subtitleLabel.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:1.0f];
	self.messageLabel.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:1.0f];
}

%end


%hook UIColor

+ (id)darkTextColor {
	UIColor *color = %orig;
	return [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:color.alphaComponent];
}
+ (id)lightTextColor {
	UIColor *color = %orig;
	return [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:color.alphaComponent];
}
+ (id)systemGrayColor {
	return [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kTintColorAlphaFactor];
}
+ (id)tablePlainHeaderFooterFloatingBackgroundColor {
	return [UIColor clearColor];
}
+ (id)tablePlainHeaderFooterBackgroundColor {
	return [UIColor clearColor];
}
+ (id)tableCellbackgroundColorPigglyWiggly {
	return [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kJustClearAlphaFactor];
}
+ (id)tableCellBackgroundColor {
	return [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kJustClearAlphaFactor];
}
+ (id)tableCellGroupedBackgroundColorLegacyWhite {
	return [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kJustClearAlphaFactor];
}
+ (id)tableCellPlainBackgroundColor {
	return [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kJustClearAlphaFactor];
}
+ (id)tableBackgroundColor {
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.Preferences"])
		return [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kJustClearAlphaFactor * 2.0f];
	
	return [UIColor clearColor];
}
+ (id)sectionHeaderOpaqueBackgroundColor {
	return [UIColor clearColor];
}
+ (id)sectionHeaderBackgroundColor {
	return [UIColor clearColor];
}
+ (id)tableCellGrayTextColor {
	return [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kTintColorAlphaFactor];
}
+ (id)noContentDarkGradientBackgroundColor {
	return [UIColor clearColor];
}
+ (id)noContentLightGradientBackgroundColor {
	return [UIColor clearColor];
}
+ (id)tableGroupedSeparatorLightColor {
	return [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kClearAlphaFactor];
}
+ (id)tableSeparatorLightColor {
	return [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kClearAlphaFactor];
}
+ (id)tableSeparatorDarkColor {
	return [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kClearAlphaFactor];
}
+ (id)tableCellGroupedBackgroundColor {
	return [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kJustClearAlphaFactor];
}
+ (id)groupTableViewBackgroundColor {
	return [UIColor clearColor];
}

%end



#pragma mark -
#pragma mark UICollectionView


%hook UICollectionView

- (void)layoutSubviews {
	%orig;
	
	self.backgroundView = nil;
	self.backgroundColor = nil;
}

- (void)_updateBackgroundView {
	//%orig;
	
	self.backgroundView = nil;
	self.backgroundColor = nil;
}

%end


%hook UICollectionViewCell

- (void)layoutSubviews {
	%orig;
	
	self.backgroundColor = [UIColor clearColor];
	self.backgroundView.alpha = 0.0f;
	self.contentView.backgroundColor = nil;
}

- (void)_updateBackgroundView {
	%orig;
	
	self.backgroundView = nil;
	self.backgroundColor = [UIColor clearColor];
}

%end



#pragma mark -
#pragma mark UITableView (basic)


%hook UITableView

- (void)layoutSubviews {
	%orig;

	if (self.superview) {
		self.sectionIndexBackgroundColor = [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kClearAlphaFactor];
	}
}

- (UIColor *)backgroundColor {
	return [UIColor clearColor];
}

- (void)setBackgroundColor:(id)color {
	%orig([UIColor clearColor]);
}

- (void)_setBackgroundColor:(id)color animated:(BOOL)animated {
	%orig([UIColor clearColor], animated);
}

- (UIColor *)sectionIndexBackgroundColor {
	return [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kJustClearAlphaFactor];
}

- (void)setSectionIndexBackgroundColor:(UIColor *)color {
	%orig([UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kJustClearAlphaFactor]);
}

- (id)_defaultSeparatorColor {
	return [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kClearAlphaFactor];
}

- (UIColor *)separatorColor {
	return [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kClearAlphaFactor];
}

- (void)setSeparatorColor:(UIColor *)color {
	%orig([UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kClearAlphaFactor]);
}

- (id)tableHeaderBackgroundColor {
	return [UIColor clearColor];
}

- (void)setTableHeaderBackgroundColor:(id)color {
	%orig([UIColor clearColor]);
}

%end


@interface UITableViewHeaderFooterView (GlareApps)
- (void)__glareapps_setBackground;
@end

@implementation UITableViewHeaderFooterView (GlareApps)

- (void)__glareapps_setBackground {
	if (self.tableView && ![self.backgroundView isKindOfClass:%c(_UIBackdropView)]) {
		self.backgroundColor = nil;
		self.contentView.backgroundColor = [UIColor clearColor];
		self.tintColor = nil;
		if ([self respondsToSelector:@selector(setBackgroundImage:)])
			self.backgroundImage = nil;
		
		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleSystemDefaultSemiLight graphicsQuality:kBackdropGraphicQualitySystemDefault];
		settings.grayscaleTintLevel = (isWhiteness ? 1.0f : 0.0f);
		
		if (![self.backgroundView isKindOfClass:[_UIBackdropView class]]) {
			_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
			self.backgroundView = backdropView;
			[backdropView release];
		}
	}
}

@end

%hook UITableViewHeaderFooterView

- (void)layoutSubviews {
	%orig;
	
	self.textLabel.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kTintColorAlphaFactor];
	
	if (self.tableView != nil && self.tableView.style == UITableViewStyleGrouped) return;
	if ([self.class requiresConstraintBasedLayout]) return;
	
	[self __glareapps_setBackground];
}

- (void)updateConstraints {
	%orig;
	
	self.textLabel.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kTintColorAlphaFactor];
	
	if (self.tableView != nil && self.tableView.style == UITableViewStyleGrouped) return;
	if (![self.class requiresConstraintBasedLayout]) return;
	
	[self __glareapps_setBackground];
}

%end


UIImage *disclosureImage = nil;
UIImage *disclosureImageWhite = nil;
UIImage *disclosureImageBlack = nil;

void setDisclosureImage(UIImageView *iv) {
	if (disclosureImageBlack == nil) {
		disclosureImageBlack = [iv.image _flatImageWithWhite:0.0f alpha:kTintColorAlphaFactor];
		disclosureImageWhite = [iv.image _flatImageWithWhite:1.0f alpha:kTintColorAlphaFactor];
		[disclosureImageBlack retain];
		[disclosureImageWhite retain];
	}
	if (disclosureImage == nil) {
		if (isWhiteness)
			disclosureImage = disclosureImageBlack;
		else
			disclosureImage = disclosureImageWhite;
	}
	
	if (iv.image != disclosureImage)
		iv.image = disclosureImage;
}

%hook UITableViewCell

- (void)layoutSubviews {
	%orig;
	
	if (![[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.Music"])
		self.backgroundColor = [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kJustClearAlphaFactor];
	
	self.textLabel.backgroundColor = [UIColor clearColor];
	self.detailTextLabel.backgroundColor = [UIColor clearColor];
	self.detailTextLabel.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kTintColorAlphaFactor];
	
	setLabelTextColorIfHasBlackColor(self.textLabel);
	
	for (UILabel *label in self.contentView.subviews) {
		if ([label isKindOfClass:[UILabel class]]) {
			label.backgroundColor = [UIColor clearColor];
			
			setLabelTextColorIfHasBlackColor(label);
		}
	}
	
	if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
		UIView *accessoryView = [self _currentAccessoryView:YES];
		
		for (UIView *v in accessoryView.subviews) {
			if (v.alpha == 0.0f) continue;
			
			if ([v isKindOfClass:[UIImageView class]]) {
				setDisclosureImage((UIImageView *)v);
				
				break;
			}
		}
	}
}

%end

%hook UITableViewCellDetailDisclosureView

- (CGSize)sizeThatFits:(CGSize)fitSize {
	CGSize rtn = %orig;
	
	UIImageView *_disclosureView = MSHookIvar<UIImageView *>(self, "_disclosureView");
	
	setDisclosureImage(_disclosureView);
	
	return rtn;
}

%end


UIImage *reorderImage = nil;
UIImage *reorderImageWhite = nil;
UIImage *reorderImageBlack = nil;

%hook UITableViewCellReorderControl

+ (id)grabberImage {
	if (reorderImageBlack == nil) {
		UIImage *rtn = %orig;
		
		reorderImageBlack = [rtn _flatImageWithWhite:0.0f alpha:kTintColorAlphaFactor];
		reorderImageWhite = [rtn _flatImageWithWhite:1.0f alpha:kTintColorAlphaFactor];
		[reorderImageBlack retain];
		[reorderImageWhite retain];
	}
	if (reorderImage == nil) {
		if (isWhiteness)
			reorderImage = reorderImageBlack;
		else
			reorderImage = reorderImageWhite;
	}
	
	return reorderImage;
}

%end


%hook UIGroupTableViewCellBackground

- (id)backgroundColor {
	return [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kJustClearAlphaFactor];
}
- (void)setBackgroundColor:(id)color {
	%orig([UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kJustClearAlphaFactor]);
}
- (UIColor *)selectionTintColor {
	return %orig;
}
- (void)setSelectionTintColor:(id)color {
	%orig;
}
- (void)setSelectionTintColor:(id)color layoutSubviews:(BOOL)arg2 {
	%orig;
}

%end



#pragma mark -
#pragma mark UITabBar


%hook UITabBarButton

- (void)_setUnselectedTintColor:(UIColor *)tintColor forceLabelToConform:(BOOL)labelConform {
	tintColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kTintColorAlphaFactor];
	labelConform = YES;
	
	%orig;
}

// >= 7.1
- (void)_setContentTintColor:(UIColor *)color forState:(UIControlState)state {
	if (state == UIControlStateNormal) {
		%orig([UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kTintColorAlphaFactor], state);
		return;
	}
	
	%orig;
}

%end



#pragma mark -
#pragma mark UIPickerView


%hook UIPickerView

- (void)layoutSubviews {
	%orig;
	
	self.backgroundColor = [UIColor clearColor];
}

%end



#pragma mark -
#pragma mark BackdropView Control


%hook UINavigationBar

- (void)layoutSubviews {
	%orig;
	
	//self.barTintColor = nil;
	//self.backgroundColor = [UIColor clearColor];
	
	if (self.superview) {
		UINavigationController *nvc = MSHookIvar<UINavigationController *>(self.superview, "_viewDelegate");
		if ([nvc isKindOfClass:[UINavigationController class]] && nvc._isTransitioning && nvc.interactiveTransition) return;
		
		if (self._backgroundView == nil) return;
		if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.MobileStore"] && self._backgroundView._is_needsLayout)
			return;
		_UIBackdropView *_adaptiveBackdrop = MSHookIvar<_UIBackdropView *>(self._backgroundView, "_adaptiveBackdrop");
		
		if (![_adaptiveBackdrop isKindOfClass:[_UIBackdropView class]]) return;
		
		if (_adaptiveBackdrop.style != kBackdropStyleForWhiteness && _adaptiveBackdrop.style != kBackdropStyleSystemDefaultDark)
			[_adaptiveBackdrop transitionToStyle:kBackdropStyleForWhiteness];
	}
}

- (id)_backgroundViewForPalette:(id)palette {
	return nil;
}

- (void)_setBackgroundImage:(id)image mini:(id)mini {
	%orig(nil, nil);
}

// Music app now playing flipside..
//- (void)_updateBackgroundImage {
//	
//}

- (UIBarStyle)barStyle {
	return kBarStyleForWhiteness;
}

- (void)setBarStyle:(UIBarStyle)style {
	%orig(kBarStyleForWhiteness);
}

- (UIColor *)barTintColor {
	return nil;
}

- (void)setBarTintColor:(UIColor *)color {
	%orig(nil);
}

- (UIColor *)backgroundColor {
	return [UIColor clearColor];
}

- (void)setBackgroundColor:(UIColor *)color {
	%orig([UIColor clearColor]);
}

- (BOOL)isTranslucent {
	return YES;
}

- (void)setTranslucent:(BOOL)translucent {
	%orig(YES);
}

%end


%hook UITabBar

- (void)layoutSubviews {
	%orig;
	
	//self.barTintColor = nil;
	//self.backgroundColor = [UIColor clearColor];
	
	_UIBackdropView *_adaptiveBackdrop = MSHookIvar<_UIBackdropView *>(self, "_adaptiveBackdrop");
	
	if (![_adaptiveBackdrop isKindOfClass:[_UIBackdropView class]]) return;
	
	if (_adaptiveBackdrop.style != kBackdropStyleForWhiteness)
		[_adaptiveBackdrop transitionToStyle:kBackdropStyleForWhiteness];
}

- (void)_setBackgroundImage:(id)image {
	%orig(nil);
}

- (UIBarStyle)barStyle {
	return kBarStyleForWhiteness;
}

- (void)setBarStyle:(UIBarStyle)style {
	%orig(kBarStyleForWhiteness);
}

- (UIColor *)barTintColor {
	return nil;
}

- (void)setBarTintColor:(UIColor *)color {
	%orig(nil);
}

- (UIColor *)backgroundColor {
	return [UIColor clearColor];
}

- (void)setBackgroundColor:(UIColor *)color {
	%orig([UIColor clearColor]);
}

- (BOOL)isTranslucent {
	return YES;
}

- (void)setTranslucent:(BOOL)translucent {
	%orig(YES);
}

%end


%hook UIToolbar

- (void)layoutSubviews {
	%orig;
	
	//self.barTintColor = nil;
	//self.backgroundColor = [UIColor clearColor];
	
	_UIBackdropView *_adaptiveBackdrop = MSHookIvar<_UIBackdropView *>(self, "_adaptiveBackdrop");
	
	if (![_adaptiveBackdrop isKindOfClass:[_UIBackdropView class]]) return;
	
	if (_adaptiveBackdrop.style != kBackdropStyleForWhiteness && _adaptiveBackdrop.style != kBackdropStyleSystemDefaultDark)
		[_adaptiveBackdrop transitionToStyle:kBackdropStyleForWhiteness];
}

- (void)_cleanupAdaptiveBackdrop {
	
}

- (UIBarStyle)barStyle {
	return kBarStyleForWhiteness;
}

- (void)setBarStyle:(UIBarStyle)style {
	%orig(kBarStyleForWhiteness);
}

- (UIColor *)barTintColor {
	return nil;
}

- (void)setBarTintColor:(UIColor *)color {
	%orig(nil);
}

- (UIColor *)backgroundColor {
	return [UIColor clearColor];
}

- (void)setBackgroundColor:(UIColor *)color {
	%orig([UIColor clearColor]);
}

- (BOOL)isTranslucent {
	return YES;
}

- (void)setTranslucent:(BOOL)translucent {
	%orig(YES);
}

%end


%hook UISearchBar

- (UIImage *)backgroundImage {
	return nil;
}

- (void)setBackgroundImage:(UIImage *)image {
	%orig(nil);
}

- (UIBarStyle)barStyle {
	return kBarStyleForWhiteness;
}

- (void)setBarStyle:(UIBarStyle)style {
	%orig(kBarStyleForWhiteness);
}

- (UIColor *)barTintColor {
	return nil;
}

- (void)setBarTintColor:(UIColor *)color {
	%orig(nil);
}

- (UIColor *)backgroundColor {
	return [UIColor clearColor];
}

- (void)setBackgroundColor:(UIColor *)color {
	%orig([UIColor clearColor]);
}

- (BOOL)isTranslucent {
	return YES;
}

- (void)setTranslucent:(BOOL)translucent {
	%orig(YES);
}

- (void)layoutSubviews {
	self.searchBarStyle = UISearchBarStyleMinimal;
	self.barStyle = kBarStyleForWhiteness;
	
	%orig;
	
	self.barTintColor = nil;
	self.backgroundColor = [UIColor clearColor];
	self.backgroundImage = nil;
}

- (void)_setStatusBarTintColor:(UIColor *)color {
	
}

- (void)_updateNeedForBackdrop {
	[self _setBackdropStyle:kBackdropStyleForWhiteness];
	
	%orig;
	
	_UIBackdropView *backdropView = MSHookIvar<_UIBackdropView *>(self, "_backdrop");
	
	if (backdropView != nil) {
		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleSystemDefaultSemiLight graphicsQuality:kBackdropGraphicQualitySystemDefault];
		settings.grayscaleTintLevel = (isWhiteness ? 1.0f : 0.0f);
		settings.grayscaleTintAlpha = (([self.controller respondsToSelector:@selector(isActive)] && self.controller.isActive) ? kTintColorAlphaFactor : 0.0f);
		if (isWhiteness)
			settings.grayscaleTintAlpha *= 1.5f;
		//settings.blurRadius = 30.0f;
		
		[backdropView transitionToSettings:settings];
	}
}

- (id)_glyphAndTextColor:(BOOL)unknown {
	// placeholder
	if (!unknown) {
		return [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kTintColorAlphaFactor];
	}
	
	return %orig;
}

%end


%hook UISearchDisplayController

- (void)showHideAnimationDidFinish {
	%orig;
	
	if (!self.isActive) {
		UINavigationBar *navBar = self.navigationItem.navigationBar;
		
		if (!navBar) {
			id _navigationControllerBookkeeper = MSHookIvar<id>(self, "_navigationControllerBookkeeper");
			
			if ([_navigationControllerBookkeeper isKindOfClass:[UINavigationController class]]) {
				UINavigationController *nc = (UINavigationController *)_navigationControllerBookkeeper;
				navBar = nc.navigationBar;
			}
		}
		
		[navBar setNeedsLayout];
	}
}

%end


%hook _UIContentUnavailableView

- (void)_updateViewHierarchy {
	%orig;
	
	self.backgroundColor = [UIColor clearColor];
	
	_UIBackdropView *_backdrop = MSHookIvar<_UIBackdropView *>(self, "_backdrop");
	
	if (_backdrop.style != kBackdropStyleSystemDefaultClear)
		[_backdrop transitionToStyle:kBackdropStyleSystemDefaultClear];
}

%end


%hook _UIModalItemAlertBackgroundView

- (void)layoutSubviews {
	%orig;
	
	_UIBackdropView *_effectView = MSHookIvar<_UIBackdropView *>(self, "_effectView");
	
	NSInteger style = (isWhiteness ? kBackdropStyleSystemDefaultUltraLight : kBackdropStyleSystemDefaultDark);
	if (_effectView.style != style)
		[_effectView transitionToStyle:style];
	
	UIImageView *_fillingView = MSHookIvar<UIImageView *>(self, "_fillingView");
	_fillingView.alpha = (isWhiteness ? 1.0f : 0.0f);
}

%end


%hook UIActivityGroupListViewController

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	
	if (self.backdropView.style != kBackdropStyleForWhiteness)
		[self.backdropView transitionToStyle:kBackdropStyleForWhiteness];
}

%end


%hook _UIPopoverStandardChromeView

- (void)layoutSubviews {
	%orig;
	
	_UIBackdropView *_blurView = MSHookIvar<_UIBackdropView *>(self, "_blurView");
	
	if (_blurView.style != kBackdropStyleForWhiteness)
		[_blurView transitionToStyle:kBackdropStyleForWhiteness];
}

%end

%hook _UIPopoverView

- (void)layoutSubviews {
	%orig;
	
	self.backgroundColor = [UIColor clearColor];
	self.standardChromeView.backgroundColor = [UIColor clearColor];
	self.backgroundView.backgroundColor = [UIColor clearColor];
	self.contentView.backgroundColor = [UIColor clearColor];
	self.toolbarShine.alpha = 0.0f;
}

%end



#pragma mark -
#pragma mark Additional BackdropView


@interface UIViewController (GlareApps)
- (BOOL)__glareapps_isNeedsToHasBackdrop;
@end

@implementation UIViewController (GlareApps)

- (BOOL)__glareapps_isNeedsToHasBackdrop {
	if ([self isKindOfClass:%c(_UIModalItemsPresentingViewController)]) return NO;
	if ([self isKindOfClass:[UIActivityViewController class]]) return NO;
	if ([self isKindOfClass:%c(SLComposeViewController)]) return NO;
	//MFMessageComposeViewController
	//MFMailComposeViewController
	
	return YES;
}

@end


%hook UIViewController

- (void)presentViewController:(UIViewController *)viewController withTransition:(UIViewAnimationTransition)transition completion:(id)fp_ {
	if ([viewController __glareapps_isNeedsToHasBackdrop]) {
		BOOL alreadyExists = NO;
		if (viewController.view.subviews.count > 0 && [viewController.view.subviews[0] isKindOfClass:[_UIBackdropView class]]) {
			_UIBackdropView *view = viewController.view.subviews[0];
			if (view.tag != 0xc001) {
				view.alpha = 0.0f;
				alreadyExists = YES;
			}
		}
		
		if ([viewController.view isKindOfClass:[_UIBackdropView class]]) {
			_UIBackdropView *backdropView = (_UIBackdropView *)viewController.view;
			
			_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleForWhiteness graphicsQuality:kBackdropGraphicQualitySystemDefault];
			
			[backdropView transitionToSettings:settings];
		}
		else {
			_UIBackdropView *backdropView = (_UIBackdropView *)[viewController.view viewWithTag:0xc001];
			[backdropView retain];
			
			if (backdropView == nil) {
				CGRect frame = viewController.view.frame;
				frame.origin.x = 0;
				
				_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleForWhiteness graphicsQuality:kBackdropGraphicQualitySystemDefault];
				if (!alreadyExists)
					settings.grayscaleTintAlpha = 0.3f;
				
				backdropView = [[_UIBackdropView alloc] initWithFrame:frame autosizesToFitSuperview:YES settings:settings];
				backdropView.tag = 0xc001;
				
				[viewController.view insertSubview:backdropView atIndex:0];
				
				backdropView.frame = frame;
			}
			
			[backdropView release];
		}
	}
	
	%orig;
}

%end


%hook UIPrintPanelViewController

- (void)_presentWindow {
	%orig;
	
	UIWindow *_window = MSHookIvar<UIWindow *>(self, "_window");
	
	_UIBackdropView *backdropView = (_UIBackdropView *)[_window viewWithTag:0xc001];
	[backdropView retain];
	
	if (backdropView == nil) {
		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleForWhiteness graphicsQuality:kBackdropGraphicQualitySystemDefault];
		settings.grayscaleTintAlpha = 0.3f;
		
		backdropView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
		backdropView.tag = 0xc001;
		
		[_window insertSubview:backdropView atIndex:0];
	}
	
	[backdropView release];
}

%end




#pragma mark -
#pragma mark AddressBook


%hook ABMemberCell

- (void)layoutSubviews {
	%orig;
	
	self.backgroundColor = [UIColor clearColor];
	self.contactNameView.backgroundColor = [UIColor clearColor];
	
	if (!isFirmware71) {
		self.contactNameView.meLabel.backgroundColor = [UIColor clearColor];
		self.contactNameView.meLabel.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kTintColorAlphaFactor];
		self.contactNameView.nameLabel.backgroundColor = [UIColor clearColor];
	}
}

%end


%hook ABMemberNameView

- (BOOL)isUserInteractionEnabled {
	return %orig;//YES;
}

- (void)drawRect:(CGRect)rect {
	self.backgroundColor = [UIColor clearColor];
	
	BOOL isHighlighted = self.highlighted;
	self.highlighted = YES;
	
	%orig;
	
	self.highlighted = isHighlighted;
}

%end


%hook ABMembersController

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	
	self.currentTableView.backgroundColor = [UIColor clearColor];
	self.currentTableView.sectionIndexBackgroundColor = [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kJustClearAlphaFactor];
}

%end



%hook ABStyleProvider

- (UIColor *)groupCellTextColor {
	return [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:0.9f];
}

- (BOOL)groupsTableShouldRemoveBackgroundView {
	return YES;
}

- (BOOL)peoplePickerBarStyleIsTranslucent {
	return YES;
}

- (UIBarStyle)peoplePickerBarStyle {
	return kBarStyleForWhiteness;
}

- (BOOL)shouldUsePeoplePickerBarStyle {
	return YES;
}

- (id)cardCellDividerColorVertical:(BOOL)vertical {
	return [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:1.0f];
}

- (UIColor *)memberNameTextColor {
	return [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:1.0];
}

- (UIColor *)cardValueTextColor {
	return [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:1.0];
}

%end


%hook ABMembersDataSource

- (void)tableView:(UIView *)tableView willDisplayHeaderView:(UITableViewHeaderFooterView *)view forSection:(NSInteger)section {
	%orig;
	
	if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
		if (![view.backgroundView isKindOfClass:%c(_UIBackdropView)]) {
			view.contentView.backgroundColor = [UIColor clearColor];
			view.tintColor = nil;
			if ([view respondsToSelector:@selector(setBackgroundImage:)])
				view.backgroundImage = nil;
			
			_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleSystemDefaultSemiLight graphicsQuality:kBackdropGraphicQualitySystemDefault];
			settings.grayscaleTintLevel = (isWhiteness ? 1.0f : 0.0f);
			
			_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
			view.backgroundView = backdropView;
			[backdropView release];
		}
	}
}

%end


%hook ABMembersController

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
	%orig;
	
	tableView.backgroundColor = [UIColor clearColor];
	
	UIView *superview = controller._containerView.behindView;
	
	_UIBackdropView *backdropView = (_UIBackdropView *)[superview viewWithTag:0xc001];
	[backdropView retain];
	
	if (backdropView == nil) {
		CGRect frame = tableView.frame;
		frame.origin.x = 0;
		
		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleForWhiteness graphicsQuality:kBackdropGraphicQualitySystemDefault];
		settings.grayscaleTintAlpha = 0.3f;
		
		backdropView = [[_UIBackdropView alloc] initWithFrame:frame autosizesToFitSuperview:YES settings:settings];
		backdropView.tag = 0xc001;
		
		[superview insertSubview:backdropView atIndex:0];
	}
	
	[backdropView release];
}

%new
- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
	UIView *superview = controller._containerView.behindView;
	
	_UIBackdropView *backdropView = (_UIBackdropView *)[superview viewWithTag:0xc001];
	
	[backdropView removeFromSuperview];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
	%orig;
	
	UIView *superview = controller._containerView.behindView;
	
	_UIBackdropView *backdropView = (_UIBackdropView *)[superview viewWithTag:0xc001];
	
	[backdropView removeFromSuperview];
}

%end


%hook ABPropertyCell

- (void)layoutSubviews {
	%orig;
	
	self.valueLabel.backgroundColor = [UIColor clearColor];
	self.labelLabel.backgroundColor = [UIColor clearColor];
}

%end


%hook ABPropertyNameCell

- (void)setBackgroundColor:(UIColor *)color {
	//%orig([UIColor clearColor]);
	
	objc_super $super = {self, [UITableViewCell class]};
	objc_msgSendSuper(&$super, @selector(setBackgroundColor:), color);
}

%end


@interface UILabel (TextAttributes)
- (id)textAttributes;
- (void)setTextAttributes:(id)arg1;
@end

%hook ABPropertyNoteCell

- (void)setBackgroundColor:(UIColor *)color {
	//%orig([UIColor clearColor]);
	
	objc_super $super = {self, [UITableViewCell class]};
	objc_msgSendSuper(&$super, @selector(setBackgroundColor:), color);
}

- (void)setLabelTextAttributes:(NSDictionary *)attributes {
	%orig;
	
	NSDictionary *&labelTextAttributes = MSHookIvar<NSDictionary *>(self, "_labelTextAttributes");
	NSDictionary *privDict = self.labelTextAttributes;
	[privDict retain];
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:privDict];
	
	dict[@"NSColor"] = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kTintColorAlphaFactor];
	
	[self.labelLabel setTextAttributes:dict];
	
	labelTextAttributes = [dict copy];
	
	[privDict release];
}

%end


%hook ABContactCell

- (void)setSeparatorColor:(UIColor *)color {
	%orig([UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kClearAlphaFactor]);
}

- (void)setContactSeparatorColor:(UIColor *)color {
	%orig([UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kClearAlphaFactor]);
}

%end


%hook ABContactHeaderView

- (void)layoutSubviews {
	%orig;
	
	UILabel *_nameLabel = MSHookIvar<UILabel *>(self, "_nameLabel");
	UILabel *_taglineLabel = MSHookIvar<UILabel *>(self, "_taglineLabel");
	
	_nameLabel.backgroundColor = [UIColor clearColor];
	_taglineLabel.backgroundColor = [UIColor clearColor];
}

%end


%hook ABGroupHeaderFooterView

- (void)updateConstraints {
	%orig;
	
	self.backgroundColor = nil;
	self.contentView.backgroundColor = [UIColor clearColor];
	self.tintColor = nil;
	if ([self respondsToSelector:@selector(setBackgroundImage:)])
		self.backgroundImage = nil;
	
	self.backgroundView.alpha = 0.0f;
}

%end


%hook ABBannerView

- (void)_updateLabel {
	%orig;
	
	self.textLabel.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:1.0f];
}

%end


%hook UIColor

+ (id)cardCellSeparatorColor {
	return [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kClearAlphaFactor];
}
+ (id)cardCellReadonlyBackgroundColor {
	return %orig;
}
+ (id)cardBackgroundInPopoverColor {
	return [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kTransparentAlphaFactor];
}
+ (id)cardCellBackgroundColor {
	return [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kJustClearAlphaFactor];
}
+ (id)cardValueReadonlyTextColor {
	return %orig;
}
+ (id)cardValueTextColor {
	return [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:1.0f];
}
+ (id)cardLabelReadonlyTextColor {
	return %orig;
}

%end



#pragma mark -
#pragma mark MessageUI


%hook MFComposeRecipientView

- (void)layoutSubviews {
	%orig;
	
	self.textField.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:1.0f];
	self.textField.backgroundColor = [UIColor clearColor];
	self.backgroundColor = [UIColor clearColor];
}

%end


%hook MFRecipientTableViewCellDetailView

- (void)layoutSubviews {
	%orig;
	
	if ([[self.tintColor description] hasPrefix:@"UIDeviceWhiteColorSpace"]) {
		self.detailLabel.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kTintColorAlphaFactor];
		self.labelLabel.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kTintColorAlphaFactor];
	}
	
	self.detailLabel.backgroundColor = [UIColor clearColor];
	self.labelLabel.backgroundColor = [UIColor clearColor];
	self.backgroundColor = [UIColor clearColor];
}

%end


%hook MFRecipientTableViewCellTitleView

- (void)layoutSubviews {
	%orig;
	
	if ([[self.tintColor description] hasPrefix:@"UIDeviceWhiteColorSpace"])
		self.titleLabel.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:1.0f];
	
	self.titleLabel.backgroundColor = [UIColor clearColor];
	self.backgroundColor = [UIColor clearColor];
}

%end


%hook MFRecipientTableViewCell

- (void)layoutSubviews {
	%orig;
	
	MFRecipientTableViewCellDetailView *_detailView = MSHookIvar<MFRecipientTableViewCellDetailView *>(self, "_detailView");
	MFRecipientTableViewCellTitleView *_titleView = MSHookIvar<MFRecipientTableViewCellTitleView *>(self, "_titleView");
	_detailView.backgroundColor = [UIColor clearColor];
	_titleView.backgroundColor = [UIColor clearColor];
}

%end




#pragma mark -
#pragma mark Constructure


%ctor
{
	isFirmware70 = (kCFCoreFoundationVersionNumber < 874.24);
	isFirmware71 = (kCFCoreFoundationVersionNumber >= 847.24);
	
	//CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &reloadPrefsNotification, CFSTR("kr.slak.glareapps.prefnoti"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	LoadSettings();
	
	if (!isThisAppEnabled()) return;
	
	kbRenderConfig = [[%c(UIKBRenderConfig) alloc] init];
	kbRenderConfig.blurRadius = 20.0f;
	kbRenderConfig.lightKeyboard = (isWhiteness ? YES : NO);
	kbRenderConfig.blurSaturation = isFirmware71 ? 0.5f : 0.9f;
	kbRenderConfig.keycapOpacity = isFirmware71 ? 1.0f : 0.82f;
	if (isFirmware71)
		kbRenderConfig.lightLatinKeycapOpacity = 1.0f;
	else
		kbRenderConfig.keyborderOpacity = 1.0f;
	
	%init;
}


