//
//  SmartAlarmCell.h
//  WifiTest
//
//  Created by Hcat on 15/9/26.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Alarm.h"

@interface SmartAlarmCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UILabel *lb_status;
@property (weak, nonatomic) IBOutlet UIButton *btn_switch;



@property (weak, nonatomic) IBOutlet UIImageView *imageV_topLine;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_bottomLine;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_DividingLine;

@property (nonatomic,strong) Alarm *alarm;

@end
