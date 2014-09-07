
#import "headers.h"




@interface PUAlbumListCellContentView : UIView
@property(retain, nonatomic, setter=_setDeleteButton:) UIButton *_deleteButton;
@property(retain, nonatomic, setter=_setSubtitleLabel:) UILabel *_subtitleLabel;
@property(retain, nonatomic, setter=_setTitleTextField:) UITextField *_titleTextField;
@end

@interface PUFeedCell : UICollectionViewCell @end
@interface PUFeedTextCell : PUFeedCell
@property(retain, nonatomic, setter=_setButton:) UIButton *_button;
@property(retain, nonatomic, setter=_setIconImageView:) UIImageView *_iconImageView;
@property(retain, nonatomic, setter=_setDetailLabel:) UILabel *_detailLabel;
@property(retain, nonatomic, setter=_setLabel:) UILabel *_label;
@end

@interface PUPhotoBrowserController : UIViewController @end

@interface PUPhotosSectionHeaderView : UIView @end

@interface PUPhotoStreamComposeServiceViewController : UIViewController
@property(readonly) UIView *sheetView;
@end

@interface PUCollectionView : UICollectionView @end

@interface PUPhotoStreamCreateTitleViewController : UIViewController @end

@interface PUPhotosSinglePickerViewController : UIViewController @end

@interface PUPhotosPickerViewController : UIViewController @end

@interface PUAbstractNavigationBanner : NSObject
@property(readonly, nonatomic) UIView *view;
@end
@interface PUPickerBannerView : UIView @end
@interface PUPickerBanner : PUAbstractNavigationBanner
@property(readonly, nonatomic) PUPickerBannerView *bannerView;
- (id)view;
@end
@interface PUAbstractAlbumListViewController : UIViewController
- (PUPickerBannerView *)_pickerBannerView;
@end
@interface PUAlbumListTableViewController : PUAbstractAlbumListViewController @end

@interface _UINavigationPaletteBackground : UIView {
	_UIBackdropView *_adaptiveBackdrop;
}
@property(nonatomic) BOOL paletteWantsAdaptiveBackdrop;
@property(nonatomic, getter=isTranslucent) BOOL translucent;
@property(nonatomic) UIBarStyle barStyle;
@property(retain, nonatomic) UIColor *barTintColor;
- (void)_syncWithBarStyles;
@end
@interface _UINavigationControllerPalette : UIView
@property(retain, nonatomic, setter=_setBackgroundView:) _UINavigationPaletteBackground *_backgroundView;
@end
@interface UINavigationItem (PUAbstractNavigationBanner)
@property(retain, nonatomic, setter=pu_setBanner:) PUAbstractNavigationBanner *pu_banner;
@end

@interface PLPhotoCommentEntryView : UIView
@property(readonly, nonatomic) UITextView *textView;
@property(readonly, nonatomic) UILabel *placeholderLabel;
@end

@interface PUViewControllerTransition : NSObject
- (id)containerView;
- (UIViewController *)toViewController;
- (UIViewController *)fromViewController;
- (id)transitionContext;
- (id)interactiveTransition;
@end
@interface PUNavigationTransition : PUViewControllerTransition @end
@interface PUPhotoBrowserZoomTransition : PUNavigationTransition @end




%hook PLPhotosApplication

%new
- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration {
	[[UIApplication sharedApplication] keyWindow].backgroundColor = [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:0.2f];
}

%new
- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
	[[UIApplication sharedApplication] keyWindow].backgroundColor = nil;
}

%end


%hook UILabel

- (BOOL)__glareapps_isActionSheetOrActivityGroup {
	BOOL isActionSheetOrActivityGroup = %orig;
	
	if (isActionSheetOrActivityGroup)
		return isActionSheetOrActivityGroup;
	
	NSString *superviewName = NSStringFromClass([self.superview class]);
	NSString *supersuperviewName = NSStringFromClass([self.superview.superview class]);
	
	isActionSheetOrActivityGroup = [superviewName hasPrefix:@"PUActionSheet"];
	if (!isActionSheetOrActivityGroup && [superviewName hasPrefix:@"UIAlert"]) {
		isActionSheetOrActivityGroup = [supersuperviewName hasPrefix:@"PUActionSheet"];
	}
	
	return isActionSheetOrActivityGroup;
}

