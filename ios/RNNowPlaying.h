#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <MediaPlayer/MediaPlayer.h>
#import <SpotifyAppRemote/SpotifyAppRemote.h>

@interface RNNowPlaying : RCTEventEmitter <RCTBridgeModule, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate>

@property (nonatomic, retain) MPMusicPlayerController  *musicPlayer;
@property (nonatomic, strong) SPTAppRemote *appRemote; // Spotify App Remote

@end
