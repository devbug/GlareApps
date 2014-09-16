
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



%hook UITableViewCell

- (void)layoutSubviews {
	%orig;
	
	self.backgroundColor = [colorHelper clearColor];
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
