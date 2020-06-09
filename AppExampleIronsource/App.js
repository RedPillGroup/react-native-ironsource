import * as React from 'react';
import { Platform, StyleSheet, Text, View, Button } from 'react-native';

import Ironsource from '@redpill-paris/react-native-ironsource';

const instructions = Platform.select({
  ios: `Press Cmd+R to reload,\nCmd+D or shake for dev menu`,
  android: `Double tap R on your keyboard to reload,\nShake or press menu button for dev menu`,
});

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
      <Button title={'initializeInterstitial'} onPress={() => {
        console.log('Ironsource initializeInterstitial');
        Ironsource.initializeInterstitial();
      }}/>
      <Button title={'call is interstitial'} onPress={async () => {
        console.log('Ironsource is interstitial available called');
        console.log('Ironsource is interstitial available ?', await Ironsource.isInterstitialReady());
      }}/>
      <Button title={'showInterstitial'} onPress={() => {
        console.log('Ironsource showInterstitial called');
        Ironsource.showInterstitial('DefaultRewardedVideo');
      }}/>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
