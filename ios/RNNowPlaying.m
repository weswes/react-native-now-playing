
#import "RNNowPlaying.h"
#import "RCTEventDispatcher.h"

@implementation RNNowPlaying

RCT_EXPORT_MODULE();

@synthesize bridge = _bridge;


- (id)init {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.musicPlayer = [MPMusicPlayerController systemMusicPlayer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingEventReceived:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:self.musicPlayer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingEventReceived:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.musicPlayer];
        
        [self.musicPlayer beginGeneratingPlaybackNotifications];
    });
    
    return self;
}

- (void)nowPlayingEventReceived:(NSNotification *)notification
{
    MPMusicPlayerController *player = (MPMusicPlayerController *)notification.object;
    // On recupere la musique jouée actuellement
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
