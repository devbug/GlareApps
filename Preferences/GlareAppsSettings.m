/* 
 * 
 *	GlareAppsSettings.m
 *	Glare Apps' Settings bundle
 *	
 *	
 *	Glare Apps
 *	Copyright (C) 2014  deVbug (devbug@devbug.me)
 *	
 *	This program is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation, either version 3 of the License.
 *	 
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *	
 *	You should have received a copy of the GNU General Public License
 *	along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *	
 */


#import "Preferences.h"



@implementation GlareAppsListController

- (void)loadView {
	[super loadView];
	
	if ([self respondsToSelector:@selector(navigationItem)]) {
		[[self navigationItem] setTitle:self._title];
	}
}

- (void)setTitle:(NSString *)title {
	if (title) {
		[super setTitle:title];
		self._title = title;
	}
}

- (void)setPreferenceNumberValue:(NSNumber *)value specifier:(PSSpecifier *)specifier {
	[PSRootController setPreferenceValue:value specifier:specifier];
}

- (NSNumber *)getPreferenceNumberValue:(PSSpecifier *)specifier {
	return [PSRootController readPreferenceValue:specifier];
}

@end



@implementation GlareAppsSettingsListController

- (id)specifiers {
	if(_specifiers == nil) {
		PSSpecifier *specifier1 = [PSSpecifier preferenceSpecifierNamed:[[self bundle] localizedStringForKey:@"Enable" value:@"Enable" table:@"GlareAppsSettings"]
																 target:self
																	set:@selector(setPreferenceNumberValue:specifier:)
																	get:@selector(getPreferenceNumberValue:)
																 detail:nil
																   cell:PSSwitchCell
																   edit:nil];
		[specifier1 setProperty:@"GlareAppsEnable" forKey:@"key"];
		[specifier1 setProperty:@"kr.slak.glareapps.prefnoti" forKey:@"PostNotification"];
		[specifier1 setProperty:@"kr.slak.GlareApps" forKey:@"defaults"];
		[specifier1 setProperty:@(YES) forKey:@"default"];
		
		PSSpecifier *specifier2 = [PSSpecifier preferenceSpecifierNamed:[[self bundle] localizedStringForKey:@"WhiteList Apps" value:@"Applied apps" table:@"GlareAppsSettings"]
																 target:self
																	set:nil
																	get:nil
																 detail:[PSFilteredAppListListController class]
																   cell:PSLinkCell
																   edit:nil];
		[specifier2 setProperty:@"WhiteList" forKey:@"key"];
		[specifier2 setProperty:@"kr.slak.glareapps.prefnoti" forKey:@"PostNotification"];
		[specifier2 setProperty:@"kr.slak.GlareApps" forKey:@"defaults"];
		[specifier2 setProperty:@(NO) forKey:@"isPopover"];
		[specifier2 setProperty:@(NO) forKey:@"enableForceType"];
		[specifier2 setProperty:@(FilteredAppSystem & ~FilteredAppWebapp) forKey:@"filteredAppType"];
		
		PSSpecifier *groupSpecifier1 = [PSSpecifier emptyGroupSpecifier];
		[groupSpecifier1 setProperty:[[self bundle] localizedStringForKey:@"EACHAPP_RESTART_REQUIRED" value:@"Each app restart is required" table:@"GlareAppsSettings"] forKey:@"footerText"];
		
		PSSpecifier *specifier3 = [PSSpecifier preferenceSpecifierNamed:[[self bundle] localizedStringForKey:@"Miscellaneous" value:@"Miscellaneous" table:@"GlareAppsSettings"]
																 target:self
																	set:nil
																	get:nil
																 detail:[GlareAppsMiscellaneousListController class]
																   cell:PSLinkCell
																   edit:nil];
		
		PSConfirmationSpecifier *specifier4 = [PSConfirmationSpecifier preferenceSpecifierNamed:[[self bundle] localizedStringForKey:@"Kill all apps" value:@"Kill all applied apps" table:@"GlareAppsSettings"]
																						 target:self
																							set:nil
																							get:nil
																						 detail:nil
																						   cell:PSButtonCell
																						   edit:nil];
		specifier4.title = [[self bundle] localizedStringForKey:@"KILL" value:@"KILL!" table:@"GlareAppsSettings"];
		specifier4.prompt = [[self bundle] localizedStringForKey:@"KillAllApps_PROMPT" value:@"Kill every applied apps" table:@"GlareAppsSettings"];
		specifier4.okButton = [[self bundle] localizedStringForKey:@"KILL" value:@"KILL!" table:@"GlareAppsSettings"];
		specifier4.cancelButton = [[self bundle] localizedStringForKey:@"Cancel" value:@"Cancel" table:@"GlareAppsSettings"];
		specifier4.confirmationAction = @selector(killAllApps:);
		[specifier4 setProperty:@(2) forKey:@"alignment"];
		
		PSSpecifier *killallapps = [PSSpecifier emptyGroupSpecifier];
		[killallapps setProperty:[[self bundle] localizedStringForKey:@"KILLALLAPPS_MSG" value:@"Include Preferences app." table:@"GlareAppsSettings"] forKey:@"footerText"];
		
		PSSpecifier *footer = [PSSpecifier emptyGroupSpecifier];
		[footer setProperty:[[self bundle] localizedStringForKey:@"MSG_COPYRIGHT" value:@"Glare Apps © deVbug" table:@"GlareAppsSettings"] forKey:@"footerText"];
		
		_specifiers = [[NSMutableArray alloc] initWithObjects:groupSpecifier1, 
															specifier1, 
															groupSpecifier1, 
															specifier2, 
															[PSSpecifier emptyGroupSpecifier], 
															specifier3, 
															killallapps, 
															specifier4, 
															footer, 
															nil];
	}
	
	return _specifiers;
}


