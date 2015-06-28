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

@implementation ShareValue



SYNTHESIZE_SINGLETON_FOR_CLASS(ShareValue)

-(void)setM_password:(NSString *)m_password{
    [UserDefaults setObject:m_password forKey:M_PASSWORD];
}

-(NSString *)m_password{
    return [UserDefaults objectForKey:M_PASSWORD];
}

-(void)setM_username:(NSString *)m_username{
    [UserDefaults setObject:m_username forKey:M_USERNAME];
}

-(NSString *)m_username{
    return [UserDefaults objectForKey:M_USERNAME];
}

@end
