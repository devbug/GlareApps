#import "BlurredBackgroundImageView.h"
#import <objc/runtime.h>
#import <QuartzCore/CAFilter.h>


#define isLargeScreen						(([[UIScreen mainScreen] bounds].size.height >= 568.0f) ? YES : NO)


@implementation BlurredBackgroundImageView {
	_UIParallaxMotionEffect *_parallax;
	BOOL _parallaxEnabled;
	BOOL _isDarkness;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		_preventPunch = NO;
		_latestOrientation = UIInterfaceOrientationPortrait;
		
		_isDarkness = YES;
		_tintColor = [[UIColor whiteColor] retain];
		_tintFraction = 1.0f;
		
		_blurRadius = -1.0f;
		_blursBackground = YES;
		_backgroundTintColor = nil;
		_style = kBackdropStyleLiteBlurDark;
		_graphicQuality = kBackdropGraphicQualitySystemDefault;
		
		_parallax = [[objc_getClass("_UIParallaxMotionEffect") alloc] init];
		_parallaxEnabled = NO;
		_parallaxSlideMagnitude = UIOffsetMake(30.0, 30.0);
		_parallax.slideMagnitude = _parallaxSlideMagnitude;
		
		_isFlickerTransition = YES;
		
		self.clipsToBounds = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.autoresizesSubviews = YES;
		self.backgroundColor = [UIColor blackColor];
		
		[self _makeBackdropView];
		_backgroundImageView = [[UIImageView alloc] initWithFrame:frame];
		
		[self addSubview:_backgroundImageView];
		[self addSubview:_backdropView];
	}
	
	return self;
}

- (void)dealloc {
	if (_parallaxEnabled)
		[_backgroundImageView removeMotionEffect:_parallax];
	[_parallax release];
	
	[_backdropView removeMaskViews];
	[_backdropView removeFromSuperview];
	[_backdropView release];
	[_backgroundImageView removeFromSuperview];
	[_backgroundImageView release];
	
	[_tintColor release];
	self.backgroundTintColor = nil;
	
	[super dealloc];
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
}

- (void)setDarkness:(BOOL)dark {
	if (_blursBackground == NO || _style == kBackdropStyleLiteColoredBlur) return;
	
	[self _setDarkness:dark];
}

- (BOOL)isDarkness {
	return _isDarkness;
}

- (void)_setDarkness:(BOOL)dark {
	_isDarkness = dark;
	_tintFraction = (!_isDarkness ? 1.5f : 1.0f);
	
	[_tintColor release];
	_tintColor = [(!_isDarkness ? [UIColor blackColor] : [UIColor whiteColor]) retain];
	self.backgroundColor = (!_isDarkness ? [UIColor whiteColor] : [UIColor blackColor]);
}

- (UIColor *)tintColorWithAlpha:(CGFloat)alpha {
	return ([UIColor colorWithWhite:(!_isDarkness ? 0.0 : 1.0) alpha:alpha]);
}

- (void)setBackgroundTintColor:(UIColor *)backgroundTintColor {
	[self _setBackgroundTintColor:backgroundTintColor withBlur:_blursBackground];
}

- (void)setBlursBackground:(BOOL)blursBackground {
	[self _setBackgroundTintColor:_backgroundTintColor withBlur:blursBackground];
}

- (void)_setBackgroundTintColor:(UIColor *)backgroundTintColor withBlur:(BOOL)blur {
	if (_backgroundTintColor != backgroundTintColor) {
		[_backgroundTintColor release];
		_backgroundTintColor = [backgroundTintColor retain];
	}
	
	_blursBackground = blur;
	
	if ((_blursBackground == NO || _style == kBackdropStyleLiteColoredBlur) && _backgroundTintColor) {
		CGFloat red, green, blue, alpha;
		[_backgroundTintColor getRed:&red green:&green blue:&blue alpha:&alpha];
		CGFloat totalLuminance = red * 0.299 + green * 0.587 + blue * 0.114;
		
		if (totalLuminance < 0.5f)
			[self _setDarkness:YES];
		else
			[self _setDarkness:NO];
	}
	
	[self _setBlurRadius:self.blurRadius];
}

