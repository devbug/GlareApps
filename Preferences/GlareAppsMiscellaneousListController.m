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
	if (_specifiers == nil) {
		NSMutableArray *__specifiers;
		
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
																	set:@selector(setEnable:specifier:)
																	get:@selector(getPreferenceNumberValue:)
																 detail:nil
																   cell:PSSwitchCell
																   edit:nil];
		[specifier3 setProperty:@"GlareAppsUseMusicAppAlbumArtBackdrop" forKey:@"key"];
		[specifier3 setProperty:@"kr.slak.glareapps.prefnoti" forKey:@"PostNotification"];
		[specifier3 setProperty:@"kr.slak.GlareApps" forKey:@"defaults"];
		[specifier3 setProperty:@(NO) forKey:@"default"];
		[specifier3 setProperty:@"MusicApp_Enable_Specifier" forKey:@"id"];
		
		__specifiers = [[NSMutableArray alloc] initWithObjects:theme, 
															specifier1, 
															groupSpecifier1, 
															specifier2, 
															musicAppGroupSpecifier, 
															specifier3, 
															nil];
		
		NSNumber *musicGroupEnable = [self getPreferenceNumberValue:specifier3];
		if ([musicGroupEnable boolValue])
			[__specifiers addObjectsFromArray:[self makeMusicAppGroupExtraSpecifiers]];
		
		_specifiers = __specifiers;
	}
	
	return _specifiers;
}

- (NSMutableArray *)makeMusicAppGroupExtraSpecifiers {
	NSMutableArray *__specifiers = [NSMutableArray array];
	
	PSSpecifier *specifier1 = [PSSpecifier preferenceSpecifierNamed:[[self bundle] localizedStringForKey:@"Show AlbumArt" value:@"Show AlbumArt" table:@"GlareAppsSettings"]
															 target:self
																set:@selector(setPreferenceNumberValue:specifier:)
																get:@selector(getPreferenceNumberValue:)
															 detail:nil
															   cell:PSSwitchCell
															   edit:nil];
	[specifier1 setProperty:@"GlareAppsShowMusicAppAlbumArt" forKey:@"key"];
	[specifier1 setProperty:@"kr.slak.glareapps.prefnoti" forKey:@"PostNotification"];
	[specifier1 setProperty:@"kr.slak.GlareApps" forKey:@"defaults"];
	[specifier1 setProperty:@(YES) forKey:@"default"];
	
	[__specifiers addObject:specifier1];
	
	PSSpecifier *specifier2 = [PSSpecifier preferenceSpecifierNamed:[[self bundle] localizedStringForKey:@"Backdrop Blur Radius" value:@"Backdrop Blur Radius" table:@"GlareAppsSettings"]
															 target:self
																set:nil
																get:nil
															 detail:nil
															   cell:PSTitleValueCell
															   edit:nil];
	
	[__specifiers addObject:specifier2];
	
	PSSpecifier *specifier3 = [PSSpecifier preferenceSpecifierNamed:[[self bundle] localizedStringForKey:@"Backdrop Blur Radius" value:@"Backdrop Blur Radius" table:@"GlareAppsSettings"]
															 target:self
																set:@selector(setPreferenceNumberValue:specifier:)
																get:@selector(getPreferenceNumberValue:)
															 detail:nil
															   cell:PSSliderCell
															   edit:nil];
	[specifier3 setProperty:@"GlareAppsMusicAppAlbumArtBackdropBlurRadius" forKey:@"key"];
	[specifier3 setProperty:@"kr.slak.glareapps.prefnoti" forKey:@"PostNotification"];
	[specifier3 setProperty:@"kr.slak.GlareApps" forKey:@"defaults"];
	[specifier3 setProperty:@(0.0f) forKey:@"min"];
	[specifier3 setProperty:@(30.0f) forKey:@"max"];
	[specifier3 setProperty:(PSIsiPad() ? @(20.0f) : @(15.0f)) forKey:@"default"];
	[specifier3 setProperty:@(YES) forKey:@"showValue"];
	
	[__specifiers addObject:specifier3];
	
	return __specifiers;
}

- (NSArray *)getGroupExtraSpecifiersFromGroupEnableSpecifier:(PSSpecifier *)specifier {
	NSString *specifierID = [specifier propertyForKey:@"id"];
	
	if (specifierID) {
		NSMutableArray *specifiers = [NSMutableArray array];
		NSInteger index = [self indexOfSpecifierID:specifierID];
		NSInteger group = 0, row = 0, rows = 0, i = 1;
		
		[self getGroup:&group row:&row ofSpecifierID:specifierID];
		rows = [self rowsForGroup:group];
		
		for (index++; i < rows && index < _specifiers.count; index++, i++) {
			PSSpecifier *currentSpecifier = _specifiers[index];
			
			if ([[PSTableCell stringFromCellType:currentSpecifier.cellType] isEqualToString:@"PSGroupCell"])
				break;
			
			[specifiers addObject:currentSpecifier];
		}
		
		return specifiers;
	}
	
	return nil;
}

- (void)setEnable:(NSNumber *)value specifier:(PSSpecifier *)specifier {
	@autoreleasepool {
		[PSRootController setPreferenceValue:value specifier:specifier];
		
		if ([value boolValue]) {
			[self insertContiguousSpecifiers:[self makeMusicAppGroupExtraSpecifiers] afterSpecifier:specifier animated:YES];
		}
		else {
			NSArray *specifiers = [self getGroupExtraSpecifiersFromGroupEnableSpecifier:specifier];
			
			if (specifiers && specifiers.count > 0)
				[self removeContiguousSpecifiers:specifiers animated:YES];
		}
	}
}

@end



