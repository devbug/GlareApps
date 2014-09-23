
#import "headers.h"




@interface MPUVignetteBackgroundView : UIView @end

@interface MusicPlaylistActionsView : UIView @end

@interface MusicMoreListController : UIMoreListController @end

@interface MusicNoContentView : UIView {
	_UIContentUnavailableView *_contentUnavailableView;
}
@end

@interface MusicTableSectionHeaderView : UITableViewHeaderFooterView
@property(readonly, nonatomic) UILabel *titleLabel;
@property(nonatomic) CGFloat backgroundTransitionWeighting;
@end
@interface MusicAlbumsDetailTableHeaderView : UITableViewHeaderFooterView
- (void)setBackgroundTransitionProgress:(CGFloat)arg1;
- (CGFloat)backgroundTransitionProgress;
@end
@interface MusicFlipsideAlbumDetailHeaderView : UITableViewHeaderFooterView
- (void)setBackgroundTransitionProgress:(CGFloat)arg1;
- (CGFloat)backgroundTransitionProgress;
@end

@interface MusicTableViewCellContentView : UIView @end
@interface MusicSongTableViewCellContentView : MusicTableViewCellContentView
@property(readonly, nonatomic) UIImageView *geniusImageView;
@property(readonly, nonatomic) UIImageView *explicitImageView;
@end
@interface _MusicSongListTableViewCellContentView : MusicSongTableViewCellContentView
@property(readonly, nonatomic) UILabel *titleLabel;
@property(readonly, nonatomic) UIImageView *artworkImageView;
@property(readonly, nonatomic) UILabel *artistLabel;
@property(readonly, nonatomic) UILabel *albumLabel;
@property(retain, nonatomic) UIImage *artworkImage;
@property(copy, nonatomic) NSString *artist;
@property(copy, nonatomic) NSString *album;
@property(copy, nonatomic) NSString *title;
@end
@interface _MusicArtistTableViewCellContentView : MusicTableViewCellContentView
@property(retain, nonatomic) UIImage *artworkImage;
@end

@interface _MusicSearchTableViewCell : UITableViewCell
@property(copy, nonatomic) NSAttributedString *attributedTitleText;
@property(copy, nonatomic) NSAttributedString *attributedSubtitleText;
@end

@interface _MusicAddPlaylistActionTableViewCell : UITableViewCell @end
@interface MusicPlaylistsViewController : UIViewController @end



@interface MusicNowPlayingTransportControls : MPTransportControls @end
@interface MusicNowPlayingPlaybackControlsView : MPPlaybackControlsView {
	UIButton *_createButton;
	UIButton *_infoButton;
	MusicNowPlayingTransportControls *_transportControls;
	MPVolumeSlider *_volumeSlider;
}
@property(readonly, nonatomic) UIButton *infoButton;
- (BOOL)_isCreateAvailable;
- (id)shuffleButtonImage;
- (id)repeatButtonImage;
@end

@interface MusicNowPlayingVolumeSlider : MPVolumeSlider
- (void)_updateTrackTintForVolumeControlAvailability;
- (id)_trackImageWithTintColor:(id)tintColor;
@end

@interface MusicNowPlayingTitlesView : MPUNowPlayingTitlesView @end

@interface MusicNowPlayingViewController : UIViewController @end

@interface MusicMoreNavigationController : UIMoreNavigationController @end

@interface MusicTabBarController : UITabBarController
- (MusicMoreNavigationController *)moreNavigationController;
@end

@interface MAAppDelegate : NSObject
@property(readonly, nonatomic) MusicTabBarController *tabBarController;
@property(readonly, nonatomic) UINavigationController *radioNavigationController;
@end

// iPad
@interface MAPAAppDelegate : MAAppDelegate {
	UINavigationController *_nowPlayingNavigationController;
}
@end

@interface MusicMiniPlayerTransportControls : MPTransportControls @end

@interface NSBundle (__MusicUIBundle)
+ (id)musicUIBundle;
@end


#define TINT_COLOR							[colorHelper commonTextColor]
#define TINT_COLOR_WITH_ALPHA(a)			[colorHelper commonTextColorWithAlpha:a]
#define TINT_FRACTION						(isWhiteness ? 1.5f : 1.0f)


BOOL EnableNowPlayingBlurring				= YES;

static GlareAppsBlurredBackgroundImageView *backgroundImageView = nil;




UINavigationController *getCurrentNavigationController() {
	MAAppDelegate *delegate = (MAAppDelegate *)[[UIApplication sharedApplication] delegate];
	UINavigationController *nvc = nil;
	
	if (isPad) {
		nvc = MSHookIvar<UINavigationController *>(delegate, "_nowPlayingNavigationController");
	}
	else {
		UIViewController *vc = [delegate tabBarController].selectedViewController;
		nvc = (UINavigationController *)vc;
		
		if (![vc isKindOfClass:[UINavigationController class]]) {
			nvc = vc.navigationController;
		}
		
		if (![[delegate tabBarController].tabBar.selectedItem isEqual:vc.tabBarItem]) {
			nvc = [[delegate tabBarController] moreNavigationController];
		}
	}
	
	return nvc;
}


// {{{
// only for BlurredMusicApp
BOOL temporaryUnlockStatusBarForegroundColorSetting = NO;

%hook UIApplication

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle animated:(BOOL)animated {
	if (temporaryUnlockStatusBarForegroundColorSetting) %orig;
	
	temporaryUnlockStatusBarForegroundColorSetting = NO;
}

%end


%hook MAAppDelegate

