
#import <UIKit/UIKit.h>
#import "UIApplication+GlareApps.h"


enum {
	kBackdropStyleSystemDefaultClear = 2000,
	kBackdropStyleSystemDefaultUltraLight = 2010,
	kBackdropStyleSystemDefaultLight = 2020,
	kBackdropStyleSystemDefaultLightLow = 2029,
	kBackdropStyleSystemDefaultDark = 2030,
	kBackdropStyleSystemDefaultDarkLow = 2039,
	kBackdropStyleSystemDefaultGray = 2040,			// Colored
	kBackdropStyleSystemDefaultUltraDark = 2050,
	kBackdropStyleSystemDefaultAdaptiveLight = 2060,
	kBackdropStyleSystemDefaultSemiLight = 2070,
	kBackdropStyleSystemDefaultUltraGray = 2080,	// UltraColored
};

enum {
	kBackdropGraphicQualitySystemDefault = 0,
	kBackdropGraphicQualityForceOff = 10,
	kBackdropGraphicQualityForceOn = 100,
};


extern NSString * const kCAFilterNormalBlendMode;
extern NSString * const kCAFilterMultiplyBlendMode;
extern NSString * const kCAFilterScreenBlendMode;
extern NSString * const kCAFilterOverlayBlendMode;
extern NSString * const kCAFilterDarkenBlendMode;
extern NSString * const kCAFilterLightenBlendMode;
extern NSString * const kCAFilterColorDodgeBlendMode;
extern NSString * const kCAFilterColorBurnBlendMode;
extern NSString * const kCAFilterSoftLightBlendMode;
extern NSString * const kCAFilterHardLightBlendMode;
extern NSString * const kCAFilterDifferenceBlendMode;
extern NSString * const kCAFilterExclusionBlendMode;



extern BOOL isWhiteness;
extern BOOL isFirmware70;
extern BOOL isFirmware71;

#define kBackdropStyleForWhiteness			(isWhiteness ? kBackdropStyleSystemDefaultLight : kBackdropStyleSystemDefaultDark)
#define kBarStyleForWhiteness				(isWhiteness ? UIBarStyleDefault : UIBarStyleBlack)
#define kDarkColorWithWhiteForWhiteness		(isWhiteness ? 1.0f : 0.0f)
#define kLightColorWithWhiteForWhiteness	(isWhiteness ? 0.0f : 1.0f)

#define kClearAlphaFactor					(isWhiteness ? 0.2f : 0.1f)
#define kJustClearAlphaFactor				0.1f
#define kTintColorAlphaFactor				0.4f
#define kFullAlphaFactor					0.9f
#define kRealFullAlphaFactor				1.0f
#define kTransparentAlphaFactor				0.01f
#define kRealTransparentAlphaFactor			0.0f


#define isPad								(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


BOOL isThisAppEnabled();
void clearBar(UIView *view);
void setLabelTextColorIfHasBlackColor(UILabel *label);
NSMutableAttributedString *colorReplacedAttributedString(NSAttributedString *text);



#pragma mark -
#pragma mark Private Headers


@class _UIBackdropView;
@interface _UIBackdropViewSettings : NSObject
+ (id)settingsForPrivateStyle:(NSInteger)arg1;
+ (id)settingsForStyle:(NSInteger)arg1;
+ (id)settingsForPrivateStyle:(NSInteger)arg1 graphicsQuality:(NSInteger)arg2;
+ (id)settingsForStyle:(NSInteger)arg1 graphicsQuality:(NSInteger)arg2;
@property(nonatomic) BOOL usesColorTintView;
@property(nonatomic) CGFloat scale;
@property(retain, nonatomic) UIColor *legibleColor;
@property(retain, nonatomic) UIImage *filterMaskImage;
@property(nonatomic) CGFloat blurRadius;
@property(retain, nonatomic) UIImage *colorTintMaskImage;
@property(nonatomic) CGFloat colorTintMaskAlpha;
@property(nonatomic) CGFloat colorTintAlpha;
@property(retain, nonatomic) UIColor *colorTint;
@property(retain, nonatomic) UIImage *grayscaleTintMaskImage;
@property(nonatomic) CGFloat grayscaleTintMaskAlpha;
@property(nonatomic) CGFloat grayscaleTintAlpha;
@property(nonatomic) CGFloat grayscaleTintLevel;
@property(nonatomic) NSInteger graphicsQuality;
@property(nonatomic) NSInteger style;
@property(nonatomic, assign) _UIBackdropView *backdrop;
@end
@interface _UIBackdropView : UIView
+ (id)allBackdropViews;
@property(copy, nonatomic) NSString *groupName;
@property(retain, nonatomic) UIImage *colorTintMaskImage;
@property(retain, nonatomic) UIImage *grayscaleTintMaskImage;
@property(retain, nonatomic) UIImage *filterMaskImage;
@property(retain, nonatomic) _UIBackdropViewSettings *inputSettings;
@property(nonatomic) BOOL blursBackground;
@property(nonatomic) NSInteger style;
- (void)applySettings:(id)arg1;
- (void)computeAndApplySettings:(id)arg1;
- (void)_setBlursBackground:(BOOL)arg1;
- (void)setBackdropVisible:(BOOL)arg1;
- (void)transitionIncrementallyToPrivateStyle:(NSInteger)arg1 weighting:(CGFloat)arg2;
- (void)transitionIncrementallyToStyle:(NSInteger)arg1 weighting:(CGFloat)arg2;
- (void)transitionToSettings:(id)arg1;
- (void)transitionToPrivateStyle:(NSInteger)arg1;
- (void)transitionToStyle:(NSInteger)arg1;
- (void)removeMaskViews;
- (void)updateMaskViewsForView:(id)arg1;
- (void)updateMaskViewForView:(id)arg1 flag:(NSInteger)arg2;
- (id)initWithFrame:(CGRect)arg1 style:(NSInteger)arg2;
- (id)initWithStyle:(NSInteger)arg1;
- (id)initWithSettings:(_UIBackdropViewSettings *)arg1;
- (id)initWithFrame:(CGRect)arg1 settings:(_UIBackdropViewSettings *)arg2;
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(_UIBackdropViewSettings *)arg3;
@end