%end


%hook PUFlatWhiteInterfaceTheme

- (UIKeyboardAppearance)defaultKeyboardAppearance {
	return (isWhiteness ? UIKeyboardAppearanceLight : UIKeyboardAppearanceDark);
}

- (NSInteger)topLevelStatusBarStyle {
	return kBarStyleForWhiteness;
}

// < 7.1
- (NSInteger)topLevelNavigationBarStyle {
	return kBarStyleForWhiteness;
}

- (NSInteger)photoCollectionToolbarStyle {
	return kBarStyleForWhiteness;
}

- (UIColor *)photoCollectionViewBackgroundColor {
	return [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kTransparentAlphaFactor];
}

- (UIColor *)emptyPlaceholderViewBackgroundColor {
	return [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kTransparentAlphaFactor];
}

- (UIColor *)albumListBackgroundColor {
	return [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kTransparentAlphaFactor];
}

- (UIColor *)cloudFeedBackgroundColor {
	return [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kTransparentAlphaFactor];
}

// >= 7.1
- (void)configureAlbumListSubtitleLabel:(id)control asOpaque:(BOOL)opaque {
	%orig(control, NO);
}
- (void)configureAlbumListTitleTextField:(id)control asOpaque:(BOOL)opaque {
	%orig(control, NO);
}
- (void)configureAlbumListTitleLabel:(id)control asOpaque:(BOOL)opaque {
	%orig(control, NO);
}

%end


%hook PUAlbumListCellContentView

- (void)layoutSubviews {
	%orig;
	
	self._titleTextField.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:1.0f];
}

%end


%hook PUFeedTextCell

- (void)layoutSubviews {
	%orig;
	
	self._label.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:1.0f];
	self._detailLabel.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:1.0f];
}

%end


%hook PUPhotoBrowserController

- (void)_setOverlaysVisible:(BOOL)visible animated:(BOOL)animated updateBarsVisibility:(BOOL)updateBars {
	%orig;
	
	if (isFirmware71 && updateBars) {
		UINavigationBar *navBar = self.navigationController.navigationBar;
		
		_UIBackdropView *_adaptiveBackdrop = navBar._backgroundView._adaptiveBackdrop;
		
		if (_adaptiveBackdrop.style != kBackdropStyleForWhiteness && _adaptiveBackdrop.style != kBackdropStyleSystemDefaultDark)
			[_adaptiveBackdrop transitionToStyle:kBackdropStyleForWhiteness];
	}
}

%end


%hook PUTabbedLibraryViewController

- (void)_showBarWithTransition:(NSInteger)transition isExplicit:(BOOL)isExplicit {
	if (isFirmware71)
		%orig(7, YES);
	else
		%orig;
}
- (void)_hideBarWithTransition:(NSInteger)transition isExplicit:(BOOL)isExplicit {
	if (isFirmware71)
		%orig(0, YES);
	else
		%orig;
}

%end


%hook PUPhotosSectionHeaderView

- (void)_updateBackground {
	%orig;
	
	self.backgroundColor = [UIColor clearColor];
	
	_UIBackdropView *_backdropView = MSHookIvar<_UIBackdropView *>(self, "_backdropView");
	
	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleSystemDefaultSemiLight];
	settings.grayscaleTintLevel = (isWhiteness ? 1.0f : 0.0f);
	
	if (_backdropView.style != kBackdropStyleSystemDefaultSemiLight)
		[_backdropView transitionToSettings:settings];
}

%end