- (void)navigationController:(UINavigationController *)nav willShowViewController:(UIViewController *)vc animated:(BOOL)animated {
	[UIApplication sharedApplication].statusBar.foregroundColor = [colorHelper commonTextColor];
	
	%orig;
	
	if (!EnableNowPlayingBlurring && useBlendedMode && useMusicAppAlbumArtBackdrop && ![vc isKindOfClass:%c(MusicNowPlayingViewController)]) {
		MAAppDelegate *delegate = (MAAppDelegate *)[[UIApplication sharedApplication] delegate];
		
		UINavigationBar *navBar = [[delegate tabBarController] moreNavigationController].navigationBar;
		navBar._backgroundView.alpha = 1.0f;
		
		navBar = [delegate radioNavigationController].navigationBar;
		navBar._backgroundView.alpha = 1.0f;
		
		navBar = vc.navigationController.navigationBar;
		navBar._backgroundView.alpha = 1.0f;
	}
	
	if (useMusicAppAlbumArtBackdrop) {
		MusicAVPlayer *avPlayer = [%c(MusicAVPlayer) sharedAVPlayer];
		
		if (!avPlayer.isPlaying)
			backgroundImageView.alpha = 0.0f;
	}
	
	[backgroundImageView removeMaskViews];
}

%end


%hook UIViewController

- (void)viewWillAppear:(BOOL)animated {
	clearBar(self.navigationController.navigationBar);
	
	%orig;
}

- (void)viewDidLayoutSubviews {
	%orig;
	
	if (EnableNowPlayingBlurring && [self isKindOfClass:%c(MusicNowPlayingViewController)]) {
		temporaryUnlockStatusBarForegroundColorSetting = YES;
	}
}

%end
// }}}


%hook UIViewController

- (BOOL)__glareapps_isNeedsToHasBackdrop {
	BOOL rtn = %orig;
	
	if (isFirmware71 && [self isKindOfClass:%c(MPUBackdropContentViewController)]) return NO;
	
	return rtn;
}

%end


%hook UILabel

- (BOOL)__glareapps_isActionSheetOrActivityGroup {
	UIView *superview = self.superview;
	BOOL rtn = NO;
	
	while (EnableNowPlayingBlurring && superview != nil && ![superview isKindOfClass:[UIWindow class]]) {
		if ([NSStringFromClass(superview.class) hasPrefix:@"MusicNowPlaying"]) {
			rtn = YES;
			break;
		}
		if ([NSStringFromClass(superview.class) hasPrefix:@"UINavigationBar"]) {
			rtn = YES;
			break;
		}
		
		superview = superview.superview;
	}
	
	return rtn;
}

%end


%hook _UIBackdropView

- (BOOL)__glareapps_shouldRejectOwnBackgroundColor {
	return YES;
}

%end


%hook MPUVignetteBackgroundView

- (void)layoutSubviews {
	%orig;
	
	if ([self.superview isKindOfClass:%c(UISearchResultsTableView)]) {
		_UIBackdropView *backdropView = (_UIBackdropView *)[self viewWithTag:0xc002];
		[backdropView retain];
		
		CGRect frame = self.frame;
		frame.origin.x = 0;
		frame.origin.y = 0;
		
		if (backdropView == nil) {
			backdropView = [[_UIBackdropView alloc] initWithFrame:frame style:kBackdropStyleForWhiteness];
			backdropView.tag = 0xc002;
			[self insertSubview:backdropView atIndex:0];
		}
		
		backdropView.frame = frame;
		[backdropView release];
	}
		
	self.backgroundColor = [colorHelper themedFakeClearColor];
	
	UIImageView *_imageView = MSHookIvar<UIImageView *>(self, "_imageView");
	_imageView.backgroundColor = [colorHelper clearColor];
	_imageView.alpha = kRealTransparentAlphaFactor;
	
	UIView *_containerView = MSHookIvar<UIView *>(self, "_containerView");
	_containerView.backgroundColor = [colorHelper clearColor];
}

%end


UIImage *shuffleImage = nil;

%hook MusicTheme

+ (id)disabledPlaybackControlColor {
	return [colorHelper systemGrayColor];
}

+ (id)tableViewCellSeparatorColor {
	return [colorHelper systemGrayColor];
}

+ (id)shuffleImage {
	if (shuffleImage) return shuffleImage;
	
	UIImage *_shuffleImage = %orig;
	
	shuffleImage = [_shuffleImage _flatImageWithColor:[[[UIApplication sharedApplication] keyWindow] tintColor]];
	[shuffleImage retain];
	
	return shuffleImage;
}

%end


%hook MusicPlaylistActionsView

- (void)layoutSubviews {
	%orig;
	
	_UIBackdropView *_backdropView = MSHookIvar<_UIBackdropView *>(self, "_backdropView");
	
	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleSystemDefaultSemiLight];
	settings.grayscaleTintLevel = (isWhiteness ? 1.0f : 0.0f);
	
	if (_backdropView.style != kBackdropStyleSystemDefaultSemiLight)
		[_backdropView transitionToSettings:settings];
}

%end


%hook MusicNoContentView

+ (void)endApplicationTranslucency {
	
}

+ (void)beginApplicationTranslucency {
	
}

- (void)layoutSubviews {
	%orig;
	
	self.backgroundColor = [colorHelper fakeBlackClearColor];
}

%end


// for MusicFlipside
%hook _UINavigationPaletteBackground

- (void)updateBackgroundView {
	%orig;
	
	_UIBackdropView *_adaptiveBackdrop = MSHookIvar<_UIBackdropView *>(self, "_adaptiveBackdrop");
	_adaptiveBackdrop.alpha = 0.0f;
}

%end


%group Firmware71_MusicTableSectionHeaderView_Background

%hook MusicTableSectionHeaderView

