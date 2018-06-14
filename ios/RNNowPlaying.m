#import "RNNowPlaying.h"


@implementation RNNowPlaying
{
  bool hasListeners;
}

RCT_EXPORT_MODULE();

-(BOOL)requiresMainQueueSetup
{
    return YES;
}


- (NSArray<NSString *> *)supportedEvents
{
    return @[@"NowPlayingEvent"];
}

-(void)startObserving{
    // Traiter les cas du refus...
    if ([MPMediaLibrary authorizationStatus] == MPMediaLibraryAuthorizationStatusAuthorized){
        [self registerNotif];
    } else {
        [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
            [self registerNotif];
        }];
    }

}

-(void)registerNotif{
    hasListeners = YES;
    self.musicPlayer = [MPMusicPlayerController systemMusicPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingEventReceived:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:self.musicPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingEventReceived:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.musicPlayer];
    [self.musicPlayer beginGeneratingPlaybackNotifications];
}

- (void)nowPlayingEventReceived:(NSNotification *)notification
{
    //e.playbackTime, e.playbackDuration, e.title, e.albumTitle, e.artist
    MPMusicPlayerController *player = (MPMusicPlayerController *)notification.object;
    MPMediaItem *item = [player nowPlayingItem];


    NSString *playbackTime = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:player.currentPlaybackTime]];
    NSString *playbackDuration = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:item.playbackDuration]];
    NSString *artist = [NSString stringWithFormat:@"%@", item.artist];
    NSString *albumTitle = [NSString stringWithFormat:@"%@", item.albumTitle];
    NSString *title = [NSString stringWithFormat:@"%@", item.title];

    NSLog(@"[Nowplaying] pbstate: %ld", (long)player.playbackState);
    NSLog(@"[Nowplaying] artist: %@", artist);
    NSLog(@"[Nowplaying] albumTitle: %@", albumTitle);
    NSLog(@"[Nowplaying] title: %@", title);

    if (player.playbackState == MPMusicPlaybackStatePlaying
        && ![artist isEqualToString:@"(null)"]
        && ![albumTitle isEqualToString:@"(null)"]
        && ![title isEqualToString:@"(null)"]
        ){
        [self sendEventWithName:@"NowPlayingEvent"
                           body:@{@"playbackTime": playbackTime,
                                  @"playbackDuration": playbackDuration,
                                  @"title": title,
                                  @"albumTitle": albumTitle,
                                  @"artist": artist
                                  }];
    }

}

@end
