//  Created by Olivier Demolliens on 02/06/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "ODAppUpdate.h"

@implementation ODAppUpdate

RCT_EXPORT_MODULE()


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

    if(![appDelegate respondsToSelector:selector]){
        rejecter(0,@"react-native-app-update: Delegate is not implemented!",nil);
    }
    
    [self initVersioning];
    
    NSString *currentStoredVersion = [self storedVersion];
    NSString *currentVersion = [self currentVersion];
    
    if(![currentStoredVersion isEqualToString:currentVersion]){
        //Execute native change
        [appDelegate performSelector:selector withObject:nil withObject:nil];
        
        //Fw to RN
        NSMutableDictionary* wrapVersionDic = [[NSMutableDictionary alloc]init];
        [wrapVersionDic setValue:currentStoredVersion forKey:@"currentStoredVersion"];
        [wrapVersionDic setValue:currentVersion forKey:@"currentVersion"];
        resolve(wrapVersionDic);
        
        [self setStoredVersion:currentVersion];
    }else{
        rejecter(0,@"react-native-app-update: same version !",nil);
    }
}

+(void)initVersioning{
    NSString *storedVersion = [self storedVersion];
    if(storedVersion == nil || [storedVersion length]==0){
        [self setStoredVersion:[self currentVersion]];
    }
}

+(NSString*)currentVersionName{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+(int)currentVersionCode{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSArray* array = [version componentsSeparatedByString:@"."];
    
    if([array count]==3){
        return [[array objectAtIndex:2]intValue];
    }else if([array count]==2){
        return [[array objectAtIndex:1]intValue];
    }else{
        return 0;
    }
}

+(NSString*)currentVersion{
    return [self currentVersionName];
}

+(NSString*)storedVersion{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"rn_app_version"];;
}

+(void)setStoredVersion:(NSString*)version{
    [[NSUserDefaults standardUserDefaults] setValue:version forKey:@"rn_app_version"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
  