%hook PUPhotoStreamComposeServiceViewController

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	
	if (self.sheetView && self.sheetView.subviews.count > 1) {
		_UIBackdropView *backdropView = (_UIBackdropView *)self.sheetView.subviews[0];
		
		if ([backdropView isKindOfClass:[_UIBackdropView class]]) {
			NSInteger style = (isWhiteness ? kBackdropStyleSystemDefaultUltraLight : kBackdropStyleSystemDefaultDark);
			if (backdropView.style != style)
				[backdropView transitionToStyle:style];
		}
	}
}

%end


%hook PUPhotoStreamCreateTitleViewController

- (void)viewDidAppear:(BOOL)animated {
	%orig;
	
	UITextView *_textView = MSHookIvar<UITextView *>(self, "_textView");
	_textView.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:1.0f];
}

- (id)_placeholderColor {
	return [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kTintColorAlphaFactor];
}

%end


%hook UICollectionView

- (void)layoutSubviews {
	%orig;
	
	self.backgroundView = nil;
}

- (void)_updateBackgroundView {
	//%orig;
	
	self.backgroundView = nil;
}

%end


%hook PUPhotosSinglePickerViewController

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	
	_UIBackdropView *backdropView = (_UIBackdropView *)[self.view viewWithTag:0xc001];
	[backdropView retain];
	
	CGRect frame = self.view.frame;
	frame.origin.x = 0;
	
	if (backdropView == nil) {
		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleForWhiteness graphicsQuality:kBackdropGraphicQualitySystemDefault];
		settings.grayscaleTintAlpha = 0.3f;
		
		backdropView = [[_UIBackdropView alloc] initWithFrame:frame autosizesToFitSuperview:YES settings:settings];
		backdropView.tag = 0xc001;
		
		[self.view insertSubview:backdropView atIndex:0];
	}
	
	backdropView.frame = frame;
	
	[backdropView release];
}

- (void)viewDidAppear:(BOOL)animated {
	%orig;
	
	_UIBackdropView *backdropView = (_UIBackdropView *)[self.view viewWithTag:0xc001];
	[backdropView removeFromSuperview];
}

%end


%hook PUPhotosPickerViewController

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	
	_UIBackdropView *backdropView = (_UIBackdropView *)[self.view viewWithTag:0xc001];
	[backdropView retain];
	
	CGRect frame = self.view.frame;
	frame.origin.x = 0;
	
	if (backdropView == nil) {
		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleForWhiteness graphicsQuality:kBackdropGraphicQualitySystemDefault];
		settings.grayscaleTintAlpha = 0.3f;
		
		backdropView = [[_UIBackdropView alloc] initWithFrame:frame autosizesToFitSuperview:YES settings:settings];
		backdropView.tag = 0xc001;
		
		[self.view insertSubview:backdropView atIndex:0];
	}
	
	backdropView.frame = frame;
	
	[backdropView release];
}

- (void)viewDidAppear:(BOOL)animated {
	%orig;
	
	_UIBackdropView *backdropView = (_UIBackdropView *)[self.view viewWithTag:0xc001];
	[backdropView removeFromSuperview];
}

%end


%hook PUAlbumListTableViewController

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	
	if (self.presentingViewController) {
		_UIBackdropView *backdropView = (_UIBackdropView *)[self.view viewWithTag:0xc001];
		[backdropView retain];
		
		CGRect frame = self.view.frame;
		frame.origin.x = 0;
		
		if (backdropView == nil) {
			_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleForWhiteness graphicsQuality:kBackdropGraphicQualitySystemDefault];
			settings.grayscaleTintAlpha = 0.3f;
			
			backdropView = [[_UIBackdropView alloc] initWithFrame:frame autosizesToFitSuperview:YES settings:settings];
			backdropView.tag = 0xc001;
			
			[self.view insertSubview:backdropView atIndex:0];
		}
		
		backdropView.frame = frame;
		
		[backdropView release];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	%orig;
	
	if (self.presentingViewController) {
		_UIBackdropView *backdropView = (_UIBackdropView *)[self.view viewWithTag:0xc001];
		[backdropView removeFromSuperview];
	}
}

