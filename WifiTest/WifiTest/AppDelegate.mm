//
//  AppDelegate.m
//  WifiTest
//
//  Created by Hcat on 15/6/13.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "AppDelegate.h"

#import "IQKeyboardManager.h"

#import "LoginVC.h"
#import <BaiduMapAPI/BMapKit.h>

@interface AppDelegate ()

@property(nonatomic,strong)BMKMapManager* mapManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self thirdPartInit];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    LoginVC *t_vc = [[LoginVC alloc]init];
    _nav = [[UINavigationController alloc]initWithRootViewController:t_vc];
    self.window.rootViewController = _nav;
    [self.window makeKeyAndVisible];

    return YES;
}

-(void)thirdPartInit{
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"FufNFX9PxAmGkyKLPAEaCxmK"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [BMKMapView willBackGround];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
     [BMKMapView didForeGround];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
