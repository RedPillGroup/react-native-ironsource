#import "Ironsource.h"
#import <React/RCTLog.h>
// #import "RCTUtils.h"

@implementation Ironsource

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(setConsent:(BOOL)consent)
{
    [IronSource setConsent:consent];
    RCTLogInfo(@"[IOS NATIVE IRONSOURCE] set content true");
}

RCT_EXPORT_METHOD(initIronsourceSDK:(NSString *)appKey
                userId:(NSString *)userId 
                options:(NSDictionary *)options)
{
    [IronSource setUserId:userId];
    RCTLogInfo(@"[IOS NATIVE IRONSOURCE] userId set is: %@", userId);

    [IronSource initWithAppKey:appKey adUnits:@[IS_REWARDED_VIDEO]];
    RCTLogInfo(@"[IOS NATIVE IRONSOURCE] init SDK with APP_KEY: %@o", appKey);
    
    BOOL activateIntegrationHelper = [RCTConvert BOOL:options[@"activateIntegrationHelper"]];
    if (activateIntegrationHelper) {
        [ISIntegrationHelper validateIntegration];
        RCTLogInfo(@"[IOS NATIVE IRONSOURCE] Integration Helper activate");
    }
    else
        RCTLogInfo(@"[IOS NATIVE IRONSOURCE] Integration Helper not activate");
}

RCT_EXPORT_METHOD(showRewardedVideo:(NSString*)placementName)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        RCTLogInfo(@"[IOS NATIVE IRONSOURCE] Show Rewarded Video Called");
        [IronSource showRewardedVideoWithViewController:RCTPresentedViewController()];
    });
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
    RCTLogInfo(@"[IOS NATIVE IRONSOURCE] Init Rewarded Video");
    [IronSource setRewardedVideoDelegate:self];
}


RCT_EXPORT_METHOD(isRewardedVideoPlacementCapped:(NSString*)placementName : (RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
{
    @try {
        resolve(@([IronSource isRewardedVideoCappedForPlacement:@"Placement"]));
    }
    @catch (NSException *exception) {
        RCTLogInfo(@"isRewardedVideoCappedForPlacement, Error, %@", exception.reason);
        reject(@"isRewardedVideoCappedForPlacement, Error, %@", exception.reason, nil);
    }
}

@end


