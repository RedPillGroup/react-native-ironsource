package com.ironsource;

// import com.facebook.react.bridge.Callback;
// import com.facebook.react.bridge.NativeModule;
// import com.facebook.react.bridge.ReactContext;

import android.app.Activity;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.ironsource.mediationsdk.IronSource;
import com.ironsource.mediationsdk.integration.IntegrationHelper;

import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.ironsource.mediationsdk.logger.IronSourceError;
import com.ironsource.mediationsdk.model.Placement;
import com.ironsource.mediationsdk.sdk.RewardedVideoListener;
import com.facebook.react.bridge.Callback;

public class IronsourceModule extends ReactContextBaseJavaModule {
    private boolean initialized;

    private final ReactApplicationContext reactContext;

    public IronsourceModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "Ironsource";
    }

    /****************** 
     * INITIALISATION *
     ******************/

    @ReactMethod
    public void setConsent(boolean consent) {
        IronSource.setConsent(consent);
    }

    @ReactMethod
    public void initIronsourceSDK(final String appId, final String userId, final ReadableMap options, final Promise promise) {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                final Activity activity = reactContext.getCurrentActivity();
                final boolean activateIntegrationHelper = options.getBoolean("activateIntegrationHelper");

                IronSource.setUserId(userId);
                IronSource.init(activity, appId, IronSource.AD_UNIT.REWARDED_VIDEO, IronSource.AD_UNIT.INTERSTITIAL);
                if (activity != null && activateIntegrationHelper) {
                    IntegrationHelper.validateIntegration(activity);
                }
                promise.resolve(null);
            }
        });
    }

    /**************** 
     * REWAREDVIDEO *
     ****************/

    @ReactMethod
    public void isRewardedVideoAvailable(Promise promise) {
        try {
            Log.d("Ironsource", "isRewardedVideo() called!!");
            promise.resolve(IronSource.isRewardedVideoAvailable());
        }
        catch (Exception e) {
            Log.d("Ironsource", "isRewardedVideo error %s", e);
            promise.reject("isRewardedVideoAvailable, Error, " + e);
        }
    }

    @ReactMethod
    public void showRewardedVideo(final String placementName) {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                Log.d("Ironsource", "showRewardedVideo() called!!");
                boolean available = IronSource.isRewardedVideoAvailable();
                if (available) {
                    Log.d("Ironsource", "isRewardedVideoAvailable() = true");
                    IronSource.showRewardedVideo(placementName);
                } else {
                    Log.d("Ironsource", "isRewardedVideoAvailable() = false");
                }
            }
        });
    }

    @ReactMethod
    public void isRewardedVideoPlacementCapped(final String placementName, Promise promise) {
        try {
            Log.d("Ironsource", "isRewardedVideoPlacementCapped() called!!");
            promise.resolve(IronSource.isRewardedVideoPlacementCapped(placementName));
        }
        catch (Exception e) {
            Log.d("Ironsource", "isRewardedVideoPlacementCapped error %s", e);
            promise.reject("isRewardedVideoPlacementCapped, Error, " + e);
        }
    }

    @ReactMethod
    public void initializeRewardedVideo() {
        if (!initialized) {
            initialized = true;
            IronSource.setRewardedVideoListener(new RewardedVideoListener() {
                @Override
                public void onRewardedVideoAdOpened() {
                    Log.d("Ironsource", "onRewardedVideoAdOpened() called!");
                    sendEvent("ironSourceRewardedVideoDidStart", null);
                    sendEvent("ironSourceRewardedVideoDidOpen", null);
                }
                @Override
                public void onRewardedVideoAdClosed() {
                    Log.d("Ironsource", "onRewardedVideoAdClosed() called!");
                    sendEvent("ironSourceRewardedVideoClosedByUser", null);
                }
                @Override
                public void onRewardedVideoAvailabilityChanged(boolean available) {
                    Log.d("Ironsource", "onRewardedVideoAvailabilityChanged() called!");
                    if (available) {
                        Log.d("Ironsource", "ironSourceRewardedVideoAvailable!" );
                        sendEvent("ironSourceRewardedVideoAvailable", null);
                    } else {
                        Log.d("Ironsource", "ironSourceRewardedVideoUnavailable!" );
                        sendEvent("ironSourceRewardedVideoUnavailable", null);
                    }
                }
                @Override
                public void onRewardedVideoAdRewarded(Placement placement) {
                    String rewardName = placement.getRewardName();
                    int rewardAmount = placement.getRewardAmount();
                    Log.d("Ironsource", "onRewardedVideoAdRewarded() called! " + rewardName + " " + rewardAmount);
                    WritableMap map = Arguments.createMap();
                    map.putString("rewardName", rewardName);
                    map.putString("rewardAmount", String.valueOf(rewardAmount));
                    sendEvent("ironSourceRewardedVideoAdRewarded", map);
                }
                @Override
                public void onRewardedVideoAdShowFailed(IronSourceError se) {
                    Log.d("Ironsource", "onRewardedVideoAdShowFailed() called!");
                    sendEvent("ironSourceRewardedVideoClosedByError", null);
                }

                @Override
                public void onRewardedVideoAdClicked(Placement placement) {
                    Log.d("Ironsource", "onRewardedVideoAdClicked() called!");
                }
                @Override
                public void onRewardedVideoAdStarted() {
                    Log.d("Ironsource", "onRewardedVideoAdStarted() called!");
                    sendEvent("ironSourceRewardedVideoAdStarted", null);
                }
                @Override
                public void onRewardedVideoAdEnded() {
                    Log.d("Ironsource", "onRewardedVideoAdEnded() called!");
                    sendEvent("ironSourceRewardedVideoAdEnded", null);
                }
            });
        }
    }

    private void sendEvent(String eventName, @Nullable WritableMap params) {
        getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(eventName, params);
    }

    /**************** 
     * INTERSTITIAL *
     ****************/

    @ReactMethod
    public void initializeInterstitial() {
        IronSource.loadInterstitial();
        Log.d("Ironsource", "Interstitial is initialized");
    }

    @ReactMethod
    public void isInterstitialReady(Promise promise) {
        try {
            Log.d("Ironsource", "isInterstitialReady() called!!");
            promise.resolve(IronSource.isInterstitialReady());
        }
        catch (Exception e) {
            Log.d("Ironsource", "isInterstitialReady error %s", e);
            promise.reject("isInterstitialReadyAvailable, Error, " + e);
        }
    }

    @ReactMethod
    public void showInterstitial(String placementName) {
        IronSource.showInterstitial(placementName);
    }
}
