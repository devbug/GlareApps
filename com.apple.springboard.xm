
#import "headers.h"



@interface SBApplication : NSObject
- (void)setActivationSetting:(NSUInteger)fp8 flag:(BOOL)fp12;
- (void)setActivationSetting:(NSUInteger)fp8 value:(id)fp12;
- (void)setDeactivationSetting:(NSUInteger)fp8 flag:(BOOL)fp12;
- (id)bundleIdentifier;
- (NSString *)displayIdentifier;
- (BOOL)shouldLaunchPNGless;
- (BOOL)showsProgress;
- (BOOL)isRunning;
@end

@interface SpringBoard : UIApplication
- (BOOL)isLocked;
- (NSArray *)_accessibilityRunningApplications;
- (SBApplication *)_accessibilityFrontMostApplication;
- (void)quitTopApplication:(GSEventRef)fp8;
@end

@interface SBWorkspaceEvent : NSObject
+ (id)eventWithLabel:(CFStringRef)fp8 handler:(void(^)(void))handler;
- (void)execute;
@end
@interface SBWorkspaceEventQueue : NSObject
+ (instancetype)sharedInstance;
- (void)cancelEventsWithName:(CFStringRef)fp8;
- (void)executeOrAppendEvent:(id)fp8;
@end


extern "C" NSString *BKSApplicationTerminationReasonDescription(int reason);
extern "C" void BKSTerminateApplicationForReasonAndReportWithDescription(NSString *app, int a, int b, NSString *description);
extern NSString *const SBSAppSwitcherQuitAppNotification;



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

static void reloadPrefsNotification(CFNotificationCenterRef center,
									void *observer,
									CFStringRef name,
									const void *object,
									CFDictionaryRef userInfo) {
	LoadSettings();
	[colorHelper reloadSettings];
}


void killSBApplicationForReasonAndReportWithDescription(SBApplication *app, int reason, BOOL report, NSString *desc)
{
	if (desc == nil)
		desc = BKSApplicationTerminationReasonDescription(reason);
	
	NSString *label = [NSString stringWithFormat:@"TerminateApp: %@ (%@)", app.bundleIdentifier, desc];
	
	SBWorkspaceEvent *event = [%c(SBWorkspaceEvent) eventWithLabel:(CFStringRef)label handler:^{
		BKSTerminateApplicationForReasonAndReportWithDescription(app.bundleIdentifier, reason, report, desc);
	}];
	
	SBWorkspaceEventQueue *eventQueue = [%c(SBWorkspaceEventQueue) sharedInstance];
	[eventQueue executeOrAppendEvent:event];
}

void killAllApps(NSArray *filteredApps)
{
	dispatch_async(dispatch_get_main_queue(), ^{
		SpringBoard *springBoard = (SpringBoard *)[UIApplication sharedApplication];
		NSArray *applist = [springBoard _accessibilityRunningApplications];
		
		SBApplication *topApplication = ([springBoard isLocked] ? nil : [springBoard _accessibilityFrontMostApplication]);
		
		if (topApplication && [filteredApps containsObject:topApplication.displayIdentifier]) {
			SBWorkspaceEvent *event = [%c(SBWorkspaceEvent) eventWithLabel:CFSTR("QuitTopApp") handler:^{
				[springBoard quitTopApplication:nil];
			}];
			SBWorkspaceEventQueue *eventQueue = [%c(SBWorkspaceEventQueue) sharedInstance];
			[eventQueue executeOrAppendEvent:event];
		}
		
		for (SBApplication *app in applist) {
			if (!isTheAppUIServiceProcess(app.displayIdentifier) && ![filteredApps containsObject:app.displayIdentifier])
				continue;
			
			[[%c(NSDistributedNotificationCenter) defaultCenter] postNotificationName:SBSAppSwitcherQuitAppNotification object:app.bundleIdentifier];
			
			[app setDeactivationSetting:0x2 flag:NO];
			[app setDeactivationSetting:0x11 flag:YES];
			
			killSBApplicationForReasonAndReportWithDescription(app, 1, NO, @"killed by GlareAppsSettings");
		}
	});
}


void reloadKillAllAppsNotification(CFNotificationCenterRef center,
									void *observer,
									CFStringRef name,
									const void *object,
									CFDictionaryRef userInfo) {
	@synchronized (GlareAppsWhiteList) {
		killAllApps(GlareAppsWhiteList);
	}
}