@interface UIApplication (private_api)
- (UIStatusBar *)statusBar;
- (void)_setTextLegibilityEnabled:(BOOL)arg1;
- (void)_setApplicationBackdropStyle:(NSInteger)arg1;
- (void)_setApplicationIsOpaque:(BOOL)arg1;
- (void)_setDefaultTopNavBarTintColor:(id)arg1;
- (id)_defaultTopNavBarTintColor;
- (id)_currentTintViewWindow;
- (BOOL)_shouldTintStatusBar;
- (void)_setTopNavBarTintColor:(id)arg1 withDuration:(NSTimeInterval)arg2;
- (void)_setBackgroundStyle:(NSInteger)arg1;
@end

@interface _UITabBarBackgroundView : UIView @end

@interface _UIBarBackgroundImageView : UIImageView
@property(nonatomic, getter=isTranslucent) BOOL translucent;
- (id)image;
- (void)setImage:(id)arg1;
- (id)topStripView;
@end
@interface _UINavigationBarBackground : _UIBarBackgroundImageView {
	_UIBackdropView *_adaptiveBackdrop;
}
@property(retain, nonatomic, setter=_setShadowView:) UIView *_shadowView;
- (void)updateBackgroundImage;
@property(nonatomic) BOOL barWantsAdaptiveBackdrop;
@property(nonatomic, getter=isTranslucent) BOOL translucent;
@property(nonatomic) UIBarStyle barStyle;
@property(retain, nonatomic) UIColor *barTintColor;
// >= 7.1
- (id)_adaptiveBackdrop;
- (void)backdropView:(id)arg1 didChangeToGraphicsQuality:(NSInteger)arg2;
- (id)backdropView:(id)arg1 willChangeToGraphicsQuality:(NSInteger)arg2;
@end
@interface UINavigationBar (private_api)
- (_UINavigationBarBackground *)_backgroundView;
@end

@interface UINavigationController (private_api)
@property(retain, nonatomic) UIViewController *disappearingViewController;
@property(nonatomic, getter=isInteractiveTransition) BOOL interactiveTransition;
- (BOOL)_isTransitioning;
@end

@interface _UIContentUnavailableView : UIView {
	_UIBackdropView *_backdrop;
}
@end

@interface UITableViewHeaderFooterView (private_api)
@property(nonatomic, assign) UITableView *tableView;
@property(retain, nonatomic) UIImage *backgroundImage;
@end

@interface UINavigationItem (private_api)
- (UINavigationBar *)navigationBar;
@end

@interface UITableView (private_api)
- (NSInteger)_separatorBackdropOverlayBlendMode;
- (void)_setSeparatorBackdropOverlayBlendMode:(CGBlendMode)arg1;
- (void)_setSeparatorBackdropOverlayBlendModeForUIAppearance:(CGBlendMode)arg1;
@end

@interface UITableViewCell (private_api)
- (UIView *)_currentAccessoryView:(BOOL)arg1;
@end

@interface UITableViewCellReorderControl : UIControl @end

@interface UIGroupTableViewCellBackground : UIView @end

