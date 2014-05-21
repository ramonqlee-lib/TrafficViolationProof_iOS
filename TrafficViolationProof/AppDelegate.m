//
//  AppDelegate.m
//  TrafficViolationProof
//
//  Created by ramonqlee on 5/21/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "AppDelegate.h"
#import "ViolationQueryViewController.h"
#import "AboutViewController.h"
#import "MYViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //TODO::第一次使用软件或者升级后
    if(true)
    {
        [self initIntroduction];
    }
    else
    {
        [self initTabBar];
    }
    
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

#pragma mark init
-(void)initIntroduction
{
    MYViewController* introduction = [MYViewController new];
    self.window.rootViewController = introduction;
    [introduction release];
}

-(void)initTabBar
{
    ViolationQueryViewController* violationController = [ViolationQueryViewController new];
    AboutViewController* aboutController = [AboutViewController new];
    
    UITabBarController* tabbedController = [[UITabBarController alloc]init];
    tabbedController.viewControllers = [[NSArray alloc]initWithObjects:violationController,aboutController, nil];
    
    self.window.rootViewController = tabbedController;
    
    [violationController release];
    [aboutController release];
    
    //set properties
    UITabBar *tabBar = tabbedController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    tabBarItem1.title = @"Home";
    tabBarItem2.title = @"Maps";
    
    
    [tabBarItem1 setSelectedImage:[UIImage imageNamed:@"home_selected.png"]];
    [tabBarItem2 setSelectedImage:[UIImage imageNamed:@"maps_selected.png"]];
}

@end
