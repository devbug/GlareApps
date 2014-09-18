
#import <substrate.h>
#import <UIKit/UIKit.h>
#import "Frameworks/Frameworks.h"
#import "Categories/Categories.h"
#import "GlareAppsColorHelper.h"
#import "GlareAppsBlurredBackgroundImageView.h"


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



@class GlareAppsColorHelper;

extern BOOL isWhiteness;
extern BOOL useBlendedMode;
extern BOOL useMusicAppAlbumArtBackdrop;
extern BOOL isFirmware70;
extern BOOL isFirmware71;
extern GlareAppsColorHelper *colorHelper;

#define kBackdropStyleForWhiteness			(isWhiteness ? kBackdropStyleSystemDefaultLight : kBackdropStyleSystemDefaultDark)
#define kBarStyleForWhiteness				(isWhiteness ? UIBarStyleDefault : UIBarStyleBlack)
#define kDarkColorWithWhiteForWhiteness		(isWhiteness ? 1.0f : 0.0f)
#define kLightColorWithWhiteForWhiteness	(isWhiteness ? 0.0f : 1.0f)

#define kClearAlphaFactor					(isWhiteness ? 0.2f : 0.1f)
#define kJustClearAlphaFactor				(isWhiteness ? 0.2f : 0.1f)
#define kTintColorAlphaFactor				0.4f
#define kFullAlphaFactor					0.9f
#define kRealFullAlphaFactor				1.0f
#define kTransparentAlphaFactor				0.01f
#define kRealTransparentAlphaFactor			0.0f


#define isPad								(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


BOOL isThisAppUIServiceProcess();
BOOL isTheAppUIServiceProcess(NSString *bundleIdentifier);
BOOL isThisAppEnabled();
BOOL isTheAppEnabled(NSString *bundleIdentifier);
void clearBar(UIView *view);
void setLabelTextColorIfHasBlackColor(UILabel *label);
NSMutableAttributedString *colorReplacedAttributedString(NSAttributedString *text);

UIColor *blendColor();
void blendView(id control);



@interface MFMailComposeViewController : UIViewController @end
@interface SLComposeViewController : UIViewController @end
@interface SKComposeReviewViewController : UIViewController @end