- (void)setStyle:(NSInteger)style {
	_style = style;
	_blurRadius = -1.0f;
	
	if (_style == kBackdropStyleLiteColoredBlur)
		[self _setBackgroundTintColor:_backgroundTintColor withBlur:_blursBackground];
}

- (CGFloat)blurRadius {
	if (_blurRadius < 0.0f) {
		return _backdropView.blurRadius;
	}
	
	return _blurRadius;
}

- (void)_setBlurRadius:(CGFloat)radius {
	return;
	CALayer *layer = [_backgroundImageView layer];
	if (_blursBackground && [self isParallaxEnabled]) {
		CAFilter *filter = [CAFilter filterWithName:@"gaussianBlur"];
		[filter setValue:@(radius) forKey:@"inputRadius"];
		layer.filters = [NSArray arrayWithObject:filter];
	}
	else 
		layer.filters = nil;
}


- (void)setParallaxEnabled:(BOOL)enabled {
	if (_parallaxEnabled == enabled) return;
	
	_parallaxEnabled = enabled;
	
	if (_parallaxEnabled) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[_backgroundImageView addMotionEffect:_parallax];
		});
	}
	else {
		[_backgroundImageView removeMotionEffect:_parallax];
	}
}

- (BOOL)isParallaxEnabled {
	return _parallaxEnabled;
}

- (void)setParallaxSlideMagnitude:(UIOffset)slideOffset {
	_parallaxSlideMagnitude = slideOffset;
	
	_parallax.slideMagnitude = _parallaxSlideMagnitude;
}


- (void)_maskButton:(UIButton *)button {
	if (!button || button.alpha == 0.0f) return;
	
	button.tintColor = _tintColor;
	[button setAlpha:0.1f * _tintFraction];
}

- (void)punchView:(UIView *)view {
	if (_preventPunch) return;
	if (!view || view.alpha == 0.0f) return;
	if (view.hidden) return;
	
	if ([view respondsToSelector:@selector(_setDrawsAsBackdropOverlayWithBlendMode:)]) {
		[view _setBackdropMaskViewFlags:1];
		//[view _setDrawsAsBackdropOverlayWithBlendMode:_isDarkness ? kCGBlendModeOverlay : kCGBlendModeMultiply];
		[_backdropView applyOverlayBlendMode:(_isDarkness ? kCGBlendModeOverlay : kCGBlendModeMultiply) toView:view];
	}
	[_backdropView updateMaskViewsForView:view];
	[view _setFrameForBackdropMaskViews:view.frame];
}

- (void)punchMPButton:(UIButton *)button {
	if (!button || button.alpha == 0.0f) return;
	
	button.opaque = NO;
	
	for (UIView *v in button.subviews) {
		if (v.alpha == 0.0f) continue;
		
		if ([v isKindOfClass:[UIImageView class]]) {
			v.alpha = 0.1f * _tintFraction;
		}
		else {
			v.alpha = 0.3f;
			[self punchView:v];
		}
		
		v.opaque = NO;
		v.tintColor = _tintColor;
	}
	
	button.titleLabel.textColor = _tintColor;
	if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
		[button setTitleColor:_tintColor forState:0];
}

- (void)punchUINavBar:(UINavigationBar *)navBar {
	if (!navBar || navBar.alpha == 0.0f) return;
	
	for (UIView *v in navBar.subviews) {
		if (v.alpha == 0.0f) continue;
		
		if ([v isKindOfClass:[UINavigationButton class]] && v.subviews.count >= 1 && [v.subviews[0] isKindOfClass:[UIImageView class]]) {
			[self _maskButton:(UIButton *)v];
			[self punchView:v];
			v.alpha = 0.3f * _tintFraction;
		}
		else if ([v isKindOfClass:objc_getClass("_UINavigationBarBackIndicatorView")]) {
			[self punchView:v];
			v.alpha = 0.3f;
			v.tintColor = _tintColor;
		}
		else
			v.alpha = 1.0f;
	}
	
	UIView *_backgroundView = navBar._backgroundView;
	_backgroundView.alpha = 0.0f;
	
	UILabel *_titleView = [navBar valueForKey:@"_titleView"];
	if ([_titleView respondsToSelector:@selector(text)]) {
		_titleView.opaque = NO;
		[self punchView:_titleView];
		_titleView.alpha = 0.3f * _tintFraction;
		_titleView.textColor = _tintColor;
	}
	
	navBar.tintColor = _tintColor;
}

