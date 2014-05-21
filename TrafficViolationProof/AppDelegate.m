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
#import "IntroductionController.h"
#import "AntiCameraViewController.h"
#import "ViolationHistoryViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //TODO::根据条件，确定是进入引导流程还是进入主界面
    //条件的确定：安装了新版本，并且有引导配置文件(将引导流程标准化，做几个模板，通过组合的方式来实现引导)
    if(true)
    {
        [self startIntroduction];
    }
    else
    {
        [self startMainUIWithTabbar];
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
-(void)startIntroduction
{
    IntroductionController* introduction = [IntroductionController new];
    self.window.rootViewController = introduction;
    [introduction release];
}

-(void)startMainUIWithTabbar
{
    ViolationQueryViewController* violationController = [ViolationQueryViewController new];
    AboutViewController* aboutController = [AboutViewController new];
    AntiCameraViewController* antiCamera = [AntiCameraViewController new];
    ViolationHistoryViewController* history = [ViolationHistoryViewController new];
    
    UITabBarController* tabbedController = [[UITabBarController alloc]init];
    tabbedController.viewControllers = [[NSArray alloc]initWithObjects:violationController,antiCamera,history,aboutController, nil];
    
    self.window.rootViewController = tabbedController;
    
    [violationController release];
    [aboutController release];
    [antiCamera release];
    [history release];
    
    //set properties
    UITabBar *tabBar = tabbedController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    
    //暂时不考虑支持国际化的问题，字符资源就写在这里了
    tabBarItem1.title = @"查违章";
    tabBarItem2.title = @"防违章";
    tabBarItem3.title = @"历史违章";
    tabBarItem4.title = @"设置";
    
    [tabBarItem1 setSelectedImage:[UIImage imageNamed:@"home_selected.png"]];
    [tabBarItem2 setSelectedImage:[UIImage imageNamed:@"maps_selected.png"]];
}

@end