%new
- (void)setBackgroundTransitionProgress:(CGFloat)progress {
	_UIBackdropView *backdropView = (_UIBackdropView *)[self viewWithTag:0xc001];
	[backdropView retain];
	
	CGRect frame = self.frame;
	frame.origin.x = 0;
	frame.origin.y = 0;
	
	if (backdropView == nil) {
		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleSystemDefaultSemiLight];
		settings.grayscaleTintLevel = (isWhiteness ? 1.0f : 0.0f);
		
		backdropView = [[_UIBackdropView alloc] initWithFrame:frame settings:settings];
		backdropView.alpha = 0.0f;
		backdropView.tag = 0xc001;
	}
	
	backdropView.frame = frame;
	
	if (self.backgroundView != backdropView)
		self.backgroundView = backdropView;
	
	self.backgroundView.alpha = progress;
	
	[backdropView release];
}

%end


%hook UITableView

- (NSRange)MPU_rangeOfVisibleSections {
	NSArray *indexPaths = [self indexPathsForVisibleRows];
	
	NSInteger start = (indexPaths.count > 0 ? ((NSIndexPath *)indexPaths[0]).section : -1), count = 0, currentSection = -1;
	
	for (NSIndexPath *indexPath in indexPaths) {
		if (indexPath.section > currentSection) {
			currentSection = indexPath.section;
			count++;
		}
		
		if (currentSection < start)
			start = currentSection;
	}
	
	return NSMakeRange(start, count);
}

%end

%end


%group Firmware70_MusicTableSectionHeaderView_Background

%hook MusicTableSectionHeaderView

// < 7.1
- (void)setBackgroundTransitionProgress:(CGFloat)progress {
	_UIBackdropView *backdropView = (_UIBackdropView *)[self viewWithTag:0xc001];
	[backdropView retain];
	
	CGRect frame = self.frame;
	frame.origin.x = 0;
	frame.origin.y = 0;
	
	if (backdropView == nil) {
		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleSystemDefaultSemiLight];
		settings.grayscaleTintLevel = (isWhiteness ? 1.0f : 0.0f);
		
		backdropView = [[_UIBackdropView alloc] initWithFrame:frame settings:settings];
		backdropView.alpha = 0.0f;
		backdropView.tag = 0xc001;
	}
	
	backdropView.frame = frame;
	
	if (self.backgroundView != backdropView)
		self.backgroundView = backdropView;
	
	%orig;
	
	[backdropView release];
}

%end

%end


%hook MusicTableSectionHeaderView

- (void)layoutSubviews {
	%orig;
	
	self.titleLabel.textColor = [colorHelper systemGrayColor];
}

%end

%hook MusicAlbumsDetailTableHeaderView

- (void)setBackgroundTransitionProgress:(CGFloat)progress {
	_UIBackdropView *backdropView = (_UIBackdropView *)[self viewWithTag:0xc001];
	[backdropView retain];
	
	CGRect frame = self.frame;
	frame.origin.x = 0;
	frame.origin.y = 0;
	
	if (backdropView == nil) {
		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleSystemDefaultSemiLight];
		settings.grayscaleTintLevel = (isWhiteness ? 1.0f : 0.0f);
		
		backdropView = [[_UIBackdropView alloc] initWithFrame:frame settings:settings];
		backdropView.alpha = 0.0f;
		backdropView.tag = 0xc001;
	}
	
	backdropView.frame = frame;
	
	if (self.backgroundView != backdropView)
		self.backgroundView = backdropView;
	
	%orig;
	
	if (isFirmware71)
		self.backgroundView.alpha = progress;
	
	[backdropView release];
}

%end


// for MoreListController
%hook UITabBarCustomizeView

- (void)layoutSubviews {
	%orig;
	
	_UIBackdropView *backdropView = (_UIBackdropView *)[self viewWithTag:0xc003];
	[backdropView retain];
	
	CGRect frame = self.frame;
	frame.origin.x = 0;
	frame.origin.y = 0;
	
	if (backdropView == nil) {
		backdropView = [[_UIBackdropView alloc] initWithFrame:frame style:kBackdropStyleForWhiteness];
		backdropView.tag = 0xc003;
		[self insertSubview:backdropView atIndex:0];
	}
	
	backdropView.frame = frame;
	
	self.backgroundColor = [colorHelper clearColor];
	
	[backdropView release];
}

%end


%hook MusicMoreListController

