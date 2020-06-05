#import "Ironsource.h"
#import <React/RCTLog.h>
#import "RCTUtils.h"

@implementation Ironsource

NSString *const kIronSourceRewardedVideoAvailable = @"ironSourceRewardedVideoAvailable";
NSString *const kIronSourceRewardedVideoUnavailable = @"ironSourceRewardedVideoUnavailable";
NSString *const kIronSourceRewardedVideoAdRewarded = @"ironSourceRewardedVideoAdRewarded";
NSString *const kIronSourceRewardedVideoClosedByError = @"ironSourceRewardedVideoClosedByError";
NSString *const kIronSourceRewardedVideoClosedByUser = @"ironSourceRewardedVideoClosedByUser";
NSString *const kIronSourceRewardedVideoDidStart = @"ironSourceRewardedVideoDidStart";
NSString *const kIronSourceRewardedVideoDidOpen = @"ironSourceRewardedVideoDidOpen";
NSString *const kIronSourceRewardedVideoAdStarted = @"ironSourceRewardedVideoAdStarted";
NSString *const kIronSourceRewardedVideoAdEnded = @"ironSourceRewardedVideoAdEnded";

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

- (NSArray<NSString *> *)supportedEvents {
    return @[kIronSourceRewardedVideoAvailable,
             kIronSourceRewardedVideoUnavailable,
             kIronSourceRewardedVideoAdRewarded,
             kIronSourceRewardedVideoClosedByError,
             kIronSourceRewardedVideoClosedByUser,
             kIronSourceRewardedVideoDidStart,
             kIronSourceRewardedVideoDidOpen,
             kIronSourceRewardedVideoAdStarted,
             kIronSourceRewardedVideoAdEnded
             ];
}

    /****************** 
     * INITIALISATION *
     ******************/

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

    /**************** 
     * REWAREDVIDEO *
     ****************/

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

- (void)didReceiveRewardForPlacement:(ISPlacementInfo*)placementInfo {
    NSNumber * rewardAmount = [placementInfo rewardAmount];
    NSString * rewardName = [placementInfo rewardName];
    NSLog(@">>>>>>>>>>>> RewardedVideo %@ reward amount %@", rewardName, rewardAmount);
    [self sendEventWithName:kIronSourceRewardedVideoAdRewarded body:@{
                                                                      @"rewardName": rewardName,
                                                                      @"rewardAmount": rewardAmount
                                                                      }];
}

 - (void)rewardedVideoHasChangedAvailability:(BOOL)available {
     if(available == YES) {
         NSLog(@">>>>>>>>>>>> RewardedVideo available");
         [self sendEventWithName:kIronSourceRewardedVideoAvailable body:nil];
     } else {
         NSLog(@">>>>>>>>>>>> RewardedVideo NOT available");
         [self sendEventWithName:kIronSourceRewardedVideoUnavailable body:nil];
     }
 }

- (void)didReceiveRewardForPlacement:(ISPlacementInfo*)placementInfo {
    NSNumber * rewardAmount = [placementInfo rewardAmount];
    NSString * rewardName = [placementInfo rewardName];
    NSLog(@">>>>>>>>>>>> RewardedVideo %@ reward amount %@", rewardName, rewardAmount);
    [self sendEventWithName:kIronSourceRewardedVideoAdRewarded body:@{
                                                                      @"rewardName": rewardName,
                                                                      @"rewardAmount": rewardAmount
                                                                      }];
}

- (void)rewardedVideoDidFailToShowWithError:(NSError *)error {
    NSLog(@">>>>>>>>>>>> RewardedVideo ad closed due to an error: %@!", error);
    [self sendEventWithName:kIronSourceRewardedVideoClosedByError body:nil];
}

- (void)rewardedVideoDidOpen{
    NSLog(@">>>>>>>>>>>> RewardedVideo opened!");
    // @Deprecated kIronSourceRewardedVideoDidStart
    [self sendEventWithName:kIronSourceRewardedVideoDidStart body:nil];
    [self sendEventWithName:kIronSourceRewardedVideoDidOpen body:nil];
}

- (void)rewardedVideoDidClose {
    NSLog(@">>>>>>>>>>>> RewardedVideo closed!");
    [self sendEventWithName:kIronSourceRewardedVideoClosedByUser body:nil];
}

- (void)rewardedVideoDidStart {
    NSLog(@">>>>>>>>>>>> RewardedVideo Ad Started!");
    [self sendEventWithName:kIronSourceRewardedVideoAdStarted body:nil];
}

- (void)rewardedVideoDidEnd {
    NSLog(@">>>>>>>>>>>> RewardedVideo Ad Ended!");
    [self sendEventWithName:kIronSourceRewardedVideoAdEnded body:nil];
}

@end


