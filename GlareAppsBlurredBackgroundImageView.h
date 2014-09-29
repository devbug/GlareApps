#import "headers.h"


typedef NS_ENUM(NSInteger, UIBackdropStyleLite) {
	UIBackdropStyleLiteBlurLight			= 1002020,
	UIBackdropStyleLiteBlurDark				= 1002030,
	UIBackdropStyleLiteColoredBlur			= 1002040,
	UIBackdropStyleLiteBlurUltraDark		= 1002050,
	UIBackdropStyleLiteColoredBlurLight		= 1002060,
	UIBackdropStyleLiteColoredBlurDark		= 1002070,
} NS_ENUM_AVAILABLE_IOS(7_0);


@interface GlareAppsBlurredBackgroundImageView : UIView {
	UIImageView *_backgroundImageView;
	_UIBackdropView *_backdropView;
}

@property (nonatomic) BOOL preventPunch;
@property (nonatomic, readonly) UIColor *tintColor;
@property (nonatomic, retain, setter=setBackgroundTintColor:) UIColor *backgroundTintColor;
@property (nonatomic) UIInterfaceOrientation latestOrientation;
@property (nonatomic, readonly) CGFloat tintFraction;
@property (nonatomic, getter=blurRadius) CGFloat blurRadius;
@property (nonatomic, setter=setBlursBackground:) BOOL blursBackground;
@property (nonatomic) UIOffset parallaxSlideMagnitude;
@property (nonatomic) BOOL isFlickerTransition;
@property (nonatomic, setter=setStyle:) NSInteger style;
@property (nonatomic) UIBackdropGraphicsQuality graphicQuality;

- (id)initWithFrame:(CGRect)frame;

- (void)setFrame:(CGRect)frame;
- (UIColor *)tintColorWithAlpha:(CGFloat)alpha;

- (void)setParallaxEnabled:(BOOL)enabled;
- (BOOL)isParallaxEnabled;

- (BOOL)isDarkness;

- (void)punchView:(UIView *)view;
- (void)punchMPButton:(UIButton *)button;
- (void)punchUINavBar:(UINavigationBar *)navBar;
- (void)unpunchView:(UIView *)view;
- (void)reconfigureBackdropFromCurrentSettings;
- (void)removeMaskViews;

- (void)_setBackgoundImage:(UIImage *)image;
- (UIImage *)_getImageFromMPAVItem:(MPAVItem *)item;
- (void)_setBackgroundImageFromMPAVItem:(MPAVItem *)item;

- (void)updateBackgroundImage:(UIImage *)image animated:(BOOL)animated;
- (void)updateBackgroundViewForOrientation:(UIInterfaceOrientation)orientation;
@end

