
#import "headers.h"




#pragma mark -
#pragma mark Settings


static BOOL GlareAppsEnable = YES;
static NSArray *GlareAppsWhiteList = nil;


static void LoadSettings() {
	@synchronized (GlareAppsWhiteList) {
		NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/kr.slak.GlareApps.plist"];
		
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
}

void reloadPrefsNotification(CFNotificationCenterRef center,
							void *observer,
							CFStringRef name,
							const void *object,
							CFDictionaryRef userInfo) {
	LoadSettings();
}

BOOL isThisAppUIServiceProcess() {
	NSString *executablePath = [[NSBundle mainBundle] executablePath];
	
	if ([executablePath hasSuffix:@"/MessagesViewService"]
			|| [executablePath hasSuffix:@"/MailCompositionService"]
			|| [executablePath hasSuffix:@"/SocialUIService"]
			|| [executablePath hasSuffix:@"/CompassCalibrationViewService"]
			|| [executablePath hasSuffix:@"/GameCenterUIService"]
			|| [executablePath hasSuffix:@"/MusicUIService"]
			|| [executablePath hasSuffix:@"/PassbookUIService"]
			|| [executablePath hasSuffix:@"/StoreKitUIService"]
			|| [executablePath hasSuffix:@"/WebViewService"])
		return YES;
	
	return NO;
}

BOOL isTheAppUIServiceProcess(NSString *bundleIdentifier) {
	if ([bundleIdentifier isEqualToString:@"com.apple.mobilesms.compose"]
			|| [bundleIdentifier isEqualToString:@"com.apple.MailCompositionService"]
			|| [bundleIdentifier isEqualToString:@"com.apple.social.remoteui.SocialUIService"]
			|| [bundleIdentifier isEqualToString:@"com.apple.CompassCalibrationViewService"]
			|| [bundleIdentifier isEqualToString:@"com.apple.gamecenter.GameCenterUIService"]
			|| [bundleIdentifier isEqualToString:@"com.apple.MusicUIService"]
			|| [bundleIdentifier isEqualToString:@"com.apple.PassbookUIService"]
			|| [bundleIdentifier isEqualToString:@"com.apple.ios.StoreKitUIService"]
			|| [bundleIdentifier isEqualToString:@"com.apple.WebViewService"])
		return YES;
	
	return NO;
}

BOOL isThisAppEnabled() {
	if (GlareAppsWhiteList == nil)
		LoadSettings();
	
	if (!GlareAppsEnable) return NO;
	
	if (isThisAppUIServiceProcess()) return YES;
	
	@synchronized (GlareAppsWhiteList) {
		if (GlareAppsWhiteList) {
			if (![GlareAppsWhiteList containsObject:[[NSBundle mainBundle] bundleIdentifier]])
				return NO;
		} else return NO;
	}
	
	return YES;
}

BOOL isTheAppEnabled(NSString *bundleIdentifier) {
	if (GlareAppsWhiteList == nil)
		LoadSettings();
	
	if (!GlareAppsEnable) return NO;
	
	if (isTheAppUIServiceProcess(bundleIdentifier)) return YES;
	
	@synchronized (GlareAppsWhiteList) {
		if (GlareAppsWhiteList) {
			if (![GlareAppsWhiteList containsObject:bundleIdentifier])
				return NO;
		} else return NO;
	}
	
	return YES;
}

void setLabelTextColorIfHasBlackColor(UILabel *label) {
	if (label.attributedText) return;
	
	if ([label.textColor isEqual:[colorHelper blackColor]] 
			|| [label.textColor isEqual:colorHelper.color_0_0__1_0] 
			|| [label.textColor isEqual:colorHelper.rgbBlackColor]) {
		label.textColor = [colorHelper commonTextColor];
		return;
	}
	
	if ([[label.textColor description] hasPrefix:@"UIDeviceWhiteColorSpace"]) {
		CGFloat white = 0.0f, alpha = 0.0f;
		[label.textColor getWhite:&white alpha:&alpha];
		
		if (white != kLightColorWithWhiteForWhiteness && white < 0.4f) {
			label.textColor = [colorHelper commonTextColorWithAlpha:fabs(1.0f-white)*alpha];
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
			mutableAttributes[@"NSColor"] = [colorHelper commonTextColorWithAlpha:alpha];
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

GlareAppsColorHelper *colorHelper			= nil;




@implementation UIApplication (GlareApps)

- (void)__glareapps_applicationDidFinishLaunching {
	[[UIApplication sharedApplication] _setApplicationBackdropStyle:kBackdropStyleForWhiteness];
	[[UIApplication sharedApplication] setStatusBarStyle:kBarStyleForWhiteness];
	[[UIApplication sharedApplication] keyWindow].backgroundColor = [colorHelper clearColor];
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
	
	[[UIApplication sharedApplication] keyWindow].backgroundColor = [colorHelper keyWindowBackgroundColor];
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
	[[UIApplication sharedApplication] keyWindow].backgroundColor = [colorHelper keyWindowBackgroundColor];
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
	//[[UIApplication sharedApplication] keyWindow].backgroundColor = [colorHelper clearColor];
	
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
	bar.backgroundColor = [colorHelper clearColor];
	bar.translucent = YES;
	
	[bar setNeedsLayout];
}

%hook UIViewController

- (void)viewWillAppear:(BOOL)animated {
	//clearBar(self.navigationController.navigationBar);
	//clearBar(self.navigationController.toolbar);
	//clearBar(self.tabBarController.tabBar);
	
	%orig;
	
	[[UIApplication sharedApplication] setStatusBarStyle:kBarStyleForWhiteness];
	self.view.backgroundColor = [colorHelper themedFakeClearColor];
	self.dropShadowView.backgroundColor = nil;
}

- (void)viewDidAppear:(BOOL)animated {
	%orig;
	
	[[UIApplication sharedApplication] setStatusBarStyle:kBarStyleForWhiteness];
}

%end


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
	if ([superviewclass isEqualToString:@"UIPageControl"]) {
		return;
	}
	if (self.window != nil && self.window != [UIApplication sharedApplication].keyWindow) {
		return;
	}
	
	if ([color isEqual:[colorHelper clearColor]]) {
		return;
	}
	if ([color isEqual:[colorHelper blackColor]] || [color isEqual:[colorHelper whiteColor]]) {
		self.backgroundColor = [colorHelper clearColor];
		return;
	}
	if (color != nil && ![color isEqual:[colorHelper clearColor]]
			&& [[color description] hasPrefix:@"UIDeviceWhiteColorSpace"]
			&& ![color isEqual:[colorHelper keyWindowBackgroundColor]]
			&& ![color isEqual:[colorHelper preferencesUITableViewBackgroundColor]]
			&& ![color isEqual:[colorHelper themedFakeClearColor]]
			&& ![color isEqual:[colorHelper defaultTableViewCellBackgroundColor]]) {
		//self.backgroundColor = [colorHelper clearColor];
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
	if ([superviewclass isEqualToString:@"UIPageControl"]) {
		%orig;
		return;
	}
	if (self.window != nil && self.window != [UIApplication sharedApplication].keyWindow) {
		%orig;
		return;
	}
	
	if ([color isEqual:[colorHelper clearColor]]) {
		%orig;
		return;
	}
	if ([color isEqual:[colorHelper whiteColor]]) {
		%orig([colorHelper clearColor]);
		return;
	}
	if (color != nil && ![color isEqual:[colorHelper clearColor]]
			&& [[color description] hasPrefix:@"UIDeviceWhiteColorSpace"]
			&& ![color isEqual:[colorHelper keyWindowBackgroundColor]]
			&& ![color isEqual:[colorHelper preferencesUITableViewBackgroundColor]]
			&& ![color isEqual:[colorHelper themedFakeClearColor]]
			&& ![color isEqual:[colorHelper defaultTableViewCellBackgroundColor]]) {
		//%orig([colorHelper clearColor]);
		//return;
	}
	
	%orig;
}

%end


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
	
	return isActionSheetOrActivityGroup;
}

@end


%hook UILabel

- (void)setTextColor:(UIColor *)textColor {
	CGFloat white = 0.0f, alpha = 0.0f;
	
	if (![self.superview isKindOfClass:%c(UITableViewCellContentView)] 
			&& [[textColor description] hasPrefix:@"UIDeviceWhiteColorSpace"] && [textColor getWhite:&white alpha:&alpha]) {
		if (white == 0.5f && alpha == 1.0f)
			textColor = [colorHelper systemGrayColor];
	}
	
	NSString *selfText = nil;
	if ([self isKindOfClass:%c(UIDateLabel)])
		selfText = ((UIDateLabel *)self)._dateString;
	else
		selfText = self.text;
	
	if (!isWhiteness && selfText && ![self __glareapps_isActionSheetOrActivityGroup]
			&& [[textColor description] hasPrefix:@"UIDeviceWhiteColorSpace"] && [textColor getWhite:&white alpha:&alpha]) {
		if (white != kLightColorWithWhiteForWhiteness)
			textColor = [colorHelper colorWithWhite:fabs(kLightColorWithWhiteForWhiteness - white) alpha:alpha];
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
		if (white == 0.5f && alpha == 1.0f)
			textColor = [colorHelper systemGrayColor];
		else if ((!isWhiteness && white < 0.5f) || (isWhiteness && white > 0.5f))
			textColor = [colorHelper colorWithWhite:fabs(1.0f-white) alpha:alpha];
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
	
	if (!isWhiteness && [self.textColor isEqual:[colorHelper blackColor]])
		self.textColor = [colorHelper commonTextColor];
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
	
	if (!isWhiteness && [self.textColor isEqual:[colorHelper blackColor]] && ![superviewName hasPrefix:@"_UIModalItem"])
		self.textColor = [colorHelper commonTextColor];
	if ([self respondsToSelector:@selector(setKeyboardAppearance:)])
		self.keyboardAppearance = (isWhiteness ? UIKeyboardAppearanceLight : UIKeyboardAppearanceDark);
}

- (id)_placeholderColor {
	return [colorHelper systemGrayColor];
}

- (void)setTextColor:(UIColor *)textColor {
	CGFloat white = 0.0f, alpha = 0.0f;
	
	if ([[textColor description] hasPrefix:@"UIDeviceWhiteColorSpace"] && [textColor getWhite:&white alpha:&alpha]) {
		if ((!isWhiteness && white < 0.5f) || (isWhiteness && white > 0.5f))
			textColor = [colorHelper colorWithWhite:fabs(1.0f-white) alpha:alpha];
	}
	
	%orig;
}

%end


%hook UITextContentView

- (UIColor *)textColor {
	return [colorHelper commonTextColor];
}

- (void)setTextColor:(UIColor *)color {
	%orig([colorHelper commonTextColor]);
}

- (void)setText:(NSString *)text {
	%orig;
	
	[self setTextColor:[colorHelper commonTextColor]];
}
- (void)setContentToAttributedString:(id)attributedString {
	%orig;
	
	[self setTextColor:[colorHelper commonTextColor]];
}
- (void)setContentToHTMLString:(id)htmlString {
	%orig;
	
	[self setTextColor:[colorHelper commonTextColor]];
}

- (id)initWithCoder:(id)code {
	self = %orig;
	
	if (self) {
		[self setTextColor:[colorHelper commonTextColor]];
	}
	
	return self;
}
- (id)initWithFrame:(CGRect)frame webView:(id)webView {
	self = %orig;
	
	if (self) {
		[self setTextColor:[colorHelper commonTextColor]];
	}
	
	return self;
}
- (id)initWithFrame:(CGRect)frame {
	self = %orig;
	
	if (self) {
		[self setTextColor:[colorHelper commonTextColor]];
	}
	
	return self;
}

%end


%hook UIColor

+ (id)darkTextColor {
	UIColor *color = %orig;
	return [colorHelper commonTextColorWithAlpha:color.alphaComponent];
}
+ (id)lightTextColor {
	UIColor *color = %orig;
	return [colorHelper lightTextColorWithAlpha:color.alphaComponent];
}
+ (id)systemGrayColor {
	return [colorHelper systemGrayColor];
}
+ (UIColor *)darkGrayColor {
	return [colorHelper systemDarkGrayColor];
}
+ (UIColor *)lightGrayColor {
	return [colorHelper systemLightGrayColor];
}
+ (id)tableCellDefaultSelectionTintColor {
	return [colorHelper systemLightGrayColor];
}
+ (id)tableSelectionGradientEndColor {
	return [colorHelper systemLightGrayColor];
}
+ (id)tableSelectionGradientStartColor {
	return [colorHelper systemDarkGrayColor];
}
+ (id)tableSelectionColor {
	return [colorHelper systemLightGrayColor];
}
+ (id)tablePlainHeaderFooterFloatingBackgroundColor {
	return [colorHelper clearColor];
}
+ (id)tablePlainHeaderFooterBackgroundColor {
	return [colorHelper clearColor];
}
+ (id)tableCellbackgroundColorPigglyWiggly {
	return [colorHelper defaultTableViewCellBackgroundColor];
}
+ (id)tableCellBackgroundColor {
	return [colorHelper defaultTableViewCellBackgroundColor];
}
+ (id)tableCellGroupedBackgroundColorLegacyWhite {
	return [colorHelper defaultTableViewCellBackgroundColor];
}
+ (id)tableCellPlainBackgroundColor {
	return [colorHelper defaultTableViewCellBackgroundColor];
}
+ (id)tableBackgroundColor {
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.Preferences"])
		return [colorHelper preferencesUITableViewBackgroundColor];
	
	return [colorHelper clearColor];
}
+ (id)sectionHeaderOpaqueBackgroundColor {
	return [colorHelper clearColor];
}
+ (id)sectionHeaderBackgroundColor {
	return [colorHelper clearColor];
}
+ (id)tableCellGrayTextColor {
	return [colorHelper systemGrayColor];
}
+ (id)noContentDarkGradientBackgroundColor {
	return [colorHelper clearColor];
}
+ (id)noContentLightGradientBackgroundColor {
	return [colorHelper clearColor];
}
+ (id)tableGroupedSeparatorLightColor {
	return [colorHelper defaultTableViewSeparatorColor];
}
+ (id)tableSeparatorLightColor {
	return [colorHelper defaultTableViewSeparatorColor];
}
+ (id)tableSeparatorDarkColor {
	return [colorHelper defaultTableViewSeparatorColor];
}
+ (id)tableCellGroupedBackgroundColor {
	return [colorHelper defaultTableViewCellBackgroundColor];
}
+ (id)groupTableViewBackgroundColor {
	return [colorHelper clearColor];
}

%end


%hook _UIContentUnavailableView

- (void)_updateViewHierarchy {
	%orig;
	
	self.backgroundColor = [colorHelper clearColor];
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


%hook _UIPopoverView

- (void)layoutSubviews {
	%orig;
	
	self.backgroundColor = [colorHelper clearColor];
	self.standardChromeView.backgroundColor = [colorHelper clearColor];
	self.backgroundView.backgroundColor = [colorHelper clearColor];
	self.contentView.backgroundColor = [colorHelper clearColor];
	self.toolbarShine.alpha = 0.0f;
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
	
	self.backgroundColor = [colorHelper clearColor];
	self.backgroundView.alpha = 0.0f;
	self.contentView.backgroundColor = [colorHelper clearColor];
}

- (void)_updateBackgroundView {
	%orig;
	
	self.backgroundView = nil;
	self.backgroundColor = [colorHelper clearColor];
}

%end



#pragma mark -
#pragma mark UITableView


%hook UITableView

- (void)layoutSubviews {
	%orig;

	if (self.superview) {
		self.sectionIndexBackgroundColor = [colorHelper defaultTableViewCellBackgroundColor];
	}
}

- (UIColor *)backgroundColor {
	return [colorHelper clearColor];
}

- (void)setBackgroundColor:(id)color {
	%orig([colorHelper clearColor]);
}

- (void)_setBackgroundColor:(id)color animated:(BOOL)animated {
	%orig([colorHelper clearColor], animated);
}

- (UIColor *)sectionIndexBackgroundColor {
	return [colorHelper defaultTableViewCellBackgroundColor];
}

- (void)setSectionIndexBackgroundColor:(UIColor *)color {
	%orig([colorHelper defaultTableViewCellBackgroundColor]);
}

- (id)_defaultSeparatorColor {
	return [colorHelper defaultTableViewSeparatorColor];
}

- (UIColor *)separatorColor {
	return [colorHelper defaultTableViewSeparatorColor];
}

- (void)setSeparatorColor:(UIColor *)color {
	%orig([colorHelper defaultTableViewSeparatorColor]);
}

- (id)tableHeaderBackgroundColor {
	return [colorHelper clearColor];
}

- (void)setTableHeaderBackgroundColor:(id)color {
	%orig([colorHelper clearColor]);
}

//- (void)setSeparatorStyle:(UITableViewCellSeparatorStyle)style {
//	%orig(UITableViewCellSeparatorStyleSingleLine);
//}

%end


@implementation UITableViewHeaderFooterView (GlareApps)

- (void)__glareapps_setBackground {
	if ([self isKindOfClass:%c(ABGroupHeaderFooterView)]) return;
	
	if (self.tableView && ![self.backgroundView isKindOfClass:%c(_UIBackdropView)]) {
		if (![self.backgroundView isKindOfClass:[_UIBackdropView class]]) {
			self.backgroundColor = nil;
			self.contentView.backgroundColor = [colorHelper clearColor];
			self.tintColor = nil;
			if ([self respondsToSelector:@selector(setBackgroundImage:)])
				self.backgroundImage = nil;
			
			_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForPrivateStyle:kBackdropStyleSystemDefaultSemiLight graphicsQuality:kBackdropGraphicQualitySystemDefault];
			settings.grayscaleTintLevel = (isWhiteness ? 1.0f : 0.0f);
			
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
	
	self.textLabel.textColor = [colorHelper systemGrayColor];
	
	if (self.tableView != nil && self.tableView.style == UITableViewStyleGrouped) return;
	if ([self.class requiresConstraintBasedLayout]) return;
	
	[self __glareapps_setBackground];
}

- (void)updateConstraints {
	%orig;
	
	self.textLabel.textColor = [colorHelper systemGrayColor];
	
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
		disclosureImageBlack = [iv.image _flatImageWithColor:colorHelper.color_0_0__0_4];
		disclosureImageWhite = [iv.image _flatImageWithColor:colorHelper.color_1_0__0_4];
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

@implementation UITableViewCell (GlareApps)

- (BOOL)__glareapps_isNeedsToSetJustClearBackground {
	return NO;
}

@end

%hook UITableViewCell

- (void)layoutSubviews {
	%orig;
	
	if ([self __glareapps_isNeedsToSetJustClearBackground])
		self.backgroundColor = [colorHelper defaultTableViewCellBackgroundColor];
	
	self.textLabel.backgroundColor = [colorHelper clearColor];
	self.detailTextLabel.backgroundColor = [colorHelper clearColor];
	self.detailTextLabel.textColor = [colorHelper systemGrayColor];
	
	setLabelTextColorIfHasBlackColor(self.textLabel);
	
	for (UILabel *label in self.contentView.subviews) {
		if ([label isKindOfClass:[UILabel class]]) {
			label.backgroundColor = [colorHelper clearColor];
			
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
		
		reorderImageBlack = [rtn _flatImageWithColor:colorHelper.color_0_0__0_4];
		reorderImageWhite = [rtn _flatImageWithColor:colorHelper.color_1_0__0_4];
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
	return [colorHelper defaultTableViewCellBackgroundColor];
}
- (void)setBackgroundColor:(id)color {
	%orig([colorHelper defaultTableViewCellBackgroundColor]);
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
	tintColor = [colorHelper systemGrayColor];
	labelConform = YES;
	
	%orig;
}

// >= 7.1
- (void)_setContentTintColor:(UIColor *)color forState:(UIControlState)state {
	if (state == UIControlStateNormal) {
		%orig([colorHelper systemGrayColor], state);
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
	
	self.backgroundColor = [colorHelper clearColor];
}

%end



#pragma mark -
#pragma mark UIAlert


%hook _UIModalItemAlertBackgroundView

- (void)layoutSubviews {
	%orig;
	
	UIImageView *_fillingView = MSHookIvar<UIImageView *>(self, "_fillingView");
	_fillingView.alpha = (isWhiteness ? 1.0f : 0.0f);
}

%end


%hook UIActionSheet

- (void)layout {
	%orig;
	
	_UIBackdropView *_backdropView = nil;
	if (isFirmware71) {
		_backdropView = MSHookIvar<_UIBackdropView *>(self, "_backgroundView");
	}
	else {
		_backdropView = MSHookIvar<_UIBackdropView *>(self, "_backdropView");
	}
	
	if (![_backdropView isKindOfClass:[_UIBackdropView class]]) return;
	
	UIImage *grayscaleTintMaskImage = [_backdropView.inputSettings.grayscaleTintMaskImage retain];
	UIImage *colorTintMaskImage = [_backdropView.inputSettings.colorTintMaskImage retain];
	UIImage *filterMaskImage = [_backdropView.inputSettings.filterMaskImage retain];
	
	NSInteger style = (isWhiteness ? kBackdropStyleSystemDefaultUltraLight : kBackdropStyleSystemDefaultUltraDark);
	if (_backdropView.style != style) {
		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:style];
		settings.blurRadius = 7.0f;
		settings.grayscaleTintMaskImage = grayscaleTintMaskImage;
		settings.colorTintMaskImage = colorTintMaskImage;
		settings.filterMaskImage = filterMaskImage;
		
		[_backdropView transitionToSettings:settings];
	}
	
	[grayscaleTintMaskImage release];
	[colorTintMaskImage release];
	[filterMaskImage release];
}

%end

%hook _UIActionSheetBlendingHighlightView

- (id)initWithFrame:(CGRect)frame colorBurnColor:(id)burnColor plusDColor:(id)plusDColor {
	if (isWhiteness) return %orig;
	
	burnColor = colorHelper.color_0_9__0_2;
	
	return %orig;
}

%end

%hook _UIActionSheetBlendingSeparatorView

- (id)initWithFrame:(CGRect)frame {
	_UIActionSheetBlendingSeparatorView *rtn = %orig;
	
	if (rtn && !isWhiteness) {
		UIView *_colorBurnView = MSHookIvar<UIView *>(rtn, "_colorBurnView");
		
		[_colorBurnView.layer setCompositingFilter:nil];
	}
	
	return rtn;
}

%end

%hook UIAlertButton

- (void)setHighlightImage:(UIImage *)image {
	if (!isWhiteness)
		image = [image _flatImageWithColor:[colorHelper commonTextColor]];
	
	%orig;
}

%end


%hook _UIModalItemContentView

- (void)layout {
	%orig;
	
	self.backgroundColor = nil;
	self.buttonTable.backgroundColor = nil;
	self.titleLabel.textColor = [colorHelper commonTextColor];
	self.subtitleLabel.textColor = [colorHelper commonTextColor];
	self.messageLabel.textColor = [colorHelper commonTextColor];
}

%end

%hook _UIModalItemAlertContentView

- (void)layout {
	%orig;
	
	self.backgroundColor = nil;
	self.buttonTable.backgroundColor = nil;
	self.titleLabel.textColor = [colorHelper commonTextColor];
	self.subtitleLabel.textColor = [colorHelper commonTextColor];
	self.messageLabel.textColor = [colorHelper commonTextColor];
}

%end

%hook _UIModalItemRepresentationView

- (void)setUseFakeEffectSource:(BOOL)useFakeEffectSource animated:(BOOL)animated {
	%orig;//(NO, animated);
	
	UIView *_fakeEffectSourceView = MSHookIvar<UIView *>(self, "_fakeEffectSourceView");
	_fakeEffectSourceView.backgroundColor = [colorHelper defaultAlertViewRepresentationViewBackgroundColor];
}

%end



#pragma mark -
#pragma mark UISearch


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
	return [colorHelper clearColor];
}

- (void)setBackgroundColor:(UIColor *)color {
	%orig([colorHelper clearColor]);
}

- (BOOL)isTranslucent {
	return YES;
}

- (void)setTranslucent:(BOOL)translucent {
	%orig(YES);
}

- (void)layoutSubviews {
	self.searchBarStyle = UISearchBarStyleMinimal;
	
	%orig;
	
	self.barTintColor = nil;
	self.backgroundColor = [colorHelper clearColor];
	self.backgroundImage = nil;
	
	_UIBackdropView *backdropView = MSHookIvar<_UIBackdropView *>(self, "_backdrop");
	backdropView.alpha = 1.0f;
	backdropView.hidden = NO;
}

- (void)_setStatusBarTintColor:(UIColor *)color {
	
}

- (id)initWithCoder:(id)coder {
	self = %orig;
	
	if (self) {
		self.searchBarStyle = UISearchBarStyleMinimal;
		self.barStyle = kBarStyleForWhiteness;
		[self _setBackdropStyle:kBackdropStyleForWhiteness];
		
		self.barTintColor = nil;
		self.backgroundColor = [colorHelper clearColor];
		self.backgroundImage = nil;
		self.translucent = YES;
	}
	
	return self;
}
- (id)initWithFrame:(CGRect)frame {
	self = %orig;
	
	if (self) {
		self.searchBarStyle = UISearchBarStyleMinimal;
		self.barStyle = kBarStyleForWhiteness;
		[self _setBackdropStyle:kBackdropStyleForWhiteness];
		
		self.barTintColor = nil;
		self.backgroundColor = [colorHelper clearColor];
		self.backgroundImage = nil;
		self.translucent = YES;
	}
	
	return self;
}

- (void)_updateNeedForBackdrop {
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
		return [colorHelper systemGrayColor];
	}
	
	return %orig;
}

%end


%hook UISearchDisplayController

- (void)_setTableViewVisible:(BOOL)visible inView:(UIView *)view {
	%orig;
	
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.Music"]) return;
	
	_UIBackdropView *backdropView = (_UIBackdropView *)[self._containerView viewWithTag:0xc001];
	[backdropView retain];
	
	if (backdropView == nil) {
		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleForWhiteness];
		backdropView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
		backdropView.tag = 0xc001;
		[self._containerView insertSubview:backdropView atIndex:0];
	}
	
	backdropView.alpha = visible ? 1.0f : 0.0f;
	
	[backdropView release];
}

- (void)searchBar:(id)searchBar textDidChange:(NSString *)text {
	%orig;
	
	if (text.length == 0) {
		_UIBackdropView *backdropView = (_UIBackdropView *)[self._containerView viewWithTag:0xc001];
		backdropView.alpha = 0.0f;
	}
}

%end



#pragma mark -
#pragma mark BackdropView Control


%hook _UIBackdropView

- (void)transitionToSettings:(_UIBackdropViewSettings *)newSettings {
	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForPrivateStyle:newSettings.style];
	if (settings.blurRadius == newSettings.blurRadius 
			&& settings.grayscaleTintAlpha == newSettings.grayscaleTintAlpha
			&& settings.grayscaleTintLevel == newSettings.grayscaleTintLevel) {
		if (isWhiteness && newSettings.style == kBackdropStyleSystemDefaultSemiLight) {
			%orig;
			return;
		}
		if (self.inputSettings.style != kBackdropStyleForWhiteness && self.inputSettings.style != newSettings.style) {
			%orig;
			return;
		}
		if (self.inputSettings != nil)
			return;
	}
	
	%orig;
}

- (id)initWithFrame:(CGRect)frame autosizesToFitSuperview:(BOOL)fitSuperview settings:(_UIBackdropViewSettings *)newSettings {
	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForPrivateStyle:newSettings.style];
	if (settings.blurRadius == newSettings.blurRadius 
			&& settings.grayscaleTintAlpha == newSettings.grayscaleTintAlpha
			&& settings.grayscaleTintLevel == newSettings.grayscaleTintLevel) {
		if (newSettings.style != kBackdropStyleForWhiteness 
				&& (newSettings.style == kBackdropStyleSystemDefaultUltraLight || newSettings.style == kBackdropStyleSystemDefaultLight 
						|| newSettings.style == kBackdropStyleSystemDefaultDark || newSettings.style == kBackdropStyleSystemDefaultAdaptiveLight)) {
			_UIBackdropViewSettings *styledSettings = [_UIBackdropViewSettings settingsForPrivateStyle:kBackdropStyleForWhiteness];
			
			return %orig(frame, fitSuperview, styledSettings);
		}
		if (newSettings.style != kBackdropStyleForWhiteness 
				&& (newSettings.style == kBackdropStyleSystemDefaultLightLow || newSettings.style == kBackdropStyleSystemDefaultDarkLow)) {
			_UIBackdropViewSettings *styledSettings = [_UIBackdropViewSettings settingsForPrivateStyle:kBackdropStyleForWhiteness+9];
			
			return %orig(frame, fitSuperview, styledSettings);
		}
	}
	if (newSettings == nil) {
		newSettings = [_UIBackdropViewSettings settingsForPrivateStyle:kBackdropStyleForWhiteness];
	}
	
	return %orig;
}

%end



#pragma mark -
#pragma mark Additional BackdropView


@implementation UIViewController (GlareApps)

- (BOOL)__glareapps_isNeedsToHasBackdrop {
	if ([self isKindOfClass:%c(_UIModalItemsPresentingViewController)]) return NO;
	if ([self isKindOfClass:[UIActivityViewController class]]) return NO;
	if ([self isKindOfClass:%c(SLComposeViewController)]) return NO;
	if ([self isKindOfClass:%c(MPInlineVideoFullscreenViewController)]) return NO;
	
	return YES;
}

- (BOOL)__glareapps_shouldRemoveBackdropAfterPresenting {
	return NO;
}

@end


%hook UIViewController

- (void)presentViewController:(UIViewController *)viewController withTransition:(UIViewAnimationTransition)transition completion:(void (^)(void))fp_ {
	if ([viewController __glareapps_isNeedsToHasBackdrop]) {
		if (viewController.view.subviews.count > 0 && [viewController.view.subviews[0] isKindOfClass:[_UIBackdropView class]]) {
			_UIBackdropView *view = viewController.view.subviews[0];
			if (view.tag != 0xc001) {
				view.alpha = 0.0f;
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
				
				backdropView = [[_UIBackdropView alloc] initWithFrame:frame autosizesToFitSuperview:YES settings:settings];
				backdropView.tag = 0xc001;
				
				[viewController.view insertSubview:backdropView atIndex:0];
				
				backdropView.frame = frame;
			}
			
			[backdropView release];
		}
	}
	
	void (^completion)(void) = ^{
		if (fp_)
			fp_();
		
		if ([viewController __glareapps_shouldRemoveBackdropAfterPresenting]) {
			_UIBackdropView *backdropView = (_UIBackdropView *)[viewController.view viewWithTag:0xc001];
			[backdropView removeFromSuperview];
		}
	};
	
	%orig(viewController, transition, completion);
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
		
		backdropView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
		backdropView.tag = 0xc001;
		
		[_window insertSubview:backdropView atIndex:0];
	}
	
	[backdropView release];
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
	
	colorHelper = [GlareAppsColorHelper sharedInstance];
	
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


