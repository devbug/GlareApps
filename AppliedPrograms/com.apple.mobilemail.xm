
#import "headers.h"



@interface MailboxContentViewController : UIViewController
@property(retain, nonatomic) UITableView *tableView;
@end

@interface MailboxListViewControllerMail : UITableViewController @end

@interface ThreadBannerView : UITableViewHeaderFooterView
- (void)setBackgroundView:(id)arg1;
- (UIView *)backgroundView;
@end

@interface MailboxContentViewCell : UITableViewCell
@property(retain, nonatomic) UIColor *originalBackgroundColor;
@end

@interface _CellStaticView : UIView
@property(retain, nonatomic) UIColor *originalBackgroundColor;
@end

@interface MessageHeaderHeader : UIView @end

/*@interface DOMNode : NSObject
@property(copy) NSString *textContent;
@end
@interface DOMElement : DOMNode
@property(readonly) DOMCSSStyleDeclaration *style;
@end
@interface DOMHTMLElement : DOMElement
@property(readonly) NSString *titleDisplayString;
@property(copy) NSString *outerText;
@property(copy) NSString *outerHTML;
@property(copy) NSString *innerText;
@property(copy) NSString *innerHTML;
@end

@interface DOMDocument : DOMNode
@property(readonly) DOMStyleSheetList *styleSheets;
@end
@interface DOMHTMLDocument : DOMDocument
@property(copy) NSString *vlinkColor;
@property(copy) NSString *linkColor;
@property(copy) NSString *alinkColor;
@property(copy) NSString *fgColor;
@property(copy) NSString *bgColor;
@end

@interface UIWebBrowserView : UIWebDocumentView
@end
@interface MFSubjectWebBrowserView : UIWebBrowserView @end
@interface MessageHeaderHeader : UIView {
	MFSubjectWebBrowserView *_subjectWebView;
	DOMHTMLElement *_subjectTextElement;
}
- (void)_setSubjectText:(id)arg1;
@end*/



%hook UIApplication

- (void)__glareapps_applicationDidFinishLaunching {
	%orig;
	
	NSArray *superviews = [UIApplication sharedApplication].keyWindow.subviews;
	UIView *superview = (superviews.count > 0 ? superviews[0] : nil);
	UIView *view = (superview.subviews.count > 0 ? superview.subviews[0] : nil);
	view.backgroundColor = nil;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		view.alpha = kRealTransparentAlphaFactor;
}

%end


%hook MailboxContentViewController

- (void)viewDidAppear:(BOOL)arg1 {
	%orig;
	
	UIView *placeholder = (self.tableView.subviews.count >= 2 ? self.tableView.subviews[0] : nil);
	
	if (![placeholder isKindOfClass:%c(UITableViewWrapperView)] && ![placeholder isKindOfClass:[UIRefreshControl class]])
		placeholder.alpha = 0.0f;
}

%end


%hook MailboxContentViewCell

- (id)_dateLabelTextColor {
	return [colorHelper systemGrayColor];
}

- (id)_bodyAttributesWithColor:(id)color {
	return %orig([colorHelper systemGrayColor]);
}

- (void)drawInStaticView:(id)staticView highlighted:(BOOL)highlighted {
	UIImageView *_chevron = MSHookIvar<UIImageView *>(self, "_chevron");
	_chevron.image = [_chevron.image _flatImageWithColor:[colorHelper commonTextColor]];
	
	self.backgroundColor = [colorHelper clearColor];
	
	%orig;
}

%end


%hook UITableViewCellSelectedBackground

- (void)setSelectionTintColor:(UIColor *)color {
	%orig([colorHelper systemDarkGrayColor]);
}

- (void)setMultiselectBackgroundColor:(UIColor *)color {
	%orig([colorHelper lightTextColor]);
}

%end


%hook MessageHeaderHeader

- (void)_setSubjectText:(id)arg1 {
	%orig;
	
	UIView *_subjectWebView = MSHookIvar<UIView *>(self, "_subjectWebView");
	_subjectWebView.opaque = NO;
	_subjectWebView.backgroundColor = [colorHelper clearColor];
	
	self.backgroundColor = [colorHelper clearColor];
}

- (id)_subjectLineHTML:(BOOL)useHtml {
	NSString *html = %orig;
	
	// BODY { padding: 0; m...
	html = [html stringByReplacingOccurrencesOfString:@"BODY { padding: 0; m" 
										   withString:@"BODY { padding: 0; background-color: transparent; m"];
	
	if (!isWhiteness) {
		// SPAN[ID=subject] { font: -apple-system-short-headline; vertical-align: text-top; color: #000;
		html = [html stringByReplacingOccurrencesOfString:@"SPAN[ID=subject] { font: -apple-system-short-headline; vertical-align: text-top; color: #000;" 
											   withString:@"SPAN[ID=subject] { font: -apple-system-short-headline; vertical-align: text-top; color: #FFFFFF;"];
	}
	
	return html;
}

%end


%hook ThreadBannerView

- (void)setBackgroundView:(UIView *)view {
	if ([self.backgroundView isKindOfClass:[_UIBackdropView class]]) return;
	
	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleSystemDefaultSemiLight];
	settings.grayscaleTintLevel = (isWhiteness ? 1.0f : 0.0f);
	
	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
	
	UIView *&_backgroundView = MSHookIvar<UIView *>(self, "_backgroundView");
	
	[self insertSubview:backdropView belowSubview:_backgroundView];
	[colorHelper addBlurView:backdropView];
	
	[_backgroundView removeFromSuperview];
	[_backgroundView release];
	
	_backgroundView = backdropView;
	
	[backdropView release];
}

- (void)layoutSubviews {
	[self setBackgroundView:nil];
	self.backgroundColor = [colorHelper clearColor];
	self.opaque = NO;
	
	%orig;
}

- (void)setAlternateText:(id)text {
	%orig;
	
	UILabel *_alternateLabel = MSHookIvar<UILabel *>(self, "_alternateLabel");
	_alternateLabel.textColor = [colorHelper systemGrayColor];
}

- (void)dealloc {
	UIView *&_backgroundView = MSHookIvar<UIView *>(self, "_backgroundView");
	[_backgroundView removeFromSuperview];
	_backgroundView = nil;
	
	%orig;
}

%end


%hook ComposeNavigationController

- (BOOL)__glareapps_shouldRemoveBackdropAfterPresenting {
	if (isPad) return NO;
	
	return YES;
}

%end




%ctor {
	if (!isThisAppEnabled()) return;
	
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.mobilemail"]) {
		%init;
	}
}
