/**
 * Copyright (c) 2015-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

#import <ODAppUpdate/AppUpdateListenerSingleton.h>

@interface AppDelegate () <AppVersionListener>


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [AppUpdateListenerSingleton sharedManager:self];
  
  NSURL *jsCodeLocation;
  
  jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
  
  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"SampleAppUpdate"
                                               initialProperties:nil
                                                   launchOptions:launchOptions];
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
  
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)checkMigrationAppVersion:(NSMutableDictionary*)storedVersion andCurrentVersion:(NSMutableDictionary*)currentVersion {
  
  int majorStoredVersion = [[storedVersion objectForKey:@"major"]intValue];
  int minorStoredVersion = [[storedVersion objectForKey:@"minor"]intValue];
  int versionStoredCode = [[storedVersion objectForKey:@"version"]intValue];
  
  int majorCurrentVersion = [[currentVersion objectForKey:@"major"]intValue];
  int minorCurrentVersion = [[currentVersion objectForKey:@"minor"]intValue];
  int versionCurrentCode = [[currentVersion objectForKey:@"version"]intValue];
  
  //New version of the app
  if(majorCurrentVersion > majorStoredVersion || minorCurrentVersion > minorStoredVersion || versionCurrentCode > versionStoredCode){
    if(majorCurrentVersion == 1 && majorStoredVersion == 1){
      if (minorCurrentVersion > minorStoredVersion) {
        //Do something
        NSLog(@"new version minorCurrentVersion>minorStoredVersion");
      }
    }
  }
  
  if(majorCurrentVersion > majorStoredVersion || minorCurrentVersion > minorStoredVersion || versionCurrentCode > versionStoredCode){
    //Do something
    NSLog(@"new version");
  }
  
}

@end
