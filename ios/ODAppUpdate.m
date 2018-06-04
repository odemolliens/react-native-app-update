//  Created by Olivier Demolliens on 02/06/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "ODAppUpdate.h"

@implementation ODAppUpdate RCT_EXPORT_MODULE()


/*- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}*/


RCT_EXPORT_METHOD(appVersion:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    [ODAppUpdate appVersion:resolve rejecter:reject];
}

+(void)appVersion:(RCTPromiseResolveBlock)resolve
              rejecter:(RCTPromiseRejectBlock)rejecter {
  
    /****/
    id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
    
    SEL selector = NSSelectorFromString(@"checkMigrationAppVersion:andCurrentVersion:");

    if([appDelegate respondsToSelector:selector]){

        [appDelegate performSelector:selector withObject:nil withObject:nil];
    }else{
        NSLog(@"react-native-app-update: Delegate is not implemented!");
    }
    /****/
    
    //Load data and return them
    NSMutableArray *elements = [[NSUserDefaults standardUserDefaults] objectForKey:@"networkData"];
    
    //Forward to RN layer
    resolve(elements);
}

@end
  