- (id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(id)indexPath {
	UITableViewCell *cell = %orig;
	
	cell.backgroundColor = [colorHelper defaultTableViewCellBackgroundColor];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(id)indexPath {
	%orig;
	
	cell.imageView.tintColor = [colorHelper systemGrayColor];
}

%end


%hook _MusicSongListTableViewCellContentView

- (void)setTitle:(NSString *)title {
	%orig;
	
	self.titleLabel.textColor = [colorHelper musicTableViewCellTextColor];
}
- (void)setArtist:(NSString *)artist {
	%orig;
	
	if (isFirmware70)
		self.artistLabel.textColor = [colorHelper musicTableViewCellTextColor];
}
- (void)setAlbum:(NSString *)album {
	%orig;
	
	if (isFirmware70)
		self.albumLabel.textColor = [colorHelper systemGrayColor];
}

// >= 7.1
- (void)_updateAlbumArtistLabelPhone {
	%orig;
	
	NSAttributedString *text = self.artistLabel.attributedText;
	
	if (self.artistLabel != nil && text != nil) {
		NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:text];
		[attributedString enumerateAttributesInRange:(NSRange){0,[attributedString length]} 
											 options:NSAttributedStringEnumerationReverse 
										  usingBlock:^(NSDictionary *attributes, NSRange range, BOOL *stop) {
			NSMutableDictionary *mutableAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
			UIColor *color = mutableAttributes[@"NSColor"];
			if ([[color description] hasPrefix:@"UIDeviceWhiteColorSpace"]) {
				// colorReplacedAttributedString()로 인해 이미 처리됨.
			}
			else {
				mutableAttributes[@"NSColor"] = [colorHelper systemGrayColor];
			}
			[attributedString setAttributes:mutableAttributes range:range];
		}];
		
		self.artistLabel.attributedText = attributedString;
		[attributedString release];
	}
}

%end


%hook _MusicArtistTableViewCellContentView

- (void)setDetailAttributedText:(NSAttributedString *)text {
	%orig(colorReplacedAttributedString(text));
}

- (void)layoutSubviews {
	%orig;
	
	UILabel *_titleLabel = MSHookIvar<UILabel *>(self, "_titleLabel");
	_titleLabel.textColor = [colorHelper commonTextColor];
	UILabel *_detailLabel = MSHookIvar<UILabel *>(self, "_detailLabel");
	_detailLabel.textColor = [colorHelper commonTextColor];
	
	UIImageView *_artworkImageView = MSHookIvar<UIImageView *>(self, "_artworkImageView");
	_artworkImageView.backgroundColor = [colorHelper clearColor];
}

%end


%hook MusicAlbumsDetailTableHeaderView

- (void)layoutSubviews {
	%orig;
	
	UILabel *_titleLabel = MSHookIvar<UILabel *>(self, "_titleLabel");
	_titleLabel.textColor = [colorHelper commonTextColor];
	UILabel *_yearLabel = MSHookIvar<UILabel *>(self, "_yearLabel");
	_yearLabel.textColor = [colorHelper commonTextColor];
	UILabel *_detailTextLabel = MSHookIvar<UILabel *>(self, "_detailTextLabel");
	_detailTextLabel.textColor = [colorHelper commonTextColor];
	
	UILabel *_copyrightLabel = MSHookIvar<UILabel *>(self, "_copyrightLabel");
	_copyrightLabel.textColor = [colorHelper systemGrayColor];
	
	UIImageView *_artworkImageView = MSHookIvar<UIImageView *>(self, "_artworkImageView");
	_artworkImageView.backgroundColor = [colorHelper clearColor];
}

%end


%hook MusicFlipsideAlbumDetailHeaderView

- (void)layoutSubviews {
	%orig;
	
	UILabel *_songLabel = MSHookIvar<UILabel *>(self, "_songLabel");
	_songLabel.textColor = [colorHelper commonTextColor];
	
	UIImageView *_artworkImageView = MSHookIvar<UIImageView *>(self, "_artworkImageView");
	_artworkImageView.backgroundColor = [colorHelper clearColor];
}

%end


%hook _MPHAlbumTableViewCellContentView

- (void)setDetailAttributedText:(NSAttributedString *)text {
	%orig(colorReplacedAttributedString(text));
}

- (void)layoutSubviews {
	%orig;
	
	UILabel *_titleLabel = MSHookIvar<UILabel *>(self, "_titleLabel");
	_titleLabel.textColor = [colorHelper commonTextColor];
	UILabel *_subtitleLabel = MSHookIvar<UILabel *>(self, "_subtitleLabel");
	_subtitleLabel.textColor = [colorHelper commonTextColor];
	UILabel *_detailLabel = MSHookIvar<UILabel *>(self, "_detailLabel");
	_detailLabel.textColor = [colorHelper commonTextColor];
	
	UIImageView *_artworkImageView = MSHookIvar<UIImageView *>(self, "_artworkImageView");
	_artworkImageView.backgroundColor = [colorHelper clearColor];
}

%end


%hook _MusicPlaylistTableViewCell

- (void)setDetailAttributedText:(NSAttributedString *)text {
	%orig(colorReplacedAttributedString(text));
}

- (void)layoutSubviews {
	%orig;
	
	UILabel *_detailLabel = MSHookIvar<UILabel *>(self, "_detailLabel");
	_detailLabel.textColor = [colorHelper commonTextColor];
	
	UIImageView *_artworkImageView = MSHookIvar<UIImageView *>(self, "_artworkImageView");
	_artworkImageView.backgroundColor = [colorHelper clearColor];
}

%end


%hook _MusicSearchTableViewCell

- (void)setAttributedTitleText:(NSAttributedString *)text {
	%orig(colorReplacedAttributedString(text));
}

- (void)setAttributedSubtitleText:(NSAttributedString *)text {
	%orig(colorReplacedAttributedString(text));
}

- (void)layoutSubviews {
	%orig;
	
	//UIImageView *_artworkImageView = MSHookIvar<UIImageView *>(self, "_artworkImageView");
	//_artworkImageView.backgroundColor = [colorHelper clearColor];
}

%end


%hook _MusicSongListTableViewCellContentView

- (void)layoutSubviews {
	%orig;
	
	self.artworkImageView.backgroundColor = [colorHelper clearColor];
}

%end


%hook MPMediaItemImageRequest

- (void)setArtworkFormat:(NSInteger)format {
	//%orig(1);
	%orig;
}

- (void)setFillColor:(UIColor *)fillColor {
	
}

- (void)setContentMode:(NSInteger)contentMode {
	
}

- (void)setFillToSquareAspectRatio:(BOOL)fill {
	%orig;
}

%end


%hook _MusicAddPlaylistActionTableViewCell

- (void)layoutSubviews {
	%orig;
	
	self.textLabel.textColor = [colorHelper musicTableViewCellTextColor];
}

%end


%hook MusicMiniPlayerTransportControls

- (void)layoutSubviews {
	%orig;
	
	UIButton *_playButton = MSHookIvar<UIButton *>(self, "_playButton");
	UIButton *_previousButton = MSHookIvar<UIButton *>(self, "_previousButton");
	UIButton *_nextButton = MSHookIvar<UIButton *>(self, "_nextButton");
	
	_playButton.tintColor = useBlendedMode ? blendColor() : TINT_COLOR;
	_previousButton.tintColor = useBlendedMode ? blendColor() : TINT_COLOR;
	_nextButton.tintColor = useBlendedMode ? blendColor() : TINT_COLOR;
	
	if (useBlendedMode) {
		blendView(_playButton);
		blendView(_previousButton);
		blendView(_nextButton);
	}
}

%end


%hook MusicMiniPlayerPlaybackControlsView

- (void)layoutSubviews {
	%orig;
	
	if (useBlendedMode) {
		UIButton *_shuffleButton = MSHookIvar<UIButton *>(self, "_shuffleButton");
		UIButton *_repeatButton = MSHookIvar<UIButton *>(self, "_repeatButton");
		UIButton *_createButton = MSHookIvar<UIButton *>(self, "_createButton");
		
		[_shuffleButton setTitleColor:blendColor() forState:UIControlStateNormal];
		[_repeatButton setTitleColor:blendColor() forState:UIControlStateNormal];
		[_createButton setTitleColor:blendColor() forState:UIControlStateNormal];
		
		blendView(_shuffleButton);
		blendView(_repeatButton);
		blendView(_createButton);
		
		MusicNowPlayingTitlesView *_titlesView = MSHookIvar<MusicNowPlayingTitlesView *>(self, "_titlesView");
		blendView(_titlesView._titleLabel);
	}
}

%end


%hook MPHAlbumHeaderView

- (void)setCountAttributedString:(NSAttributedString *)text {
	%orig(colorReplacedAttributedString(text));
}

- (UIColor *)secondaryTextColor {
	return [colorHelper systemDarkGrayColor];
}

- (void)setSecondaryTextColor:(UIColor *)color {
	%orig([colorHelper systemDarkGrayColor]);
}

%end


%hook MPHCZAlbumTracksCellConfiguration

+ (UIColor *)tableViewCellBackgroundColor {
	return [colorHelper clearColor];
}

%end


%hook MPHCZAlbumTableViewController

- (id)_createTableViewBackgroundView {
	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleForWhiteness graphicsQuality:kBackdropGraphicQualitySystemDefault];
	
	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
	//backdropView.tag = 0xc001;
	
	//[colorHelper addBlurView:backdropView];
	
	return [backdropView autorelease];
}

