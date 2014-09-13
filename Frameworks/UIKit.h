
#import "headers.h"



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
//- (id)_flatImageWithWhite:(CGFloat)arg1 alpha:(CGFloat)arg2;
- (id)_flatImageWithColor:(UIColor *)arg1;
@end

@interface UIBarButtonItem (private_api)
- (UIImage *)image;
- (void)setImage:(UIImage *)arg1;
@end

@interface UISearchBarBackground : _UIBarBackgroundImageView @end

@interface UISearchResultsTableView : UITableView
@property(nonatomic) UISearchDisplayController *controller;
@end
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

@interface UIActivityGroupCancelButton : UIButton
@property(retain, nonatomic) _UIBackdropView *backdropView;
@end

