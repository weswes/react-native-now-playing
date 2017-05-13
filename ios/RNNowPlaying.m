#import "RNNowPlaying.h"
#import "RCTEventDispatcher.h"

@implementation RNNowPlaying


RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"NowPlayingEvent"];
}

- (RNNowPlaying *)init {
    self.musicPlayer = [MPMusicPlayerController systemMusicPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingEventReceived:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:self.musicPlayer];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingEventReceived:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.musicPlayer];
        
    [self.musicPlayer beginGeneratingPlaybackNotifications];

    return self;
}

- (void)nowPlayingEventReceived:(NSNotification *)notification
{
    //e.playbackTime, e.playbackDuration, e.title, e.albumTitle, e.artist
    MPMusicPlayerController *player = (MPMusicPlayerController *)notification.object;
    MPMediaItem *item = [player nowPlayingItem];
    NSLog(@"%@", item);
    if (player.playbackState == MPMusicPlaybackStatePlaying){
        [self sendEventWithName:@"NowPlayingEvent"
              body:@{@"playbackTime": [NSNumber numberWithDouble:player.currentPlaybackTime],
                     @"playbackDuration": [NSNumber numberWithDouble:item.playbackDuration],
                     @"title": item.title,
                     @"albumTitle": item.albumTitle,
                     @"artist": item.artist
                                                            
                   }];
    }
}

- (NSDictionary *)constantsToExport
{
    return @{ @"test": @"test" };
}

@end
