
#import "headers.h"



@interface SFAirDropIconView : UIControl {
	UIImageView *_imageView;
}
@end

@interface SFAirDropActiveIconView : UIImageView
@property(nonatomic, getter=isMasked) BOOL masked;
@end

@interface SFAirDropActivityViewController : UIViewController @end



void initHookForSharingFramework();

