
#import "../headers.h"


typedef NS_ENUM(NSInteger, UIBackdropStyle) {
	UIBackdropStyleCombiner					= -3,
	UIBackdropStyleNone						= -2,
	UIBackdropStyleBlur						= 2,
	UIBackdropStyleClear					= 2000,
	UIBackdropStyleUltraLight				= 2010,
	UIBackdropStyleLight					= 2020,
	UIBackdropStyleLightLow					= 2029,
	UIBackdropStyleDark						= 2030,
	UIBackdropStyleDarkWithZoom				= 2031,
	UIBackdropStyleDarkLow					= 2039,
	UIBackdropStyleColored					= 2040,		// Gray
	UIBackdropStyleUltraDark				= 2050,
	UIBackdropStyleAdaptiveLight			= 2060,
	UIBackdropStyleSemiLight				= 2070,
	UIBackdropStyleUltraColored				= 2080,		// UltraGray
	
	UIBackdropStyleGreen					= 10091,
	UIBackdropStyleRed						= 10092,
	UIBackdropStyleBlue						= 10120,
	
	// >= iOS 7.1
	UIBackdropStyleFlatSemiLight			= 2071,
	UIBackdropStylePasscodePaddle			= 3900,
	UIBackdropStyleLightKeyboard			= 3901,
} NS_ENUM_AVAILABLE_IOS(7_0);

typedef NS_ENUM(NSInteger, UIBackdropGraphicsQuality) {
	UIBackdropGraphicsQualitySystemDefault	= 0,
	UIBackdropGraphicsQualityForceOff		= 10,
	UIBackdropGraphicsQualityForceOn		= 100,
} NS_ENUM_AVAILABLE_IOS(7_0);

typedef NS_ENUM(NSInteger, UIBackdropOverlayBlendMode) {
	UIBackdropOverlayBlendModeNormal		= 0,
	UIBackdropOverlayBlendModePlusD			= 1,
	UIBackdropOverlayBlendModePlusL			= 2,
	UIBackdropOverlayBlendModeColorDodge	= 3,
} NS_ENUM_AVAILABLE_IOS(7_0);


extern "C" UIImage *_UIImageWithName(NSString *);


@interface CALayer (private_api)
@property BOOL allowsGroupBlending;
@end

@interface _UIParallaxMotionEffect : UIMotionEffect
@property(nonatomic) struct UIOffset slideMagnitude;
@property(nonatomic) CGFloat rotatingSphereRadius;
@property(nonatomic) CGFloat maximumVerticalTiltAngle;
@property(nonatomic) CGFloat maximumHorizontalTiltAngle;
@property(nonatomic) CGFloat verticalSlideAccelerationBoostFactor;
@property(nonatomic) CGFloat horizontalSlideAccelerationBoostFactor;
@end

