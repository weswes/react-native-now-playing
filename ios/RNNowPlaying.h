#import "RCTBridgeModule.h"
#import <MediaPlayer/MediaPlayer.h>

@interface RNNowPlaying : NSObject <RCTBridgeModule>

@property (nonatomic, retain) MPMusicPlayerController  *musicPlayer;

@end
  
