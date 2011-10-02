//
//  SunGardConnectAppDelegate.h
//  SunGardConnect
//
//  Created by Sonny on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AuthenticationController;

@interface SunGardConnectAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet AuthenticationController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
