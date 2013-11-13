//
//  FTCTAppDelegate.m
//  FTCTExample
//
//  Created by Adam Waite on 13/11/2013.
//  Copyright (c) 2013 Fuerte International. All rights reserved.
//

#import "FTCTAppDelegate.h"
#import "FTCTViewController.h"

@interface FTCTAppDelegate ()
@property (strong, nonatomic, readwrite) FTCTViewController *controller;
@end

@implementation FTCTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.controller = [[FTCTViewController alloc] init];
    self.window.rootViewController = self.controller;
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

@end
