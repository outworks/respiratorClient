//
//  SmartAlarmSetVC.h
//  WifiTest
//
//  Created by Hcat on 15/9/26.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "BasicVC.h"
#import "Alarm.h"

typedef NS_ENUM(NSUInteger, SmartAlarmSetType) {
    SmartAlarmSetTypeAdd,
    SmartAlarmSetTypeSet
};


@protocol SmartAlarmSetVCDelegate <NSObject>

@required
- (void)alarmIsdidAdded:(Alarm *)alarm;

@end


@interface SmartAlarmSetVC : BasicVC

@property (nonatomic,strong) Alarm *alarm;
@property (nonatomic,weak) id<SmartAlarmSetVCDelegate> deleaget;
@property (nonatomic) SmartAlarmSetType type;

@end
