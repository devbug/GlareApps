
#import "headers.h"


@interface CKConversationListController : UIViewController @end

@protocol CKGradientReferenceView <NSObject>
- (struct CGRect)gradientFrame;
@end
@interface CKGradientReferenceView : UIView <CKGradientReferenceView> @end
@interface CKBalloonTextView : UITextView
@property(copy, nonatomic) NSAttributedString *attributedText;
@end
@interface CKGradientView : UIView
@property(retain, nonatomic) UIView *effectView;
@property(retain, nonatomic) NSArray *colors;
@property(nonatomic, assign) UIView<CKGradientReferenceView> *referenceView;
- (id)gradient;
@end

@interface CKBalloonImageView : UIImageView @end
@interface CKBalloonView : CKBalloonImageView
@property(retain, nonatomic) CKBalloonImageView *overlay;
@property(nonatomic) BOOL wantsSkinnyMask;
@property(nonatomic) BOOL hasOverlay;
@property(nonatomic) BOOL canUseOpaqueMask;
@property(nonatomic, getter=isShowingMenu) BOOL showingMenu;
@property(nonatomic, getter=isFilled) BOOL filled;
@property(nonatomic) BOOL hasTail;
@property(nonatomic) BOOL orientation;
//@property(nonatomic) NSObject<CKBalloonViewDelegate> *delegate;
@property(readonly, nonatomic) UIColor *overlayColor;
@end
@interface CKColoredBalloonView : CKBalloonView
@property(nonatomic) BOOL wantsGradient;
@property(retain, nonatomic) CKGradientView *gradientView;
@property(retain, nonatomic) UIImageView *mask;
@property(nonatomic) BOOL color;
- (id)balloonImage;
@property(retain, nonatomic) UIView<CKGradientReferenceView> *gradientReferenceView;
- (id)overlayColor;
@end
@interface CKTextBalloonView : CKColoredBalloonView
@property(nonatomic) BOOL centerTextWhenSkinny;
@property(copy, nonatomic) NSAttributedString *attributedText;
@property(retain, nonatomic) CKBalloonTextView *textView;
@property(nonatomic) BOOL containsHyperlink;
@property(readonly, nonatomic) BOOL isInteractingWithLink;
@end



%hook SMSApplication

%new
- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration {
	[[UIApplication sharedApplication] keyWindow].backgroundColor = [UIColor colorWithWhite:kDarkColorWithWhiteForWhiteness alpha:0.2f];
}

%new
- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
	[[UIApplication sharedApplication] keyWindow].backgroundColor = nil;
}

%end


%hook UITableViewCell

- (void)layoutSubviews {
	%orig;
	
	self.backgroundColor = [UIColor clearColor];
}

%end


%hook CKConversationListController

- (void)viewWillLayoutSubviews {
	%orig;
	
	UITableView *_table = MSHookIvar<UITableView *>(self, "_table");
	
	UIView *placeholder = (_table.subviews.count >= 2 ? _table.subviews[0] : nil);
	
	if (![placeholder isKindOfClass:%c(UITableViewWrapperView)])
		placeholder.backgroundColor = [UIColor clearColor];
}

%end


%hook CKConversationSearcher

- (void)searchDisplayController:(id)searchController willShowSearchResultsTableView:(UITableView *)resultsTableView {
	%orig;
	
	UIView *superview = resultsTableView.superview;
	
	_UIBackdropView *backdropView = (_UIBackdropView *)[superview viewWithTag:0xc001];
	[backdropView retain];
	
	if (backdropView == nil) {
		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:kBackdropStyleForWhiteness graphicsQuality:kBackdropGraphicQualitySystemDefault];
		
		backdropView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
		backdropView.tag = 0xc001;
		
		[superview insertSubview:backdropView atIndex:0];
	}
	
	backdropView.alpha = 1.0f;
	
	[backdropView release];
}

- (void)searchDisplayController:(id)searchController willHideSearchResultsTableView:(UITableView *)resultsTableView {
	%orig;
	
	UIView *superview = resultsTableView.superview;
	
	_UIBackdropView *backdropView = (_UIBackdropView *)[superview viewWithTag:0xc001];
	backdropView.alpha = 0.0f;
}

%end


// for biteSMS
%hook UIViewController

- (void)viewWillAppear:(BOOL)animated {
	clearBar(self.navigationController.navigationBar);
	clearBar(self.navigationController.toolbar);
	clearBar(self.tabBarController.tabBar);
	
	%orig;
}

%end



%ctor {
	if (!isThisAppEnabled()) return;
	
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.MobileSMS"]) {
		%init;
	}
}
