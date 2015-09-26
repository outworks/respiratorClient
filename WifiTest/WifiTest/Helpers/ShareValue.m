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
}

-(NSArray *)arr_alarms{
    return [UserDefaults objectForKey:ARR_ALARMS];
}

@end
