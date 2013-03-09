//
//  MBAppDelegate.m
//  SpacialDemo
//
//  Created by Mo Bitar on 2/17/13.
//  Copyright (c) 2013 progenius. All rights reserved.
//

#import "MBAppDelegate.h"
#import "MasterViewController.h"

@implementation MBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    MasterViewController *master = [[MasterViewController alloc] init];
    self.window.rootViewController = master;
    [self.window makeKeyAndVisible];
    return YES;
}
@end
