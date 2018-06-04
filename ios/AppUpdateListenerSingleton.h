//
//  AppUpdateListenerSingleton.h
//  ODAppUpdate
//
//  Created by Olivier Demolliens on 02/06/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppVersionListener.h"

@interface AppUpdateListenerSingleton : NSObject
{
    
}

+ (id)sharedManager:(id<AppVersionListener>)newListener;


@end