- (void)unpunchView:(UIView *)view {
	if (_preventPunch) return;
	//if (!view || view.alpha == 0.0f) return;
	
	if ([view respondsToSelector:@selector(_setDrawsAsBackdropOverlayWithBlendMode:)])
		[view _setBackdropMaskViewFlags:0];
	[_backdropView updateMaskViewsForView:view];
	[view _setFrameForBackdropMaskViews:view.frame];
}

- (void)reconfigureBackdropFromCurrentSettings {
	[_backdropView removeMaskViews];
	
	[self _makeBackdropView];
}

- (void)removeMaskViews {
	[_backdropView removeMaskViews];
}


- (void)_setBackgoundImage:(UIImage *)image {
	_backgroundImageView.frame = [self _getBackgroundImageFrameForArtworkSize:image.size];
	_backgroundImageView.image = image;
}

- (UIImage *)_getImageFromMPAVItem:(MPAVItem *)item {
	MPImageCache *cache = item.imageCache;
	MPMediaItem *mediaItem = item.mediaItem;
	MPMediaItemArtwork *artwork = mediaItem.artwork;
	CGSize imageSize = artwork.bounds.size;
	CGSize newSize = imageSize;
	CGFloat by = 88.0f / (MIN(imageSize.width, imageSize.height));
	newSize.width *= by;
	newSize.height *= by;
	
	UIImage *image = nil;
	
	if (MAX(imageSize.width, imageSize.height) > 568.0f) {
		NSString *artworkCacheID = [mediaItem valueForProperty:@"MPMediaItemPropertyArtworkCacheID"];
		if (artworkCacheID && [artworkCacheID longLongValue] > 1) {
			MPMediaItemImageRequest *request = [[objc_getClass("MPMediaItemImageRequest") alloc] initWithMediaItem:mediaItem];
			request.finalSize = newSize;
			request.artworkCacheID = artworkCacheID;
			request.placeHolderMediaType = 1;
			request.fillToSquareAspectRatio = YES;
			
			image = [cache cachedImageForRequest:request];
			
			if (imageSize.width != imageSize.height) {
				image = [[request _newBitmapImageFromImage:image finalSize:newSize] autorelease];
			}
			
			[request release];
		}
		
		if (image == nil) {
			MPMediaItemImageRequest *request = [item imageCacheRequestWithSize:newSize time:0.0f];
			request.finalSize = newSize;
			if ([request respondsToSelector:@selector(setFillToSquareAspectRatio:)]) {
				request.fillToSquareAspectRatio = YES;
			}
			
			image = [cache cachedImageForRequest:request];
			
			if (imageSize.width != imageSize.height) {
				image = [[request _newBitmapImageFromImage:image finalSize:newSize] autorelease];
			}
		}
	}
	
	if (image == nil) {
		image = [artwork albumImageWithSize:imageSize];
	}
	
	if (image == nil) {
		image = [artwork imageWithSize:imageSize];
	}
	
	return image;
}

- (void)_setBackgroundImageFromMPAVItem:(MPAVItem *)item {
	UIImage *image = [self _getImageFromMPAVItem:item];
	
	[self _setBackgoundImage:image];
}

