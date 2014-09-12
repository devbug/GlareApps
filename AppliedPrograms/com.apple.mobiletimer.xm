
#import "headers.h"



@interface MTStopwatchControlsView : UIView @end

@interface AlarmTableViewCell : UITableViewCell @end

@interface AnalogClockView : UIView
@property(readonly, nonatomic, getter=isNighttime) BOOL nighttime;
@end

@interface WorldClockView : UIView
@property(readonly, nonatomic) UILabel *weatherLabel;
@property(readonly, nonatomic) UILabel *dayLabel;
@property(readonly, nonatomic) UILabel *nameLabel;
@property(readonly, nonatomic) AnalogClockView *analogClock;
@property(nonatomic, assign) id /*<WorldClockViewBackgroundHost>*/ backgroundHost;
@property(nonatomic) NSInteger appearance;
@end
@interface WorldClockCellView : UIView
@property(readonly, nonatomic) UILabel *combinedLabel;
@end

@class FullScreenWorldClockCollectionCell;
@protocol FullScreenWorldClockCollectionCellDelegate <NSObject>
- (void)cellBackgroundDidUpdate:(FullScreenWorldClockCollectionCell *)arg1 isDayTime:(BOOL)arg2;
@end

@interface FullScreenWorldClockCollectionCell : UICollectionViewCell /*<WorldClockViewBackgroundHost>*/ {
	WorldClockView *_clockView;
}
+ (id)dayTimeBackgroundColor;
+ (id)nightTimeBackgroundColor;
@property(nonatomic, assign) id <FullScreenWorldClockCollectionCellDelegate> delegate;
@property(readonly, nonatomic) WorldClockView *clockView;
@property(readonly, nonatomic) UIView *clockBackground;
- (void)updateBackground:(BOOL)isDayTime;
@end

@interface WorldClockCollectionCell : UICollectionViewCell
@property(retain, nonatomic) WorldClockView *clockView;
@end
@interface WorldClockCollectionView : UICollectionView @end
@interface WorldClockPadContentView : UIView
@property(readonly, nonatomic) WorldClockCollectionView *clocksView;
@end

@interface MTCircleButton : UIButton
@property(readonly, nonatomic) NSUInteger size;
@end

@interface AlarmScheduleCollectionView : UICollectionView @end
@interface AlarmScheduleHeaderView : UIView @end
@interface AlarmScheduleView : UIView
@property(readonly, nonatomic) AlarmScheduleCollectionView *alarmsView;
@property(readonly, nonatomic) AlarmScheduleHeaderView *headerView;
@end

@interface AlarmScheduleGridView : UIView @end

@interface LapPadTableViewCell : UITableViewCell @end
@interface LapPadTableViewHeaderView : UIView @end

@interface AddClockViewController : UITableViewController @end


enum {
	kMTButtonColorBlack = 0,
	kMTButtonColorRed,
	kMTButtonColorGreen,
	kMTButtonColorGray,
};

enum {
	kMTButtonStyleNormal = 0,
	kMTButtonStyleStop,
	kMTButtonStyleStart,
	kMTButtonStyleDisabled,
};


extern "C" UIColor *MTButtonColor(NSUInteger type);
extern "C" UIColor *MTButtonTextColor(NSUInteger type);
extern "C" UIImage *MTButtonCircleImageForColorAndSize(NSUInteger type, NSUInteger size);



UIColor *(*origin_MTButtonColor)(NSUInteger type) = NULL;

UIColor *new_MTButtonColor(NSUInteger type) {
	UIColor *color = nil;
	
	switch (type) {
		default:
		case kMTButtonStyleNormal:
			break;
		case kMTButtonStyleStop:
			break;
		case kMTButtonStyleStart:
			break;
		case kMTButtonStyleDisabled:
			break;
	}
	
	return color;
}


UIColor *(*origin_MTButtonTextColor)(NSUInteger type) = NULL;

UIColor *new_MTButtonTextColor(NSUInteger type) {
	UIColor *color = nil;
	
	switch (type) {
		default:
		case kMTButtonStyleNormal:
			break;
		case kMTButtonStyleStop:
			break;
		case kMTButtonStyleStart:
			break;
		case kMTButtonStyleDisabled:
			break;
	}
	
	return color;
}


%hook MTCircleButton

- (void)setColor:(NSUInteger)colorType forState:(UIControlState)state {
	// original routine
	//[self setTitleColor:MTButtonTextColor(colorType) forState:state];
	//[self setBackgroundImage:MTButtonCircleImageForColorAndSize(colorType, self.size), forState:state];
	
	//%orig;
	
	UIColor *color = MTButtonTextColor(colorType);
	[self setTitleColor:(colorType == kMTButtonStyleDisabled ? color : [UIColor colorWithWhite:1.0f alpha:kFullAlphaFactor]) 
			   forState:state];
	
	UIImage *image = MTButtonCircleImageForColorAndSize(colorType, self.size);
	image = [image _flatImageWithColor:color];
	
	[self setBackgroundImage:image forState:state];
}

- (void)setBackgroundColor:(UIColor *)color {
	%orig([UIColor clearColor]);
}