@interface UIView (private_api)
+ (BOOL)_isInAnimationBlock;
- (void)_updateBackdropMaskViewsInScrollView:(id)arg1;
- (void)_recursivelySetHiddenForBackdropMaskViews:(BOOL)arg1;
- (void)_setHiddenForBackdropMaskViews:(BOOL)arg1;
- (void)_setTransformForBackdropMaskViews:(struct CGAffineTransform)arg1;
- (void)_setCenterForBackdropMaskViews:(struct CGPoint)arg1 convertPoint:(BOOL)arg2;
- (void)_setCenterForBackdropMaskViews:(struct CGPoint)arg1;
- (void)_setBoundsForBackdropMaskViews:(struct CGRect)arg1;
- (void)_setFrameForBackdropMaskViews:(struct CGRect)arg1 convertFrame:(BOOL)arg2;
- (void)_setBackdropMaskViewFlags:(NSInteger)arg1;
- (id)_backdropMaskViewForFlag:(NSInteger)arg1;
- (void)_setBackdropMaskView:(id)arg1 forFlag:(NSInteger)arg2;
- (void)sendSubviewToBack:(id)arg1;
- (void)_setDrawsAsBackdropOverlayWithBlendMode:(CGBlendMode)arg1;
- (void)_updateBackdropMaskFrames;
- (void)_removeBackdropMaskViews;
- (void)_setDrawsAsBackdropOverlay:(BOOL)arg1;
- (void)_setFrameForBackdropMaskViews:(struct CGRect)arg1;
- (id)_viewControllerForAncestor;
- (BOOL)_is_needsLayout;
@end

@interface UIDropShadowView : UIView @end

@interface UIViewController (private_api)
@property(retain, nonatomic) UIDropShadowView *dropShadowView;
@end

@interface UIAlertSheetTextField : UITextField @end

@interface UIActivityGroupListViewController : UIViewController
@property(retain, nonatomic) _UIBackdropView *backdropView;
@end

@interface UIStatusBar : UIView
@property(retain, nonatomic) UIColor *foregroundColor;
@end

@interface UIImage (Private)
- (id)_flatImageWithWhite:(CGFloat)arg1 alpha:(CGFloat)arg2;
- (id)_flatImageWithColor:(UIColor *)arg1;
@end

@interface UIBarButtonItem (private_api)
- (UIImage *)image;
- (void)setImage:(UIImage *)arg1;
@end


@interface ABMemberNameView : UIView
@property(nonatomic) BOOL highlighted;
// < 7.1
@property(readonly, nonatomic) UILabel *meLabel;
@property(readonly, nonatomic) UILabel *nameLabel;
// >= 7.1
@property(nonatomic, retain) UITableViewCell *cell;
@end

@interface ABMemberCell : UITableViewCell
@property(retain, nonatomic) ABMemberNameView *contactNameView;
@end

@interface ABMembersController : UIViewController
- (UISearchDisplayController *)__searchController;
- (UISearchBar *)__searchBar;
- (UITableView *)currentTableView;
- (UIView *)contentView;
- (UITableView *)tableView;
@end

@interface ABContactCell : UITableViewCell
// < 7.1
@property(retain, nonatomic) UIColor *separatorColor;
// >= 7.1
@property(retain, nonatomic) UIColor *contactSeparatorColor;
@end
@interface ABPropertyCell : UITableViewCell
@property(readonly, nonatomic) UILabel *valueLabel;
@property(readonly, nonatomic) UILabel *labelLabel;
@property(copy, nonatomic) NSDictionary *valueTextAttributes;
@property(copy, nonatomic) NSDictionary *labelTextAttributes;
@end
@interface ABPropertyNameCell : UITableViewCell
@property(readonly, nonatomic) UITextField *textField;
@end
@interface ABPropertyNoteCell : ABPropertyCell
@property(retain, nonatomic) UITextView *textView;
@end

@interface ABGroupHeaderFooterView : UITableViewHeaderFooterView
@property(readonly, nonatomic) UIView *bottomSeparatorView;
@property(readonly, nonatomic) UIView *topSeparatorView;
@property(readonly, nonatomic) UILabel *titleLabel;
@end

@interface ABBannerView : UITableViewCell @end

@interface ABContactView : UITableView @end

@interface UISearchBarBackground : _UIBarBackgroundImageView @end

@interface UISearchResultsTableView : UITableView @end
@interface UISearchDisplayControllerContainerView : UIView
@property(readonly, nonatomic) UIView *behindView;
@end
@interface UISearchDisplayController (private_api)
@property(nonatomic, getter=isActive) BOOL active;
- (UISearchDisplayControllerContainerView *)_containerView;
@end

@interface UIColor (private_api)
- (CGFloat)alphaComponent;
@end