@class _UIBackdropView;
@interface _UIBackdropViewSettings : NSObject
+ (id)darkeningTintColor;
+ (id)settingsForPrivateStyle:(UIBackdropStyle)arg1;
+ (id)settingsForStyle:(UIBackdropStyle)arg1;
+ (id)settingsForPrivateStyle:(UIBackdropStyle)arg1 graphicsQuality:(UIBackdropGraphicsQuality)arg2;
+ (id)settingsForStyle:(UIBackdropStyle)arg1 graphicsQuality:(UIBackdropGraphicsQuality)arg2;
@property(nonatomic) BOOL appliesTintAndBlurSettings;
@property(nonatomic) BOOL usesDarkeningTintView;	// >= iOS 7.1
@property(nonatomic) BOOL usesContentView;
@property(nonatomic) BOOL usesColorBurnTintView;	// >= iOS 7.1
@property(nonatomic) BOOL usesColorTintView;
@property(nonatomic) BOOL usesGrayscaleTintView;
@property(nonatomic) BOOL usesBackdropEffectView;
@property(nonatomic) CGFloat scale;
@property(retain, nonatomic) UIColor *legibleColor;
@property(retain, nonatomic) UIImage *filterMaskImage;
@property(copy, nonatomic) NSString *blurQuality;
@property(nonatomic) NSInteger blurHardEdges;
@property(nonatomic) CGFloat blurRadius;
@property(retain, nonatomic) UIImage *darkeningTintMaskImage;	// >= iOS 7.1
@property(nonatomic) CGFloat darkeningTintBrightness;	// >= iOS 7.1
@property(nonatomic) CGFloat darkeningTintSaturation;	// >= iOS 7.1
@property(nonatomic) CGFloat darkeningTintHue;	// >= iOS 7.1
@property(nonatomic) CGFloat darkeningTintAlpha;	// >= iOS 7.1
@property(retain, nonatomic) UIImage *colorBurnTintMaskImage;	// >= iOS 7.1
@property(nonatomic) CGFloat colorBurnTintAlpha;	// >= iOS 7.1
@property(nonatomic) CGFloat colorBurnTintLevel;	// >= iOS 7.1
@property(retain, nonatomic) UIImage *colorTintMaskImage;
@property(nonatomic) CGFloat colorTintMaskAlpha;
@property(nonatomic) CGFloat colorTintAlpha;
@property(retain, nonatomic) UIColor *colorTint;
@property(retain, nonatomic) UIImage *grayscaleTintMaskImage;
@property(nonatomic) CGFloat grayscaleTintMaskAlpha;
@property(nonatomic) CGFloat grayscaleTintAlpha;
@property(nonatomic) CGFloat grayscaleTintLevel;
@property(nonatomic) UIBackdropGraphicsQuality graphicsQuality;
@property(nonatomic) UIBackdropStyle style;
@property(nonatomic, assign) _UIBackdropView *backdrop;
@property(nonatomic) BOOL blursWithHardEdges;
@end
@interface _UIBackdropView : UIView
+ (id)allBackdropViews;
@property(nonatomic) CGFloat _blurRadius;
@property(copy, nonatomic) NSString *_blurQuality;
@property(nonatomic) BOOL blurRadiusSetOnce;
@property(nonatomic) BOOL backdropVisibilitySetOnce;
@property(nonatomic) NSInteger blurHardEdges;
@property(nonatomic) BOOL simulatesMasks;
@property(copy, nonatomic) NSString *groupName;
@property(nonatomic) BOOL applySettingsAfterLayout;
@property(nonatomic) NSInteger maskMode;
@property(retain, nonatomic) UIImage *darkeningTintMaskImage;	// >= iOS 7.1
@property(retain, nonatomic) UIView *darkeningTintView;	// >= iOS 7.1
@property(retain, nonatomic) UIView *contentView;
//@property(retain, nonatomic) CAFilter *tintFilter;
//@property(retain, nonatomic) CAFilter *colorSaturateFilter;
//@property(retain, nonatomic) CAFilter *gaussianBlurFilter;
@property(retain, nonatomic) UIImage *colorBurnTintMaskImage;	// >= iOS 7.1
@property(retain, nonatomic) UIView *colorBurnTintView;	// >= iOS 7.1
@property(retain, nonatomic) UIImage *colorTintMaskImage;
@property(retain, nonatomic) UIView *colorTintView;
@property(retain, nonatomic) UIImage *grayscaleTintMaskImage;
@property(retain, nonatomic) UIView *grayscaleTintView;
@property(retain, nonatomic) UIImage *filterMaskImage;
@property(nonatomic) BOOL allowsColorSettingsSuppression;
@property(nonatomic) BOOL wantsColorSettings;
@property(nonatomic) BOOL requiresTintViews;
@property(nonatomic) BOOL applyingTransition;
@property(nonatomic) BOOL applyingBackdropChanges;
@property(retain, nonatomic) _UIBackdropViewSettings *inputSettings;
@property(nonatomic) NSTimeInterval appliesOutputSettingsAnimationDuration;
@property(nonatomic) BOOL computesColorSettings;
@property(nonatomic) BOOL blursBackground;
@property(nonatomic) UIBackdropStyle style;
- (BOOL)disablesOccludedBackdropBlurs;	// >= iOS 7.1
- (void)setDisablesOccludedBackdropBlurs:(BOOL)arg1;	// >= iOS 7.1
- (void)applySettings:(id)arg1;
- (void)computeAndApplySettings:(id)arg1;
- (void)transitionIncrementallyToPrivateStyle:(UIBackdropStyle)arg1 weighting:(CGFloat)arg2;
- (void)transitionIncrementallyToStyle:(UIBackdropStyle)arg1 weighting:(CGFloat)arg2;
- (void)transitionToSettings:(id)arg1;
- (void)transitionToColor:(id)arg1;
- (void)transitionToPrivateStyle:(UIBackdropStyle)arg1;
- (void)transitionToStyle:(UIBackdropStyle)arg1;
- (void)_setBlursBackground:(BOOL)arg1;
- (void)setUsesZoom;
- (void)setBackdropVisible:(BOOL)arg1;
- (BOOL)isBackdropVisible;
- (void)setTintFilterForSettings:(id)arg1;
- (void)setSaturationDeltaFactor:(CGFloat)arg1;
- (CGFloat)saturationDeltaFactor;
- (void)_updateInputBounds;
- (void)scheduleUpdateInputBoundsIfNeeded;
- (void)setBlurFilterWithRadius:(CGFloat)arg1 blurQuality:(id)arg2 blurHardEdges:(NSInteger)arg3;
- (void)setBlurFilterWithRadius:(CGFloat)arg1 blurQuality:(id)arg2;
- (void)setBlursWithHardEdges:(BOOL)arg1;
- (BOOL)blursWithHardEdges;
- (void)setBlurQuality:(id)arg1;
- (id)blurQuality;
- (void)setBlurRadius:(CGFloat)arg1;
- (CGFloat)blurRadius;
- (id)filters;
- (void)_updateFilters;
- (void)removeOverlayBlendModeFromView:(id)arg1;
- (void)applyOverlayBlendModeToView:(id)arg1;
- (void)applyOverlayBlendMode:(UIBackdropOverlayBlendMode)arg1 toView:(id)arg2;
- (void)removeMaskViews;
- (void)updateMaskViewsForView:(id)arg1;
- (void)updateMaskViewForView:(id)arg1 flag:(NSInteger)arg2;
- (void)setMaskImage:(id)arg1 onLayer:(id)arg2;
- (id)backdropViewLayer;
- (void)setShouldRasterizeEffectsView:(BOOL)arg1;
- (void)clearUpdateInputBoundsRunLoopObserver;
- (id)initWithFrame:(CGRect)arg1 style:(UIBackdropStyle)arg2;
- (id)initWithPrivateStyle:(UIBackdropStyle)arg1;
- (id)initWithStyle:(UIBackdropStyle)arg1;
- (id)initWithSettings:(_UIBackdropViewSettings *)arg1;
- (id)initWithFrame:(CGRect)arg1 settings:(_UIBackdropViewSettings *)arg2;
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(_UIBackdropViewSettings *)arg3;
@end