- (void)viewDidLayoutSubviews {
	%orig;
		
	if (isFirmware71 && self.presentingViewController) {
		UINavigationBar *navBar = self.navigationController.navigationBar;
		
		if (navBar) {
			_UIBackdropView *_adaptiveBackdrop = MSHookIvar<_UIBackdropView *>(navBar._backgroundView, "_adaptiveBackdrop");
			
			if (_adaptiveBackdrop.style != kBackdropStyleForWhiteness)
				[_adaptiveBackdrop transitionToStyle:kBackdropStyleForWhiteness];
		}
		
		UINavigationItem *navigationItem = self.navigationItem;
		PUPickerBanner *banner = (PUPickerBanner *)navigationItem.pu_banner;
		if ([banner isKindOfClass:%c(PUPickerBanner)]) {
			_UINavigationControllerPalette *pal = (_UINavigationControllerPalette *)banner.view.superview;
			
			if ([pal isKindOfClass:%c(_UINavigationControllerPalette)]) {
				_UIBackdropView *_adaptiveBackdrop = MSHookIvar<_UIBackdropView *>(pal._backgroundView, "_adaptiveBackdrop");
				
				if (_adaptiveBackdrop.style != kBackdropStyleForWhiteness)
					[_adaptiveBackdrop transitionToStyle:kBackdropStyleForWhiteness];
			}
		}
	}
}

%end


%hook PLPhotoCommentEntryView

- (void)layoutSubviews {
	%orig;
	
	self.textView.textColor = [UIColor colorWithWhite:0.0f alpha:kFullAlphaFactor];
	self.placeholderLabel.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kTintColorAlphaFactor];
}

%end


%hook UIViewController

- (BOOL)__glareapps_isNeedsToHasBackdrop {
	BOOL rtn = %orig;
	
	if ([self isKindOfClass:%c(PUPhotoStreamComposeServiceViewController)]) return NO;
	if ([self isKindOfClass:%c(PUNavigationController)]) return NO;
	
	return rtn;
}

%end


%hook PUPhotoBrowserController

- (UIColor *)photoBackgroundColor {
	return [UIColor colorWithWhite:1.0 alpha:kTransparentAlphaFactor];
}

%end

%hook PUPhotoBrowserZoomTransition

- (void)_transitionDidFinishAnimationForOperation:(NSInteger)operation {
	// push
	if (operation == 1)
		self.fromViewController.view.alpha = kRealFullAlphaFactor;
	
	%orig;
}

- (void)_transitionWillBeginAnimationForOperation:(NSInteger)operation {
	%orig;
	
	// push
	if (operation == 1)
		self.fromViewController.view.alpha = kRealTransparentAlphaFactor;
}

%end


%hook PUPhotoStreamRecipientViewController

- (void)composeRecipientView:(id)recipientView textDidChange:(id)text {
	%orig;
	
	MFComposeRecipientView *_recipientView = MSHookIvar<MFComposeRecipientView *>(self, "_recipientView");
	
	_recipientView.textField.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:1.0f];
}

- (id)tableView:(id)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MFRecipientTableViewCell *cell = %orig;
	
	if ([cell isKindOfClass:%c(MFRecipientTableViewCell)]) {
		MFRecipientTableViewCellDetailView *_detailView = MSHookIvar<MFRecipientTableViewCellDetailView *>(cell, "_detailView");
		MFRecipientTableViewCellTitleView *_titleView = MSHookIvar<MFRecipientTableViewCellTitleView *>(cell, "_titleView");
		
		if (_detailView.tintColor == nil || [[_detailView.tintColor description] hasPrefix:@"UIDeviceWhiteColorSpace"]) {
			_detailView.detailLabel.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kTintColorAlphaFactor];
			_detailView.labelLabel.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:kTintColorAlphaFactor];
		}
		if (_titleView.tintColor == nil || [[_titleView.tintColor description] hasPrefix:@"UIDeviceWhiteColorSpace"]) {
			_titleView.titleLabel.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:1.0f];
		}
	}
	
	return cell;
}

%end




%ctor {
	if (!isThisAppEnabled()) return;
	
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.mobileslideshow"]) {
		%init;
	}
}
