//
//  AppUpdateListenerSingleton.m
//  ODAppUpdate
//
//  Created by Olivier Demolliens on 02/06/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "AppUpdateListenerSingleton.h"



@interface AppUpdateListenerSingleton()

@property(nonatomic, assign) id<AppVersionListener> listener;

@end

@implementation AppUpdateListenerSingleton


+ (id)sharedManager {
    static AppUpdateListenerSingleton *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            //Init
    });
    return sharedMyManager;
}

-(void)setAppListener:(id<AppVersionListener>)newListener{
    self.listener = newListener;
}
@end