@interface UIApplication (private_api)
- (UIStatusBar *)statusBar;
- (void)_setTextLegibilityEnabled:(BOOL)arg1;
- (void)_setApplicationBackdropStyle:(UIBackdropStyle)arg1;
- (void)_setApplicationIsOpaque:(BOOL)arg1;
- (void)_setDefaultTopNavBarTintColor:(id)arg1;
- (id)_defaultTopNavBarTintColor;
- (id)_currentTintViewWindow;
- (BOOL)_shouldTintStatusBar;
- (void)_setTopNavBarTintColor:(id)arg1 withDuration:(NSTimeInterval)arg2;
- (void)_setBackgroundStyle:(NSInteger)arg1;
@end

@interface _UITabBarBackgroundView : UIView @end

@interface UITabBar (private_api)
@property(nonatomic, setter=_setHidesShadow:) BOOL _hidesShadow;
@property(retain, nonatomic, setter=_setBackgroundView:) UIView *_backgroundView;
@end

@interface UIToolbar (private_api)
@property(nonatomic, setter=_setHidesShadow:) BOOL _hidesShadow;
- (BOOL)_isInNavigationBar;
- (UIView *)_backgroundView;
@end

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
- (void)backdropView:(id)arg1 didChangeToGraphicsQuality:(UIBackdropGraphicsQuality)arg2;
- (id)backdropView:(id)arg1 willChangeToGraphicsQuality:(UIBackdropGraphicsQuality)arg2;
@end
@interface UINavigationButton : UIButton @end
@interface UINavigationBar (private_api)
@property(nonatomic, setter=_setHidesShadow:) BOOL _hidesShadow;
- (BOOL)isMinibar;
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
- (UIBackdropOverlayBlendMode)_separatorBackdropOverlayBlendMode;
- (void)_setSeparatorBackdropOverlayBlendMode:(UIBackdropOverlayBlendMode)arg1;
- (void)_setSeparatorBackdropOverlayBlendModeForUIAppearance:(UIBackdropOverlayBlendMode)arg1;
- (UIView *)_tableHeaderBackgroundView;
- (void)setTableHeaderBackgroundColor:(id)arg1;
- (UITableViewCell *)_reorderingCell;
@end

