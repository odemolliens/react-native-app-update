//
//  AppUpdateListenerSingleton.m
//  ODAppUpdate
//
//  Created by Olivier Demolliens on 02/06/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "AppUpdateListenerSingleton.h"
#import <UIKit/UIKit.h>


@interface AppUpdateListenerSingleton()

@property(nonatomic, strong) id<AppVersionListener> listener;

@end

@implementation AppUpdateListenerSingleton


+ (id)sharedManager:(id<AppVersionListener>)newListener {
    static AppUpdateListenerSingleton *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //Init
        sharedMyManager.listener = newListener;
    });
    return sharedMyManager;
}
@end
