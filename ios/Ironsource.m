#import "Ironsource.h"
#import <React/RCTLog.h>
// #import "RCTUtils.h"

@implementation Ironsource


RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(sampleMethod:(NSString *)stringArgument numberParameter:(nonnull NSNumber *)numberArgument callback:(RCTResponseSenderBlock)callback)
{
    // TODO: Implement some actually useful functionality
    callback(@[[NSString stringWithFormat: @"numberArgument: %@ stringArgument: %@", numberArgument, stringArgument]]);
}

RCT_EXPORT_METHOD(initIronsourceSDK:(NSString *)appKey rewardedAdUnit:(NSString *)rewardedAdUnit)
{
    [IronSource setConsent:YES];
    RCTLogInfo(@"[IOS NATIVE IRONSOURCE] set content true");

    [IronSource initWithAppKey:appKey adUnits:@[IS_REWARDED_VIDEO]];
    RCTLogInfo(@"[IOS NATIVE IRONSOURCE] init SDK with APP_KEY: %@ and rewardedVideo AdsUnit: %@", appKey, rewardedAdUnit);
    
    [ISIntegrationHelper validateIntegration];
    RCTLogInfo(@"[IOS NATIVE IRONSOURCE] Integration Helper activated");

}

RCT_EXPORT_METHOD(showRewardedVideo:(NSString*)placementName)
{
    // if ([IronSource hasRewardedVideo]) {
    //     NSLog(@"showRewardedVideo - video available");
    //     [self sendEventWithName:kIronSourceRewardedVideoAvailable body:nil];
        
    dispatch_async(dispatch_get_main_queue(), ^{
        RCTLogInfo(@"[IOS NATIVE IRONSOURCE] Show Rewarded Video Called");
        [IronSource showRewardedVideoWithViewController:RCTPresentedViewController()];
    });
    // } else {
    //     NSLog(@"showRewardedVideo - video unavailable");
    //     [self sendEventWithName:kIronSourceRewardedVideoUnavailable body:nil];
    // }
}

RCT_EXPORT_METHOD(isRewardedVideoAvailable:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
{
    @try {
        resolve(@([IronSource hasRewardedVideo]));
    }
    @catch (NSException *exception) {
        RCTLogInfo(@"isRewardedVideoAvailable, Error, %@", exception.reason);
        reject(@"isRewardedVideoAvailable, Error, %@", exception.reason, nil);
    }
}

RCT_EXPORT_METHOD(initializeRewardedVideo)
{
    // if (!initialized) {
        RCTLogInfo(@"[IOS NATIVE IRONSOURCE] Init Rewarded Video");

        [IronSource setRewardedVideoDelegate:self];
        // initialized = YES;
    // }
}

// RCT_EXPORT_METHOD(initializeRewardedVideo)
// {
//     [IronSource hasRewardedVideo];
// }

@end