@interface UITableViewCell (private_api)
- (UIBackdropOverlayBlendMode)_separatorBackdropOverlayBlendMode;
- (void)_setSeparatorBackdropOverlayBlendMode:(UIBackdropOverlayBlendMode)arg1;
- (UIView *)_currentAccessoryView:(BOOL)arg1;
- (void)_updateCellMaskViewsForView:(id)arg1 backdropView:(id)arg2;
- (UITableView *)_tableView;
@property(retain, nonatomic) UIView *backgroundView;
@end

@interface UITableViewCellReorderControl : UIControl @end

@interface UIGroupTableViewCellBackground : UIView @end

@interface UITableViewCellSelectedBackground : UIView
@property(retain, nonatomic) UIColor *selectionTintColor;
@property(retain, nonatomic) UIColor *multiselectBackgroundColor;
@end

@interface UIView (private_api)
+ (BOOL)_isInAnimationBlock;
- (void)_updateBackdropMaskViewsInScrollView:(id)arg1;
- (void)_updateBackdropMaskFrames;
- (void)_recursivelyUpdateBackdropMaskFrames;	// iOS 7.0.x
- (void)_recursivelySetHiddenForBackdropMaskViews:(BOOL)arg1;
- (void)_setHiddenForBackdropMaskViews:(BOOL)arg1;
- (void)_setTransformForBackdropMaskViews:(struct CGAffineTransform)arg1;
- (void)_setCenterForBackdropMaskViews:(struct CGPoint)arg1 convertPoint:(BOOL)arg2;
- (void)_setCenterForBackdropMaskViews:(struct CGPoint)arg1;
- (void)_setBoundsForBackdropMaskViews:(struct CGRect)arg1;
- (void)_setFrameForBackdropMaskViews:(struct CGRect)arg1 convertFrame:(BOOL)arg2;
- (void)_setFrameForBackdropMaskViews:(struct CGRect)arg1;
- (id)_anyBackdropMaskView;
- (void)_removeBackdropMaskViews;
- (id)_backdropMaskViewForFlag:(NSInteger)arg1;
- (void)_setBackdropMaskView:(id)arg1 forFlag:(NSInteger)arg2;
- (id)_generateBackdropMaskViewForFlag:(NSInteger)arg1;
- (id)_generateBackdropMaskImage;
@property(readonly, nonatomic) NSArray *_backdropMaskViews;
- (void)_setBackdropMaskViewForFilters:(id)arg1;
@property(readonly, nonatomic) UIView *_backdropMaskViewForFilters;
- (void)_setBackdropMaskViewForColorTint:(id)arg1;
@property(readonly, nonatomic) UIView *_backdropMaskViewForColorTint;
- (void)_setBackdropMaskViewForGrayscaleTint:(id)arg1;
@property(readonly, nonatomic) UIView *_backdropMaskViewForGrayscaleTint;
- (void)_setBackdropMaskViewFlags:(NSInteger)arg1;
- (NSInteger)_backdropMaskViewFlags;
- (void)_setDrawsAsBackdropOverlayWithBlendMode:(UIBackdropOverlayBlendMode)arg1;
- (void)_setDrawsAsBackdropOverlay:(BOOL)arg1;
- (BOOL)_drawsAsBackdropOverlay;
- (void)sendSubviewToBack:(id)arg1;
- (id)_viewControllerForAncestor;
- (BOOL)_is_needsLayout;
- (BOOL)_isInVisibleHierarchy;
@end

@interface UIDropShadowView : UIView @end

@interface UIViewController (private_api)
@property(retain, nonatomic) UIDropShadowView *dropShadowView;
@end

@interface UIAlertSheetTextField : UITextField @end

@interface UICollectionViewCell (private_api)
- (id)_collectionView;
@end

@interface UIActivityGroupViewController : UICollectionViewController
@property(nonatomic) BOOL darkStyleOnLegacyApp;
@property(nonatomic) UIActivityCategory activityCategory;
@end
@interface UIActivityGroupView : UIView @end
@interface UIActivityGroupListViewController : UIViewController
@property(retain, nonatomic) _UIBackdropView *backdropView;
@end

@interface UIActivity (private_api)
- (id)_activityImage;
@end
@interface _UIActivityFunctionImageView : UIImageView @end
@interface _UIActivityGroupActivityCell : UICollectionViewCell
@property(nonatomic) BOOL darkStyleOnLegacyApp;
@property(retain, nonatomic) UILabel *activityLabel;
@property(retain, nonatomic) _UIActivityFunctionImageView *activityImageView;
@end

