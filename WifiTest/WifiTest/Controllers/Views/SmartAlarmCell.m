//
//  SmartAlarmCell.m
//  WifiTest
//
//  Created by Hcat on 15/9/26.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "SmartAlarmCell.h"

@implementation SmartAlarmCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _imageV_DividingLine.backgroundColor = [UIColor colorWithRed:170.f/255.f green:170.f/255.f blue:170.f/255.f alpha:0.5f];
    _imageV_bottomLine.backgroundColor = [UIColor colorWithRed:170.f/255.f green:170.f/255.f blue:170.f/255.f alpha:0.5f];
    _lb_time.highlightedTextColor = [UIColor lightGrayColor];
    _lb_status.highlightedTextColor = _lb_status.textColor;
    // Configure the view for the selected state
}

- (void) setAlarm:(Alarm *)alarm{
    if (alarm) {
        _alarm = alarm;
        
        _lb_time.text = _alarm.time;
        
        if (_alarm.status) {
          
            _lb_status.text = @"ON";
            _lb_status.textColor = UIColorFromRGB(0x4E991C);
            [_btn_switch setImage:[UIImage imageNamed:@"selector_on"] forState:UIControlStateNormal];
            
        } else {
            
            _lb_status.text = @"OFF";
            _lb_status.textColor = [UIColor lightGrayColor];
            [_btn_switch setImage:[UIImage imageNamed:@"selector_off"] forState:UIControlStateNormal];
        
        }
    }

}

- (IBAction)btnSwitchAction:(id)sender {

    if (_alarm) {
        
         _alarm.status = !_alarm.status;
        
        if (_alarm.status) {
            
            _lb_status.text = @"ON";
            _lb_status.textColor = UIColorFromRGB(0x4E991C);
            [_btn_switch setImage:[UIImage imageNamed:@"selector_on"] forState:UIControlStateNormal];
            
        } else {
            
            _lb_status.text = @"OFF";
            _lb_status.textColor = [UIColor lightGrayColor];
            [_btn_switch setImage:[UIImage imageNamed:@"selector_off"] forState:UIControlStateNormal];
            
        }
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ALARMCHANGE object:nil];
}



@end