%end



#pragma mark -
#pragma mark NowPlaying


BOOL isEnabledRedrawControls(UIView *self) {
	if ([self.superview isKindOfClass:%c(MusicNowPlayingPlaybackControlsView)]) {
		if (EnableNowPlayingBlurring) return NO;
		
		return YES;
	}
	else if (isPad) return YES;
	
	return NO;
}


%hook MusicNowPlayingPlaybackControlsView

- (void)layoutSubviews {
	%orig;
	
	if (EnableNowPlayingBlurring) return;
	
	MusicNowPlayingTransportControls *_transportControls = MSHookIvar<MusicNowPlayingTransportControls *>(self, "_transportControls");
	UIButton *_playButton = MSHookIvar<UIButton *>(_transportControls, "_playButton");
	UIButton *_previousButton = MSHookIvar<UIButton *>(_transportControls, "_previousButton");
	UIButton *_nextButton = MSHookIvar<UIButton *>(_transportControls, "_nextButton");
	
	_playButton.tintColor = useBlendedMode ? blendColor() : TINT_COLOR;
	_previousButton.tintColor = useBlendedMode ? blendColor() : TINT_COLOR;
	_nextButton.tintColor = useBlendedMode ? blendColor() : TINT_COLOR;
	
	if (useBlendedMode) {
		UIButton *_shuffleButton = MSHookIvar<UIButton *>(self, "_shuffleButton");
		UIButton *_repeatButton = MSHookIvar<UIButton *>(self, "_repeatButton");
		UIButton *_createButton = MSHookIvar<UIButton *>(self, "_createButton");
		
		[_shuffleButton setTitleColor:blendColor() forState:UIControlStateNormal];
		[_repeatButton setTitleColor:blendColor() forState:UIControlStateNormal];
		[_createButton setTitleColor:blendColor() forState:UIControlStateNormal];
		
		blendView(self);
	}
}

%end


%hook MusicNowPlayingVolumeSlider

- (void)_updateTrackTintForVolumeControlAvailability {
	if (!isEnabledRedrawControls(self)) {
		%orig;
		return;
	}
	
	@autoreleasepool {
		UIColor *&_maximumTintUsedForTrackImageColor = MSHookIvar<UIColor *>(self, "_maximumTintUsedForTrackImageColor");
		UIColor *&_minimumTintUsedForTrackImageColor = MSHookIvar<UIColor *>(self, "_minimumTintUsedForTrackImageColor");
		
		UIColor *maxColor = useBlendedMode ? blendColor() : TINT_COLOR_WITH_ALPHA(0.1*TINT_FRACTION);
		UIColor *minColor = useBlendedMode ? blendColor() : TINT_COLOR;
		
		if (![_maximumTintUsedForTrackImageColor isEqual:maxColor]) {
			UIImage *image = [self _trackImageWithTintColor:maxColor];
			[self setMaximumTrackImage:image forState:UIControlStateNormal];
			[_maximumTintUsedForTrackImageColor release];
			_maximumTintUsedForTrackImageColor = [maxColor retain];
		}
		
		if (![_minimumTintUsedForTrackImageColor isEqual:minColor]) {
			UIImage *image = [self _trackImageWithTintColor:minColor];
			[self setMinimumTrackImage:image forState:UIControlStateNormal];
			[_minimumTintUsedForTrackImageColor release];
			_minimumTintUsedForTrackImageColor = [minColor retain];
		}
	}
}

- (void)didMoveToSuperview {
	%orig;
	
	[self _updateTrackTintForVolumeControlAvailability];
	
	@autoreleasepool {
		if (isEnabledRedrawControls(self)) {
			UIImage *thumbImage = [[self _thumbImageForStyle:self.style] _flatImageWithColor:useBlendedMode ? blendColor() : TINT_COLOR];
			[self setThumbImage:thumbImage forState:UIControlStateNormal];
			
			UIImage *maxValueImage = [UIImage imageNamed:@"volume-maximum-value-image" inBundle:[NSBundle musicUIBundle]];
			maxValueImage = [maxValueImage _flatImageWithColor:useBlendedMode ? blendColor() : [colorHelper systemGrayColor]];
			[self setMaximumValueImage:maxValueImage];
			
			UIImage *minValueImage = [UIImage imageNamed:@"volume-minimum-value-image" inBundle:[NSBundle musicUIBundle]];
			minValueImage = [minValueImage _flatImageWithColor:useBlendedMode ? blendColor() : [colorHelper systemGrayColor]];
			[self setMinimumValueImage:minValueImage];
		}
	}
}

