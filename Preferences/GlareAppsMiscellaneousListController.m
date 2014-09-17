/* 
 * 
 *	GlareAppsMiscellaneousListController.m
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



@implementation GlareAppsMiscellaneousListController

- (id)specifiers {
	if(_specifiers == nil) {
		PSSpecifier *groupSpecifier1 = [PSSpecifier emptyGroupSpecifier];
		[groupSpecifier1 setProperty:[[self bundle] localizedStringForKey:@"EACHAPP_RESTART_REQUIRED" value:@"Each app restart is required" table:@"GlareAppsSettings"] forKey:@"footerText"];
		
		PSSpecifier *specifier1 = [PSSpecifier preferenceSpecifierNamed:[[self bundle] localizedStringForKey:@"Use White theme" value:@"Use White theme" table:@"GlareAppsSettings"]
																 target:self
																	set:@selector(setPreferenceNumberValue:specifier:)
																	get:@selector(getPreferenceNumberValue:)
																 detail:nil
																   cell:PSSwitchCell
																   edit:nil];
		[specifier1 setProperty:@"GlareAppsUseWhiteTheme" forKey:@"key"];
		[specifier1 setProperty:@"kr.slak.glareapps.prefnoti" forKey:@"PostNotification"];
		[specifier1 setProperty:@"kr.slak.GlareApps" forKey:@"defaults"];
		[specifier1 setProperty:@(NO) forKey:@"default"];
		
		PSSpecifier *theme = [PSSpecifier emptyGroupSpecifier];
		[theme setProperty:[[self bundle] localizedStringForKey:@"DEFAULT_THEME_MSG" value:@"Default is Black theme." table:@"GlareAppsSettings"] forKey:@"footerText"];
		
		PSSpecifier *specifier2 = [PSSpecifier preferenceSpecifierNamed:[[self bundle] localizedStringForKey:@"Use Blended mode" value:@"Use Blended mode" table:@"GlareAppsSettings"]
																 target:self
																	set:@selector(setPreferenceNumberValue:specifier:)
																	get:@selector(getPreferenceNumberValue:)
																 detail:nil
																   cell:PSSwitchCell
																   edit:nil];
		[specifier2 setProperty:@"GlareAppsUseBlendedMode" forKey:@"key"];
		[specifier2 setProperty:@"kr.slak.glareapps.prefnoti" forKey:@"PostNotification"];
		[specifier2 setProperty:@"kr.slak.GlareApps" forKey:@"defaults"];
		[specifier2 setProperty:@(NO) forKey:@"default"];
		
		PSSpecifier *musicAppGroupSpecifier = [PSSpecifier groupSpecifierWithName:[[self bundle] localizedStringForKey:@"MUSICAPP_" value:@"Music app" table:@"GlareAppsSettings"]];
		[musicAppGroupSpecifier setProperty:[[self bundle] localizedStringForKey:@"MUSICAPP_RESTART_REQUIRED" value:@"Music app restart is required" table:@"GlareAppsSettings"] forKey:@"footerText"];
		
		PSSpecifier *specifier3 = [PSSpecifier preferenceSpecifierNamed:[[self bundle] localizedStringForKey:@"Use AlbumArt Backdrop" value:@"Use AlbumArt Backdrop" table:@"GlareAppsSettings"]
																 target:self
																	set:@selector(setPreferenceNumberValue:specifier:)
																	get:@selector(getPreferenceNumberValue:)
																 detail:nil
																   cell:PSSwitchCell
																   edit:nil];
		[specifier3 setProperty:@"GlareAppsUseMusicAppAlbumArtBackdrop" forKey:@"key"];
		[specifier3 setProperty:@"kr.slak.glareapps.prefnoti" forKey:@"PostNotification"];
		[specifier3 setProperty:@"kr.slak.GlareApps" forKey:@"defaults"];
		[specifier3 setProperty:@(NO) forKey:@"default"];
		
		_specifiers = [[NSMutableArray alloc] initWithObjects:theme, 
															specifier1, 
															groupSpecifier1, 
															specifier2, 
															musicAppGroupSpecifier, 
															specifier3, 
															nil];
	}
	
	return _specifiers;
}

@end



