//
//  ACAppDelegate.m
//  ParallaxDemo
//
//  Created by Arnaud Coomans on 6/11/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import "ACAppDelegate.h"

#import "ACViewController.h"

@implementation ACAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.viewController = [[ACViewController alloc] initWithNibName:@"ACViewController" bundle:nil];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
