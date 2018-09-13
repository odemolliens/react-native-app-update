# react-native-app-update

## Getting started

`$ npm install react-native-app-update --save`

### Mostly automatic installation

  

`$ react-native link react-native-app-update`

  

### Manual installation

  
  

#### iOS

  

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`

2. Go to `node_modules` ➜ `react-native-app-update` and add `ODAppUpdate.xcodeproj`

3. In XCode, in the project navigator, select your project. Add `libODAppUpdate.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`

4. Run your project (`Cmd+R`)<

  

#### Android

  

1. Open up `android/app/src/main/java/[...]/MainActivity.java`

- Add `import com.odemolliens.appupdate.ODAppUpdatePackage;` to the imports at the top of the file

- Add `new ODAppUpdatePackage()` to the list returned by the `getPackages()` method

2. Append the following lines to `android/settings.gradle`:

```

include ':react-native-app-update'

project(':react-native-app-update').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-app-update/android')

```

3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:

```

compile project(':react-native-app-update')

```

  
  

### Setup iOS

  

1. Open up `AppDelegate.m` 
- Add a new import `#import <ODAppUpdate/AppUpdateListenerSingleton.h>`
- Add a private interface :
 ```
@interface AppDelegate () <AppVersionListener>


@end
```  

- Add `[AppUpdateListenerSingleton sharedManager:self];` in the method `application:didFinishLaunchingWithOptions`
- Add the new protocol:
```
- (void)checkMigrationAppVersion:(NSString *)previousversion andCurrentVersion:(NSString *)currentversion {
        //Do something 
}
```
  
 ### Setup Android
 
1. Open up `MainApplication.java`:
- Add in the  `getPackages` method:
```
new ODAppUpdatePackage(new AppVersionListener() {  
	    @Override  
	    public void checkMigrationAppVersion(String previousversion, String currentversion) {   
        //Do something 
        }  
})
```


## Usage

```javascript

import  ODAppUpdate  from  'react-native-app-update';

  

// TODO: What to do with the module?

ODAppUpdate;

```