- (void)layoutSubviews {
	%orig;
	
	if (!isEnabledRedrawControls(self)) return;
	
	@autoreleasepool {
		UIImageView *_maxTrackView = MSHookIvar<UIImageView *>(self, "_maxTrackView");
		_maxTrackView.alpha = useBlendedMode ? 0.4f : 1.0f;
		
		UIImageView *_minTrackView = MSHookIvar<UIImageView *>(self, "_minTrackView");
		_minTrackView.alpha = useBlendedMode ? 1.0f : 0.4f;
		
		if (useBlendedMode) {
			blendView(self);
		}
	}
}

%end


%hook MPDetailSlider

- (void)_updateTimeDisplayForTime:(NSTimeInterval)time {
	%orig;
	
	if (!isEnabledRedrawControls(self)) return;
	
	if (useBlendedMode) {
		UILabel *_currentTimeLabel = MSHookIvar<UILabel *>(self, "_currentTimeLabel");
		UILabel *_currentTimeInverseLabel = MSHookIvar<UILabel *>(self, "_currentTimeInverseLabel");
		
		blendView(_currentTimeLabel);
		blendView(_currentTimeInverseLabel);
	}
}

- (void)layoutSubviews {
	%orig;
	
	if (isEnabledRedrawControls(self)) {
		UIImageView *_minTrackView = MSHookIvar<UIImageView *>(self, "_minTrackView");
		_minTrackView.alpha = 0.3f * TINT_FRACTION;
		
		UIImageView *_maxTrackView = MSHookIvar<UIImageView *>(self, "_maxTrackView");
		_maxTrackView.alpha = 1.0f;
		
		if (useBlendedMode) {
			_minTrackView.alpha = 1.0f;
			_maxTrackView.alpha = 0.4f;
			
			blendView(self);
		}
	}
}

- (id)_colorSliceImageWithColor:(UIColor *)color height:(CGFloat)height {
	if (isEnabledRedrawControls(self)) {
		UIImage *image = %orig([colorHelper whiteColor], height);
		return [image _flatImageWithColor:TINT_COLOR];
	}
	
	return %orig;
}

- (void)setMaximumTrackImage:(UIImage *)image forState:(UIControlState)state {
	if (isEnabledRedrawControls(self)) {
		image = [image _flatImageWithColor:useBlendedMode ? blendColor() : TINT_COLOR_WITH_ALPHA(0.1f*TINT_FRACTION)];
	}
	
	%orig;
}
- (void)setMinimumTrackImage:(UIImage *)image forState:(UIControlState)state {
	if (isEnabledRedrawControls(self)) {
		image = [image _flatImageWithColor:useBlendedMode ? blendColor() : TINT_COLOR];
	}
	
	%orig;
}

- (id)thumbImageForState:(UIControlState)state {
	UIImage *image = %orig;
	
	if (isEnabledRedrawControls(self) && useBlendedMode) {
		return [image _flatImageWithColor:blendColor()];
	}
	
	return image;
}

%end


%hook MPURatingControl

+ (id)ratingDotImage {
	UIImage *image = %orig;
	
	if (!EnableNowPlayingBlurring)
		image = [image _flatImageWithColor:useBlendedMode ? blendColor() : TINT_COLOR];
	
	return image;
}

+ (id)ratingStarImage {
	UIImage *image = %orig;
	
	if (!EnableNowPlayingBlurring)
		image = [image _flatImageWithColor:useBlendedMode ? blendColor() : TINT_COLOR];
	
	return image;
}

%end


%hook MusicNowPlayingViewController

%new
- (void)__glareapps_updateNavigationBar {
	if (EnableNowPlayingBlurring) return;
	
	UINavigationBar *navBar = getCurrentNavigationController().navigationBar;
	
	if (isPad) {
		navBar = MSHookIvar<UINavigationBar *>(self, "_padFakeNavigationBar");
	}
	
	if (useMusicAppAlbumArtBackdrop) {
		UIView *_contentView = MSHookIvar<UIView *>(self, "_contentView");
		_contentView.hidden = !showMusicAppAlbumArt;
	}
	
	if (useBlendedMode && useMusicAppAlbumArtBackdrop) {
		navBar._backgroundView.alpha = 0.0f;
	}
	else {
		clearBar(navBar);
		
		UILabel *_titleView = [navBar valueForKey:@"_titleView"];
		if ([_titleView respondsToSelector:@selector(text)]) {
			_titleView.textColor = TINT_COLOR;
		}
	}
}

- (void)viewDidLayoutSubviews {
	%orig;
	
	if (EnableNowPlayingBlurring) return;
	
	[self performSelector:@selector(__glareapps_updateNavigationBar)];
	
	MusicNowPlayingTitlesView *_titlesView = MSHookIvar<MusicNowPlayingTitlesView *>(self, "_titlesView");
	_titlesView._titleLabel.textColor = TINT_COLOR;
	_titlesView._detailLabel.textColor = TINT_COLOR_WITH_ALPHA(0.6);
	
	if (useBlendedMode) {
		blendView(_titlesView._titleLabel);
		blendView(_titlesView._detailLabel);
		
		MPURatingControl *_ratingControl = MSHookIvar<MPURatingControl *>(self, "_ratingControl");
		blendView(_ratingControl);
	}
}

