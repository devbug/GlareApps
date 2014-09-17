#import "headers.h"


enum {
	kBackdropStyleSystemDefaultBlur = 2,
	kBackdropStyleSystemDefaultGreen = 10091,
	kBackdropStyleSystemDefaultRed = 10092,
	kBackdropStyleSystemDefaultBlue = 10120,
	
	//
	kBackdropStyleLiteBlurLight = 1002020,
	kBackdropStyleLiteBlurDark = 1002030,
	kBackdropStyleLiteColoredBlur = 1002040,
	kBackdropStyleLiteBlurUltraDark = 1002050,
	kBackdropStyleLiteColoredBlurLight = 1002060,
	kBackdropStyleLiteColoredBlurDark = 1002070,
};


@interface BlurredBackgroundImageView : UIView {
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
@property (nonatomic) NSInteger graphicQuality;

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

