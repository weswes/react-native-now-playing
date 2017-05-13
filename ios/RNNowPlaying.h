#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <MediaPlayer/MediaPlayer.h>

@interface RNNowPlaying : RCTEventEmitter <RCTBridgeModule>

@property (nonatomic, retain) MPMusicPlayerController  *musicPlayer;

@end
  