- (void)_updateForCurrentItemAnimated:(BOOL)animated {
	%orig;
	
	if (EnableNowPlayingBlurring) return;
	
	if (!useMusicAppAlbumArtBackdrop) return;
	if (backgroundImageView.alpha != 0.0f) return;
	
	UIImageView *_contentView = MSHookIvar<UIImageView *>(self, "_contentView");
	if (![_contentView respondsToSelector:@selector(image)]) return;
	
	MPAVItem *_item = MSHookIvar<MPAVItem *>(self, "_item");
	
	UIImage *albumArt = [backgroundImageView _getImageFromMPAVItem:_item];
	
	if (albumArt == nil)
		albumArt = _contentView.image;
	
	backgroundImageView.latestOrientation = [[UIDevice currentDevice] orientation];
	[backgroundImageView updateBackgroundImage:albumArt animated:NO];
	
	backgroundImageView.alpha = 1.0f;
}

- (void)viewDidAppear:(BOOL)animated {
	%orig;
	
	if (EnableNowPlayingBlurring) return;
	
	if (useMusicAppAlbumArtBackdrop)
		backgroundImageView.alpha = 1.0f;
}

- (void)_updateNavigationItemAnimated:(BOOL)animated {
	%orig;
	
	if (EnableNowPlayingBlurring) return;
	
	if (animated)
		[self performSelector:@selector(__glareapps_updateNavigationBar)];
}

%end




#pragma mark -
#pragma mark RadioUI


// RUStationActionsViewController, RUStationActionTableViewCell, RUStationTuningView
@interface RUStationActionTableViewCell : UITableViewCell @end

@interface RUStationTuningSlider : UISlider @end

@interface RUStationTuningView : UIView {
	RUStationTuningSlider *_tuningSlider;
	UIImageView *_tuningSliderMaskView;
	UILabel *_tuningType1Label;
	UILabel *_tuningType2Label;
	UILabel *_tuningType3Label;
}
@end

@interface RUTableSectionHeaderView : UITableViewHeaderFooterView {
	_UIBackdropView *_backdropView;
	UILabel *_titleLabel;
}
@property(nonatomic, copy) NSAttributedString *attributedTitle;
@end

@interface RUStationTreeTableHeaderView : UITableViewHeaderFooterView {
	UILabel *_titleLabel;
}
@end

@interface RUStationActionsViewController : UIViewController @end

@interface RUWelcomeViewController : UIViewController @end


%hook RUStationActionTableViewCell

- (void)layoutSubviews {
	%orig;
	
	self.textLabel.textColor = [colorHelper commonTextColor];
	self.detailTextLabel.textColor = [colorHelper systemGrayColor];
}

%end


%hook RUStationTuningView

- (void)layoutSubviews {
	%orig;
	
	RUStationTuningSlider *_tuningSlider = MSHookIvar<RUStationTuningSlider *>(self, "_tuningSlider");
	UILabel *_tuningType1Label = MSHookIvar<UILabel *>(self, "_tuningType1Label");
	UILabel *_tuningType2Label = MSHookIvar<UILabel *>(self, "_tuningType2Label");
	UILabel *_tuningType3Label = MSHookIvar<UILabel *>(self, "_tuningType3Label");
	
	UIColor *tintColor = [colorHelper systemGrayColor];
	
	if (![_tuningSlider.maximumTrackTintColor isEqual:_tuningSlider.minimumTrackTintColor])
		[_tuningSlider setMaximumTrackTintColor:tintColor];
	
	for (UILabel *label in _tuningSlider.subviews) {
		if ([label isKindOfClass:[UILabel class]])
			label.textColor = tintColor;
	}
	
	_tuningType1Label.textColor = tintColor;
	_tuningType2Label.textColor = tintColor;
	_tuningType3Label.textColor = tintColor;
}

%end


%hook RUTableSectionHeaderView

- (void)setAttributedTitle:(NSAttributedString *)text {
	%orig(colorReplacedAttributedString(text));
}

- (void)layoutSubviews {
	%orig;
	
	UILabel *_titleLabel = MSHookIvar<UILabel *>(self, "_titleLabel");
	_titleLabel.textColor = [colorHelper commonTextColor];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	id rtn = %orig;
	
	if (rtn) {
		_UIBackdropView *_backdropView = MSHookIvar<_UIBackdropView *>(self, "_backdropView");
		
		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleSystemDefaultSemiLight];
		settings.grayscaleTintLevel = (isWhiteness ? 1.0f : 0.0f);
		
		[_backdropView transitionToSettings:settings];
	}
	
	return rtn;
}

%end


%hook RUStationTreeTableHeaderView

- (void)layoutSubviews {
	%orig;
	
	UILabel *_titleLabel = MSHookIvar<UILabel *>(self, "_titleLabel");
	_titleLabel.textColor = [colorHelper commonTextColor];
}

%end


%hook RUStationActionsViewController

- (void)viewDidLayoutSubviews {
	%orig;
	
	UILabel *_copyrightLabel = MSHookIvar<UILabel *>(self, "_copyrightLabel");
	_copyrightLabel.textColor = [colorHelper systemGrayColor];
}

%end


%hook MusicRadioViewController

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
	void (^fp)(void) = ^{
		if (completion) completion();
		
		UIView *_snapshotView = MSHookIvar<UIView *>(self, "_snapshotView");
		_snapshotView.hidden = YES;
		
		UIScrollView *_scrollView = MSHookIvar<UIScrollView *>(self, "_scrollView");
		_scrollView.hidden = NO;
	};
	
	%orig(viewControllerToPresent, flag, fp);
	
	UIView *_snapshotView = MSHookIvar<UIView *>(self, "_snapshotView");
	_snapshotView.hidden = YES;
	
	UIScrollView *_scrollView = MSHookIvar<UIScrollView *>(self, "_scrollView");
	_scrollView.hidden = NO;
}

%end


