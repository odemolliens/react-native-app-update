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

- (void)checkMigrationAppVersion:(NSArray*)storedVersion andCurrentVersion:(NSArray*)currentVersion {
  
  int majorStoredVersion = [[storedVersion objectAtIndex:0]intValue];
  int minorStoredVersion = [[storedVersion objectAtIndex:1]intValue];
  int versionStoredCode = [[storedVersion objectAtIndex:2]intValue];
  
  int majorCurrentVersion = [[currentVersion objectAtIndex:0]intValue];
  int minorCurrentVersion = [[currentVersion objectAtIndex:1]intValue];
  int versionCurrentCode = [[currentVersion objectAtIndex:2]intValue];
  
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
