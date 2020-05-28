
#import "RNReactNativeIronsource.h"

@implementation RNReactNativeIronsource

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()


RCT_EXPORT_METHOD(initIronsourceSDK:(NSString *)appKey rewardedAdUnit:(NSString *)rewardedAdUnit)
{
    [IronSource initWithAppKey:appKey adUnits:@[rewardedAdUnit]];
    RCTLogInfo(@"[IOS NATIVE IRONSOURCE] init SDK with APP_KEY: %@ and rewardedVideo AdsUnit: %@", appKey, rewardedAdUnit);
    
    [ISIntegrationHelper validateIntegration];
    RCTLogInfo("[IOS NATIVE IRONSOURCE] Integration Helper activated");

}

// [IronSource setRewardedVideoDelegate:yourRewardedVideoDelegate];

// [ISIntegrationHelper validateIntegration];

@end
