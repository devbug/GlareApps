
#import "MessageUI.h"



%hook MFComposeRecipientView

- (void)layoutSubviews {
	%orig;
	
	self.textField.textColor = [colorHelper commonTextColor];
	self.textField.backgroundColor = [colorHelper clearColor];
	self.backgroundColor = [colorHelper clearColor];
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
