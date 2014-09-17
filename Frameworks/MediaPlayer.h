
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

@interface MusicNowPlayingObserver : NSObject {
	MusicAVPlayer *_avPlayer;
}
@end

