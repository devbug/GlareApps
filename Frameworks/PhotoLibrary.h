
#import "headers.h"



@interface PLCameraView : UIView
@property(readonly, nonatomic) UIView *_previewMaskingView;
@end

@interface PLWallpaperButton : UIButton
@property(retain, nonatomic) _UIBackdropView *backdropView;
@property(retain, nonatomic) UIImageView *titleMaskImageView;
@end

@interface PLEditPhotoController : UIViewController
@property(retain, nonatomic) UIToolbar *toolbar;
@property(retain, nonatomic) UINavigationBar *navigationBar;
@end
@interface PLEffectSelectionViewControllerView : UIView @end

@interface PLPhotoCommentEntryView : UIView
@property(readonly, nonatomic) UITextView *textView;
@property(readonly, nonatomic) UILabel *placeholderLabel;
@end

