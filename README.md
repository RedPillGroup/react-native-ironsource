# react-native-ironsource
react-native-ironsource is a bridge to use ironsource android and ios SDK .

Part of SDK implemented:
- Initialisation.
- Rewarded video.

## Install

```
  yarn add @redpill-paris/react-native-ironsource
```

## Configuration

### Android
Add the following to your android/build.gradle file inside repositories section:
```javascript
  maven {
    url "https://dl.bintray.com/ironsource-mobile/android-sdk"
  }
```
Then add the following to the dependencies section of your android/ap/build.gradle:
```javascript
  dependencies {
      implementation 'com.ironsource.sdk:mediationsdk:6.16.2' 
  }
```

Add the following permissions to your AndroidManifest.xml file inside the manifest tag but outside the <application> tag:
```xml
  <uses-permission android:name="android.permission.INTERNET" />
  <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

Add the following activities inside the <application> tag in your AndroidManifest:
```xml
  <activity
    android:name="com.ironsource.sdk.controller.ControllerActivity"
    android:configChanges="orientation|screenSize"
    android:hardwareAccelerated="true"
  />
  <activity
    android:name="com.ironsource.sdk.controller.InterstitialActivity"
    android:configChanges="orientation|screenSize"
    android:hardwareAccelerated="true"
    android:theme="@android:style/Theme.Translucent"
  />
  <activity
    android:name="com.ironsource.sdk.controller.OpenUrlActivity"
    android:configChanges="orientation|screenSize"
    android:hardwareAccelerated="true"
    android:theme="@android:style/Theme.Translucent"
  />
```

Add the Play Services dependencies into the dependencies block:
```
  dependencies {
      implementation fileTree(dir: 'libs', include: ['*.jar'])
      implementation 'com.google.android.gms:play-services-ads-identifier:17.0.0'
      implementation 'com.google.android.gms:play-services-basement:17.1.1'
  }
```
You need to add the Network Adapters you want in the podfil of your app.

Exemple:
```
    implementation 'com.ironsource.adapters:vungleadapter:4.3.0@jar'
    implementation 'com.vungle:publisher-sdk-android:6.5.3'

    implementation 'com.ironsource.adapters:adcolonyadapter:4.3.0@jar'
    implementation 'com.adcolony:sdk:4.1.4'

    implementation 'com.ironsource.adapters:facebookadapter:4.3.14@jar'
    implementation 'com.facebook.android:audience-network-sdk:5.9.0'
```

Look at the official documentation for more information:
https://developers.ironsrc.com/ironsource-mobile/android/mediation-networks-android/

### IOS
You need to add the Network Adapters you want in the podfil of your app.

Exemple:
```javascript
  pod 'IronSourceAppLovinAdapter','> 1'
  pod 'IronSourceVungleAdapter','> 1'
  pod 'IronSourceFacebookAdapter','> 1'
  pod 'IronSourceAdColonyAdapter','> 1'
```

Look at the official documentation for more information:
https://developers.ironsrc.com/ironsource-mobile/ios/mediation-networks-ios/

## Methods:

- ## Initialisation:

### initIronsourceSDK: 
```javascript
  await Ironsource.initIronsourceSDK('a392e26d', 'demoapp', { activateIntegrationHelper: true });
```
### setConsent: 
```javascript
  IronSource.setConsent(true);
```

- ## Rewarded Video:

### initializeRewardedVideo
```javascript
  Ironsource.initializeRewardedVideo();
```
### isRewardedVideoAvailable: 
```javascript
  await Ironsource.isRewardedVideoAvailable();
```

### isRewardedVideoAvailable: 
```javascript
  await Ironsource.isRewardedVideoAvailable();
```
### showRewardedVideo: 
```javascript
  Ironsource.showRewardedVideo('DefaultRewardedVideo');
```

## Listeners

Listeners available:
- 'ironSourceRewardedVideoAvailable'
- 'ironSourceRewardedVideoUnavailable'
- 'ironSourceRewardedVideoDidOpen'
- 'ironSourceRewardedVideoDidStart'
- 'ironSourceRewardedVideoClosedByUser'
- 'ironSourceRewardedVideoClosedByError'
- 'ironSourceRewardedVideoAdStarted'
- 'ironSourceRewardedVideoAdEnded'
- 'ironSourceRewardedVideoAdRewarded'

### addEventListener: 
```javascript
    function listenerRewardVideo(resolve, reject) {
      Ironsource.addEventListener('ironSourceRewardedVideoAdRewarded', res => {
        console.log(`Rewarded! ${JSON.stringify(res)}`, 'log');
        resolve();
      });
    }
```

## Exemple:

```javascript
export default function App() {

  function listenerRewardVideo(resolve, reject) {
    console.log('Setup Listeners reward Video', 'log');
    Ironsource.addEventListener('ironSourceRewardedVideoAdRewarded', res => {
      console.log(`Rewarded! ${JSON.stringify(res)}`, 'log');
      resolve();
    });
    Ironsource.addEventListener('ironSourceRewardedVideoClosedByUser', () => {
      console.log(`Video reward closed by the User`, 'warn');
      Ironsource.removeAllListeners();
      resolve();
    });
    Ironsource.addEventListener('ironSourceRewardedVideoClosedByError', () => {
      console.log(`Video reward closed by an Error`, 'error');
      Ironsource.removeAllListeners();
      reject(new Error('Video closed by an error'));
    });
    console.log('Success Setup Listeners reward Video', 'log');
  }

  return (
    <View style={styles.container}>
      <Button title={'Init'} onPress={async () => {
        console.log('Ironsource from app:', Ironsource);
        await Ironsource.initIronsourceSDK(Platform === 'ios'  ? 'a8de03dd' : 'a392e26d', 'demoapp', { activateIntegrationHelper: true });
      }}/>
      <Button title={'init rewarded'} onPress={() => {
        console.log('init rewarded');
        Ironsource.initializeRewardedVideo();
      }}/>
      <Button title={'call is rewarded'} onPress={async () => {
        console.log('Ironsource is rewarded video available called');
        console.log('Ironsource is rewarded video available ?', await Ironsource.isRewardedVideoAvailable());
      }}/>
      <Button title={'Show'} onPress={() => {
        return new Promise(async (resolve, reject) => {
          listenerRewardVideo(resolve, reject);
          console.log('Ironsource showrewarded video');
          Ironsource.showRewardedVideo('DefaultRewardedVideo');
        });
      }}/>
    </View>
  );
}
```

Don't forget to take a look at the AppExampleIronsource for more information !