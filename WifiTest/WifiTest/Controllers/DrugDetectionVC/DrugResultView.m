//
//  DrugResultView.m
//  WifiTest
//
//  Created by Hcat on 15/8/23.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "DrugResultView.h"

@interface DrugResultView()

@property (weak, nonatomic) IBOutlet UILabel *lb_drupChina;
@property (weak, nonatomic) IBOutlet UILabel *lb_drupEnglish;


// 测试结果
@property (weak, nonatomic) IBOutlet UILabel *lb_date;

@property (weak, nonatomic) IBOutlet UILabel *lb_beforeTime;
@property (weak, nonatomic) IBOutlet UILabel *lb_beforePEF;
@property (weak, nonatomic) IBOutlet UILabel *lb_beforeFEV1;
@property (weak, nonatomic) IBOutlet UILabel *lb_beforeFVC;
@property (weak, nonatomic) IBOutlet UILabel *lb_beforeFEV1FVC;

@property (weak, nonatomic) IBOutlet UILabel *lb_afterTime;
@property (weak, nonatomic) IBOutlet UILabel *lb_afterPEF;
@property (weak, nonatomic) IBOutlet UILabel *lb_afterFEV1;
@property (weak, nonatomic) IBOutlet UILabel *lb_afterFVC;
@property (weak, nonatomic) IBOutlet UILabel *lb_afterFEV1FVC;



@end


@implementation DrugResultView

+ (DrugResultView *)initCustomView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"DrugResultView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}

-(void)loadData{
    
    if (_beforeMonidata) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date= [dateFormatter dateFromString:_beforeMonidata.saveTime];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *t_dateStr = [dateFormatter stringFromDate:date];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        date= [dateFormatter dateFromString:_beforeMonidata.saveTime];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSString *t_beforeTime = [dateFormatter stringFromDate:date];
        
        _lb_date.text = t_dateStr;
        _lb_beforeTime.text = t_beforeTime;
        _lb_beforePEF.text = [NSString stringWithFormat:@"PEF:%@",[_beforeMonidata.pef stringValue]];
        _lb_beforeFEV1.text = [NSString stringWithFormat:@"FEV1:%@",[_beforeMonidata.fev1 stringValue]];
        _lb_beforeFVC.text = [NSString stringWithFormat:@"FVC:%@",[_beforeMonidata.fvc stringValue]];
        _lb_beforeFEV1FVC.text = [NSString stringWithFormat:@"FEV1/FVC:%.2f%%",[_beforeMonidata.fev1 floatValue]/[_beforeMonidata.fvc floatValue]*100];
    }
    
    if (_afterMonidata) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date= [dateFormatter dateFromString:_afterMonidata.saveTime];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *t_dateStr = [dateFormatter stringFromDate:date];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        date= [dateFormatter dateFromString:_afterMonidata.saveTime];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSString *t_afterTime = [dateFormatter stringFromDate:date];
        
        _lb_date.text = t_dateStr;
        _lb_afterTime.text = t_afterTime;
        _lb_afterPEF.text = [NSString stringWithFormat:@"PEF:%@",[_afterMonidata.pef stringValue]];
        _lb_afterFEV1.text = [NSString stringWithFormat:@"FEV1:%@",[_afterMonidata.fev1 stringValue]];
        _lb_afterFVC.text = [NSString stringWithFormat:@"FVC:%@",[_afterMonidata.fvc stringValue]];
        _lb_afterFEV1FVC.text = [NSString stringWithFormat:@"FEV1/FVC:%.2f%%",[_afterMonidata.fev1 floatValue]/[_afterMonidata.fvc floatValue]*100];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