- (void)killAllApps:(PSSpecifier *)specifier {
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("kr.slak.glareapps.killallapps"), NULL, NULL, TRUE);
}


/*- (UIViewController *)controllerForSpecifier:(PSSpecifier *)specifier {
	UIViewController *vc = [super controllerForSpecifier:specifier];
	
	if ([vc isKindOfClass:[PSFilteredAppListListController class]]) {
		PSFilteredAppListListController *next = (PSFilteredAppListListController *)vc;
		next.isPopover = NO;
		next.enableForceType = NO;
		next.filteredAppType = (FilteredAppSystem & ~FilteredAppWebapp);
		next.delegate = self;
	}
	
	return vc;
}

- (FilteredListType)filteredListTypeForIdentifier:(NSString *)identifier {
	FilteredListType appType = FilteredListNone;
	
	BOOL isWhiteList = NO;
	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Library/Preferences/kr.slak.GlareApps.plist"]) {
		NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/kr.slak.GlareApps.plist"];
		
		if (data) {
			NSArray *whitelist = [data objectForKey:@"WhiteList"];
			
			if (whitelist != nil)
				isWhiteList = [whitelist containsObject:identifier];
		}
	}
	
	if (isWhiteList) {
		appType = FilteredListNormal;
	}
	else {
		appType = FilteredListNone;
	}
	
	return appType;
}

- (void)didSelectRowAtCell:(PSFilteredAppListCell *)cell {
	NSString *identifier = cell.displayId;
	NSMutableDictionary *data;
	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Library/Preferences/kr.slak.GlareApps.plist"]) {
		data = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/kr.slak.GlareApps.plist"];
	}
	else {
		data = [NSMutableDictionary dictionary];
	}
	
	NSMutableArray *whitelist = [[data objectForKey:@"WhiteList"] retain];
	if (whitelist == nil)
		whitelist = [[NSMutableArray alloc] init];
	
	if (cell.filteredListType == FilteredListNormal) {
		[whitelist addObject:identifier];
	}
	else {
		[whitelist removeObject:identifier];
	}
	
	[data setObject:whitelist forKey:@"WhiteList"];
	[whitelist release];
	
	
	[data writeToFile:@"/User/Library/Preferences/kr.slak.GlareApps.plist" atomically:YES];
	
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("kr.slak.glareapps.prefnoti"), NULL, NULL, true);
}*/

@end



