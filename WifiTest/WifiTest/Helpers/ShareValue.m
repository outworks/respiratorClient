//
//  ShareValue.m
//  HelloToy
//
//  Created by nd on 15/4/21.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "ShareValue.h"
#import "UtilsMacro.h"


#define M_USERNAME @"M_USERNAME"
#define M_PASSWORD @"M_PASSWORD"
#define M_BINDNO @"M_BINDNO"
#define ARR_ALARMS @"ARR_ALARMS"

#import "Alarm.h"
#import "LK_NSDictionary2Object.h"

@implementation ShareValue



SYNTHESIZE_SINGLETON_FOR_CLASS(ShareValue)

-(void)setM_password:(NSString *)m_password{
    [UserDefaults setObject:m_password forKey:M_PASSWORD];
    [UserDefaults synchronize];
}

-(NSString *)m_password{
    return [UserDefaults objectForKey:M_PASSWORD];
}

-(void)setM_username:(NSString *)m_username{
    [UserDefaults setObject:m_username forKey:M_USERNAME];
    [UserDefaults synchronize];
}

-(NSString *)m_username{
    return [UserDefaults objectForKey:M_USERNAME];
}

-(void)setBindNo:(NSString *)bindNo{
    [UserDefaults setObject:bindNo forKey:M_BINDNO];
    [UserDefaults synchronize];
}

-(NSString *)bindNo{
    return [UserDefaults objectForKey:M_BINDNO];
}

-(void)setArr_alarms:(NSArray *)arr_alarms{
    [UserDefaults setObject:arr_alarms forKey:ARR_ALARMS];
    [UserDefaults synchronize];
    [self addAlarmLocalNotification:arr_alarms];
}

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

-(void)addAlarmLocalNotification:(NSArray *)arr_alarms{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    if (IS_OS_8_OR_LATER) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        [[UIApplication sharedApplication]  registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
    }
    
    NSDate* now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:now];
    
    for (NSDictionary *t_dic in arr_alarms) {
        Alarm *t_alarm = [t_dic objectByClass:[Alarm class]];
        if (t_alarm.status) {
            NSDate *now = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString=[formatter stringFromDate:now];
            NSString *alarmTime = [dateString stringByAppendingFormat:@" %@:00",t_alarm.time];
            
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *alarmDate = [formatter dateFromString:alarmTime];
            
            NSTimeInterval timeinterval = [alarmDate timeIntervalSinceDate:now];
            if(timeinterval < 0){
                timeinterval = 24*3600 + timeinterval;
            }
            //            NSArray *arr_time = [t_alarm.time componentsSeparatedByString:@":"];
            //            NSInteger hs=[(NSString *)arr_time[0] integerValue] - hour;
            //            NSInteger ms=[(NSString *)arr_time[1] integerValue] - min;
            //            NSInteger hm=(hs*3600)+(ms*60)-sec;
            //            NSLog(@"%ld",hm);
            //建立后台消息对象
            UILocalNotification *notification=[[UILocalNotification alloc] init];
            if (notification!=nil)
            {
                notification.repeatInterval=kCFCalendarUnitDay;
                //                NSDate *now1=[NSDate new];
                notification.fireDate=[now dateByAddingTimeInterval:timeinterval];//距现在多久后触发代理方法
//                notification.timeZone=[NSTimeZone defaultTimeZone];
                notification.alertBody = [NSString stringWithFormat:@"该吃药了!!"];
                notification.soundName = @"ring.caf";
                notification.alertAction = @"查看";
                [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
            }
        }
    }
    
}


-(NSArray *)arr_alarms{
    return [UserDefaults objectForKey:ARR_ALARMS];
}

@end
