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

/**
 Register to events
 **/
-(void)startObserving{
    // Check Authorization on MPMediaLibrary
    // Traiter les cas du refus...
    if ([MPMediaLibrary authorizationStatus] == MPMediaLibraryAuthorizationStatusAuthorized){
        [self registerNotif];
    } else {
        [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
            [self registerNotif];
        }];
    }
    
    [self startObservingSpotify];

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


/// SPOTIFY
-(void)startObservingSpotify{
    SPTAppRemoteConnectionParamsImageFormat format = SPTAppRemoteConnectionParamsImageFormatAny;
    SPTAppRemoteConnectionParams *params =
    [[SPTAppRemoteConnectionParams alloc] initWithClientIdentifier:@"e5dec3e3ce1643909db47c3d396861c8"
                                                       redirectURI:@"spotifywatchexample://"
                                                              name:@"Kizbee"
                                                       accessToken:nil
                                                  defaultImageSize:CGSizeZero
                                                       imageFormat:format];
    
    self.appRemote = [[SPTAppRemote alloc] initWithConnectionParameters:params
                                                               logLevel:SPTAppRemoteLogLevelDebug];
    self.appRemote.delegate = self;
    
    [self.appRemote connect];
    
    [self startObserving];
}


- (void)appRemote:(SPTAppRemote *)appRemote didFailConnectionAttemptWithError:(NSError *)error
{
    // Connection failed
    NSLog(@"Connection failed %@", error);
    BOOL spotifyInstalled = [self.appRemote authorizeAndPlayURI:@""];
    if (!spotifyInstalled) {
        /*
         * The Spotify app is not installed.
         * Use SKStoreProductViewController with [SPTAppRemote spotifyItunesItemIdentifier] to present the user
         * with a way to install the Spotify app.
         */
    }
}

- (void)appRemote:(SPTAppRemote *)appRemote didDisconnectWithError:(nullable NSError *)error
{
    // Connection disconnected
    NSLog(@"Connection disconnected %@", error);
}

- (void)playerStateDidChange:(id<SPTAppRemotePlayerState>)playerState
{
    if (![playerState.track.name isEqualToString:@"Spotify"] && !playerState.isPaused){
        NSString *playbackTime = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:playerState.playbackPosition]];
        NSString *playbackDuration = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:playerState.track.duration]];
        NSString *artist = [NSString stringWithFormat:@"%@", playerState.track.artist.name];
        NSString *albumTitle = [NSString stringWithFormat:@"%@", playerState.track.album.name];
        NSString *title = [NSString stringWithFormat:@"%@", playerState.track.name];
        
        NSLog(@"[Nowplaying] artist: %@", artist);
        NSLog(@"[Nowplaying] albumTitle: %@", albumTitle);
        NSLog(@"[Nowplaying] title: %@", title);
    }
    
}

- (void)appRemoteDidEstablishConnection:(SPTAppRemote *)appRemote
{
    // Connection was successful, you can begin issuing commands
    
    appRemote.playerAPI.delegate = self;
    [appRemote.playerAPI subscribeToPlayerState:
     ^(id  _Nullable result, NSError * _Nullable error) {
         if (error) {
             NSLog(@"%@", error.localizedDescription);
         }
     }];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    NSDictionary *params = [self.appRemote authorizationParametersFromURL:url];
    NSString *token = params[SPTAppRemoteAccessTokenKey];
    if (token) {
        self.appRemote.connectionParameters.accessToken = token;
    } else if (params[SPTAppRemoteErrorDescriptionKey]) {
        NSLog(@"%@", params[SPTAppRemoteErrorDescriptionKey]);
    }
    return YES;
}
@end
