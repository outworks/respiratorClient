//
//  PickView.h
//  WifiTest
//
//  Created by nd on 15/6/25.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageV_bg;

@property (weak, nonatomic) IBOutlet UIView *v_bottom;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

+ (PickView *)initCustomView;

-(void)show;
-(void)hide;

@end