- (void)_makeBackdropView {
	// 1000 = 2020 (_UIBackdropViewSettingsLight)
	//		blurRadius:             30.0
	//		grayscaleTintLevel:     0.83
	//		grayscaleTintAlpha:     0.96
	//		colorTint:              (null)
	//		colorTintAlpha:         1.00 
	// 1001 = 2030 (_UIBackdropViewSettingsDark)
	// 1002 = 2010 (_UIBackdropViewSettingsUltraLight)
	// 1003 = 2020 (_UIBackdropViewSettingsLight)
	// 1100 = 2030 (_UIBackdropViewSettingsDark)
	// 2000 no tint, no blur (_UIBackdropViewSettingsColorSample)
	//		blurRadius:             0.0
	//		grayscaleTintLevel:     0.00
	//		grayscaleTintAlpha:     0.00
	//		colorTint:              UIDeviceWhiteColorSpace 0 1
	//		colorTintAlpha:         0.00 
	// 2010 very very white tint blur (_UIBackdropViewSettingsUltraLight)
	//		blurRadius:             20.0
	//		grayscaleTintLevel:     0.97
	//		grayscaleTintAlpha:     0.80
	//		colorTint:              (null)
	//		colorTintAlpha:         1.00 
	// 2020 little white tint blur (_UIBackdropViewSettingsLight)
	//		blurRadius:             30.0
	//		grayscaleTintLevel:     1.00
	//		grayscaleTintAlpha:     0.30
	//		colorTint:              (null)
	//		colorTintAlpha:         1.00 
	// 2029 little white tint no blur (_UIBackdropViewSettingsLightLow)
	//		blurRadius:             0.0
	// 2030 little black tint blur (_UIBackdropViewSettingsDark)
	//		blurRadius:             20.0
	//		grayscaleTintLevel:     0.11
	//		grayscaleTintAlpha:     0.73
	//		colorTint:              (null)
	//		colorTintAlpha:         1.00 
	// 2039 little black tint no blur (_UIBackdropViewSettingsDarkLow)
	//		blurRadius:             0.0
	// 2040 grayscale blur (_UIBackdropViewSettingsColored)
	//		blurRadius:             10.0
	//		grayscaleTintLevel:     0.97
	//		grayscaleTintAlpha:     0.00
	//		colorTint:              UIDeviceRGBColorSpace 5 5 5 1
	//		colorTintAlpha:         0.60 
	// 2050 very black tint blur (_UIBackdropViewSettingsUltraDark)
	//		blurRadius:             10.0
	//		grayscaleTintLevel:     0.02
	//		grayscaleTintAlpha:     0.85
	//		colorTint:              (null)
	//		colorTintAlpha:         1.00 
	// 2060 little white tint more blur (_UIBackdropViewSettingsAdaptiveLight)
	//		blurRadius:             30.0
	//		grayscaleTintLevel:     1.00
	//		grayscaleTintAlpha:     0.30
	//		colorTint:              (null)
	//		colorTintAlpha:         1.00 
	// 2070 little white tint little blur (_UIBackdropViewSettingsSemiLight)
	//		blurRadius:             5.0
	//		grayscaleTintLevel:     1.00
	//		grayscaleTintAlpha:     0.15
	//		colorTint:              (null)
	//		colorTintAlpha:         1.00 
	// 2080 grayscale blur (_UIBackdropViewSettingsUltraColored)
	//		blurRadius:             20.0
	//		grayscaleTintLevel:     0.97
	//		grayscaleTintAlpha:     0.50
	//		colorTint:              UIDeviceRGBColorSpace 5 5 5 1
	//		colorTintAlpha:         0.90 
	// 2090 = 2010 (_UIBackdropViewSettingsUltraLight)
	// 10050 = 2010 (_UIBackdropViewSettingsUltraLight)
	// 10060 = 2010 (_UIBackdropViewSettingsUltraLight)
	// 10070 = 2010 (_UIBackdropViewSettingsUltraLight)
	// 10080 = 2010 (_UIBackdropViewSettingsUltraLight)
	// 10090 = 2020 (_UIBackdropViewSettingsLight)
	// 10091 green tint blur = 2040 (_UIBackdropViewSettingsColored)
	//		blurRadius:             10.0
	//		grayscaleTintLevel:     0.97
	//		grayscaleTintAlpha:     0.00
	//		colorTint:              UIDeviceRGBColorSpace 41 255 77 1
	//		colorTintAlpha:         0.60 
	// 10092 wine red tint blur = 2040 (_UIBackdropViewSettingsColored)
	//		blurRadius:             10.0
	//		grayscaleTintLevel:     0.97
	//		grayscaleTintAlpha:     0.00
	//		colorTint:              UIDeviceRGBColorSpace 1 25 12 1
	//		colorTintAlpha:         0.60 
	// 10100 = 2020 (_UIBackdropViewSettingsLight)
	// 10110 = 2010 (_UIBackdropViewSettingsUltraLight)
	// 10120 blue tint blur = 2040 (_UIBackdropViewSettingsColored)
	//		blurRadius:             10.0
	//		grayscaleTintLevel:     0.97
	//		grayscaleTintAlpha:     0.00
	//		colorTint:              UIDeviceRGBColorSpace 8 67 143 1
	//		colorTintAlpha:         0.60 
	// 11050 = 2030 (_UIBackdropViewSettingsDark)
	// 11060 = 2030 (_UIBackdropViewSettingsDark)
	// 11070 = 2050 (_UIBackdropViewSettingsUltraDark)
	_UIBackdropViewSettings *settings = nil;
	NSInteger computedStyle = _style;
	
	if (_style >= kBackdropStyleLiteBlurLight) {
		switch (_style) {
			case kBackdropStyleLiteBlurLight:
			case kBackdropStyleLiteColoredBlurLight:
				computedStyle = kBackdropStyleSystemDefaultLight;
				[self setDarkness:NO];
				break;
			case kBackdropStyleLiteBlurDark:
			case kBackdropStyleLiteBlurUltraDark:
			case kBackdropStyleLiteColoredBlurDark:
			default:
				computedStyle = kBackdropStyleSystemDefaultDark;
				[self setDarkness:YES];
				break;
			case kBackdropStyleLiteColoredBlur:
				computedStyle = kBackdropStyleSystemDefaultAdaptiveLight;
				break;
		}
		
		settings = [objc_getClass("_UIBackdropViewSettings") settingsForStyle:computedStyle graphicsQuality:_graphicQuality];
		//NSLog(@"%@\nblurRadius:             %lf\ngrayscaleTintLevel:     %lf\ngrayscaleTintAlpha:     %lf\ncolorTint:              %@\ncolorTintAlpha:         %lf", settings, settings.blurRadius, settings.grayscaleTintLevel, settings.grayscaleTintAlpha, settings.colorTint, settings.colorTintAlpha);
		settings.blurRadius = 7.0f;
		
		if (_style != kBackdropStyleLiteColoredBlur) {
			if (_isDarkness) {
				settings.grayscaleTintAlpha = 0.8f; // 0.73 (dark)
				settings.grayscaleTintLevel = 0.05f; // 0.11 (dark)
				
				// color tint
				settings.colorTintAlpha = 0.2f;
			}
			else {
				settings.grayscaleTintAlpha = 0.3f; // 0.3 (white)
				settings.grayscaleTintLevel = 0.8f; // 1.0 (white)
				
				// color tint
				settings.colorTintAlpha = 0.4f;
			}
		}
		else {
			settings.grayscaleTintAlpha = 0.97f;
			settings.grayscaleTintLevel = 0.0f;
			
			// color tint
			settings.colorTintAlpha = 0.6f;
		}
	}
	else {
		switch (_style) {
			case kBackdropStyleSystemDefaultClear:
			case kBackdropStyleSystemDefaultUltraLight:
			case kBackdropStyleSystemDefaultLight:
			case kBackdropStyleSystemDefaultLightLow:
			case kBackdropStyleSystemDefaultAdaptiveLight:
			case kBackdropStyleSystemDefaultSemiLight:
				[self setDarkness:NO];
				break;
			case kBackdropStyleSystemDefaultBlur:
			case kBackdropStyleSystemDefaultDark:
			case kBackdropStyleSystemDefaultDarkLow:
			case kBackdropStyleSystemDefaultUltraDark:
				[self setDarkness:YES];
				break;
			case kBackdropStyleSystemDefaultGray:
			case kBackdropStyleSystemDefaultUltraGray:
				computedStyle = kBackdropStyleSystemDefaultLight;
				break;
			case kBackdropStyleSystemDefaultGreen:
			case kBackdropStyleSystemDefaultRed:
			case kBackdropStyleSystemDefaultBlue:
				[self setDarkness:NO];
				break;
			default:
				[self setDarkness:YES];
				computedStyle = kBackdropStyleSystemDefaultAdaptiveLight;
				break;
		}
		
		settings = [objc_getClass("_UIBackdropViewSettings") settingsForStyle:computedStyle graphicsQuality:_graphicQuality];
		//NSLog(@"%@\nblurRadius:             %lf\ngrayscaleTintLevel:     %lf\ngrayscaleTintAlpha:     %lf\ncolorTint:              %@\ncolorTintAlpha:         %lf", settings, settings.blurRadius, settings.grayscaleTintLevel, settings.grayscaleTintAlpha, settings.colorTint, settings.colorTintAlpha);
		
		settings.colorTintAlpha = 0.6f;
		
		if (_style == kBackdropStyleSystemDefaultGray) {
			settings.blurRadius = 10.0f;
			settings.grayscaleTintAlpha = 0.0f;
			settings.grayscaleTintLevel = 0.97f;
		}
		else if (_style == kBackdropStyleSystemDefaultUltraGray) {
			settings.blurRadius = 20.0f;
			settings.grayscaleTintAlpha = 0.50f;
			settings.grayscaleTintLevel = 0.97f;
			
			settings.colorTintAlpha = 0.9f;
		}
		else if (_style >= kBackdropStyleSystemDefaultGreen) {
			settings.grayscaleTintAlpha = 0.0f;
			settings.grayscaleTintLevel = 1.0f;
			
			settings.colorTintAlpha = 0.3f;
		}
	}
	//NSLog(@"@@@@@@@@@@@@ %@", settings);
	if (_blurRadius >= 0.0f)
		settings.blurRadius = _blurRadius;
	
	// color tint
	if (_backgroundTintColor) {
		settings.usesColorTintView = YES;
		settings.colorTint = _backgroundTintColor;
	}
	
	if (!_blursBackground) {
		settings.colorTintAlpha = 1.0f;
	}
	
	if (_backdropView) {
		[_backdropView transitionToSettings:settings];
	}
	else {
		_backdropView = [[objc_getClass("_UIBackdropView") alloc] initWithSettings:settings];
		_backdropView.maskMode = 0;
		_backdropView.groupName = @"GlareAppsBackdropBackgroundView";
	}
	
	//[_backdropView _setBlursBackground:![self isParallaxEnabled] && _blursBackground];
	
	[self _setBlurRadius:_backdropView.blurRadius];
}

