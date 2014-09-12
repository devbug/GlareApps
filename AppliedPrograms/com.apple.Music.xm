
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



@interface MPVolumeSlider : UISlider @end

@interface MPDetailSlider : UISlider {
	UILabel *_currentTimeInverseLabel;
	UILabel *_currentTimeLabel;
}
- (struct CGRect)thumbViewRect;
@end

@interface MPButton : UIButton @end

@interface MPTransportControls : UIView {
	MPButton *_alternatesButton;
	MPButton *_bookmarkButton;
	MPButton *_chaptersButton;
	MPButton *_devicePickerButton;
	MPButton *_emailButton;
	MPButton *_fastForward15SecondsButton;
	MPButton *_likeOrBanButton;
	MPButton *_nextButton;
	MPButton *_playButton;
	MPButton *_previousButton;
	MPButton *_rewind15SecondsButton;
	MPButton *_rewind30SecondsButton;
	MPButton *_scaleButton;
	MPButton *_toggleFullscreenButton;
}
@end

@interface MusicNowPlayingTransportControls : MPTransportControls @end
@interface MPPlaybackControlsView : UIView {
	MPButton *_fastFowardButton;
	MPButton *_geniusButton;
	MPButton *_mailButton;
	MPButton *_playbackSpeedButton;
	MPDetailSlider *_progressControl;
	MPButton *_radioButton;
	MPButton *_radioHistoryButton;
	MPButton *_radioShareButton;
	MPButton *_trackInfoButton;
	MPButton *_repeatButton;
	MPButton *_rewindButton;
	UIView *_rewindButtonBezel;
	MPButton *_shuffleButton;
	UILabel *_trackInfoLabel;
}
@property(readonly, nonatomic) UIImage *shuffleButtonImage;
@property(readonly, nonatomic) UIImage *repeatButtonImage;
@property(readonly, nonatomic) UIImage *mailButtonImage;
@end
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

@interface _MPUMarqueeContentView : UIView @end
@interface MPUMarqueeView : UIView
@property(readonly, nonatomic) UIView *contentView;
@property(nonatomic) CGSize contentSize;
@property(nonatomic) CGFloat contentGap;
@end
@interface MPUNowPlayingTitlesView : UIView {
	UILabel *_detailLabel;
	MPUMarqueeView *_detailMarqueeView;
	UILabel *_titleLabel;
	MPUMarqueeView *_titleMarqueeView;
}
- (void)_updateAttributedTitleLabel;
- (UILabel *)_detailLabel;
- (UILabel *)_titleLabel;
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

@interface MusicMiniPlayerTransportControls : MPTransportControls @end


#define TINT_COLOR							[colorHelper commonTextColor]
#define TINT_COLOR_WITH_ALPHA(a)			[colorHelper commonTextColorWithAlpha:a]
#define TINT_FRACTION						(isWhiteness ? 1.5f : 1.0f)


BOOL EnableNowPlayingBlurring				= YES;




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
	if (EnableNowPlayingBlurring && [self isKindOfClass:%c(MusicNowPlayingViewController)]) {
		temporaryUnlockStatusBarForegroundColorSetting = YES;
	}
	
	[UIApplication sharedApplication].statusBar.foregroundColor = [colorHelper commonTextColor];
	
	%orig;
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


%hook MAAppDelegate

%new
- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration {
	[[UIApplication sharedApplication] keyWindow].backgroundColor = [colorHelper keyWindowBackgroundColor];
}

%new
- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
	[[UIApplication sharedApplication] keyWindow].backgroundColor = nil;
}

%end


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


%hook MPUBackdropContentViewController

- (void)viewDidLoad {
	%orig;
	
	if (isFirmware71) {
		_UIBackdropView *_backdropView = MSHookIvar<_UIBackdropView *>(self, "_backdropView");
		
		if (_backdropView.style != kBackdropStyleForWhiteness)
			[_backdropView transitionToStyle:kBackdropStyleForWhiteness];
	}
}

%end


%hook MusicFlipsideTracksViewController

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	
	if (!isFirmware71) {
		UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
		
		for (UIView *v in keyWindow.subviews) {
			if ([v isKindOfClass:%c(UITransitionView)]) {
				for (UIView *v2 in v.subviews) {
					if ([v2 isKindOfClass:%c(_UIBackdropView)]) {
						_UIBackdropView *backdropView = (_UIBackdropView *)v2;
						
						if (backdropView.style != kBackdropStyleForWhiteness)
							[backdropView transitionToStyle:kBackdropStyleForWhiteness];
					}
				}
				
				break;
			}
		}
	}
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
	
	if (!isFirmware71)
		self.artistLabel.textColor = [colorHelper musicTableViewCellTextColor];
}
- (void)setAlbum:(NSString *)album {
	%orig;
	
	self.albumLabel.textColor = [colorHelper systemGrayColor];
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
	
	_playButton.tintColor = TINT_COLOR;
	_previousButton.tintColor = TINT_COLOR;
	_nextButton.tintColor = TINT_COLOR;
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
	
	_playButton.tintColor = TINT_COLOR;
	_previousButton.tintColor = TINT_COLOR;
	_nextButton.tintColor = TINT_COLOR;
}

%end


%hook MusicNowPlayingVolumeSlider