%hook RUWelcomeViewController

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	
	_UIBackdropView *backdropView = (_UIBackdropView *)[self.view viewWithTag:0xc001];
	[backdropView retain];
	
	if (backdropView == nil) {
		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleForWhiteness graphicsQuality:kBackdropGraphicQualitySystemDefault];
		
		backdropView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
		backdropView.tag = 0xc001;
		
		[self.view insertSubview:backdropView atIndex:0];
	}
	
	[backdropView release];
}

%end




void loadMusicSettings() {
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/me.devbug.BlurredMusicApp.plist"];
	
	EnableNowPlayingBlurring = [dict[@"EnableNowPlayingBlurring"] boolValue];
	if (dict[@"EnableNowPlayingBlurring"] == nil)
		EnableNowPlayingBlurring = YES;
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/BlurredMusicApp.dylib"]) {
		EnableNowPlayingBlurring = NO;
	}
}

static void reloadMusicPrefsNotification(CFNotificationCenterRef center,
										void *observer,
										CFStringRef name,
										const void *object,
										CFDictionaryRef userInfo) {
	loadMusicSettings();
}




#pragma mark -
#pragma mark NowPlaying Album art Backdrop


%hook UIApplication

- (void)__glareapps_applicationDidFinishLaunching {
	%orig;
	
	UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
	keyWindow.layer.allowsGroupBlending = NO;
	keyWindow.layer.allowsGroupOpacity = NO;
	
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	if (!UIDeviceOrientationIsValidInterfaceOrientation(orientation))
		orientation = UIDeviceOrientationPortrait;
	
	CGRect frame = [UIScreen mainScreen].bounds;
	CGFloat minValue = MIN(frame.size.width, frame.size.height);
	CGFloat maxValue = MAX(frame.size.width, frame.size.height);
	
	if (UIDeviceOrientationIsPortrait(orientation)) {
		frame.size.width = minValue;
		frame.size.height = maxValue;
	}
	else {
		frame.size.width = maxValue;
		frame.size.height = minValue;
	}
	
	backgroundImageView.frame = frame;
	backgroundImageView.latestOrientation = orientation;
	
	[keyWindow.subviews[0] insertSubview:backgroundImageView atIndex:0];
	backgroundImageView.alpha = 0.0f;
	
	if (isPad) {
		[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(__glareapps_didRotate:)
													 name:@"UIDeviceOrientationDidChangeNotification" 
												   object:nil];
	}
}

%new
- (void)__glareapps_didRotate:(NSNotification *)notification {
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	if (UIDeviceOrientationIsValidInterfaceOrientation(orientation)) {
		CGRect frame = [UIScreen mainScreen].bounds;
		CGFloat minValue = MIN(frame.size.width, frame.size.height);
		CGFloat maxValue = MAX(frame.size.width, frame.size.height);
		
		if (UIDeviceOrientationIsPortrait(orientation)) {
			frame.size.width = minValue;
			frame.size.height = maxValue;
		}
		else {
			frame.size.width = maxValue;
			frame.size.height = minValue;
		}
		
		backgroundImageView.frame = frame;
		[backgroundImageView updateBackgroundViewForOrientation:orientation];
	}
}

%end


@interface MusicNowPlayingObserver (GlareApps)
- (void)__glareapps_setNowPlayingAlbumArtAnimated:(BOOL)animated;
@end

%hook MusicNowPlayingObserver

%new
- (void)__glareapps_setNowPlayingAlbumArtAnimated:(BOOL)animated {
	MusicAVPlayer *avPlayer = [%c(MusicAVPlayer) sharedAVPlayer];
	
	backgroundImageView.latestOrientation = [[UIDevice currentDevice] orientation];
	[backgroundImageView updateBackgroundImage:[backgroundImageView _getImageFromMPAVItem:avPlayer.currentItem] animated:animated];
	
	UINavigationController *nvc = getCurrentNavigationController();
	
	if ([nvc.topViewController isKindOfClass:%c(MusicNowPlayingViewController)]) {
		backgroundImageView.alpha = 1.0f;
	}
	else {
		backgroundImageView.alpha = avPlayer.currentItem && avPlayer.isPlaying ? 1.0f : 0.0f;
	}
}

- (void)_playbackStateDidChangeNotification:(id)notification {
	%orig;
	
	[self __glareapps_setNowPlayingAlbumArtAnimated:YES];
}

- (void)_itemDidChangeNotification:(id)notification {
	%orig;
	
	[self __glareapps_setNowPlayingAlbumArtAnimated:YES];
}

- (void)_mediaArtworkDidLoadNotification:(id)notification {
	%orig;
	
	[self __glareapps_setNowPlayingAlbumArtAnimated:NO];
}

- (void)_radioArtworkDidLoadNotification:(id)notification {
	%orig;
	
	[self __glareapps_setNowPlayingAlbumArtAnimated:NO];
}

%end




%ctor {
	if (!isThisAppEnabled()) return;
	
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.Music"]) {
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &reloadMusicPrefsNotification, CFSTR("me.devbug.BlurredMusicApp.prefnoti"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		loadMusicSettings();
		
		if (useMusicAppAlbumArtBackdrop) {
			backgroundImageView = [[GlareAppsBlurredBackgroundImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
			backgroundImageView.style = kBackdropStyleForWhiteness;
			backgroundImageView.isFlickerTransition = NO;
			backgroundImageView.blurRadius = musicAppAlbumArtBackdropBlurRadius;
			backgroundImageView.graphicQuality = kBackdropGraphicQualityForceOn;
			[backgroundImageView setParallaxEnabled:NO];
			[backgroundImageView reconfigureBackdropFromCurrentSettings];
		}
		
		%init;
		
		if (isFirmware71)
			%init(Firmware71_MusicTableSectionHeaderView_Background);
		else if (isFirmware70)
			%init(Firmware70_MusicTableSectionHeaderView_Background);
	}
}
