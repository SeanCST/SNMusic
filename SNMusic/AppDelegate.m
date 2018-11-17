//
//  AppDelegate.m
//  SNMusic
//
//  Created by 肖恩伟 on 2018/11/16.
//  Copyright © 2018 肖恩伟. All rights reserved.
//

#import "AppDelegate.h"
#include "SNLoginViewController.h"
#include "SNTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 查看登录状态，未登录则显示登陆界面，已登录则直接显示首页
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL LoginedAccount = [defaults boolForKey:@"LoginedAccount"];
    LoginedAccount = YES;
    // 设置根控制器
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if (LoginedAccount) { // 未登录
        self.window.rootViewController = [[SNTabBarController alloc] init];
    } else { // 已登录
        self.window.rootViewController = [[SNLoginViewController alloc] init];
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
