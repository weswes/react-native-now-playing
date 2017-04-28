#import "RNNowPlaying.h"
#import "RCTEventDispatcher.h"

@implementation RNNowPlaying

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();
- (dispatch_queue_t-methodQueue{
	return dispatch_get_main_queue();
}

- (RNNowPlaying *)init {
    self = [super init];
    self.musicPlayer = [MPMusicPlayerController systemMusicPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingEventReceived:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:self.musicPlayer];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingEventReceived:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.musicPlayer];
        
    [self.musicPlayer beginGeneratingPlaybackNotifications];

    return self;
}

- (void)nowPlayingEventReceived:(NSNotification *)notification
{
    MPMusicPlayerController *player = (MPMusicPlayerController *)notification.object;
    MPMediaItem *item = [player nowPlayingItem];
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying){
        [self.bridge.eventDispatcher sendAppEventWithName:@"nowPlayingEvent"
                                                     body:@{@"title": item.title}];
    }
}

- (NSDictionary *)constantsToExport
{
    return @{ @"test": @"test" };
}

@end
