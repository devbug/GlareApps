
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

@interface UINavigationItem (PUAbstractNavigationBanner)
@property(retain, nonatomic, setter=pu_setBanner:) PUAbstractNavigationBanner *pu_banner;
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
	return [colorHelper themedFakeClearColor];
}

- (UIColor *)emptyPlaceholderViewBackgroundColor {
	return [colorHelper themedFakeClearColor];
}

- (UIColor *)albumListBackgroundColor {
	return [colorHelper themedFakeClearColor];
}

- (UIColor *)cloudFeedBackgroundColor {
	return [colorHelper themedFakeClearColor];
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
	
	self._titleTextField.textColor = [colorHelper commonTextColor];
}

%end


%hook PUFeedTextCell

- (void)layoutSubviews {
	%orig;
	
	self._label.textColor = [colorHelper commonTextColor];
	self._detailLabel.textColor = [colorHelper commonTextColor];
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
	
	self.backgroundColor = [colorHelper clearColor];
	
	_UIBackdropView *_backdropView = MSHookIvar<_UIBackdropView *>(self, "_backdropView");
	
	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:UIBackdropStyleSemiLight];
	settings.grayscaleTintLevel = (isWhiteness ? 1.0f : 0.0f);
	
	if (_backdropView.style != UIBackdropStyleSemiLight)
		[_backdropView transitionToSettings:settings];
}

%end


%hook PUPhotoStreamComposeServiceViewController

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	
	if (self.sheetView && self.sheetView.subviews.count > 1) {
		_UIBackdropView *backdropView = (_UIBackdropView *)self.sheetView.subviews[0];
		
		if ([backdropView isKindOfClass:[_UIBackdropView class]]) {
			NSInteger style = (isWhiteness ? UIBackdropStyleUltraLight : UIBackdropStyleDark);
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
	_textView.textColor = [colorHelper commonTextColor];
}

- (id)_placeholderColor {
	return [colorHelper systemGrayColor];
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
		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleForWhiteness graphicsQuality:UIBackdropGraphicsQualitySystemDefault];
		
		backdropView = [[_UIBackdropView alloc] initWithFrame:frame autosizesToFitSuperview:YES settings:settings];
		backdropView.tag = 0xc001;
		
		[self.view insertSubview:backdropView atIndex:0];
		[colorHelper addBlurView:backdropView];
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
		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleForWhiteness graphicsQuality:UIBackdropGraphicsQualitySystemDefault];
		
		backdropView = [[_UIBackdropView alloc] initWithFrame:frame autosizesToFitSuperview:YES settings:settings];
		backdropView.tag = 0xc001;
		
		[self.view insertSubview:backdropView atIndex:0];
		[colorHelper addBlurView:backdropView];
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
			_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleForWhiteness graphicsQuality:UIBackdropGraphicsQualitySystemDefault];
			
			backdropView = [[_UIBackdropView alloc] initWithFrame:frame autosizesToFitSuperview:YES settings:settings];
			backdropView.tag = 0xc001;
			
			[self.view insertSubview:backdropView atIndex:0];
			[colorHelper addBlurView:backdropView];
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
	return [colorHelper fakeWhiteClearColor];
}

%end

%hook PUPhotoBrowserZoomTransition

- (void)_transitionDidFinishAnimationForOperation:(UINavigationControllerOperation)operation {
	if (operation == UINavigationControllerOperationPush)
		self.fromViewController.view.alpha = kRealFullAlphaFactor;
	
	%orig;
}

- (void)_transitionWillBeginAnimationForOperation:(UINavigationControllerOperation)operation {
	%orig;
	
	if (operation == UINavigationControllerOperationPush)
		self.fromViewController.view.alpha = kRealTransparentAlphaFactor;
}

%end


%hook PUPhotoStreamRecipientViewController

- (void)composeRecipientView:(id)recipientView textDidChange:(id)text {
	%orig;
	
	MFComposeRecipientView *_recipientView = MSHookIvar<MFComposeRecipientView *>(self, "_recipientView");
	
	_recipientView.textField.textColor = [colorHelper commonTextColor];
}

- (id)tableView:(id)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MFRecipientTableViewCell *cell = %orig;
	
	if ([cell isKindOfClass:%c(MFRecipientTableViewCell)]) {
		MFRecipientTableViewCellDetailView *_detailView = MSHookIvar<MFRecipientTableViewCellDetailView *>(cell, "_detailView");
		MFRecipientTableViewCellTitleView *_titleView = MSHookIvar<MFRecipientTableViewCellTitleView *>(cell, "_titleView");
		
		if (_detailView.tintColor == nil || [[_detailView.tintColor description] hasPrefix:@"UIDeviceWhiteColorSpace"]) {
			_detailView.detailLabel.textColor = [colorHelper systemGrayColor];
			_detailView.labelLabel.textColor = [colorHelper systemGrayColor];
		}
		if (_titleView.tintColor == nil || [[_titleView.tintColor description] hasPrefix:@"UIDeviceWhiteColorSpace"]) {
			_titleView.titleLabel.textColor = [colorHelper commonTextColor];
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