%hook SBApplication

- (id)initWithBundleIdentifier:(id)bundleIdentifier webClip:(id)webClip path:(id)path bundle:(id)bundle 
				infoDictionary:(NSDictionary *)dictionary isSystemApplication:(BOOL)isSystemApplication 
				signerIdentity:(id)signerIdentity provisioningProfileValidated:(BOOL)provisioningProfileValidated 
				  entitlements:(id)entitlements {
	NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithDictionary:dictionary];
	
	if (isSystemApplication)
		infoDict[@"UIBackgroundStyle"] = isWhiteness ? @"UIBackgroundStyleLightBlur" : @"UIBackgroundStyleDarkBlur";
	
	return %orig(bundleIdentifier, webClip, path, bundle, infoDict, isSystemApplication, signerIdentity, provisioningProfileValidated, entitlements);
}

%end


%hook _UIModalItemContentView

- (void)layout {
	%orig;
	
	if (!GlareAppsEnable) return;
	
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
	
	if (!GlareAppsEnable) return;
	
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
	
	if (!GlareAppsEnable) return;
	
	UIView *_fakeEffectSourceView = MSHookIvar<UIView *>(self, "_fakeEffectSourceView");
	_fakeEffectSourceView.backgroundColor = [colorHelper defaultAlertViewRepresentationViewBackgroundColor];
}

%end

%hook _UIModalItemAlertBackgroundView

- (void)layoutSubviews {
	%orig;
	
	if (!GlareAppsEnable) return;
	
	_UIBackdropView *_effectView = MSHookIvar<_UIBackdropView *>(self, "_effectView");
	
	NSInteger style = (isWhiteness ? kBackdropStyleSystemDefaultUltraLight : kBackdropStyleSystemDefaultDark);
	if (_effectView.style != style)
		[_effectView transitionToStyle:style];
	
	UIImageView *_fillingView = MSHookIvar<UIImageView *>(self, "_fillingView");
	_fillingView.alpha = (isWhiteness ? 1.0f : 0.0f);
}

%end


%hook _UIModalItemActionSheetContentView

- (void)layout {
	%orig;
	
	if (!GlareAppsEnable) return;
	
	_UIBackdropView *_effectView = MSHookIvar<_UIBackdropView *>(self, "_effectView");
	
	NSInteger style = (isWhiteness ? kBackdropStyleSystemDefaultUltraLight : kBackdropStyleSystemDefaultDark);
	if (_effectView.style != style)
		[_effectView transitionToStyle:style];
}

%end


%hook UIActionSheet

- (void)layout {
	%orig;
	
	if (!GlareAppsEnable) return;
	
	_UIBackdropView *_backdropView = nil;
	if (isFirmware71) {
		_backdropView = MSHookIvar<_UIBackdropView *>(self, "_backgroundView");
	}
	else if (isFirmware70) {
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
	
	if (GlareAppsEnable)
		burnColor = colorHelper.color_0_9__0_2;
	
	return %orig;
}

%end

%hook _UIActionSheetBlendingSeparatorView

- (id)initWithFrame:(CGRect)frame {
	_UIActionSheetBlendingSeparatorView *rtn = %orig;
	
	if (rtn && !isWhiteness && GlareAppsEnable) {
		UIView *_colorBurnView = MSHookIvar<UIView *>(rtn, "_colorBurnView");
		
		[_colorBurnView.layer setCompositingFilter:nil];
	}
	
	return rtn;
}

%end

%hook UIAlertButton

- (void)setHighlightImage:(UIImage *)image {
	if (GlareAppsEnable)
		image = [image _flatImageWithColor:[colorHelper commonTextColor]];
	
	%orig;
}

%end


%hook UIActivityGroupListViewController

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	
	if (!GlareAppsEnable) return;
	
	if (self.backdropView.style != kBackdropStyleForWhiteness)
		[self.backdropView transitionToStyle:kBackdropStyleForWhiteness];
}

%end




%ctor {
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"]) {
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &reloadPrefsNotification, CFSTR("kr.slak.glareapps.prefnoti"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &reloadKillAllAppsNotification, CFSTR("kr.slak.glareapps.killallapps"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		LoadSettings();
		
		%init;
	}
}

