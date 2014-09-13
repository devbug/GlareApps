
#import "PhotoLibrary.h"



%hook PLCameraView

- (void)layoutSubviews {
	%orig;
	
	self._previewMaskingView.backgroundColor = [colorHelper clearColor];
}

%end


%hook PLWallpaperButton

- (void)_setupBackdropView {
	%orig;
	
	[self setTitleColor:[colorHelper commonTextColor] forState:UIControlStateNormal];
}

%end


%hook PLPhotoCommentEntryView

- (void)layoutSubviews {
	%orig;
	
	self.placeholderLabel.textColor = [colorHelper systemGrayColor];
}

%end

%hook PLCommentsViewController

- (void)_updateLayerMaskWithBoundsChange {
	%orig;
	
	UIImageView *_gradientView = MSHookIvar<UIImageView *>(self, "_gradientView");
	_gradientView.image = [_gradientView.image _flatImageWithColor:[colorHelper lightTextColor]];
}

%end


%hook PLEditPhotoController

// 만약 backdropview를 전체 스타일처럼 변경한다면 툴바 아이콘 색깔도 변경이 필요.
// 그때 쓰면 됨.
/*- (id)_newButtonItemWithIcon:(id)icon title:(id)title target:(id)target action:(SEL)action tag:(NSInteger)tag {
	UIBarButtonItem *item = %orig;
	UIButton *customView = (UIButton *)item.customView;
	UIImage *image = [customView imageForState:UIControlStateNormal];
	
	image = [image _flatImageWithColor:[colorHelper commonTextColor]];
	[customView setImage:image forState:UIControlStateNormal];
	
	return item;
}*/

// 툴바, navbar의 스타일을 원본 스타일(Dark)처럼 적용시킴.
- (void)viewDidAppear:(BOOL)animated {
	%orig;
	
	self.toolbar.barStyle = UIBarStyleBlack;
	self.navigationBar.barStyle = UIBarStyleBlack;
	
	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleSystemDefaultDark];
	settings.blurRadius = 22.0f;
	
	_UIBackdropView *_adaptiveBackdrop = MSHookIvar<_UIBackdropView *>(self.toolbar, "_adaptiveBackdrop");
	if ([_adaptiveBackdrop isKindOfClass:[_UIBackdropView class]])
		[_adaptiveBackdrop transitionToSettings:settings];
	
	_adaptiveBackdrop = MSHookIvar<_UIBackdropView *>(self.navigationBar._backgroundView, "_adaptiveBackdrop");
	if ([_adaptiveBackdrop isKindOfClass:[_UIBackdropView class]])
		[_adaptiveBackdrop transitionToSettings:settings];
}

%end

%hook PLEffectSelectionViewControllerView

// effect 배경 스타일을 원본 스타일(Dark)처럼 적용시킴.
- (void)layoutSubviews {
	%orig;
	
	if (self.subviews.count > 0) {
		_UIBackdropView *backdropView = self.subviews[0];
		if ([backdropView isKindOfClass:[_UIBackdropView class]]) {
			_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleSystemDefaultDark];
			settings.blurRadius = 22.0f;
			
			[backdropView transitionToSettings:settings];
		}
	}
}

%end



%ctor {
	if (!isThisAppEnabled()) return;
	
	%init;
}
