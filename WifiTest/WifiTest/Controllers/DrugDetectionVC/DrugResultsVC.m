//
//  DrugResultsVC.m
//  WifiTest
//
//  Created by Hcat on 15/10/26.
//  Copyright © 2015年 CivetCatsTeam. All rights reserved.
//

#import "DrugResultsVC.h"

@interface DrugResultsVC ()

@property (weak, nonatomic) IBOutlet UILabel *lb_drugName;

@property (weak, nonatomic) IBOutlet UILabel *lb_date;

@property (weak, nonatomic) IBOutlet UILabel *lb_afterTime;
@property (weak, nonatomic) IBOutlet UILabel *lb_afterPEF;
@property (weak, nonatomic) IBOutlet UILabel *lb_afterFEV1;
@property (weak, nonatomic) IBOutlet UILabel *lb_afterFVC;
@property (weak, nonatomic) IBOutlet UILabel *lb_afterFEV1FVC;

@property (weak, nonatomic) IBOutlet UILabel *lb_beforeTime;
@property (weak, nonatomic) IBOutlet UILabel *lb_beforePEF;
@property (weak, nonatomic) IBOutlet UILabel *lb_beforeFEV1;
@property (weak, nonatomic) IBOutlet UILabel *lb_beforeFVC;
@property (weak, nonatomic) IBOutlet UILabel *lb_beforeFEV1FVC;

@property (weak, nonatomic) IBOutlet UILabel *lb_result;

@property (weak, nonatomic) IBOutlet UIButton *btn_historyRecord;


@end

@implementation DrugResultsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"今日用药监测";
    [self initUI];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -
#pragma mark privateMethods

- (void)initUI{
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB(110, 85, 120),NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Medium" size:21.0]}];
    
    _lb_drugName.text = _drugName;
    
    UIImage *image_t = [UIImage imageNamed:@"icon_drug_start"];
    UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height/2, image_t.size.width/2, image_t.size.height/2, image_t.size.width/2);
    [_btn_historyRecord setBackgroundImage:[image_t resizableImageWithCapInsets:inset] forState:UIControlStateNormal];
    

    image_t = [UIImage imageNamed:@"icon_drug_start_h"];
    inset = UIEdgeInsetsMake(image_t.size.height/2, image_t.size.width/2, image_t.size.height/2, image_t.size.width/2);
    [_btn_historyRecord setBackgroundImage:[image_t resizableImageWithCapInsets:inset] forState:UIControlStateHighlighted];
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
        [dateFormatter setDateFormat:@"HH:mm"];
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
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *t_afterTime = [dateFormatter stringFromDate:date];
        
        _lb_date.text = t_dateStr;
        _lb_afterTime.text = t_afterTime;
        _lb_afterPEF.text = [NSString stringWithFormat:@"PEF:%@",[_afterMonidata.pef stringValue]];
        _lb_afterFEV1.text = [NSString stringWithFormat:@"FEV1:%@",[_afterMonidata.fev1 stringValue]];
        _lb_afterFVC.text = [NSString stringWithFormat:@"FVC:%@",[_afterMonidata.fvc stringValue]];
        _lb_afterFEV1FVC.text = [NSString stringWithFormat:@"FEV1/FVC:%.2f%%",[_afterMonidata.fev1 floatValue]/[_afterMonidata.fvc floatValue]*100];
        
    }
    
}

#pragma mark -
#pragma mark buttonAction

- (IBAction)historyRecordAction:(id)sender {
    
    
}



#pragma mark -
#pragma mark dealloc

- (void)dealloc{
    
    NSLog(@"DrugResultsVC dealloc");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
