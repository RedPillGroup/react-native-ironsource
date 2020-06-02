import { NativeModules, NativeEventEmitter } from 'react-native';

const { Ironsource } = NativeModules;

// const IronSourceRewardedVideoEventEmitter = new NativeEventEmitter(Ironsource);

// const eventHandlers = {
//   ironSourceRewardedVideoAvailable: new Map(),
// }

export default Ironsource;
