

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



extern BOOL isWhiteness;
static NSArray *GlareAppsWhiteList = nil;


void LoadSettings() {
	NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/kr.slak.GlareApps.plist"];
	if (!dict) return;
	
	if (!GlareAppsWhiteList){
		[GlareAppsWhiteList release];
		GlareAppsWhiteList = nil;
	}
	if (dict[@"WhiteList"] != nil)
		GlareAppsWhiteList = [dict[@"WhiteList"] retain];
	
	[dict release];
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
			if (![filteredApps containsObject:app.displayIdentifier])
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
	LoadSettings();
	killAllApps(GlareAppsWhiteList);
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




%ctor {
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"]) {
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &reloadKillAllAppsNotification, CFSTR("kr.slak.glareapps.killallapps"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		
		%init;
	}
}

