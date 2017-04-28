
# react-native-now-playing

## Getting started

`$ npm install react-native-now-playing --save`

### Mostly automatic installation

`$ react-native link react-native-now-playing`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-now-playing` and add `RNNowPlaying.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNNowPlaying.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNNowPlayingPackage;` to the imports at the top of the file
  - Add `new RNNowPlayingPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-now-playing'
  	project(':react-native-now-playing').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-now-playing/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-now-playing')
  	```

## Usage
```javascript
import RNNowPlaying from 'react-native-now-playing';

// TODO: What to do with the module?
RNNowPlaying;
```
  