@interface _UIModalItemContentView : UIView
@property(readonly, nonatomic) UITableView *buttonTable;
@property(retain, nonatomic) UIButton *defaultButton;
@property(retain, nonatomic) UIButton *cancelButton;
@property(readonly, nonatomic) UIView *accessoryViewControllerContrainerView;
@property(readonly, nonatomic) UITextField *passwordTextField;
@property(readonly, nonatomic) UITextField *loginTextField;
@property(readonly, nonatomic) UILabel *messageLabel;
@property(readonly, nonatomic) UILabel *subtitleLabel;
@property(readonly, nonatomic) UILabel *titleLabel;
@end

@interface _UIModalItemAlertContentView : _UIModalItemContentView @end
@interface _UIModalItemActionSheetContentView : _UIModalItemContentView @end

@interface UISearchBar (private_api)
- (void)_setBarTintColor:(id)arg1 forceUpdate:(BOOL)arg2;
- (void)_setBackdropStyle:(NSUInteger)arg1;
- (BOOL)_isAtTop;
- (BOOL)drawsBackgroundInPalette;
- (void)setDrawsBackgroundInPalette:(BOOL)arg1;
- (BOOL)drawsBackground;
- (void)setDrawsBackground:(BOOL)arg1;
- (void)_updateBackgroundToBackdropStyle:(NSInteger)arg1;
- (UISearchDisplayController *)controller;
@end

@interface UISegmentedControl (private_api)
@property(nonatomic, setter=_setTranslucentOptionsBackground:) BOOL _hasTranslucentOptionsBackground;
- (BOOL)transparentBackground;
- (void)setTransparentBackground:(BOOL)arg1;
@end

@interface _UIPopoverStandardChromeView : UIPopoverBackgroundView @end
@interface _UIPopoverView : UIView
- (UIImageView *)toolbarShine;
- (UIView *)standardChromeView;
- (UIView *)backgroundView;
- (UIView *)contentView;
@end

@interface UIDateLabel : UILabel
@property(readonly, nonatomic, getter=_dateString) NSString *dateString;
@end

@interface UIMoreNavigationController : UINavigationController @end
@interface UIMoreListController : UIViewController @end

@interface UITabBarCustomizeView : UIView @end

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

@interface UIKBRenderConfig : NSObject
+ (id)darkConfig;
+ (id)defaultConfig;
@property(nonatomic) BOOL lightKeyboard;
@property(nonatomic) CGFloat keycapOpacity;
@property(nonatomic) CGFloat blurSaturation;
@property(nonatomic) CGFloat blurRadius;
@property(readonly, nonatomic) NSInteger backdropStyle;
@property(readonly, nonatomic) BOOL whiteText;
@end
@interface UIKBRenderConfig (Firmware70)
@property(nonatomic) CGFloat keyborderOpacity;
@end
@interface UIKBRenderConfig (Firmware71)
+ (NSInteger)backdropStyleForStyle:(NSInteger)arg1;
+ (id)configForAppearance:(NSInteger)arg1;
@property(nonatomic) CGFloat lightLatinKeycapOpacity;
@end

@interface MFComposeHeaderView : UIView @end
@interface MFComposeRecipientView : MFComposeHeaderView
@property(readonly) UITextField *textField;
@end

@interface MFRecipientTableViewCellDetailView : UIView
@property(readonly) UILabel *detailLabel;
@property(readonly) UILabel *labelLabel;
- (void)setTintColor:(id)arg1 animated:(BOOL)arg2;
- (id)tintColor;
@end
@interface MFRecipientTableViewCellTitleView : UIView
@property(readonly) UILabel *titleLabel;
- (void)setTintColor:(id)arg1 animated:(BOOL)arg2;
- (id)tintColor;
@end
@interface MFRecipientTableViewCell : UITableViewCell {
	MFRecipientTableViewCellDetailView *_detailView;
	MFRecipientTableViewCellTitleView *_titleView;
}
- (void)setTintColor:(id)arg1 animated:(BOOL)arg2;
- (id)tintColor;
@end


@interface UIActivityGroupCancelButton : UIButton
@property(retain, nonatomic) _UIBackdropView *backdropView;
@end

@interface PLCameraView : UIView
@property(readonly, nonatomic) UIView *_previewMaskingView;
@end

@interface PLWallpaperButton : UIButton
@property(retain, nonatomic) _UIBackdropView *backdropView;
@property(retain, nonatomic) UIImageView *titleMaskImageView;
@end

@interface PLEditPhotoController : UIViewController
@property(retain, nonatomic) UIToolbar *toolbar;
@property(retain, nonatomic) UINavigationBar *navigationBar;
@end
@interface PLEffectSelectionViewControllerView : UIView @end


@interface MFMessageComposeViewController : UIViewController @end
@interface MFMailComposeViewController : UIViewController @end
@interface SLComposeViewController : UIViewController @end
@interface SKComposeReviewViewController : UIViewController @end
