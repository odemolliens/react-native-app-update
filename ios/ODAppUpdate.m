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
    
    NSArray *currentStoredVersion = [self storedVersion];
    NSNumber* majorStoredVersion = [currentStoredVersion objectAtIndex:0];
    NSNumber* minorStoredVersion = [currentStoredVersion objectAtIndex:1];
    NSNumber* versionStoredCode = [currentStoredVersion objectAtIndex:2];
    
    NSArray  *currentVersion = [self currentVersion];
    NSNumber* majorCurrentVersion = [currentVersion objectAtIndex:0];
    NSNumber* minorCurrentVersion = [currentVersion objectAtIndex:1];
    NSNumber* versionCurrentCode = [currentVersion objectAtIndex:2];
    
    if(majorCurrentVersion > majorStoredVersion || minorCurrentVersion > minorStoredVersion || versionCurrentCode > versionStoredCode){
        //Execute native change
        [appDelegate performSelector:selector withObject:nil withObject:nil];
        
        //Fw to RN
        NSMutableDictionary* wrapVersionDic = [[NSMutableDictionary alloc]init];
        [wrapVersionDic setValue:currentStoredVersion forKey:@"currentStoredVersion"];
        [wrapVersionDic setValue:currentVersion forKey:@"currentVersion"];
        resolve(wrapVersionDic);
        [self setStoredVersion:[self buildArrayNumberToString:currentVersion]];
    }else{
        rejecter(0,@"react-native-app-update: same version !",nil);
    }
}

+(void)initVersioning{
    
    NSArray *storedVersion = [self storedVersion];
    NSNumber* majorVersion = [storedVersion objectAtIndex:0];
    NSNumber* minorVersion = [storedVersion objectAtIndex:1];
    NSNumber* versionCode = [storedVersion objectAtIndex:2];
    
    if(majorVersion == 0 && minorVersion == 0 && versionCode == 0){
        //Lib is not initialized
       
        [self setStoredVersion: [self buildArrayNumberToString:[self currentVersion]]];
    }
}


+(NSArray*)currentVersionName{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSArray* array = [currentVersion componentsSeparatedByString:@"."];
    array = [self buildNSNumberArrayWithStringArray:array];
    if([array count]==2){
        return array;
    }else{
        return [self buildNSNumberArrayWithStringArray:[NSArray arrayWithObjects:@"0",@"0", nil]];
    }
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

+(NSArray*)currentVersion{
    NSArray* arrayCurrentVersionName = [self currentVersionName];
    return [NSArray arrayWithObjects:[arrayCurrentVersionName objectAtIndex:0],[arrayCurrentVersionName objectAtIndex:1],[self currentVersionCode], nil];
}

+(NSArray*)storedVersion{
    NSString *version =  [[NSUserDefaults standardUserDefaults] stringForKey:@"rn_app_version"];
    
    if(version == nil || [version isEqualToString:@""]){
        return [NSArray arrayWithObjects:@"0",@"0",@"0", nil];
    }
    
    NSArray* array = [version componentsSeparatedByString:@"."];
    
    if([array count]==3){
        return array;
    }else {
        return [NSArray arrayWithObjects:@"0",@"0",@"0", nil];
    }
}

+(void)setStoredVersion:(NSString*)version{
    [[NSUserDefaults standardUserDefaults] setValue:version forKey:@"rn_app_version"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSArray*)buildNSNumberArrayWithStringArray:(NSArray*)array{
    NSMutableArray *arrayInt = [[NSMutableArray alloc]init];
    for(int i = 0; i < [array count];i++){
        [arrayInt addObject:[NSNumber numberWithInt:[[array objectAtIndex:i]intValue]]];
    }
    return arrayInt;
}

+(NSString*)buildArrayNumberToString:(NSArray*)array{
    NSMutableString *mString = [[NSMutableString alloc]init];
    for(int i = 0; i < [array count];i++){
        [mString appendString:[[array objectAtIndex:i]stringValue]];
    }
    return mString;
}


@end
  
