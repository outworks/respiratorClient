//
//  Alarm.h
//  WifiTest
//
//  Created by Hcat on 15/9/26.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alarm : NSObject

@property (nonatomic,strong) NSString *time; //时间
@property (nonatomic)        BOOL      status; //开还是关

@end
