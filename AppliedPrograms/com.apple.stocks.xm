
#import "headers.h"



@interface StocksListView : UIView @end
@interface StocksStatusView : UIView
- (void)setCurrentPage:(NSInteger)arg1;
@end

@interface StocksMainView : UIView {
	UIView *_blurView;
}
- (StocksStatusView *)statusView;
- (UIView *)detailView;
- (StocksListView *)listView;
@end

@interface StocksListTableViewCell : UITableViewCell @end

@interface StocksMainController : UIViewController
- (StocksMainView *)stocksView;
@end

@interface StocksBacksideTableViewCell : UITableViewCell @end
@interface StocksBacksideView : UIView @end



%hook UIColor

+ (id)whiteColor {
	return [colorHelper commonTextColor];
}

+ (id)colorWithWhite:(CGFloat)white alpha:(CGFloat)alpha {
	if (!isWhiteness) return %orig;
	
	if (white == 0.0f || alpha == 0.0f) return %orig;
	
	/*if (white == 1.0f && alpha == 0.1f) {
		return %orig(1.0 - white, alpha);
	}
	if (white == 1.0f && alpha == 0.2f) {
		return %orig(1.0 - white, alpha);
	}
	if (white == 1.0f && alpha == 0.3f) {
		return %orig(1.0 - white, alpha);
	}
	if (white == 1.0f && alpha == 0.4f) {
		return %orig(1.0 - white, alpha);
	}
	if (white == 1.0f && alpha == 0.6f) {
		return %orig(1.0 - white, alpha);
	}
	if (white == 1.0f && alpha == 0.75f) {
		return %orig(1.0 - white, alpha);
	}
	if (white == 1.0f && alpha == 0.8f) {
		return %orig(1.0 - white, alpha);
	}*/
	if (white == 1.0f) {
		return %orig(0.0f, alpha);
	}
	if (white == 0.8f && alpha == 1.0f) {
		return %orig(1.0 - white, alpha);
	}
	if (white == 0.97f && alpha == 0.8f) {
		return %orig(1.0 - white, alpha);
	}
	if (white == 0.97f && alpha == 0.9f) {
		return %orig(1.0 - white, alpha);
	}
	if ((int)(white * 255) == 250 && alpha == 1.0f) {
		return %orig(1.0 - white, alpha);
	}
	if ((int)(white * 255) == 115 && alpha == 0.4f) {
		return %orig(1.0 - white, alpha);
	}
	
	return %orig;
}

+ (id)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	if (!isWhiteness) return %orig;
	
	if ((int)(red * 255) == 111 && (int)(green * 255) == 113 && (int)(blue * 255) == 116 && alpha == 1.0f) {
		return %orig(red/2.0, green/2.0, blue/2.0, alpha);
	}
	if ((int)(red * 255) == 242 && (int)(green * 255) == 247 && blue == 1.0f && alpha == 1.0f) {
		return %orig(0.0, 0.0, 0.0, 1.0f);
	}
	if ((int)(red * 255) == 140 && (int)(green * 255) == 143 && (int)(blue * 255) == 147 && alpha == 1.0f) {
		return %orig(red/2.0, green/2.0, blue/2.0, alpha);
	}
	if (red == 1.0f && green == 1.0f && blue == 1.0f && alpha == 0.3f) {
		return %orig(0.0, 0.0, 0.0, alpha);
	}
	
	return %orig;
}

%end

%hook StocksMainView

- (id)initWithFrame:(CGRect)frame {
	StocksMainView *rtn = %orig;
	
	if (rtn) {
		_UIBackdropView *_blurView = MSHookIvar<_UIBackdropView *>(rtn, "_blurView");
		
		if ([_blurView isKindOfClass:[_UIBackdropView class]]) {
			_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleForWhiteness graphicsQuality:UIBackdropGraphicsQualitySystemDefault];
			//settings.grayscaleTintAlpha = 0.0f;
			settings.blurRadius = 10.0f;
			
			[_blurView transitionToSettings:settings];
		}
		
		rtn.statusView.backgroundColor = [colorHelper clearColor];
		rtn.detailView.backgroundColor = [colorHelper clearColor];
	}
	
	return rtn;
}

%end


%hook StocksListTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	%orig;
	
	if (!selected) {
		self.backgroundColor = [colorHelper clearColor];
	}
	else {
		self.backgroundColor = [colorHelper stocksListTableViewCellSelectedColor];
	}
}

- (void)layoutSubviews {
	%orig;
	
	UILabel *_symbolLabel = MSHookIvar<UILabel *>(self, "_symbolLabel");
	UILabel *_priceLabel = MSHookIvar<UILabel *>(self, "_priceLabel");
	UILabel *_boxLabel = MSHookIvar<UILabel *>(self, "_boxLabel");
	
	_symbolLabel.textColor = [colorHelper commonTextColor];
	_priceLabel.textColor = [colorHelper commonTextColor];
	if (isWhiteness)
		_boxLabel.textColor = colorHelper.whiteColor;
}

%end


%hook StockMainChartView

- (void)layoutSubviews {
	%orig;
	
	UIView *_titleView = MSHookIvar<UIView *>(self, "_titleView");
	_titleView.backgroundColor = [colorHelper clearColor];
}

%end


%hook StocksBacksideTableViewCell

- (void)layoutSubviews {
	%orig;
	
	self.backgroundColor = [colorHelper clearColor];
}

%end


%hook StocksBacksideView

- (void)layoutSubviews {
	%orig;
	
	self.backgroundColor = [colorHelper clearColor];
}

%end



%ctor {
	if (!isThisAppEnabled()) return;
	
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.stocks"]) {
		%init;
	}
}
