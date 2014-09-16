
#import "headers.h"



@interface NotesTextureView : UIView
@property(retain) UIImage *image;
@end

@interface NotesTextureBackgroundView : UIView {
	NotesTextureView *_textureView;
}
@end

@interface NotesBackgroundView : UIView {
	NotesTextureBackgroundView *_textureView;
}
@end

@interface _UICompatibilityTextView : UIScrollView
@property(retain, nonatomic) UIColor *textColor;
@property(copy, nonatomic) NSAttributedString *attributedText;
@end

@interface NoteTextView : _UICompatibilityTextView @end

@interface ResumableViewController : UIViewController @end
@interface NotesDisplayController : ResumableViewController @end

@interface NotesUITableViewCell : UITableViewCell @end
@interface NoteCell : NotesUITableViewCell @end




%hook NotesTextureBackgroundView

- (void)setFrame:(CGRect)frame {
	%orig;
	
	NotesTextureView *_textureView = MSHookIvar<NotesTextureView *>(self, "_textureView");
	_textureView.alpha = 0.0f;
}

%end


%hook NotesApp

- (BOOL)application:(id)application didFinishLaunchingWithOptions:(id)options {
	BOOL rtn = %orig;
	
	[[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"letterpressGloballyEnabled"];
	
	return rtn;
}

- (void)configureNavigationBar:(id)bar {
	
}
- (void)_updateLetterpressRendering {
	
}
- (void)_configureBarLetterpress:(id)bar {
	
}

%end


%hook NotesPageViewController

- (void)setupNavBar {
	
}

%end


%hook NotesDisplayController

- (void)_updateLetterpressRendering {
	
}

%end


%hook UIToolbar

- (void)_setHidesShadow:(BOOL)hidesShadow {
	
}

- (void)setBackgroundImage:(UIImage *)backgroundImage forToolbarPosition:(UIBarPosition)topOrBottom barMetrics:(UIBarMetrics)barMetrics {
	
}

%end


%hook UITableViewCell

- (void)setAccessoryView:(UIView *)view {
	if (view) {
		view = nil;
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	%orig;
}

%end


/*UIImage *chevronAccessory = nil;

%hook UIImage

+ (id)imageNamed:(NSString *)name {
	if ([name isEqualToString:@"chevronwhitepaper"] && !isWhiteness) {
		if (chevronAccessory == nil) {
			UIImage *image = %orig;
			
			chevronAccessory = [[image _flatImageWithColor:[colorHelper lightTextColor]] retain];
		}
		
		return chevronAccessory;
	}
	
	return %orig;
}

%end*/


// < 7.1
%hook NoteCell

- (void)updateLetterpressRendering {
	
}

%end

// >= 7.1
%hook NoteCellContentView

- (void)updateLetterpressRendering {
	
}

- (void)setDate:(id)date {
	%orig;
	
	NSAttributedString *&_dateString = MSHookIvar<NSAttributedString *>(self, "_dateString");
	NSAttributedString *backupString = [_dateString retain];
	_dateString = [colorReplacedAttributedString(_dateString) retain];
	[backupString release];
	[backupString release];
}
- (void)setTitle:(id)title {
	%orig;
	
	NSAttributedString *&_titleString = MSHookIvar<NSAttributedString *>(self, "_titleString");
	NSAttributedString *backupString = [_titleString retain];
	_titleString = [colorReplacedAttributedString(_titleString) retain];
	[backupString release];
	[backupString release];
}

/*- (id)_dateTextColor:(BOOL)nonpressed {
	return [[colorHelper commonTextColor] colorWithAlphaComponent:0.8f];
}
- (id)_titleTextColor:(BOOL)nonpressed {
	return [[colorHelper commonTextColor] colorWithAlphaComponent:0.8f];
}*/

%end


%hook UIDevice

- (BOOL)_notesDeviceSupportsBodyLettpress {
	return NO;
}

- (BOOL)_notesDeviceSupportsListLettpress {
	return NO;
}

%end


%hook _UICompatibilityTextView

- (void)setTextColor:(UIColor *)color {
	%orig([colorHelper commonTextColor]);
}

%end


%hook UIColor

+ (id)notesAppYellowColor {
	if (isWhiteness) {
		UIColor *color = %orig;
		
		CGFloat red = 0.0f, green = 0.0f, blue = 0.0f, alpha = 0.0f;
		
		[color getRed:&red green:&green blue:&blue alpha:&alpha];
		
		return [colorHelper colorWithRed:fabs(1.0f-red) green:fabs(1.0f-green) blue:fabs(1.0f-blue) alpha:alpha];
	}
	
	return %orig;
}

%end




%ctor {
	if (!isThisAppEnabled()) return;
	
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.mobilenotes"]) {
		%init;
	}
}
