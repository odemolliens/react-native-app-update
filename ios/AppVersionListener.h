//
//  AppVersionListener.h
//  ODAppUpdate
//
//  Created by Olivier Demolliens on 02/06/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AppVersionListener

- (void)checkMigrationAppVersion:(NSArray*)storedVersion andCurrentVersion:(NSArray*)currentVersion;

@end