- (CGRect)_getBackgroundImageFrameForArtworkSize:(CGSize)artworkImageSize {
	CGRect f = self.frame;
	
	CGFloat minAlbumArtSize = MIN(artworkImageSize.width, artworkImageSize.height);
	CGFloat maxScreenSize = MAX(f.size.width, f.size.height);
	if ((UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)) {
		minAlbumArtSize = artworkImageSize.height;
		maxScreenSize = f.size.height;
	}
	CGFloat by = maxScreenSize / minAlbumArtSize * (_parallaxEnabled ? 1.2 : 1.0);
	CGFloat newWidth = artworkImageSize.width * by;
	CGFloat newHeight = artworkImageSize.height * by;
	
	f.origin.x = -((newWidth - f.size.width) / 2);
	f.origin.y = -((newHeight - f.size.height) / 2);
	f.size.width = newWidth;
	f.size.height = newHeight;
	
	return f;
}

- (void)updateBackgroundImage:(UIImage *)image animated:(BOOL)animated {
	if (animated) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (_isFlickerTransition) {
				[UIView animateWithDuration:0.3f
				animations:^{
					_backgroundImageView.alpha = 0.0;
				}
				completion:^(BOOL finished){
					[self _setBackgoundImage:image];
					
					[UIView animateWithDuration:0.3f
					animations:^{
						_backgroundImageView.alpha = 1.0;
					}];
				}];
			}
			else {
				_backgroundImageView.frame = [self _getBackgroundImageFrameForArtworkSize:image.size];
				
				[UIView transitionWithView:_backgroundImageView
				duration:0.6f
				options:UIViewAnimationOptionTransitionCrossDissolve
				animations:^{
					_backgroundImageView.image = image;
				}
				completion:nil];
			}
		});
	}
	else {
		[self _setBackgoundImage:image];
	}
}

- (void)updateBackgroundViewForOrientation:(UIInterfaceOrientation)orientation {
	_latestOrientation = orientation;
	
	if (_backgroundImageView.image)
		_backgroundImageView.frame = [self _getBackgroundImageFrameForArtworkSize:_backgroundImageView.image.size];
}

@end