- (void)layoutSubviews {
	%orig;
	
	if (!isEnabledRedrawControls(self)) return;
	
	UIImageView *valueImageView = MSHookIvar<UIImageView *>(self, "_maxValueImageView");
	valueImageView.image = [valueImageView.image _flatImageWithColor:TINT_COLOR];
	
	valueImageView = MSHookIvar<UIImageView *>(self, "_minValueImageView");
	valueImageView.image = [valueImageView.image _flatImageWithColor:TINT_COLOR];
	
	UIImageView *_maxTrackView = MSHookIvar<UIImageView *>(self, "_maxTrackView");
	_maxTrackView.alpha = 1.0f;
	
	UIImageView *_minTrackView = MSHookIvar<UIImageView *>(self, "_minTrackView");
	_minTrackView.alpha = 0.4f;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		self.minimumTrackTintColor = TINT_COLOR;
	}
}

- (id)maximumTrackImageForState:(UIControlState)state {
	if (!EnableNowPlayingBlurring && ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) || [self.superview isKindOfClass:%c(MusicNowPlayingPlaybackControlsView)])) {
		return [self _trackImageWithTintColor:TINT_COLOR_WITH_ALPHA(0.1*TINT_FRACTION)];
	}
	else if (isPad && ![self.superview isKindOfClass:%c(MusicNowPlayingPlaybackControlsView)]) {
		return [self _trackImageWithTintColor:TINT_COLOR_WITH_ALPHA(0.1*TINT_FRACTION)];
	}
	
	return %orig;
}

- (id)minimumTrackImageForState:(UIControlState)state {
	if (!EnableNowPlayingBlurring && ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) || [self.superview isKindOfClass:%c(MusicNowPlayingPlaybackControlsView)])) {
		return [self _trackImageWithTintColor:TINT_COLOR];
	}
	else if (isPad && ![self.superview isKindOfClass:%c(MusicNowPlayingPlaybackControlsView)]) {
		return [self _trackImageWithTintColor:TINT_COLOR];
	}
	
	return %orig;
}

- (id)thumbImageForState:(UIControlState)state {
	UIImage *image = %orig;
	
	if (!EnableNowPlayingBlurring && ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) || [self.superview isKindOfClass:%c(MusicNowPlayingPlaybackControlsView)])) {
		return [image _flatImageWithColor:TINT_COLOR];
	}
	else if (isPad && ![self.superview isKindOfClass:%c(MusicNowPlayingPlaybackControlsView)]) {
		return [image _flatImageWithColor:TINT_COLOR];
	}
	
	return image;
}

%end


%hook MPDetailSlider

- (void)layoutSubviews {
	%orig;
	
	if (isEnabledRedrawControls(self)) {
		UIImageView *_minTrackView = MSHookIvar<UIImageView *>(self, "_minTrackView");
		_minTrackView.alpha = 0.3f * TINT_FRACTION;
		
		UIImageView *_maxTrackView = MSHookIvar<UIImageView *>(self, "_maxTrackView");
		_maxTrackView.alpha = 1.0f;
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
		image = [image _flatImageWithColor:TINT_COLOR_WITH_ALPHA(0.1f*TINT_FRACTION)];
	}
	
	%orig;
}
- (void)setMinimumTrackImage:(UIImage *)image forState:(UIControlState)state {
	if (isEnabledRedrawControls(self)) {
		image = [image _flatImageWithColor:TINT_COLOR];
	}
	
	%orig;
}

%end


%hook MPURatingControl

+ (id)ratingStarImage {
	UIImage *image = %orig;
	
	if (!EnableNowPlayingBlurring)
		image = [image _flatImageWithColor:TINT_COLOR];
	
	return image;
}

%end


%hook MusicNowPlayingViewController

- (void)viewDidLayoutSubviews {
	%orig;
	
	if (EnableNowPlayingBlurring) return;
	
	UINavigationBar *navBar = self.navigationController.navigationBar;
	if (!navBar) {
		MAAppDelegate *delegate = (MAAppDelegate *)[[UIApplication sharedApplication] delegate];
		navBar = [[delegate radioNavigationController] navigationBar];
		
		if (!navBar) {
			navBar = [[[delegate tabBarController] moreNavigationController] navigationBar];
		}
	}
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		navBar = MSHookIvar<UINavigationBar *>(self, "_padFakeNavigationBar");
	}
	
	clearBar(navBar);
	
	UILabel *_titleView = [navBar valueForKey:@"_titleView"];
	if ([_titleView respondsToSelector:@selector(text)]) {
		_titleView.textColor = TINT_COLOR;
	}
	
	MusicNowPlayingTitlesView *_titlesView = MSHookIvar<MusicNowPlayingTitlesView *>(self, "_titlesView");
	_titlesView._titleLabel.textColor = TINT_COLOR;
	_titlesView._detailLabel.textColor = TINT_COLOR_WITH_ALPHA(0.6);
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
}

static void reloadMusicPrefsNotification(CFNotificationCenterRef center,
										void *observer,
										CFStringRef name,
										const void *object,
										CFDictionaryRef userInfo) {
	loadMusicSettings();
}




%ctor {
	if (!isThisAppEnabled()) return;
	
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.Music"]) {
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &reloadMusicPrefsNotification, CFSTR("me.devbug.BlurredMusicApp.prefnoti"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		loadMusicSettings();
		
		%init;
		
		if (isFirmware71)
			%init(Firmware71_MusicTableSectionHeaderView_Background);
		else if (isFirmware70)
			%init(Firmware70_MusicTableSectionHeaderView_Background);
	}
}
