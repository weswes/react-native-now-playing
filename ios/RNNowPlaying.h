
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif
#import <MediaPlayer/MediaPlayer.h>

@interface RNNowPlaying : NSObject <RCTBridgeModule>

@property (nonatomic, retain) MPMusicPlayerController  *musicPlayer;

@end
  
