
#import "headers.h"
#import <objc/runtime.h>


@interface GlareAppsColorHelper : NSObject

@property (nonatomic, readonly) UIColor *clearColor;
@property (nonatomic, readonly) UIColor *whiteColor;
@property (nonatomic, readonly) UIColor *blackColor;
@property (nonatomic, readonly) UIColor *rgbBlackColor;
@property (nonatomic, readonly) UIColor *rgbWhiteColor;
@property (nonatomic, readonly) UIColor *color_1_0__1_0;
@property (nonatomic, readonly) UIColor *color_0_0__1_0;
@property (nonatomic, readonly) UIColor *color_1_0__0_01;
@property (nonatomic, readonly) UIColor *color_0_0__0_01;
@property (nonatomic, readonly) UIColor *color_1_0__0_1;
@property (nonatomic, readonly) UIColor *color_0_0__0_1;
@property (nonatomic, readonly) UIColor *color_0_0__0_15;
@property (nonatomic, readonly) UIColor *color_1_0__0_2;
@property (nonatomic, readonly) UIColor *color_0_0__0_2;
@property (nonatomic, readonly) UIColor *color_1_0__0_4;
@property (nonatomic, readonly) UIColor *color_0_0__0_4;
@property (nonatomic, readonly) UIColor *color_1_0__0_6;
@property (nonatomic, readonly) UIColor *color_0_0__0_6;
@property (nonatomic, readonly) UIColor *color_1_0__0_8;
@property (nonatomic, readonly) UIColor *color_0_0__0_8;
@property (nonatomic, readonly) UIColor *color_0_0__0_9;
@property (nonatomic, readonly) UIColor *color_0_1__1_0;
@property (nonatomic, readonly) UIColor *color_0_3__1_0;
@property (nonatomic, readonly) UIColor *color_0_55__1_0;
@property (nonatomic, readonly) UIColor *color_0_7__1_0;
@property (nonatomic, readonly) UIColor *color_0_75__1_0;
@property (nonatomic, readonly) UIColor *color_0_9__0_2;
@property (nonatomic, readonly) UIColor *color_0_9__1_0;
@property (nonatomic, readonly) UIColor *color_0_11__0_2;
@property (nonatomic, readonly) UIColor *color_0_77__0_2;
@property (nonatomic, readonly) BOOL isWhiteness;

+ (instancetype)sharedInstance;

- (UIColor *)maskColorForBlendedMode;
- (UIColor *)fakeWhiteClearColor;
- (UIColor *)fakeBlackClearColor;
- (UIColor *)themedFakeClearColor;
- (UIColor *)commonTextColor;
- (UIColor *)commonTextColorWithAlpha:(CGFloat)alpha;
- (UIColor *)fakeCommonTextColor;
- (UIColor *)rgbCommonTextColor;
- (UIColor *)lightTextColor;
- (UIColor *)lightTextColorWithAlpha:(CGFloat)alpha;
- (UIColor *)fakeLightTextColor;
- (UIColor *)rgbLightTextColor;
- (UIColor *)keyWindowBackgroundColor;
- (UIColor *)systemGrayColor;
- (UIColor *)systemLightGrayColor;
- (UIColor *)systemDarkGrayColor;
- (UIColor *)defaultTableViewCellBackgroundColor;
- (UIColor *)defaultTableViewSeparatorColor;
- (UIColor *)defaultTableViewGroupCellTextColor;
- (UIColor *)defaultAlertViewRepresentationViewBackgroundColor;
- (UIColor *)defaultAddressBookCardCellDividerColor;
- (UIColor *)preferencesUITableViewBackgroundColor;
- (UIColor *)stocksListTableViewCellSelectedColor;
- (UIColor *)mobilePhoneDialerBackgroundColor;
- (UIColor *)themedMusicSliderMaximumTrackImageTintColor;
- (UIColor *)_musicSliderMaximumTrackImageTintColorIfDarkness;
- (UIColor *)_musicSliderMaximumTrackImageTintColorIfWhiteness;
- (UIColor *)musicNowPlayingViewTitlesDetailLabelTextColor;
- (UIColor *)musicTableViewCellTextColor;

- (UIColor *)colorWithWhite:(CGFloat)white alpha:(CGFloat)alpha;
- (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

- (void)addBlurView:(_UIBackdropView *)view;
- (void)removeBlurView:(_UIBackdropView *)view;
- (BOOL)isOwnBlurView:(_UIBackdropView *)backdrop;
- (BOOL)nowWindowRotating;

- (BOOL)needsToSetOwnBackgroundColorForBackdropView:(_UIBackdropView *)view;

- (void)reloadSettings;

@end
