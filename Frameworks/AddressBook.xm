
#import "AddressBook.h"



%hook ABMemberCell

- (void)layoutSubviews {
	%orig;
	
	self.backgroundColor = [colorHelper clearColor];
	self.contactNameView.backgroundColor = [colorHelper clearColor];
	
	if (isFirmware70) {
		self.contactNameView.meLabel.backgroundColor = [colorHelper clearColor];
		self.contactNameView.meLabel.textColor = [colorHelper systemGrayColor];
		self.contactNameView.nameLabel.backgroundColor = [colorHelper clearColor];
	}
}

%end


%hook ABMemberNameView

- (BOOL)isUserInteractionEnabled {
	return %orig;//YES;
}

- (void)drawRect:(CGRect)rect {
	self.backgroundColor = [colorHelper clearColor];
	
	BOOL isHighlighted = self.highlighted;
	self.highlighted = YES;
	
	%orig;
	
	self.highlighted = isHighlighted;
}

%end


%hook ABMembersController

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	
	self.currentTableView.backgroundColor = [colorHelper clearColor];
	self.currentTableView.sectionIndexBackgroundColor = [colorHelper defaultTableViewCellBackgroundColor];
}

%end



%hook ABStyleProvider

- (UIColor *)groupCellTextColor {
	return [colorHelper commonTextColor];
}

- (BOOL)groupsTableShouldRemoveBackgroundView {
	return YES;
}

- (BOOL)peoplePickerBarStyleIsTranslucent {
	return YES;
}

- (UIBarStyle)peoplePickerBarStyle {
	return kBarStyleForWhiteness;
}

- (BOOL)shouldUsePeoplePickerBarStyle {
	return YES;
}

- (id)cardCellBackgroundColor {
	return [colorHelper clearColor];
}

- (UIColor *)cardLabelBackgroundColor {
	return [colorHelper clearColor];
}

- (id)cardCellDividerColorVertical:(BOOL)vertical {
	return [colorHelper lightTextColor];
}

- (UIColor *)memberNameTextColor {
	return [colorHelper commonTextColor];
}

- (UIColor *)cardValueTextColor {
	return [colorHelper commonTextColor];
}

%end


%hook ABPeoplePickerNavigationController

- (BOOL)__glareapps_shouldRemoveBackdropAfterPresenting {
	return YES;
}

%end

%hook ABAccountsAndGroupsNavigationController

- (BOOL)__glareapps_shouldRemoveBackdropAfterPresenting {
	return YES;
}

%end


%hook ABPropertyCell

- (void)layoutSubviews {
	%orig;
	
	self.valueLabel.backgroundColor = [colorHelper clearColor];
	self.labelLabel.backgroundColor = [colorHelper clearColor];
}

%end


%hook ABPropertyNameCell

- (void)setBackgroundColor:(UIColor *)color {
	//%orig([colorHelper clearColor]);
	
	objc_super $super = {self, [UITableViewCell class]};
	objc_msgSendSuper(&$super, @selector(setBackgroundColor:), color);
}

%end


@interface UILabel (TextAttributes)
- (id)textAttributes;
- (void)setTextAttributes:(id)arg1;
@end

%hook ABPropertyNoteCell

- (void)setBackgroundColor:(UIColor *)color {
	//%orig([colorHelper clearColor]);
	
	objc_super $super = {self, [UITableViewCell class]};
	objc_msgSendSuper(&$super, @selector(setBackgroundColor:), color);
}

- (void)setLabelTextAttributes:(NSDictionary *)attributes {
	%orig;
	
	NSDictionary *&labelTextAttributes = MSHookIvar<NSDictionary *>(self, "_labelTextAttributes");
	NSDictionary *privDict = self.labelTextAttributes;
	[privDict retain];
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:privDict];
	
	dict[@"NSColor"] = [colorHelper systemGrayColor];
	
	[self.labelLabel setTextAttributes:dict];
	
	labelTextAttributes = [dict copy];
	
	[privDict release];
}

%end


%hook ABContactCell

- (void)setSeparatorColor:(UIColor *)color {
	%orig([colorHelper defaultTableViewSeparatorColor]);
}

- (void)setContactSeparatorColor:(UIColor *)color {
	%orig([colorHelper defaultTableViewSeparatorColor]);
}

- (void)layoutSubviews {
	%orig;
	
	self.backgroundColor = [colorHelper clearColor];
	self.textLabel.backgroundColor = [colorHelper clearColor];
	
	if (useBlendedMode)
		blendView(self.separatorView);
}

- (void)setBackgroundColor:(UIColor *)color {
	//%orig([colorHelper clearColor]);
	
	objc_super $super = {self, [UITableViewCell class]};
	objc_msgSendSuper(&$super, @selector(setBackgroundColor:), color);
}

%end


%hook ABContactHeaderView

- (void)layoutSubviews {
	%orig;
	
	UILabel *_nameLabel = MSHookIvar<UILabel *>(self, "_nameLabel");
	UILabel *_taglineLabel = MSHookIvar<UILabel *>(self, "_taglineLabel");
	
	_nameLabel.backgroundColor = [colorHelper clearColor];
	_taglineLabel.backgroundColor = [colorHelper clearColor];
}

%end


%hook ABGroupHeaderFooterView

- (void)updateConstraints {
	%orig;
	
	self.backgroundColor = nil;
	self.contentView.backgroundColor = [colorHelper clearColor];
	self.tintColor = nil;
	if ([self respondsToSelector:@selector(setBackgroundImage:)])
		self.backgroundImage = nil;
	
	self.backgroundView.alpha = 0.0f;
}

%end


%hook ABBannerView

- (void)_updateLabel {
	%orig;
	
	self.textLabel.textColor = [colorHelper commonTextColor];
}

%end


%hook ABContactView

- (void)setBackgroundColor:(UIColor *)color {
	%orig([colorHelper clearColor]);
}

%end


%hook UIColor

+ (id)cardCellSeparatorColor {
	return [colorHelper defaultTableViewSeparatorColor];
}
+ (id)cardCellReadonlyBackgroundColor {
	return %orig;
}
+ (id)cardBackgroundInPopoverColor {
	return [colorHelper themedFakeClearColor];
}
+ (id)cardCellBackgroundColor {
	return [colorHelper defaultTableViewCellBackgroundColor];
}
+ (id)cardValueReadonlyTextColor {
	return %orig;
}
+ (id)cardValueTextColor {
	return [colorHelper commonTextColor];
}
+ (id)cardLabelReadonlyTextColor {
	return %orig;
}

%end



%ctor {
	if (!isThisAppEnabled()) return;
	
	%init;
}
