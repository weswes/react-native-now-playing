#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <MediaPlayer/MediaPlayer.h>

#import <SpotifyAppRemoteSDK/SpotifyAppRemote.h>

#if __has_include(<SpotifyAppRemoteSDK/SpotifyAppRemote.h>)
#import <SpotifyAppRemoteSDK/SpotifyAppRemote.h>


@interface RNNowPlaying : RCTEventEmitter <RCTBridgeModule, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate>

+ (_Nonnull instancetype)instance;

@property (nonatomic, retain) MPMusicPlayerController  *musicPlayer;
@property (nonatomic, strong) SPTAppRemote *appRemote; // Spotify App Remote

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;


#else
 
@interface RNNowPlaying : RCTEventEmitter <RCTBridgeModule>
    
@property (nonatomic, retain) MPMusicPlayerController  *musicPlayer;

#endif

@end

