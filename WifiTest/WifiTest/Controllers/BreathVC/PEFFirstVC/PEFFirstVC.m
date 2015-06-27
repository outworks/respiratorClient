//
//  PEFFirstVC.m
//  WifiTest
//
//  Created by Hcat on 15/6/27.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "PEFFirstVC.h"
#import "PNChart.h"
#import "TestTool.h"
#import "ShareValue.h"
#import "DataAPI.h"

@interface PEFFirstVC ()

@property (weak, nonatomic) IBOutlet UIView *v_bg;
@property (weak, nonatomic) IBOutlet UILabel *lb_state;
@property (weak, nonatomic) IBOutlet UILabel *lb_info;

@property (weak, nonatomic) IBOutlet UILabel *lb_pef;

@property (nonatomic) PNCircleChart * circleChart;


@end

@implementation PEFFirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - private 

-(void)loadCircleChart:(float)number{
    
    UIColor *color;
    
    if (number > 0.8) {
        color = RGB(33, 211, 58);
    }else if(number < 0.8 && number > 0.6){
        color = RGB(237, 229, 107);
    }else if(number < 0.6){
        color = RGB(237, 14, 72);
    }
    
    [self.circleChart removeFromSuperview];
    self.circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0,0, _v_bg.frame.size.width-10, _v_bg.frame.size.width-10)
                                                      total:@100
                                                    current:[NSNumber numberWithFloat:number*100]
                                                  clockwise:YES];
    
    self.circleChart.backgroundColor = [UIColor clearColor];
    self.circleChart.center = CGPointMake(_v_bg.frame.size.width/2, _v_bg.frame.size.width/2);
    [self.circleChart setStrokeColor:color];
    //[self.circleChart setStrokeColorGradientStart:[UIColor blueColor]];
    [self.circleChart setLineWidth:@10];
    [self.circleChart strokeChart];
    [_v_bg addSubview:self.circleChart];
    
}

-(void)loadUI{

    _v_bg.layer.cornerRadius = _v_bg.frame.size.width/2;
    _v_bg.layer.masksToBounds = YES;
    _v_bg.layer.borderWidth = 1.0f;
    _v_bg.layer.borderColor = [RGB(45, 169, 238) CGColor];

    _lb_info.text = @"您今天还没测试呼吸哦";
    
    [self loadCircleChart:0];
    

}

-(void)commitData:(float)t_state{

    DataCommitRequest *t_request = [[DataCommitRequest alloc] init];
    t_request.mid = [ShareValue sharedShareValue].member.mid;
    t_request.pef = @([TestTool sharedTestTool].pef);
    t_request.fev1 = @([TestTool sharedTestTool].fev1);
    t_request.fvc = @([TestTool sharedTestTool].fvc);
    if (t_state > 0.8 ) {
        t_request.level = @0;
    }else if(t_state < 0.8 && t_state > 0.6){
        t_request.level = @1;
    }else if(t_state < 0.6){
        t_request.level = @2;
    }
    
    [DataAPI dataCommitWithRequest:t_request completionBlockWithSuccess:^(Monidata *data) {
        NSLog(@"提交成功");
    } Fail:^(int code, NSString *failDescript) {
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
    }];
}


#pragma mark - buttonAction

- (IBAction)testAcion:(id)sender {
    
    ShowHUD *hud = [ShowHUD showText:@"测试中.." configParameter:^(ShowHUD *config) {
    } inView:self.view];
    
    __weak typeof(self) weakSelf = self;
    
    [[GCDQueue globalQueue] execute:^{
        
        [[TestTool sharedTestTool] test];
        
        NSLog(@"%f",[TestTool sharedTestTool].pef);
        NSLog(@"%f",[TestTool sharedTestTool].fvc);
       
        NSLog(@"%2f",[TestTool sharedTestTool].pef/[[ShareValue sharedShareValue].member.defPef floatValue]);
        float t_state = [TestTool sharedTestTool].pef/[[ShareValue sharedShareValue].member.defPef floatValue];
        if (t_state > 1) {
            t_state = 1;
        }
        
        [self commitData:t_state];
        
        [[GCDQueue mainQueue] execute:^{
            
             weakSelf.lb_pef.text = [NSString stringWithFormat:@"%f",[TestTool sharedTestTool].pef];
            weakSelf.lb_info.text = @"PEF值最佳状态";
            
            if (t_state > 0.8 ) {
                weakSelf.lb_state.text = @"良好";
                weakSelf.lb_state.textColor = RGB(33, 211, 58);
            }else if(t_state < 0.8 && t_state > 0.6){
                weakSelf.lb_state.text = @"普通";
                weakSelf.lb_state.textColor = RGB(237, 229, 107);
            }else if(t_state < 0.6){
                weakSelf.lb_state.text = @"危险";
                weakSelf.lb_state.textColor = RGB(237, 14, 72);
            }
            [weakSelf loadCircleChart:t_state];
            [hud hide];
        }];
    }];
    
}

#pragma mark - dealloc

-(void)dealloc{


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
