
#import <substrate.h>
#import <UIKit/UIKit.h>
#import "Frameworks/Frameworks.h"
#import "Categories/Categories.h"
#import "GlareAppsColorHelper.h"
#import "GlareAppsBlurredBackgroundImageView.h"


extern NSString * const kCAFilterNormalBlendMode;
extern NSString * const kCAFilterMultiplyBlendMode;
extern NSString * const kCAFilterOverlayBlendMode;
extern NSString * const kCAFilterColorDodgeBlendMode;
extern NSString * const kCAFilterColorBurnBlendMode;
extern NSString * const kCAFilterPlusD;
extern NSString * const kCAFilterPlusL;



@class GlareAppsColorHelper;

enum {
	MusicAppAlbumArtVisibleDefault = 0,
	MusicAppAlbumArtVisibleSmaller,
	MusicAppAlbumArtVisibleNone
};

extern BOOL isWhiteness;
extern BOOL useBlendedMode;
extern BOOL useMusicAppAlbumArtBackdrop;
extern NSInteger musicAppAlbumArtVisible;
extern CGFloat musicAppAlbumArtBackdropBlurRadius;
extern BOOL isFirmware70;
extern BOOL isFirmware71;
extern GlareAppsColorHelper *colorHelper;

#define kBackdropStyleForWhiteness			(isWhiteness ? UIBackdropStyleLight : UIBackdropStyleDark)
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


#define isPad()								(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


BOOL isThisAppUIServiceProcess();
BOOL isTheAppUIServiceProcess(NSString *bundleIdentifier);
BOOL isThisAppEnabled();
BOOL isTheAppEnabled(NSString *bundleIdentifier);
void clearBar(UIView *view);
void setLabelTextColorIfHasBlackColor(UILabel *label);
NSMutableAttributedString *colorReplacedAttributedString(NSAttributedString *text);

UIColor *blendColor();
NSInteger blendMode();
void blendView(id control);


