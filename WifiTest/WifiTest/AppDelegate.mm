//
//  AppDelegate.m
//  WifiTest
//
//  Created by Hcat on 15/6/13.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "AppDelegate.h"

#import "IQKeyboardManager.h"

#import "ProductVC.h"
#import "Alarm.h"
#import "LK_NSDictionary2Object.h"
#import <BaiduMapAPI/BMapKit.h>



@interface AppDelegate ()

@property(nonatomic,strong)BMKMapManager* mapManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self thirdPartInit];
    [self addAlarmLocalNotification];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
     self.window.backgroundColor = UIColorFromRGBA(0x1d2124,0.95f);
    
    ProductVC *t_vc = [[ProductVC alloc]init];
    _nav = [[UINavigationController alloc]initWithRootViewController:t_vc];
    self.window.rootViewController = _nav;
    [self.window makeKeyAndVisible];

    return YES;
}

-(void)thirdPartInit{
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BAIDUMAPKEY  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

-(void)addAlarmLocalNotification{

    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        
    }
    
    NSDate* now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:now];
    NSInteger hour = [comps hour];
    NSInteger min = [comps minute];
    NSInteger sec = [comps second];
    
    NSArray *arr_alarms = [ShareValue sharedShareValue].arr_alarms;

    for (NSDictionary *t_dic in arr_alarms) {
        Alarm *t_alarm = [t_dic objectByClass:[Alarm class]];
        if (t_alarm.status) {
            NSArray *arr_time = [t_alarm.time componentsSeparatedByString:@":"];
            NSInteger hs=[(NSString *)arr_time[0] integerValue] - hour;
            NSInteger ms=[(NSString *)arr_time[1] integerValue] - min;
            NSInteger hm=(hs*3600)+(ms*60)-sec;
            NSLog(@"%ld",hm);
            //建立后台消息对象
            UILocalNotification *notification=[[UILocalNotification alloc] init];
            if (notification!=nil)
            {
                notification.repeatInterval=kCFCalendarUnitDay;
                NSDate *now1=[NSDate new];
                notification.fireDate=[now1 dateByAddingTimeInterval:hm];//距现在多久后触发代理方法
                notification.timeZone=[NSTimeZone defaultTimeZone];
                notification.soundName = UILocalNotificationDefaultSoundName;
                notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"你设置的时间是：%@：%@ .",nil),arr_time[0] ,arr_time[1]];
                [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
            }
        }
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

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif
{
    
}

@end
