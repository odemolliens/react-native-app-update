//  Created by Olivier Demolliens on 02/06/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "ODAppUpdate.h"

@implementation ODAppUpdate

RCT_EXPORT_MODULE()


- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}


RCT_EXPORT_METHOD(appVersion:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    [ODAppUpdate appVersion:resolve rejecter:reject];
}

+(void)appVersion:(RCTPromiseResolveBlock)resolve
              rejecter:(RCTPromiseRejectBlock)rejecter {
  
    id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
    
    SEL selector = NSSelectorFromString(@"checkMigrationAppVersion:andCurrentVersion:");

    if(![appDelegate respondsToSelector:selector]){
        rejecter(0,@"react-native-app-update: Delegate is not implemented!",nil);
    }
    
    [self initVersioning];
    
    NSArray *currentStoredVersion = [self storedVersion];
    int majorStoredVersion = [[currentStoredVersion objectAtIndex:0]intValue];
    int minorStoredVersion = [[currentStoredVersion objectAtIndex:1]intValue];
    int versionStoredCode = [[currentStoredVersion objectAtIndex:2]intValue];
    
    NSArray *currentVersion = [self currentVersionName];
    int majorCurrentVersion = [[currentVersion objectAtIndex:0]intValue];
    int minorCurrentVersion = [[currentVersion objectAtIndex:1]intValue];
    int versionCurrentCode = [[currentVersion objectAtIndex:2]intValue];
    
    if(majorCurrentVersion > majorStoredVersion || minorCurrentVersion > minorStoredVersion || versionCurrentCode > versionStoredCode){
        //Fw to RN
        NSMutableDictionary* wrapVersionDic = [[NSMutableDictionary alloc]init];
        
        NSMutableDictionary* wrapStoredDic = [[NSMutableDictionary alloc]init];
        [wrapStoredDic setValue:[NSNumber numberWithInt:majorStoredVersion] forKey:@"major"];
        [wrapStoredDic setValue:[NSNumber numberWithInt:minorStoredVersion] forKey:@"minor"];
        [wrapStoredDic setValue:[NSNumber numberWithInt:versionStoredCode] forKey:@"version"];
        
        NSMutableDictionary* wrapCurrentDic = [[NSMutableDictionary alloc]init];
        [wrapCurrentDic setValue:[NSNumber numberWithInt:majorCurrentVersion] forKey:@"major"];
        [wrapCurrentDic setValue:[NSNumber numberWithInt:minorCurrentVersion] forKey:@"minor"];
        [wrapCurrentDic setValue:[NSNumber numberWithInt:versionCurrentCode] forKey:@"version"];
        
        [wrapVersionDic setValue:wrapStoredDic forKey:@"currentStoredVersion"];
        [wrapVersionDic setValue:wrapCurrentDic forKey:@"currentVersion"];
        
        resolve(wrapVersionDic);
        
        //Execute native change
        [appDelegate performSelector:selector withObject:wrapStoredDic withObject:wrapCurrentDic];
        
        [self setStoredVersion:[self buildArrayNumberToString:[self currentVersionName]]];
    }else{
        rejecter(0,@"react-native-app-update: same version !",nil);
    }
}

+(void)initVersioning{
    
    NSArray *storedVersion = [self storedVersion];
    int majorVersion = [[storedVersion objectAtIndex:0]intValue];
    int minorVersion = [[storedVersion objectAtIndex:1]intValue];
    int versionCode = [[storedVersion objectAtIndex:2]intValue];
    
    if(majorVersion == 0 && minorVersion == 0 && versionCode == 0){
        //Lib is not initialized
        [self setStoredVersion: [self buildArrayNumberToString:[self currentVersionName]]];
    }
}

+(NSArray*)currentVersionName{
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSArray* array = [currentVersion componentsSeparatedByString:@"."];
    array = [self buildNSNumberArrayWithStringArray:array];
    if([array count]==3){
        return array;
    }else{
        return [self buildNSNumberArrayWithStringArray:[NSArray arrayWithObjects:@"0",@"0", nil]];
    }
}

+(NSArray*)storedVersion{
    NSString *version =  [[NSUserDefaults standardUserDefaults] stringForKey:@"rn_app_version"];
    
    if(version == nil){
        return [NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0], nil];
    }
    
    NSArray* array = [version componentsSeparatedByString:@"."];
    
    if([array count]==3){
        return array;
    }else {
        return [NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0], nil];
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
        if(i!=([array count]-1)){
            [mString appendString:@"."];
        }
       
    }
    return mString;
}


@end
  
