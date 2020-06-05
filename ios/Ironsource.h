#import <React/RCTBridgeModule.h>

#import "IronSource/IronSource.h"
#import "React/RCTConvert.h"
#import "RCTEventEmitter.h"

@interface Ironsource : RCTEventEmitter <RCTBridgeModule, ISRewardedVideoDelegate>

@end