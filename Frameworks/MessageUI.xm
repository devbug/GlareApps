
#import "MessageUI.h"



%hook MFComposeHeaderView

- (void)layoutSubviews {
	%orig;
	
	UIView *_separator = MSHookIvar<UIView *>(self, "_separator");
	_separator.backgroundColor = [colorHelper defaultTableViewSeparatorColor];
}

%end


%hook MFComposeRecipientView

- (void)layoutSubviews {
	%orig;
	
	self.textField.textColor = [colorHelper commonTextColor];
	self.textField.backgroundColor = [colorHelper clearColor];
	self.backgroundColor = [colorHelper clearColor];
}

%end


%hook MFComposeRecipientTextView

- (void)layoutSubviews {
	%orig;
	
	self.textView.textColor = [colorHelper commonTextColor];
	self.textView.backgroundColor = [colorHelper clearColor];
	self.backgroundColor = [colorHelper clearColor];
}

- (void)atomTextViewDidBecomeFirstResponder:(UITextView *)textView {
	%orig;
	
	self.textView.textColor = [colorHelper commonTextColor];
	self.textView.backgroundColor = [colorHelper clearColor];
}

- (void)textViewDidChange:(UITextView *)textView {
	%orig;
	
	self.textView.textColor = [colorHelper commonTextColor];
	self.textView.backgroundColor = [colorHelper clearColor];
}

%end


%hook MFMailComposeView

- (BOOL)presentSearchResults:(NSArray *)searchResults {
	BOOL rtn = %orig;
	
	if (isPad) return rtn;
	
	UITableView *_searchResultsTable = MSHookIvar<UITableView *>(self, "_searchResultsTable");
	
	_UIBackdropView *backdropView = (_UIBackdropView *)[self.bodyScroller viewWithTag:0xc001];
	[backdropView retain];
	[backdropView removeFromSuperview];
	
	if (backdropView == nil) {
		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleForWhiteness graphicsQuality:kBackdropGraphicQualitySystemDefault];
		
		backdropView = [[_UIBackdropView alloc] initWithFrame:_searchResultsTable.frame autosizesToFitSuperview:NO settings:settings];
		backdropView.tag = 0xc001;
		
		[colorHelper addBlurView:backdropView];
	}
	
	backdropView.frame = _searchResultsTable.frame;
	backdropView.alpha = 1.0f;
	
	[self.bodyScroller insertSubview:backdropView belowSubview:_searchResultsTable];
	
	[backdropView release];
	
	return rtn;
}

- (void)dismissSearchResults {
	_UIBackdropView *backdropView = (_UIBackdropView *)[self.bodyScroller viewWithTag:0xc001];
	backdropView.alpha = 0.0f;
	
	%orig;
}

- (void)layoutSubviews {
	%orig;
	
	UITableView *_searchResultsTable = MSHookIvar<UITableView *>(self, "_searchResultsTable");
	_UIBackdropView *backdropView = (_UIBackdropView *)[self.bodyScroller viewWithTag:0xc001];
	backdropView.frame = _searchResultsTable.frame;
	backdropView.alpha = _searchResultsTable.superview != nil ? 1.0f : 0.0f;
}

- (void)_layoutSubviews:(BOOL)unknown changingView:(id)view toSize:(CGSize)unknownSize searchResultsWereDismissed:(BOOL)searchResultsDismissed {
	%orig;
	
	UITableView *_searchResultsTable = MSHookIvar<UITableView *>(self, "_searchResultsTable");
	_UIBackdropView *backdropView = (_UIBackdropView *)[self.bodyScroller viewWithTag:0xc001];
	
	backdropView.alpha = _searchResultsTable.superview != nil ? 1.0f : 0.0f;
}

%end


%hook MFRecipientTableViewCellDetailView

- (void)layoutSubviews {
	%orig;
	
	if ([[self.tintColor description] hasPrefix:@"UIDeviceWhiteColorSpace"]) {
		self.detailLabel.textColor = [colorHelper systemGrayColor];
		self.labelLabel.textColor = [colorHelper systemGrayColor];
	}
	
	self.detailLabel.backgroundColor = [colorHelper clearColor];
	self.labelLabel.backgroundColor = [colorHelper clearColor];
	self.backgroundColor = [colorHelper clearColor];
}

%end


%hook MFRecipientTableViewCellTitleView

- (void)layoutSubviews {
	%orig;
	
	if ([[self.tintColor description] hasPrefix:@"UIDeviceWhiteColorSpace"])
		self.titleLabel.textColor = [colorHelper commonTextColor];
	
	self.titleLabel.backgroundColor = [colorHelper clearColor];
	self.backgroundColor = [colorHelper clearColor];
}

%end


%hook MFRecipientTableViewCell

- (void)layoutSubviews {
	%orig;
	
	MFRecipientTableViewCellDetailView *_detailView = MSHookIvar<MFRecipientTableViewCellDetailView *>(self, "_detailView");
	MFRecipientTableViewCellTitleView *_titleView = MSHookIvar<MFRecipientTableViewCellTitleView *>(self, "_titleView");
	_detailView.backgroundColor = [colorHelper clearColor];
	_titleView.backgroundColor = [colorHelper clearColor];
}

%end



%ctor {
	if (!isThisAppEnabled()) return;
	
	%init;
}
