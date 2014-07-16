//
//  SMAppDelegate.m
//  ShaunMerritt_AfterburnerApplication
//
//  Created by Shaun Merritt on 7/11/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMAppDelegate.h"
#import "SMRateMoviesViewController.h"
#import "NetworkEngine.h"


@implementation SMAppDelegate
@synthesize networkEngine;
@synthesize favoriteMpaa_rating;
@synthesize favoriteRunTimes;
@synthesize minutesToBeWithin;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    minutesToBeWithin = 30;
    
    
        
    /* NETWORK SETUP */
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
    
    self.networkEngine = [[NetworkEngine alloc]
                          initWithHostName:kBaseURL
                          customHeaderFields:nil];
    [self.networkEngine useCache];
    
    self.imdbNetworkEngine = [[NetworkEngine alloc]
                              initWithHostName:@"www.imdb.com/xml/find?json=1&nr=1&nm=on&q="
                              customHeaderFields:nil];
    [self.imdbNetworkEngine useCache];

    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
