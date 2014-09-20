
#import <MediaPlayer/MediaPlayer.h>
#import "../headers.h"



//extern NSString *MPMediaItemPropertyArtworkCacheID;

@interface MPMediaItemArtwork (private_api)
- (id)albumImageWithSize:(struct CGSize)arg1;
@end
@interface MPMediaItem (private_api)
@property(readonly, nonatomic) MPMediaItemArtwork *artwork;
@end
@interface MPImageCacheRequest : NSOperation
@property(nonatomic) BOOL finalSizeMayDifferWhenApsectRatioMatches;
@property(nonatomic) NSInteger contentMode;
@property(nonatomic) struct CGSize finalSize;
@property(nonatomic) NSInteger artworkFormat;
- (id)_newBitmapImageFromImage:(id)arg1 finalSize:(struct CGSize)arg2;
- (id)copyImageFromImage:(id)arg1;
@end
@interface MPMediaItemImageRequest : MPImageCacheRequest
@property(nonatomic) NSUInteger placeHolderMediaType;
@property(nonatomic) BOOL usePlaceholderAsFallback;
@property(nonatomic) BOOL fillToSquareAspectRatio;
@property(nonatomic) BOOL crop;
@property(nonatomic) NSInteger artworkFormat;
@property(copy, nonatomic) NSString *artworkCacheID;
- (id)initWithMediaItem:(id)arg1;
@end
@interface MPImageCache : NSObject
- (id)imageForRequest:(id)arg1 error:(id *)arg2;
- (id)_cachedImageForKey:(id)arg1;
- (id)cachedImageForRequest:(id)arg1;
@end
// for iOS 7.1
@interface MPNowPlayingObserver : NSObject
@property (assign, getter=isEnabled, nonatomic) BOOL enabled;
@property (nonatomic, readonly) MPImageCache *imageCache;
@end

@interface MPAVItem : NSObject
@property(readonly, nonatomic) MPMediaItem *mediaItem;
@property(readonly, nonatomic) unsigned long long persistentID;
- (id)imageCacheRequestWithSize:(struct CGSize)arg1 time:(double)arg2 usePlaceholderAsFallback:(BOOL)arg3;
- (id)imageCacheRequestWithSize:(struct CGSize)arg1 time:(double)arg2;
@property(readonly, nonatomic) MPImageCache *imageCache;
@end

@interface MPAVController : NSObject
+ (id)sharedInstance;
@property(readonly, nonatomic, getter=isPlaying) BOOL playing;
@property(readonly, nonatomic) BOOL isCurrentItemReady;
@property(readonly, nonatomic) MPMediaItem *currentMediaItem;
@property(readonly, nonatomic) MPAVItem *currentItem;
@end
@interface MusicAVPlayer : MPAVController
+ (id)sharedAVPlayer;
@end

@interface MusicNowPlayingObserver : MPNowPlayingObserver  /* NSObject (< 7.1) */ {
	MusicAVPlayer *_avPlayer;
}
+ (id)sharedObserver; // >= 7.1
@end


@interface MPVolumeSlider : UISlider
@property(readonly, nonatomic) NSInteger style;
- (id)_maxTrackImageForStyle:(UIControlState)arg1;
- (id)_minTrackImageForStyle:(UIControlState)arg1;
- (id)_thumbImageForStyle:(UIControlState)arg1;
@end

@interface MPDetailSlider : UISlider {
	UILabel *_currentTimeInverseLabel;
	UILabel *_currentTimeLabel;
}
- (struct CGRect)thumbViewRect;
- (id)_colorSliceImageWithColor:(id)arg1 height:(CGFloat)arg2;
@end

@interface MPButton : UIButton @end

@interface MPTransportControls : UIView {
	MPButton *_alternatesButton;
	MPButton *_bookmarkButton;
	MPButton *_chaptersButton;
	MPButton *_devicePickerButton;
	MPButton *_emailButton;
	MPButton *_fastForward15SecondsButton;
	MPButton *_likeOrBanButton;
	MPButton *_nextButton;
	MPButton *_playButton;
	MPButton *_previousButton;
	MPButton *_rewind15SecondsButton;
	MPButton *_rewind30SecondsButton;
	MPButton *_scaleButton;
	MPButton *_toggleFullscreenButton;
}
@end

@interface MPPlaybackControlsView : UIView {
	MPButton *_fastFowardButton;
	MPButton *_geniusButton;
	MPButton *_mailButton;
	MPButton *_playbackSpeedButton;
	MPDetailSlider *_progressControl;
	MPButton *_radioButton;
	MPButton *_radioHistoryButton;
	MPButton *_radioShareButton;
	MPButton *_trackInfoButton;
	MPButton *_repeatButton;
	MPButton *_rewindButton;
	UIView *_rewindButtonBezel;
	MPButton *_shuffleButton;
	UILabel *_trackInfoLabel;
}
@property(readonly, nonatomic) UIImage *shuffleButtonImage;
@property(readonly, nonatomic) UIImage *repeatButtonImage;
@property(readonly, nonatomic) UIImage *mailButtonImage;
@end

@interface _MPUMarqueeContentView : UIView @end
@interface MPUMarqueeView : UIView
@property(readonly, nonatomic) UIView *contentView;
@property(nonatomic) CGSize contentSize;
@property(nonatomic) CGFloat contentGap;
@end
@interface MPUNowPlayingTitlesView : UIView {
	UILabel *_detailLabel;
	MPUMarqueeView *_detailMarqueeView;
	UILabel *_titleLabel;
	MPUMarqueeView *_titleMarqueeView;
}
- (void)_updateAttributedTitleLabel;
- (UILabel *)_detailLabel;
- (UILabel *)_titleLabel;
@end

@interface MPURatingControl : UIControl @end