@interface UIStatusBar : UIView
@property(retain, nonatomic) UIColor *foregroundColor;
@end

@interface UIImage (private_api)
+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle;
//- (id)_flatImageWithWhite:(CGFloat)arg1 alpha:(CGFloat)arg2;
- (id)_flatImageWithColor:(UIColor *)arg1;
@end

@interface UIImageView (private_api)
@property(nonatomic) NSInteger drawMode;
@end

@interface UIBarButtonItem (private_api)
- (UIImage *)image;
- (void)setImage:(UIImage *)arg1;
@end

@interface UISearchBarBackground : _UIBarBackgroundImageView @end

@interface UISearchResultsTableView : UITableView
@property(nonatomic, assign) UISearchDisplayController *controller;
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
- (void)_updateNeedForBackdrop;
- (void)_updateBackgroundToBackdropStyle:(UIBackdropStyle)arg1;
- (UISearchDisplayController *)controller;
@end

@interface UISegmentedControl (private_api)
@property(nonatomic, setter=_setTranslucentOptionsBackground:) BOOL _hasTranslucentOptionsBackground;
- (BOOL)transparentBackground;
- (void)setTransparentBackground:(BOOL)arg1;
@end
@interface UISegment : UIImageView
- (id)label;
- (BOOL)isSelected;
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
@interface UITabBarButton : UIButton
@property(nonatomic, getter=_isSelected, setter=_setSelected:) BOOL _selected;
- (UIImageView *)_swappableImageView;
@end

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
@property(readonly, nonatomic) UIBackdropStyle backdropStyle;
@property(readonly, nonatomic) BOOL whiteText;
@end
@interface UIKBRenderConfig (Firmware70)
@property(nonatomic) CGFloat keyborderOpacity;
@end
@interface UIKBRenderConfig (Firmware71)
+ (UIBackdropStyle)backdropStyleForStyle:(NSInteger)arg1;
+ (id)configForAppearance:(NSInteger)arg1;
@property(nonatomic) CGFloat lightLatinKeycapOpacity;
@end

@interface UIActivityGroupCancelButton : UIButton
@property(retain, nonatomic) _UIBackdropView *backdropView;
@end

@interface UITextContentView : UIView
@property(readonly, nonatomic) UITextPosition *endOfDocument;
@property(readonly, nonatomic) UITextPosition *beginningOfDocument;
@property(copy, nonatomic) NSDictionary *markedTextStyle;
- (void)unmarkText;
- (void)setMarkedText:(id)arg1 selectedRange:(struct _NSRange)arg2;
@property(readonly, nonatomic) UITextRange *markedTextRange;
@property(copy) UITextRange *selectedTextRange;
- (void)replaceRange:(id)arg1 withText:(id)arg2;
@property(nonatomic, getter=isEditing) BOOL editing;
@property(nonatomic, getter=isEditable) BOOL editable;
@property(nonatomic) struct _NSRange selectedRange;
@property(copy, nonatomic) NSString *text;
- (BOOL)hasText;
@property(retain, nonatomic) UIColor *textColor;
@property(retain, nonatomic) UIFont *font;
@property(copy, nonatomic) NSAttributedString *attributedText;
@property(nonatomic) BOOL allowsEditingTextAttributes;
- (id)contentAsAttributedString;
- (void)setContentToAttributedString:(id)arg1;
- (id)contentAsHTMLString;
- (void)setContentToHTMLString:(id)arg1;
- (BOOL)isSMSTextView;
@end

@interface _UITextFieldRoundedRectBackgroundViewNeue : UIImageView
@property(retain, nonatomic) UIColor *fillColor;
@property(retain, nonatomic) UIColor *strokeColor;
@end

@interface UISlider (private_api)
- (void)_setUseLookNeue:(BOOL)arg1;
@end

@interface UIWindow (private_api)
- (BOOL)_isHostedInAnotherProcess;
@end

@interface UIPeripheralHost : NSObject
+ (id)activeInstance;
+ (id)sharedInstance;
- (id)containerTextEffectsWindowAboveStatusBar;
- (id)containerTextEffectsWindow;
- (id)containerWindow;
//@property(readonly, nonatomic) UIKeyboard *automaticKeyboard;
@property(readonly, nonatomic) UIResponder *responder;
@end

@interface UITextMagnifierRenderer : UIView @end
@interface UITextMagnifierCaretRenderer : UITextMagnifierRenderer @end

