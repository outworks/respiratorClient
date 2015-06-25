//
//  PickView.m
//  WifiTest
//
//  Created by nd on 15/6/25.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "PickView.h"

@implementation PickView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (PickView *)initCustomView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PickView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}


- (IBAction)tapAction:(id)sender {
    [self hide];
}

- (IBAction)finishAction:(id)sender {
    
    
}


-(void)show{
    [UIView animateWithDuration:0.5 animations:^{   //老封面渐隐效果
        _imageV_bg.alpha = 0.5f;
    } completion:^(BOOL finished){
        
    }];
    
    [UIView animateWithDuration:0.5 animations:^{   //老封面渐隐效果
        CGRect frame = _v_bottom.frame;
        frame.origin.y = frame.origin.y - 225;
        _v_bottom.frame = frame;
    } completion:^(BOOL finished){
        
    }];
    
}



-(void)hide{
    [UIView animateWithDuration:0.5 animations:^{   //老封面渐隐效果
        _imageV_bg.alpha = 0.5f;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.5 animations:^{   //老封面渐隐效果
            CGRect frame = _v_bottom.frame;
            frame.origin.y = frame.origin.y + 225;
            _v_bottom.frame = frame;
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
    }];
}

@end