%end



%hook MTTimerPickerView

- (void)setBackgroundColor:(id)color {
	%orig([UIColor clearColor]);
}

- (void)internalSetBackgroundColor:(id)color {
	%orig([UIColor clearColor]);
}

%end


%hook MTStopwatchControlsView

- (void)layoutSubviews {
	%orig;
	
	self.backgroundColor = [UIColor clearColor];
	
	UIView *_buttonsBackgroundView = MSHookIvar<UIView *>(self, "_buttonsBackgroundView");
	_buttonsBackgroundView.backgroundColor = [UIColor clearColor];
}

%end


%hook AlarmTableViewCell

- (void)setBackgroundColor:(id)color {
	%orig([UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kJustClearAlphaFactor]);
}

- (void)internalSetBackgroundColor:(id)color {
	%orig([UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:kJustClearAlphaFactor]);
}

%end


%hook WorldClockCellView

- (void)layoutSubviews {
	%orig;
	
	self.combinedLabel.textColor = [UIColor colorWithWhite:kLightColorWithWhiteForWhiteness alpha:1.0f];
}

%end


%hook WorldClockView

- (void)updateColorThemeForFullscreen {
	%orig;
	
	self.dayLabel.textColor = [UIColor colorWithWhite:0.7f alpha:kFullAlphaFactor];
}

%end


%hook FullScreenWorldClockCollectionController

- (void)dismiss {
	%orig;
	
	[[UIApplication sharedApplication] setStatusBarStyle:kBarStyleForWhiteness];
}

%end


%hook UILabel

- (BOOL)__glareapps_isActionSheetOrActivityGroup {
	if ([self.superview isKindOfClass:%c(WorldClockView)]) {
		WorldClockView *clockView = (WorldClockView *)self.superview;
		// if fullscreen WorldClockView
		if (clockView.appearance == 3)
			return YES;
	}
	if ([self.superview isKindOfClass:%c(AlarmScheduleGridView)]) return YES;
	
	return %orig;
}

%end


%hook AlarmScheduleHeaderView

- (id)newDateLabel {
	UILabel *label = %orig;
	
	label.backgroundColor = [UIColor clearColor];
	
	return label;
}

- (void)setBackgroundColor:(id)color {
	%orig([UIColor clearColor]);
}

%end


%hook AlarmScheduleGridView

- (void)layoutSubviews {
	%orig;
	
	self.backgroundColor = [UIColor clearColor];
	
	NSMutableArray *_hourLabels = MSHookIvar<NSMutableArray *>(self, "_hourLabels");
	for (UILabel *label in _hourLabels) {
		label.textColor = [UIColor colorWithWhite:0.0f alpha:kFullAlphaFactor];
	}
}

%end


%hook LapPadTableViewHeaderView

- (void)layoutSubviews {
	%orig;
	
	UILabel *_leftColumnHeader = MSHookIvar<UILabel *>(self, "_leftColumnHeader");
	UILabel *_centerColumnHeader = MSHookIvar<UILabel *>(self, "_centerColumnHeader");
	UILabel *_rightColumnHeader = MSHookIvar<UILabel *>(self, "_rightColumnHeader");
	
	_leftColumnHeader.backgroundColor = [UIColor clearColor];
	_centerColumnHeader.backgroundColor = [UIColor clearColor];
	_rightColumnHeader.backgroundColor = [UIColor clearColor];
	
	self.backgroundColor = [UIColor clearColor];
}

%end


%hook LapPadTableViewCell

- (void)setBackgroundColor:(id)arg1 {
	%orig([UIColor clearColor]);
}

- (void)internalSetBackgroundColor:(id)arg1 {
	%orig([UIColor clearColor]);
}

%end


%hook StopwatchPadControls

- (void)_setControlsBackgroundColor {
	UILabel *_currentLapTimeLabel = MSHookIvar<UILabel *>(self, "_currentLapTimeLabel");
	_currentLapTimeLabel.backgroundColor = [UIColor clearColor];
}

%end


%hook TimerPadControlsView

- (void)layoutSubviews {
	%orig;
	
	UIImageView *_circleBackground = MSHookIvar<UIImageView *>(self, "_circleBackground");
	_circleBackground.alpha = 0.3f;
	
	UIButton *_toneButton = MSHookIvar<UIButton *>(self, "_toneButton");
	_toneButton.backgroundColor = [UIColor clearColor];
}

%end


%hook AddClockViewController

- (void)viewDidLoad {
	%orig;
	
	UINavigationBar *navBar = self.navigationItem.navigationBar;
	navBar.translucent = YES;
}

%end


%hook UITableViewCell

- (BOOL)__glareapps_isNeedsToSetJustClearBackground {
	return YES;
}

%end




%ctor {
	if (!isThisAppEnabled()) return;
	
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.mobiletimer"]) {
		//MSHookFunction((void *)MTButtonColor, (void *)new_MTButtonColor, (void **)&origin_MTButtonColor);
		//MSHookFunction((void *)MTButtonTextColor, (void *)new_MTButtonTextColor, (void **)&origin_MTButtonTextColor);
		
		%init;
	}
}
