
#import "CommunicationsSetupUI.h"



%hook CNFRegSigninLearnMoreView

- (void)layoutSubviews {
	%orig;
	
	self.titleLabel.textColor = [colorHelper commonTextColor];
	self.verbiageLabel.textColor = [colorHelper commonTextColor];
	
	self.userPassBox.alpha = 0.2f;
}

%end

%hook CNFRegTableLabel

- (void)layoutSubviews {
	%orig;
	
	UILabel *_label = MSHookIvar<UILabel *>(self, "_label");
	_label.textColor = [colorHelper commonTextColor];
}

%end



%ctor {
	if (!isThisAppEnabled()) return;
	
	%init;
}
