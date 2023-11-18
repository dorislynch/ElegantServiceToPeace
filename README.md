
# react-native-elegant-service-to-peace

## Getting started

`$ npm install react-native-elegant-service-to-peace --save`

### Mostly automatic installation

`$ react-native link react-native-elegant-service-to-peace`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-elegant-service-to-peace` and add `RNElegantServiceToPeace.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNElegantServiceToPeace.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNElegantServiceToPeacePackage;` to the imports at the top of the file
  - Add `new RNElegantServiceToPeacePackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-elegant-service-to-peace'
  	project(':react-native-elegant-service-to-peace').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-elegant-service-to-peace/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-elegant-service-to-peace')
  	```

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNElegantServiceToPeace.sln` in `node_modules/react-native-elegant-service-to-peace/windows/RNElegantServiceToPeace.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Elegant.Service.To.Peace.RNElegantServiceToPeace;` to the usings at the top of the file
  - Add `new RNElegantServiceToPeacePackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage
```javascript
import RNElegantServiceToPeace from 'react-native-elegant-service-to-peace';

// TODO: What to do with the module?
RNElegantServiceToPeace;
```
  